<script>
$(document).ready(function() {
	$('#mnu_app').addClass('selected');
	$('#mnu_default').removeClass('selected');
	imgRegularToSelected($('#mnu_app'));
	imgToRegular($('#mnu_default'));
	
	<?php if ($session->isSession('nuevo') && $session->getSession('nuevo')) { ?>
		mostrarAyuda();
	<?php } ?>
	
	$('.amigo_izquierda').click(function() {
		posicionAnterior = posicionObjeto;
		posicionObjeto -= visibles;
		if (posicionObjeto < 0) {
			if (--posicionAnterior < 0) {
				posicionObjeto = $(this).parent().find('.amigo').length - visibles;
			} else {
				posicionObjeto = 0;
			}
		}
		valorActual = posicionObjeto * tamanioObjetos;
	
		portlet = $(this).parent().find('.amigos_portlet');
		portlet.stop().animate( { scrollLeft: valorActual }, 500);
	});
	$('.amigo_derecha').click(function() {
		posicionAnterior = posicionObjeto;
		posicionObjeto += visibles;
		limite = $(this).parent().find('.amigo').length - visibles;
		if (posicionObjeto > limite) {
			if (++posicionAnterior > limite) {
				posicionObjeto = 0;
			} else {
				posicionObjeto = limite;
			}
		}
		valorActual = posicionObjeto * tamanioObjetos;

		portlet = $(this).parent().find('.amigos_portlet');
		portlet.stop().animate( { scrollLeft: valorActual }, 500);
	});
});
	
function mostrarAyuda() {
	$('#ayuda_wikiapodos').click(function() {
		$(this).hide();
		$('.apodos[letra="c"]').css('visibility', 'hidden');
		$('.definiciones_apodos').hide();
	});
	
	$('.definiciones_apodos').show();
	$('.apodos[letra="c"]').css('visibility', 'visible');
	$('#ayuda_wikiapodos').show();
}

// Carrusel objeto
var tamanioObjetos = 54;
var posicionObjeto = 0;
var visibles = 8;
</script>
<?php if ($usuario != null) { ?>
	<div class="titulo">Wikiapodos</div>
	<div class="boton_ayuda"><img src="images/app_ayuda.png" alt="Ayuda" class="over" onclick="mostrarAyuda()" /></div>
	<div class="subtitulo">Estamos buscando los mejores apodos</div>
	<div class="contenido">
		<div class="boton_agregar"><img src="images/app_btn_agregar.png" alt="Agregar un apodo" onclick="loadTemplate('creador')" class="over" /></div>
		<div class="boton_ver"><img src="images/app_btn_ver.png" alt="Ver mis apodos" onclick="loadTemplate('apodos', 'tipo=asignados')" class="over" /></div>
		<?php if (count($amigos_con_apodo)) { ?>
			<div class="amigos_con_apodo">
				<div class="descripcion">Amigos con apodos</div>
				<div class="cuadro">
				<?php if (count($amigos_con_apodo) > 10) { ?>
					<div class="flecha amigo_izquierda"><img src="images/creador_flecha_izq.png" class="over" /></div><div class="amigos_portlet">
				<?php } ?>
				<?php foreach ($amigos_con_apodo as $amigo) { ?><div class="amigo" onclick="loadTemplate('apodosAmigo','id=<?php echo $amigo->id; ?>')"><div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $amigo->id); ?>"/></div><div class="nombre"><?php echo $amigo->nombre; ?></div></div><?php } ?>
				<?php if (count($amigos_con_apodo) > 10) { ?>
					</div><div class="flecha amigo_derecha"><img src="images/creador_flecha_der.png" class="over" /></div>
				<?php } ?>
				</div>
			</div>
		<?php } else {?>
			<span class="mensaje_amigos_con_apodo">Haz click en el botón 'agregar un apodo' para apodar a tus amigos.</span>
		<?php }?>
		<div class="titulo_destacados"><span>Los más destacados</span></div>
		<div class="destacados">
			<?php foreach ($destacados as $destacado) { ?>
			<div class="destacados_apodo">
				<div class="cuadro_avatar">
					<div class="avatar"><img src="images/apodos/<?php echo $destacado->imagenUrl; ?>" alt="<?php echo $destacado->getNombreApodo(); ?>" onclick="loadTemplate('apodo','id=<?php echo $destacado->id; ?>');" style="cursor: pointer; width: 210px; height: 210px;"/></div>
					<div class="nombre"><?php echo Utils::limitaCaracteres($destacado->getNombreApodo(), 17); ?></div>
				</div>
				<div class="amigos">
					<?php
						$contador = 0;
						foreach ($destacado->tags as $tag) {
							$contador++;
					?>
						<div class="amigo">
							<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $tag->id); ?>"/></div>
							<div class="nombre"><?php echo $tag->nombre; ?></div>
						</div>
					<?php
							if ($contador >= 10) {
								break;
							}
						}
					?>
				</div>
				<div class="botones">
					<div class="boton_ver_mas boton" onclick="loadTemplate('apodo','id=<?php echo $destacado->id; ?>')">Ver más</div>
				</div>
			</div>
			<?php } ?>
		</div>
	</div>
	<?php echo $listaDefiniciones; ?>
<?php } else { ?>
	<?php echo $permisos; ?>
<?php } ?>