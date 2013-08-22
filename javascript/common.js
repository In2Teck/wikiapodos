String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}

/**
 * Método que redirige la página a la url indicada.
 * @param url al cual se desea redirigir.
 */
function redirige(url) {
	window.top.location = url;
}

var spinner = null;
/**
 * Método que muestra el loader.
 */
function showLoader() {
	$('#loader').show();
	if (spinner == null) {
		var opts = {
			lines: 13, // The number of lines to draw
			length: 20, // The length of each line
			width: 10, // The line thickness
			radius: 30, // The radius of the inner circle
			corners: 1, // Corner roundness (0..1)
			rotate: 0, // The rotation offset
			direction: 1, // 1: clockwise, -1: counterclockwise
			color: '#FFFFFF', // #rgb or #rrggbb
			speed: 1, // Rounds per second
			trail: 60, // Afterglow percentage
			shadow: false, // Whether to render a shadow
			hwaccel: false, // Whether to use hardware acceleration
			className: 'spinner', // The CSS class to assign to the spinner
			zIndex: 2e9, // The z-index (defaults to 2000000000)
			top: '0', // Top position relative to parent in px
			left: '0' // Left position relative to parent in px
		};
		var target = document.getElementById('spinner');
		spinner = new Spinner(opts).spin(target);
	} else {
		var target = document.getElementById('spinner');
		spinner.spin(target);
	}
}

/**
 * Método que oculta el loader.
 */
function hideLoader() {
	$('#loader').hide();
	if (spinner != null) {
		spinner.stop();
	}
}

/**
 * Método que carga el template y los parámetros en el contenido por medio de AJAX.
 * @param template que se utilizará.
 * @param qs querystring que se utilizará durante la carga del template.
 */
function loadTemplate(template, qs) {
	if (qs === undefined) {
		qs = '';
	}
	showLoader();
	$('#content').load('ajax.php?accion=template&page=' + template + '&signed_request=' + $('#signed_request').val() + '&' + qs,
		function(response, status, xhr) {
			actualizaBotones();
			if (template != 'creador') {
				hideLoader();
			}
			/**
			if (status == "error") {
				alert(xhr.status + " " + xhr.statusText);
			}
			**/
		});
}

/**
 * Método que dispara el evento click en el elemento deseado cuando el usuario presiona 'Enter'.
 * @param evento del teclado.
 * @param funcion que se desea ejecutar.
 * @param parametros con los que se ejecuta la función.
 */
function ejecutaEnEnter(event, funcion, parametros) {
	if (event.keyCode == 13) {
		if (parametros) {
			funcion(parametros);
		} else {
			funcion();
		}
	}
}

/**
 * Función que actualiza las imágenes de los botones de la aplicación.
 **/
function actualizaBotones() {
	$('.over').unbind('mouseenter');
	$('.over').unbind('mouseleave');
	$('.over').mouseenter(function() {
		imgRegularToOver(this);
	}).mouseleave(function() {
		imgToRegular(this);
	});
	$('.boton').unbind('mouseenter');
	$('.boton').unbind('mouseleave');
	$('.boton').mouseenter(function() {
		invierteColores(this);
	}).mouseleave(function() {
		invierteColores(this);
	});
}

function imgRegularToOver(elemento) {
	source = $(elemento).attr('src');
	if (source.indexOf('_over') < 0 && source.indexOf('_selected') < 0) {
		punto = source.lastIndexOf('.');
		nombre = source.substring(0, punto);
		ext = source.substring(punto, source.length);
	
		$(elemento).attr('src', nombre + '_over' + ext);
	}
}

function imgRegularToSelected(elemento) {
	source = $(elemento).attr('src');
	if (source.indexOf('_over') < 0 && source.indexOf('_selected') < 0) {
		punto = source.lastIndexOf('.');
		nombre = source.substring(0, punto);
		ext = source.substring(punto, source.length);
	
		$(elemento).attr('src', nombre + '_selected' + ext);
	}
}

function imgToRegular(elemento) {
	source = $(elemento).attr('src');
	if (source.indexOf('_over') >= 0 || source.indexOf('_selected') >= 0) {
		guion = source.lastIndexOf('_');
		punto = source.lastIndexOf('.');
		nombre = source.substring(0, guion);
		ext = source.substring(punto, source.length);
	
		if ($(elemento).hasClass('selected')) {
			$(elemento).attr('src', nombre + '_selected' + ext);
		} else {
			$(elemento).attr('src', nombre + ext);
		}
	}
}

function invierteColores(elemento) {
	color = $(elemento).css('color');
	background = $(elemento).css('background-color');
	$(elemento).css('color', background);
	$(elemento).css('background-color', color);
}

/**
 * Método que quita todos los caracteres acentuados o tildes por su correspondiente
 * caracter sin acento o tilde.
 * @param cadena que se desea "limpiar".
 * @return cadena
 **/
function limpiaCaracteres(s) {
	var r = s.toLowerCase();
	r = r.replace(new RegExp("\\s", 'g'),"");
	r = r.replace(new RegExp("[àáâãäå]", 'g'),"a");
	r = r.replace(new RegExp("æ", 'g'),"ae");
	r = r.replace(new RegExp("ç", 'g'),"c");
	r = r.replace(new RegExp("[èéêë]", 'g'),"e");
	r = r.replace(new RegExp("[ìíîï]", 'g'),"i");
	r = r.replace(new RegExp("ñ", 'g'),"n");	    
	r = r.replace(new RegExp("[òóôõö]", 'g'),"o");
	r = r.replace(new RegExp("œ", 'g'),"oe");
	r = r.replace(new RegExp("[ùúûü]", 'g'),"u");
	r = r.replace(new RegExp("[ýÿ]", 'g'),"y");
	r = r.replace(new RegExp("\\W", 'g'),"");
	return r;
}

/**
 * Método que limita una cadena a un número máximo de caracteres. El método regresa la
 *  cadena original en caso de que no pase el número máximo de caracteres o regresa
 *  los primeros caracteres seguido de '...' completando el número máximo de caracteres.
 * @param cadena que se desea limitar.
 * @param maximo número máximo de caracteres permitidos.
 * @return cadena
 **/
function limitaCaracteres(cadena, maximo) {
	if (cadena.length > maximo) {
		cadena.substring(0, maximo - 3) + '...';
	}
	return cadena;
}

/**
 * Método que publica en el muro del usuario.
 * @param facebook_id id de facebook del usuario.
 * @param titulo titulo del mensaje
 * @param subtitulo subtitulo del mensaje
 * @param descripcion descripcion del mensaje
 * @param url url a la que se redirigirá
 * @param imagen imagen que se desplegará
 **/
function publicarEnMuro(facebook_id, titulo, subtitulo, descripcion, url, imagen) {
	FB.ui({
		method: 'feed',
		to: facebook_id,
		name: titulo,
		caption: subtitulo,
		description: descripcion,
		link: url,
		picture: imagen
	},
	function(response) {
		funcionSuccess(response);
	});
}