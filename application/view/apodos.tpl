<script>
// Funciones de la alerta
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

// Inicialización de la página
$(document).ready(function() {
	// Inicialización de botones
	$('#mnu_app').addClass('selected');
	$('#mnu_default').removeClass('selected');
	imgRegularToSelected($('#mnu_app'));
	imgToRegular($('#mnu_default'));
	
	<?php if ($tipo == 'creados') { ?>
		$('#btn_creados').addClass('selected');
		imgRegularToSelected($('#btn_creados'));
	<?php } else { ?>
		$('#btn_asignados').addClass('selected');
		imgRegularToSelected($('#btn_asignados'));
	<?php } ?>
	
	// Scroll
	var posicion = 0;
	var tamanioObjetos = 550;
	$('.apodos_arriba').click(function() {
		totalApodos = Math.ceil($(this).parent().parent().find('.apodo_horizontal').length / 3);
		posicion--;
		if (posicion < 0) {
			posicion = totalApodos - 1;
		}
		
		portlet = $(this).parent().parent().find('.portlet_apodos');
		valorActual = tamanioObjetos * posicion;
		portlet.stop().animate( { scrollTop: valorActual }, 500);
	});
	$('.apodos_abajo').click(function() {
		totalApodos = Math.ceil($(this).parent().parent().find('.apodo_horizontal').length / 3);
		posicion++;
		if (posicion >= totalApodos) {
			posicion = 0;
		}
		
		portlet = $(this).parent().parent().find('.portlet_apodos');
		valorActual = tamanioObjetos * posicion;
		portlet.stop().animate( { scrollTop: valorActual }, 500);
	});
	
	// Se aceptan y rechazan invitaciones
	$('.btn_acepto').click(function() {
		showLoader();
		var padre = $(this).parent().parent();
		$.ajax({
			url: "ajax.php",
			data: {
				"accion" : "funcion",
				"funcion" : "aceptarApodo",
				"apodoId" : $(this).attr('apodoId'),
				"signed_request" : $('#signed_request').val()
			},
			type : "POST",
			success: function(response) {
				if ($(response).find('success').length > 0) {
					padre.remove('.solicitud');
					padre.append('<div class="estado">Has sido apodado como <em>' + padre.find('.avatar img').attr('alt') +  '</em>.</div>');
				} else {
					abrirAlert('Advertencia', 'No se pudo registrar tu solicitud correctamente. Favor de intentar mas tarde.');
				}
				hideLoader();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				abrirAlert('Advertencia', 'No se pudo registrar tu solicitud correctamente. Favor de intentar mas tarde.');
				hideLoader();
			}
		});
	});
	$('.btn_rechazar').click(function() {
		showLoader();
		var padre = $(this).parent().parent();
		$.ajax({
			url: "ajax.php",
			data: {
				"accion" : "funcion",
				"funcion" : "rechazarApodo",
				"apodoId" : $(this).attr('apodoId'),
				"signed_request" : $('#signed_request').val()
			},
			type : "POST",
			success: function(response) {
				if ($(response).find('success').length > 0) {
					padre.remove('.estado');
					padre.append('<div class="estado">Has reportado <em>' + padre.find('.avatar img').attr('alt') +  '</em>.</div>');
					padre.find('.btn_rechazar').hide();
				} else {
					abrirAlert('Advertencia', 'No se pudo registrar tu solicitud correctamente. Favor de intentar mas tarde.');
				}
				hideLoader();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				abrirAlert('Advertencia', 'No se pudo registrar tu solicitud correctamente. Favor de intentar mas tarde.');
				hideLoader();
			}
		});
	});
});	
</script>
<?php if ($usuario != null) { ?>
	<div id="alert">
		<div id="alert_background"></div>
		<div id="botonCerrar"><img class="over" src="images/apodo_cerrar.png" onclick="cerrarAlert()"/></div>
		<div id="alert_content">
			<div class="titulo"></div>
			<div class="mensaje"></div>
			<div class="boton_aceptar"><img class="over" src="images/alert_aceptar.png" onclick="cerrarAlert()"/></div>
		</div>
	</div>
	<div class="titulo">Mis Apodos</div>
	<div class="contenido">
		<div class="boton_asignados"><img id="btn_asignados" src="images/apodos_btn_asignados.png" alt="Ver mis apodos" onclick="loadTemplate('apodos', 'tipo=asignados')" class="over" /></div>
		<div class="boton_creados"><img id="btn_creados" src="images/apodos_btn_creados.png" alt="Ver apodos creados" onclick="loadTemplate('apodos', 'tipo=creados')" class="over" /></div>
		<?php if (count($apodos) > 0) { ?>
			<div class="mis_apodos">
				<div class="portlet_apodos">
				<?php foreach ($apodos as $apodo) { ?>
				<?php if (($tipo == 'asignados' && $apodo->status == 1) || $tipo == 'creados') { ?>
					<div class="apodo_horizontal">
						<div class="cuadro_avatar">
							<div class="avatar"><img src="images/apodos/<?php echo $apodo->imagenUrl; ?>" alt="<?php echo $apodo->getNombreApodo(); ?>" onclick="loadTemplate('apodo','id=<?php echo $apodo->id; ?>')" style="cursor: pointer"/></div>
							<div class="nombre"><?php echo Utils::limitaCaracteres($apodo->getNombreApodo(), 15); ?></div>
						</div>
						<?php if ($tipo == 'creados') { ?>
						<div class="amigos">
							<?php
								if (count($apodo->tags) > 0) {
									$contador = 0;
									foreach ($apodo->tags as $tag) {
										$contador++;
							?>
								<div class="amigo">
									<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $tag->id); ?>"/></div>
									<div class="nombre"><?php echo $tag->nombre; ?></div>
								</div>
							<?php
										if ($contador == 9) {
											break;
										}
									}
								} else {
							?>
								<span class="mensaje">NO HAY PERSONAS CON ESTE APODO, SÉ EL PRIMERO EN APODAR A ALGUIEN.</span>
							<?php
								}
							?>
						</div>
						<?php } else { ?>
							<?php if ($apodo->status == 1) { ?>
								<div class="estado">
									<a href="javascript: loadTemplate('apodosAmigo','id=<?php echo $apodo->usuarioDesdeId; ?>')"><?php echo $apodo->usuarioDesdeNombre; ?></a> te ha apodado como <a href="javascript: loadTemplate('apodo','id=<?php echo $apodo->id; ?>')"><?php echo $apodo->getNombreApodo(); ?></a>.
									<img src="images/apodos_apoda.png" alt="Crear apodo" class="over btn_crear" onclick="loadTemplate('creador')"/>
								</div>
							<?php } ?>
						<?php } ?>
						<div class="apodo_descripcion_cuadro">
							<div class="apodo_descripcion_texto"><?php echo $apodo->descripcion; ?></div>
							<?php if ($apodo->status == 1) { ?>
								<img src="images/apodos_reportar.png" alt="Reportar Apodo" class="over btn_rechazar" apodoId="<?php echo $apodo->id; ?>"/>
							<?php } ?>
						</div>
						<div class="botones">
							<div class="boton_ver_mas boton" onclick="loadTemplate('apodo','id=<?php echo $apodo->id; ?>')">Ver más</div>
						</div>
					</div>
				<?php } ?>
				<?php } ?>
				</div>
				<?php if (count($apodos) > 3) { ?>
				<div class="flechas">
					<div class="flecha apodos_arriba"><img src="images/apodos_flecha_arr.png" class="over" /></div>
					<div class="flecha apodos_abajo"><img src="images/apodos_flecha_aba.png" class="over" /></div>
				</div>
				<?php } ?>
			</div>
		<?php } else { ?>
			<div class="mensaje">
				<?php if ($tipo == 'creados') { ?>
					Aún no has creado ningún apodo.
					<br/>
					<img src="images/app_btn_agregar.png" alt="Agregar un apodo" onclick="loadTemplate('creador')" class="over" />
				<?php } else if ($tipo == 'asignados') { ?>
					Por el momento no te han asignado ningún apodo.
				<?php } ?>
			</div>
		<?php } ?>
	</div>
	<?php echo $listaDefiniciones; ?>
<?php } else { ?>
	<?php echo $permisos; ?>
<?php } ?>