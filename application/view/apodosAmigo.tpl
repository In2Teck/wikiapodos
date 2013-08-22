<script>
$(document).ready(function() {
	// Inicialización de botones
	$('#mnu_app').addClass('selected');
	$('#mnu_default').removeClass('selected');
	imgRegularToSelected($('#mnu_app'));
	imgToRegular($('#mnu_default'));
	
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
	<div class="titulo">Wikiapodos</div>
	<div class="subtitulo">Apodos de <?php echo $nombreAmigo; ?></div>
	<div class="contenido" style="margin-top: 20px !important;">
		<?php if (count($apodos) > 0) { ?>
			<div class="mis_apodos">
				<div class="portlet_apodos">
				<?php foreach ($apodos as $apodo) { ?>
					<div class="apodo_horizontal">
						<div class="cuadro_avatar">
							<div class="avatar"><img src="images/apodos/<?php echo $apodo->imagenUrl; ?>" alt="<?php echo $apodo->getNombreApodo(); ?>" onclick="loadTemplate('apodo','id=<?php echo $apodo->id; ?>')" style="cursor: pointer"/></div>
							<div class="nombre"><?php echo Utils::limitaCaracteres($apodo->getNombreApodo(), 15); ?></div>
						</div>
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
						<div class="apodo_descripcion_cuadro">
							<div class="apodo_descripcion_texto"><?php echo $apodo->descripcion; ?></div>
						</div>
						<div class="botones">
							<div class="boton_ver_mas boton" onclick="loadTemplate('apodo','id=<?php echo $apodo->id; ?>')">Ver más</div>
						</div>
					</div>
				<?php } ?>
				</div>
				<?php if (count($apodos) > 3) { ?>
				<div class="flechas">
					<div class="flecha apodos_arriba"><img src="images/apodos_flecha_arr.png" class="over" /></div>
					<div class="flecha apodos_abajo"><img src="images/apodos_flecha_aba.png" class="over" /></div>
				</div>
				<?php } ?>
			</div>
		<?php } ?>
	</div>
	<?php echo $listaDefiniciones; ?>
<?php } else { ?>
	<?php echo $permisos; ?>
<?php } ?>