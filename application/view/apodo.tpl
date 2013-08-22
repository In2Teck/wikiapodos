<script>
$(document).ready(function() {
	$('#mnu_app').addClass('selected');
	$('#mnu_default').removeClass('selected');
	imgRegularToSelected($('#mnu_app'));
	imgToRegular($('#mnu_default'));
	
	<?php if ($asignarAmigo == "true") { ?>
		$('.apodos_overlay').show();
		$('.apodo_asignar_amigos').show();
	<?php } ?>
});
</script>
<?php if ($usuario != null) { ?>
	<script>

		var calificacion = <?php echo $calificacion; ?>;
		var calificacionPromedio = <?php echo $apodo->calificacion; ?>;
		var apodoId = <?php echo $apodo->id; ?>;

		$(document).ready(function() {
			actualizarCalificacion();
			actualizarCalificacionPromedio(); 
	  
			$('.estrella').hover(
				function () {
					var idElemento = $(this).children("img:first").attr('id');
					var numEstrella = parseInt(idElemento.substr(idElemento.length - 1));
		
					for (var i=1; i <= 5; i++) {
						if (i <= numEstrella) {
							$('#estrella'+i).attr('src', 'images/apodo_estrella_over.png');
						} else {
							$('#estrella'+i).attr('src', 'images/apodo_estrella_vacia.png');
						}
					}
				},
				function () {
					actualizarCalificacion();
				}
			);

			$('.estrella').click(
				function () {
					var idElemento = $(this).children("img:first").attr('id');
					var numEstrella = parseInt(idElemento.substr(idElemento.length - 1));
			
					showLoader();
					$.ajax({
						url: "ajax.php",
						data: {
							"accion" : "funcion",
							"funcion" : "actualizarCalificacion",
							"apodoId" : apodoId,
							"calificacion" : numEstrella,
							"signed_request" : $('#signed_request').val()
						},
						type : "POST",
						success: function(response) {
							if ($(response).find('success').length > 0) {
								calificacion = numEstrella;
								calificacionPromedio = $(response).find('calificacionPromedio').html();
								actualizarCalificacion();
								actualizarCalificacionPromedio(); 
							}
							hideLoader();
						},
						error: function(errorText) {
							abrirAlert('Advertencia', 'No fue posible registrar tu calificación. Vuelve a intentarlo más tarde.');
							hideLoader();
						}
					});
				}
			); 
	
			if($('#amigos_facebook').children().length == 0) {
				$('#amigos_facebook').html('No hay personas con este apodo, sé el primero en apodar a alguien.');
			}
			
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
	
			$('.ventana .amigos .amigo').children('.paloma').parent().click(
				function () {
					$(this).find('.paloma').toggle();
					$(this).find('.cuadro').toggle();
				}
			);
	
		});

		function actualizarCalificacion() {
			for (var i=1; i <= 5; i++) {
				if (i <= calificacion) {
					$('#estrella'+i).attr('src', 'images/apodo_estrella_llena.png');
				} else {
					$('#estrella'+i).attr('src', 'images/apodo_estrella_vacia.png');
				}
			}
		}

		function actualizarCalificacionPromedio() {
			$('.calificacion_promedio').html('Popularidad: ' + (parseFloat(calificacionPromedio)).toFixed(1));
		}

		function compartirFacebook() {
	
			FB.ui({
				  method: 'feed',
				  redirect_uri: '<?php echo $cache->urlPortalFB?>?app_data=' + encodeURIComponent('{"accion":"template","page":"apodo","id":"' + apodoId + '"}'),
				  link: '<?php echo $cache->urlPortalFB?>?app_data=' + encodeURIComponent('{"accion":"template","page":"apodo","id":"' + apodoId + '"}'),
				  picture: '<?php echo $cache->urlPortal."images/apodos/".$apodo->imagenUrl;?>',
				  name: '<?php echo $apodo->getNombreApodo(); ?>',
				  caption: 'Wikiapodos',
				  description: 'Este es uno de los tantos APODOS ESPECIALES que puedes encontrar en el WIKIAPODOS.'
				}, function(response){});
		}

		function enviarApodos() {		
			var amigosSeleccionados = new Array();
			$(".paloma:visible").parent().each(function() {
				amigosSeleccionados.push($(this).attr('id'));
			});
	
			showLoader();
			$.ajax({
				url: "ajax.php",
				data: {
					"accion" : "funcion",
					"funcion" : "etiquetarAmigos",
					"apodoId" : apodoId,
					"amigos" : amigosSeleccionados,
					"signed_request" : $('#signed_request').val()
				},
				type : "POST",
				success: function(response) {
					loadTemplate('apodo', 'id=' + apodoId);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					abrirAlert('Advertencia', 'No fue posible etiquetar a tus amigos en este momento. Favor de intentar mas tarde.');
					hideLoader();
				}
			});
			cerrarVentana();
	
			FB.ui({method: 'apprequests',
			 to: amigosSeleccionados,
			 title: '¿Deseas enviarle este apodo a tus amigos?',
			 message: 'Te he puesto un APODO ESPECIAL',
		   }, function(response) {});
		}

		function borrarFiltro() {
			$("#texto_busqueda").val('');
			$('.amigo').show();
		}

		function cerrarVentana() {
			borrarFiltro();
			$('.apodos_overlay').hide();
			$('.apodo_asignar_amigos').hide();
			$('.paloma').hide();
			$('.cuadro').hide();
		}

	</script>

	<div class="apodos_overlay" style="display: none;"></div>
	<div class="titulo">Wikiapodos</div>
	<div class="contenido">
		<div class="apodo_izquierda">
			<div class="apodo_avatar">
				<div class="avatar"><img src="images/apodos/<?php echo $apodo->imagenUrl; ?>" alt="<?php echo $apodo->getNombreApodo(); ?>"/></div>
				<div class="creador">
					<div class="imagen"><img src="<?php if ($apodo->autor->id == '1') { echo 'images/logo_JCE.jpg'; } else { echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $apodo->autor->id); } ?>"></div>
					<div class="texto">Creado por:</div>
					<div class="nombre"><?php echo $apodo->autor->nombre . ' ' . $apodo->autor->apellido; ?></div>
				</div>
			</div>
			<div class="apodo_asignar">
				<img src="images/apodo_asignar.png" alt="Asignar a un amigo" class="over" onclick="$('.apodos_overlay').show();$('.apodo_asignar_amigos').show();"/>
			</div>
			<div class="apodo_crear">
				<img src="images/apodo_crear.png" alt="Crear nuevo apodo" class="over" onclick="loadTemplate('creador')"/>
			</div>
			<div class="apodo_calificar">
				<div class="texto">¿Te gusta este apodo?</div>
				<div class="estrellas">
					<div class="estrella"><img src="images/apodo_estrella_vacia.png" id="estrella1"/></div>
					<div class="estrella"><img src="images/apodo_estrella_vacia.png" id="estrella2"/></div>
					<div class="estrella"><img src="images/apodo_estrella_vacia.png" id="estrella3"/></div>
					<div class="estrella"><img src="images/apodo_estrella_vacia.png" id="estrella4"/></div>
					<div class="estrella"><img src="images/apodo_estrella_vacia.png" id="estrella5"/></div>
				</div>
				<div class="calificacion_promedio"></div>
			</div>
			<div class="apodo_compartir">
				<a href="https://twitter.com/intent/tweet?screen_name=CuervoEspecial&text=Este%20es%20uno%20de%20los%20tantos%20APODOS%20ESPECIALES%20que%20puedes%20encontrar%20en%20WIKIAPODOS%20%23ApodoEspecial,%20aquí:%20<?php echo $apodo->urlCorto;?>" data-lang="es" data-related="CuervoEspecial"><img src="images/apodo_twitter.png" alt="Twitter" class="over"/></a>
				<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
				<img src="images/apodo_compartir.png" alt="Compartir"/>
				<img src="images/apodo_facebook.png" alt="Facebook" class="over" onclick="compartirFacebook()"/>
			</div>
		</div>
		<div class="apodo_derecha">
			<div class="apodo_nombre"><?php echo $apodo->getNombreApodo() ?></div>
			<div class="apodo_descripcion">
				<div class="texto">
					<?php echo $apodo->descripcion; ?>
				</div>
			</div>
			<div class="apodo_tags">
				<div class="texto">Etiquetados</div>
				<div class="facebook">
					<div class="amigos" id="amigos_facebook">
						<?php foreach ($apodo->tags as $tag) { ?>
							<div class="amigo">
								<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $tag->id); ?>"/></div>
								<div class="nombre"><?php echo $tag->nombre; ?></div>
							</div>
						<?php } ?>
					</div>
				</div>
			</div>
		</div>
		<div class="apodo_asignar_amigos" style="display: none;">
			<div class="boton_cerrar">
				<img src="images/apodo_cerrar.png" alt="Cerrar ventana" class="over" onclick="cerrarVentana()"/>
			</div>
			<div class="ventana">
				<div class="titulo">
					¿Qué amigos son "<?php echo $apodo->getNombreApodo(); ?>"?
				</div>
				<div class="buscador">
					<span><img src="images/apodo_busqueda.png"/></span>
					<span><input type="text" id="texto_busqueda"/></span>
					<span><img src="images/apodo_eliminar.png" onclick="borrarFiltro()"/></span>
				</div>
				<div class="amigos">
					<?php foreach ($amigos as $amigo) { ?>
						<div class="amigo" id="<?php echo $amigo['uid']; ?>">
							<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $amigo['uid']); ?>"/></div>
							<div class="nombre"><?php echo $amigo['name']; ?></div>
							<div class="cuadro"></div>
							<?php if ($amigo['status'] == 0) { ?>
							    	<div class="pendiente""><img src="images/apodo_pendiente.png"/></div>
							<?php } else if ($amigo['status'] == 1) { ?>
									<div class="aceptado""><img src="images/apodo_aceptado.png"/></div>
							<?php } else if ($amigo['status'] == 2) { ?>
									<div class="rechazado""><img src="images/apodo_rechazado.png"/></div>
							<?php } else if ($amigo['status'] == 3) { ?>
									<div class="rechazado""><img src="images/apodo_rechazado.png"/></div>
							<?php } else { ?>
									<div class="paloma""><img src="images/apodo_paloma.png"/></div>
							<?php } ?>
						</div>
					<?php } ?>
				</div>
				<div class="boton_enviar"><img src="images/apodo_enviar.png" alt="Enviar apodo" class="over" onclick="enviarApodos()"/></div>
			</div>
		</div>
	</div>
	<?php echo $listaDefiniciones; ?>
<?php } else { ?>
	<?php echo $permisos; ?>
<?php } ?>