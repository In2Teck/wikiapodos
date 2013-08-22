<script>
$(document).ready(function() {
	$('#mnu_default').addClass('selected');
	$('#mnu_app').removeClass('selected');
	imgRegularToSelected($('#mnu_default'));
	imgToRegular($('#mnu_app'));
	
	/**
	var posicion = 0;
	var tamanioObjetos = 192;
	$('.carrusel_anterior').click(function() {
		totalApodos = $(this).parent().find('.apodo').length;
		posicion--;
		if (posicion < 0) {
			posicion = totalApodos - 1;
		}
		
		portlet = $(this).parent().find('.carrusel_imagenes');
		valorActual = tamanioObjetos * posicion;
		portlet.stop().animate( { scrollLeft: valorActual }, 500);
		
		actualizarVideo($(this).parent().find('.apodo:nth-child(' + (posicion + 1) + ')').attr('youtube'));
	});
	$('.carrusel_siguiente').click(function() {
		totalApodos = $(this).parent().find('.apodo').length;
		posicion++;
		if (posicion >= totalApodos) {
			posicion = 0;
		}
		
		portlet = $(this).parent().find('.carrusel_imagenes');
		valorActual = tamanioObjetos * posicion;
		portlet.stop().animate( { scrollLeft: valorActual }, 500);
		
		actualizarVideo($(this).parent().find('.apodo:nth-child(' + (posicion + 1) + ')').attr('youtube'));
	});
	
	function actualizarVideo(direccion) {
		$('#iframeYoutube').attr('src', direccion);
	}
	**/
});
</script>
<div class="titulo">Apodos</div>
<div class="contenido">
	<div class="apodos">
		<!-- div class="carrusel">
			<div class="carrusel_anterior"><img id="apodo_anterior" src="images/creador_flecha_izq.png" class="over"></div>
			<div class="carrusel_imagenes">
				<div class="apodo" youtube="//www.youtube.com/embed/EynCDFcgPfc?list=PLAF0D3542F985629D">
					<div class="avatar"><img src="images/apodos/chanclas.jpg" alt="El Chanclas"/></div>
					<div class="nombre">El Chanclas</div>
				</div>
				<div class="apodo" youtube="//www.youtube.com/embed/RFfUoB35Ve0?list=PLAF0D3542F985629D">
					<div class="avatar"><img src="images/apodos/china.jpg" alt="La China"/></div>
					<div class="nombre">La China</div>
				</div>
				<div class="apodo" youtube="//www.youtube.com/embed/5w2oY09_MwA?list=PLAF0D3542F985629D">
					<div class="avatar"><img src="images/apodos/todas_mias.jpg" alt="El Todas Mías"/></div>
					<div class="nombre">El Todas Mías</div>
				</div>
				<div class="apodo" youtube="//www.youtube.com/embed/b6-jnNWAq7w?list=PLAF0D3542F985629D">
					<div class="avatar"><img id="apodo_siguiente" src="images/apodos/pollo.jpg" alt="El Pollo"/></div>
					<div class="nombre">El Pollo</div>
				</div>
			</div>
			<div class="carrusel_siguiente"><img src="images/creador_flecha_der.png" class="over"></div>
		</div -->
		<div class="video">
			<iframe id="iframeYoutube" width="400" height="225" src="//www.youtube.com/embed/J170cI_Sh68" frameborder="0" allowfullscreen></iframe>
		</div>
	</div>
	<div class="agregar">
		<img src="images/default_libro.png" alt="Gracias apodo por ser Especial" class="libro"/>
		<img src="images/default_agrega.png" alt="Agrega un apodo" onclick="loadTemplate('app')" class="btn_agrega over"/>
	</div>
	<div class="twitter">
		<script src="https://platform.twitter.com/widgets.js"></script>
		También únete al movimiento utilizando en Twitter el hashtag <a href="https://twitter.com/search/realtime?&q=%23ApodoEspecial" target="_blank">#ApodoEspecial</a><br/> sigue a
		<a href="https://twitter.com/intent/follow?&screen_name=CuervoEspecial">@CuervoEspecial</a> para conocer las diferentes dinámicas
		<br/>
		<a href="https://twitter.com/intent/follow?&screen_name=CuervoEspecial"><img src="images/default_siguenos.png" class="over"/></a>
		<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
	</div>
</div>