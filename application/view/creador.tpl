<script>
$(document).ready(function() {
	$('#mnu_app').addClass('selected');
	$('#mnu_default').removeClass('selected');
	imgRegularToSelected($('#mnu_app'));
	imgToRegular($('#mnu_default'));
	
	<?php if ($session->isSession('nuevo_creador') && $session->getSession('nuevo_creador')) { ?>
		mostrarAyuda();
	<?php } ?>
	
	imagesLoaded('#content', function() {
		hideLoader();
	});
});

function mostrarAyuda() {
	$('#ayuda_creador').click(function() {
		$(this).hide();
	});
	$('#ayuda_creador').show();
}
</script>
<?php if ($usuario != null) { ?>
	<script>
		var defaultCampo = "Aquí escribe el apodo";
		var paso = 1;
		
		<?php
			$apodos_nombres = array();
			$apodos_ids = array();
			foreach($apodos as $apodo) {
				$apodos_nombres[] = $apodo->getNombreApodo();
				$apodos_ids[] = $apodo->id;
			}
			
			$js_array = json_encode($apodos_nombres); 
			echo "var apodos = ". $js_array . ";\n";
			
			$js_array = json_encode($apodos_ids); 
			echo "var apodos_ids = ". $js_array . ";\n";
		?>
		
		var apodos_temp = [];
		for (var i = 0; i < apodos.length; i++) {
			apodos_temp[i] = limpiaCaracteres(apodos[i]);
		}
		
		function pasoSiguiente() {
			// Validaciones
			var prefijo = $('#prefijo').val() + ' ';
			if (paso == 1) {
				var nombreTemp = $('#nombre').val();
				var nombreTempTrim = nombreTemp.trim();
				if (prefijo == ' ') {
					abrirAlert('Advertencia', 'Por favor selecciona el prefijo del apodo ("el" o "la").');
					return;
				} else if (nombreTemp == defaultCampo || nombreTempTrim == '') {
					abrirAlert('Advertencia', 'Por favor escribe el apodo.');
					return;
				} else if (nombreTempTrim.length > 25) {
					abrirAlert('Advertencia', 'El apodo no puede contener mas de 25 caracteres.');
					return;
				} else if (!nombreTempTrim.charAt(0).match(/[A-Za-záÁéÉíÍóÓúÚñÑ]/g)) {
					abrirAlert('Advertencia', 'El apodo debe empezar con una letra.');
					return;
				} else if (nombreTempTrim.substring(0,3) == 'la ' || nombreTempTrim.substring(0,3) == 'el ') {
					abrirAlert('Advertencia', 'El apodo no puede empezar con "el" o "la", selecciona el prefijo que le corresponde.');
					return;
				} else if (apodos_temp.indexOf(limpiaCaracteres(prefijo + ' ' + nombreTemp)) != -1) {
					var indice = apodos_temp.indexOf(limpiaCaracteres(prefijo + ' ' + nombreTemp));
					abrirAlert('Advertencia', 'El apodo <a href="javascript: loadTemplate(\'apodo\',\'id=' + apodos_ids[indice] + '\')">' + apodos[indice] + '</a> ya existe y lo puedes ver <a href="javascript: loadTemplate(\'apodo\',\'id=' + apodos_ids[indice] + '\')">aquí</a>. Por favor ingresa otro apodo.');
					return;
				}
				var cadena = limpiaCaracteres($('#nombre').val().toLowerCase());
				for (var i = 0; i < palabrasProhibidas.length; i++) {
					if (new RegExp(palabrasProhibidas[i].toLowerCase()).test(cadena)) {
						abrirAlert('Advertencia', 'Estas usando una palabra prohibida en el apodo. Por favor verifícalo y vuelve a intentar.');
						return;
					}
				}
				$('.boton_ayuda').hide();
			} else if (paso == 2) {
				if ($('#descripcion').val().trim() == '') {
					abrirAlert('Advertencia', 'Por favor escribe la descripción del apodo.');
					return;
				} else if ($('#descripcion').val().trim().length > 300) {
					abrirAlert('Advertencia', 'La descripción no puede ser mayor a 300 caracteres.');
					return;
				} else if ($('.creador_amigos .amigo.seleccionado').length <= 0) {
					abrirAlert('Advertencia', 'Debes seleccionar al menos uno de tus amigos que sea tu apodo.');
					return;
				}
				var cadena = limpiaCaracteres($('#descripcion').val().toLowerCase());
				for (var i = 0; i < palabrasProhibidas.length; i++) {
					if (new RegExp(palabrasProhibidas[i].toLowerCase()).test(cadena)) {
						abrirAlert('Advertencia', 'Estas usando una palabra prohibida en la descripción. Por favor verifícalo y vuelve a intentar.');
						return;
					}
				}
			}
			$('.creador_apodo[paso="' + paso + '"]').hide();
			
			paso++;
			
			// Actualizaciones
			if (paso == 2) {
				$('.creador_descripcion .nombre').html(prefijo + $('#nombre').val().trim());
				$('.creador_confirmacion .nombre').html(prefijo + $('#nombre').val().trim());
				
				imagenes = [];
				avatares = $('.imagen_centro img');
				for (var i = 0; i < avatares.length; i++) {
					imagenes[i] = $(avatares[i]).attr('src');
				}
				showLoader();
				$.ajax({
					url: "ajax.php",
					data: {
						"accion" : "funcion",
						"funcion" : "crearAvatar",
						"imagenes" : imagenes,
						"signed_request" : $('#signed_request').val()
					},
					type : "POST",
					success: function(response) {
						if ($(response).find('success').length > 0) {
							hideLoader();
							var source = $(response).find('url').html() + '?t=' + (new Date()).getMilliseconds();
							$('.creador_descripcion .avatar img').attr('src', source);
							$('.creador_confirmacion .avatar img').attr('src', source);
						} else {
							pasoAnterior();
							hideLoader();
							abrirAlert('Advertencia', 'No se pudo crear tu avatar correctamente. Favor de intentar mas tarde.');
						}
					},
					error: function(jqXHR, textStatus, errorThrown) {
						pasoAnterior();
						hideLoader();
						abrirAlert('Advertencia', 'No se pudo crear tu avatar correctamente. Favor de intentar mas tarde.');
					}
				});
			} else if (paso == 3) {
				$('.creador_confirmacion .descripcion .texto').html($('#descripcion').val().trim());
				$('.creador_confirmacion_amigos .cuadro_amigos').html('');
				var amigos = $('.creador_amigos .amigo.seleccionado');
				for (var i = 0; i < amigos.length; i++) {
					$('.creador_confirmacion_amigos .cuadro_amigos').append($(amigos[i]).clone());
					$('.creador_confirmacion_amigos .cuadro_amigos .amigo').removeClass('seleccionado');
				}
			}
			
			$('.creador_apodo[paso="' + paso + '"]').show();
		}
		
		function pasoAnterior() {
			$('.creador_apodo[paso="' + paso + '"]').hide();
			paso--;
			$('.creador_apodo[paso="' + paso + '"]').show();
			if (paso == 1) {
				$('.boton_ayuda').show();
			}
		}
		
		var apodoNuevo = 0;
		var palabrasProhibidas = ['<?php echo implode("','", $palabrasProhibidas); ?>'];
		
		function publicar() {
			var nombre = $('#nombre').val().trim();
			var prefijo = $('#prefijo').val();
			var descripcion = $('#descripcion').val().trim();
			var imagenUrl = $('.creador_descripcion .avatar img').attr('src');
			apodo = {
				nombre: nombre,
				prefijo: prefijo,
				descripcion: descripcion,
				imagen_url: imagenUrl
			};
			showLoader();
			$.ajax({
				url: "ajax.php",
				data: {
					"accion" : "funcion",
					"funcion" : "crearApodo",
					"apodo" : apodo,
					"signed_request" : $('#signed_request').val()
				},
				type : "POST",
				success: function(response) {
					if ($(response).find('success').length > 0) {
						if ($(response).find('existeApodo').html() == 'true') {
							hideLoader();
							abrirAlert('Advertencia', 'El apodo ya existe. Por favor ingresa otro apodo.');
						} else if ($(response).find('prefijo').html() == 'true') {
							hideLoader();
							abrirAlert('Advertencia', 'El apodo no puede empezar con "el" o "la", selecciona el prefijo que le corresponde.');
						} else if ($(response).find('palabraProhibida').html() == 'true') {
							hideLoader();
							abrirAlert('Advertencia', 'Estas usando una palabra prohibida en el apodo o la descripción. Por favor verifícalo y vuelve a intentar.');
						} else {
							apodoNuevo = $(response).find('apodoId').html();
							enviarInvitaciones();
						}
					} else {
						hideLoader();
						abrirAlert('Advertencia', 'No se pudo registrar tu solicitud correctamente. Favor de intentar mas tarde.');
					}
				},
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoader();
					abrirAlert('Advertencia', 'No se pudo crear tu apodo correctamente. Favor de intentar mas tarde.');
				}
			});
		}
		
		function enviarInvitaciones() {
			var amigos = $('.creador_confirmacion_amigos .cuadro_amigos .amigo');
			var tags = new Array();
			for (var i = 0; i < amigos.length; i++) {
				tags[i] = $(amigos[i]).attr('id');
			}
			
			$.ajax({
				url: "ajax.php",
				data: {
					"accion" : "funcion",
					"funcion" : "etiquetarAmigos",
					"apodoId" : apodoNuevo,
					"amigos" : tags,
					"signed_request" : $('#signed_request').val()
				},
				type : "POST",
				success: function(response) {
					hideLoader();
					loadTemplate('apodo', 'id=' + apodoNuevo);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					hideLoader();
					loadTemplate('apodo', 'id=' + apodoNuevo);
				}
			});
			
			FB.ui({
				method: 'apprequests',
				to: tags,
				title: '¿Deseas enviarle este apodo a tus amigos?',
				message: 'Te he puesto un APODO ESPECIAL',
			}, function(response){});
		}
		
		function abrirAlert(titulo, mensaje) {
			$('#alert .titulo').html(titulo);
			$('#alert .mensaje').html(mensaje);
			$('#alert').show();
		}
		
		function cerrarAlert() {
			$('#alert').hide();
			$('#alert .titulo').html('');
			$('#alert .mensaje').html('');
		}
		
		// Para el paso 1
		$('#nombre').val(defaultCampo);
		$('#nombre').click(function() {
			if ($(this).val() == defaultCampo) {
				$(this).val('');
			}
		}).blur(function() {
			if ($(this).val().trim() == '') {
				$(this).val(defaultCampo);
			}
		}).keypress(function(e) {
			if (!e) var e = window.event
			if (e.keyCode) code = e.keyCode;
			else if (e.which) code = e.which;
			
			var character = String.fromCharCode(code);
			
			// if they pressed esc... remove focus from field...
			if (code==27) { this.blur(); return false; }
			// ignore if they are press other keys
			// strange because code: 39 is the down key AND ' key...
			// and DEL also equals .
			if (!e.ctrlKey && code!=9 && code!=8 && code!=36 && code!=37 && code!=38 && (code!=39 || (code==39 && character=="'")) && code!=40) {
				if (character.match(/[A-Za-záÁéÉíÍóÓúÚñÑ\ ]/g)) {
					return true;
				} else {
					return false;
				}
			}
		});
		
		$('.checkbox').click(function() {
			id = $(this).attr('id');
			if (id == 'prefijo_el') {
				$('#prefijo_la img').hide();
				$('#prefijo').val('El');
			} else if (id == 'prefijo_la') {
				$('#prefijo_el img').hide();
				$('#prefijo').val('La');
			}
			$('#' + id + ' img').show();
		});
		
		// Para el paso 2
		$('.categoria').click(function() {
			var id = $(this).attr('categoria');
			$('.categoria').removeClass('seleccionado');
			$('.objetos').hide();
			
			$('.categoria[categoria="' + id + '"]').addClass('seleccionado');
			$('.objetos[categoria="' + id + '"]').show();
			
			posicionObjeto = 0
			$('.objetos[categoria="' + id + '"] .objetos_portlet').scrollLeft(0);
		});
		
		imagenes = [];
		<?php
			$cuerpo = -1;
			foreach ($imagenes as $imagen) {
				if ($cuerpo != $imagen->cuerpoId) {
					$cuerpo = $imagen->cuerpoId;
					echo 'imagenes[' . $imagen->cuerpoId . '] = [];';
				}
				echo 'imagenes[' . $imagen->cuerpoId . '][' . $imagen->objetoId . '] = "' . $imagen->imagenUrl . '";';
			}
		?>
		
		$('.objeto > .imagen').click(function() {
			$(this).parent().parent().find('.objeto').removeClass('seleccionado');
			$(this).parent().addClass('seleccionado');
			
			idObjeto = $(this).parent().attr('objeto');
			idCategoria = $(this).parent().attr('categoria');
			cuerpos = $('.cuerpo');
			for (var i = 0; i < cuerpos.length; i++) {
				objeto = $(cuerpos[i]).find('.imagen img[categoria="' + idCategoria + '"]');
				if ((idObjeto == '-1') || imagenes[$(cuerpos[i]).attr('cuerpo')][idObjeto] == undefined) {
					$(objeto).attr('src','images/transparente.png');
					$(objeto).attr('objeto', '-1');
				} else {
					$(objeto).attr('src','images/cuerpos_objetos/' + imagenes[$(cuerpos[i]).attr('cuerpo')][idObjeto]);
					$(objeto).attr('objeto', idObjeto);
				}
			}
		});
		$('.objeto[categoria="4"] > .imagen')[0].click();
		
		// Carrusel objeto
		var tamanioObjetos = 54;
		var posicionObjeto = 0;
		var visibles = 7;
		$('.objeto_izquierda').click(function() {
			posicionAnterior = posicionObjeto;
			posicionObjeto -= visibles;
			if (posicionObjeto < 0) {
				if (--posicionAnterior < 0) {
					posicionObjeto = $(this).parent().find('.objeto').length - visibles;
				} else {
					posicionObjeto = 0;
				}
			}
			valorActual = posicionObjeto * tamanioObjetos;
			
			portlet = $(this).parent().find('.objetos_portlet');
			portlet.stop().animate( { scrollLeft: valorActual }, 500);
		});
		$('.objeto_derecha').click(function() {
			posicionAnterior = posicionObjeto;
			posicionObjeto += visibles;
			limite = $(this).parent().find('.objeto').length - visibles;
			if (posicionObjeto > limite) {
				if (++posicionAnterior > limite) {
					posicionObjeto = 0;
				} else {
					posicionObjeto = limite;
				}
			}
			valorActual = posicionObjeto * tamanioObjetos;
		
			portlet = $(this).parent().find('.objetos_portlet');
			portlet.stop().animate( { scrollLeft: valorActual }, 500);
		});
		
		// Carrusel cuerpo
		var tamanioCuerpos = 194;
		var posicionCuerpo = 0;
		$('.cuerpo_izquierda').click(function() {
			portlet = $(this).parent().find('.cuerpos_portlet');
			posicionAnterior = posicionCuerpo;
			posicionCuerpo--;
			if (posicionCuerpo < 0) {
				posicionCuerpo = $('.cuerpo').length - 1;
			}
			valorActual = posicionCuerpo * tamanioCuerpos;
			if (posicionAnterior != posicionCuerpo) {
				$('.cuerpo .imagen:eq(' + posicionAnterior + ')').removeClass('imagen_centro');
				$('.cuerpo .imagen:eq(' + posicionCuerpo + ')').addClass('imagen_centro');
				portlet.stop().animate( { scrollLeft: valorActual }, 500);
			}
		});
		$('.cuerpo_derecha').click(function() {
			portlet = $(this).parent().find('.cuerpos_portlet');
			posicionAnterior = posicionCuerpo;
			posicionCuerpo++;
			if (posicionCuerpo >= $('.cuerpo').length) {
				posicionCuerpo = 0;
			}
			valorActual = posicionCuerpo * tamanioCuerpos;
			if (posicionAnterior != posicionCuerpo) {
				$('.cuerpo .imagen:eq(' + posicionAnterior + ')').removeClass('imagen_centro');
				$('.cuerpo .imagen:eq(' + posicionCuerpo + ')').addClass('imagen_centro');
				portlet.stop().animate( { scrollLeft: valorActual }, 500);
			}
		});
		
		// Selector amigos
		$('.amigo').click(function() {
			$(this).toggleClass('seleccionado');
		});
		
		$("#texto_busqueda").keyup(function() {
			var texto = limpiaCaracteres($(this).val());
		
			$('.amigo .nombre').each(function(index) {
				nombreCompleto = limpiaCaracteres($(this).html());
				if (nombreCompleto.indexOf(texto) >= 0) {
					$(this).parent().show();
				} else {
					$(this).parent().hide();
			}
			});
		});
		
		function borrarFiltro() {
			$("#texto_busqueda").val('');
			$('.amigo').show();
		}
	
	</script>
	<div id="alert">
		<div id="alert_background"></div>
		<div id="botonCerrar"><img class="over" src="images/apodo_cerrar.png" onclick="cerrarAlert()"/></div>
		<div id="alert_content">
			<div class="titulo"></div>
			<div class="mensaje"></div>
			<div class="boton_aceptar"><img class="over" src="images/alert_aceptar.png" onclick="cerrarAlert()"/></div>
		</div>
	</div>
	<div class="titulo">Agrega un apodo</div>
	<div class="boton_ayuda"><img src="images/app_ayuda.png" alt="Ayuda" class="over" onclick="mostrarAyuda()" /></div>
	<div class="creador_apodo" paso="1">
		<div class="paso">Paso 1</div>
		<div class="creador_nombre">
			<span class="checkboxes">El <span id="prefijo_el" class="checkbox"><img src="images/creador_paloma.png" alt="Sí"/></span>&nbsp;&nbsp; La <span id="prefijo_la" class="checkbox"><img src="images/creador_paloma.png" alt="Sí"/></span></span> &nbsp;<span class="campo"><input id="nombre" name="nombre" value="" maxlength="25"/></span>
			<input type=hidden id="prefijo"/>
		</div>
		<div class="titulo_creador"><span>Crea el avatar del apodo</span></div>
		<div class="creador_avatar">
			<div class="categorias">
				<?php foreach ($categorias as $categoria) { ?>
					<div class="categoria" categoria="<?php echo $categoria->id; ?>" style="cursor: pointer;">
						<div class="imagen"><img src="images/categorias/<?php echo $categoria->imagenUrl; ?>"/><div class="cuadro"></div></div>
						<div class="nombre"><?php echo $categoria->descripcion; ?></div>
					</div>
				<?php } ?>
			</div>
			<?php foreach ($categorias as $categoria) { ?>
				<div class="objetos" categoria="<?php echo $categoria->id; ?>">
					<?php
						// Pongo echos porque no quiero espacios entre las imágenes.
						echo '<div class="flecha objeto_izquierda"><img src="images/creador_flecha_izq.png" class="over" /></div>';
						echo '<div class="objetos_portlet" categoria="' . $categoria->id . '">';
						if ($categoria->id != 4) {
							echo '<div class="objeto seleccionado" objeto="-1" categoria="' . $categoria->id . '"><div class="imagen"><img src="images/objetos/' . $categoria->imagenUrl . '"/><div class="cuadro"></div></div></div>';
						}
						$contador = 1;
						foreach ($categoria->objetos as $objeto) {
							echo '<div class="objeto" objeto="' . $objeto->id . '" categoria="' . $categoria->id . '">';
							echo '<div class="imagen"><img src="images/objetos/' . $objeto->imagenUrl . '"/><div class="cuadro"></div></div>';
							echo '</div>';
							$contador++;
						}
						for (; $contador < 7; $contador++) {
							echo '<div class="objeto"><div class="imagen_vacia"></div></div>';
						}
						echo '</div>';
						echo '<div class="flecha objeto_derecha"><img src="images/creador_flecha_der.png" class="over" /></div>';
					?>
				</div>
			<?php } ?>
			<div class="cuerpos">
				<div class="flecha cuerpo_izquierda"><img src="images/creador_flecha_izq.png" class="over" /></div>
				<div class="cuerpos_portlet">
				<?php
					$cont = 0;
					foreach ($cuerpos as $cuerpo) {
						$cont++;
				?>
					<div class="cuerpo" cuerpo="<?php echo $cuerpo->id; ?>">
						<div class="imagen <?php if ($cont == 1) { echo 'imagen_centro'; } ?>">
							<img class="imagen_cuerpo" src="images/cuerpos/<?php echo $cuerpo->imagenUrl; ?>"/>
							<img src="images/transparente.png" objeto="-1" categoria="4"/>
							<img src="images/transparente.png" objeto="-1" categoria="2"/>
							<img src="images/transparente.png" objeto="-1" categoria="3"/>
							<img src="images/transparente.png" objeto="-1" categoria="1"/>
						</div>
					</div>
				<?php
					}
				?>
				</div>
				<div class="flecha cuerpo_derecha"><img src="images/creador_flecha_der.png" class="over" /></div>
			</div>
		</div>
		<div class="botones">
			<img src="images/creador_volver_hacer.png" alt="Volver a hacer" class="over" onclick="loadTemplate('creador')"/>
			<img src="images/creador_listo.png" alt="Listo" class="over" onclick="pasoSiguiente()"/>
		</div>
	</div>
	<div class="creador_apodo" paso="2" style="display: none;">
		<div class="paso">Paso 2</div>
		<div class="creador_descripcion">
			<div class="avatar"><img src="images/fondo_avatar.png"/></div>
			<div class="nombre"></div>
			<div class="descripcion">
				Descripción:<br/>
				<textarea id="descripcion" name="descripcion" rows="4" maxlength="300"/>
			</div>
		</div>
		<div class="creador_amigos">
			<div class="titulo_amigos">Elige a tus amigos con este apodo</div>
			<div class="buscador">
				<span><img src="images/apodo_busqueda.png"/></span>
				<span><input type="text" id="texto_busqueda"/></span>
				<span><img src="images/apodo_eliminar.png" onclick="borrarFiltro()"/></span>
			</div>
			<div class="cuadro_amigos">
			<?php foreach ($amigos as $amigo) { ?>
			<div class="amigo" id="<?php echo $amigo['uid']; ?>">
				<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $amigo['uid']); ?>"/></div>
				<div class="nombre"><?php echo $amigo['name']; ?></div>
				<div class="cuadro"></div>
				<div class="paloma"><img src="images/apodo_paloma.png"/></div>
			</div>
			<?php } ?>
			</div>
		</div>
		<div class="botones">
			<img src="images/creador_volver.png" alt="Volver" class="over" onclick="pasoAnterior()"/>
			<img src="images/creador_listo.png" alt="Listo" class="over" onclick="pasoSiguiente()"/>
		</div>
	</div>
	<div class="creador_apodo" paso="3" style="display: none;">
		<div class="paso">Paso 3</div>
		<div class="creador_confirmacion">
			<div class="avatar"><img src="images/fondo_avatar.png"/></div>
			<div class="nombre"></div>
			<div class="descripcion">
				Descripción:<br/>
				<span class="texto"></span>
			</div>
		</div>
		<div class="creador_confirmacion_amigos">
			<div class="titulo_amigos">Amigos apodados</div>
			<div class="cuadro_amigos">
			</div>
		</div>
		<div class="botones">
			<img src="images/creador_volver.png" alt="Volver" class="over" onclick="pasoAnterior()"/>
			<img src="images/creador_publicar.png" alt="Publicar" class="over" onclick="publicar()"/>
		</div>
	</div>
<?php } else { ?>
	<?php echo $permisos; ?>
<?php } ?>