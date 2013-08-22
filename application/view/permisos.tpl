<div class="titulo">Wikiapodos</div>
<div class="subtitulo">Agrega y encuentra los mejores apodos</div>
<div class="permisos">
	<div class="libro">
		<img src="images/permisos_libro.png" alt="Gracias apodo por ser especial">
	</div>
	<div class="pasos">
		<div class="pasos_titulo">Pasos</div>
		<div class="paso">
			<span class="numero"><img src="images/permisos_1.png" alt="1"/></span>
			<span class="texto">Agrega<br/>un apodo</span>
		</div>
		<div class="paso">
			<span class="numero"><img src="images/permisos_2.png" alt="2"/></span>
			<span class="texto">Taggea a<br/>tus amigos</span>
		</div>
		<div class="paso">
			<span class="numero"><img src="images/permisos_3.png" alt="3"/></span>
			<span class="texto">Publica<br/>en tu muro</span>
		</div>
	</div>
	<div class="manita">
		<div class="boton_empezar" onclick='login("<?php echo $facebook->getAppID(); ?>", "<?php echo $cache->fbPermissions; ?>", "<?php echo $urlRedireccion; ?>")'><img src="images/permisos_empezar.png" class="over"/></div>
		</div>
	<div class="usuarios">
		<div class="usuarios_titulo">Ellos ya tienen apodo</div>
		<div class="usuarios_tabla">
			<?php foreach ($usuarios as $amigo) { ?>
				<div class="amigo">
					<div class="thumbnail"><img src="<?php echo Utils::generaUrlThumbnail($cache->urlImagenesFacebook, $amigo->id); ?>"/></div>
					<div class="nombre"><?php echo $amigo->nombre; ?></div>
				</div>
			<?php } ?>
		</div>
	</div>
</div>
<?php if ($request->getRequest('forzar') == 'permisos') { ?>
<script>
	$('.boton_empezar').click();
</script>
<?php } ?>