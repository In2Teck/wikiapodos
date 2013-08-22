<?php
// Reportar errores
error_reporting(E_ALL);

// Revisa versión de PHP
if (version_compare(phpversion(), '5.1.0', '<') == TRUE) {
	exit('PHP5.1+ Requerido');
}

// Correccion de Magic Quotes
if (ini_get('magic_quotes_gpc')) {
	function clean($data) {
   		if (is_array($data)) {
  			foreach ($data as $key => $value) {
    			$data[clean($key)] = clean($value);
  			}
		} else {
  			$data = stripslashes($data);
		}
	
		return $data;
	}			
	
	$_GET = clean($_GET);
	$_POST = clean($_POST);
	$_COOKIE = clean($_COOKIE);
}

if (!ini_get('date.timezone')) {
	date_default_timezone_set('America/Mexico_City');
}

// Compatibilidad con Windows IIS  
if (!isset($_SERVER['DOCUMENT_ROOT'])) { 
	if (isset($_SERVER['SCRIPT_FILENAME'])) {
		$_SERVER['DOCUMENT_ROOT'] = str_replace('\\', '/', substr($_SERVER['SCRIPT_FILENAME'], 0, 0 - strlen($_SERVER['PHP_SELF'])));
	}
}

if (!isset($_SERVER['DOCUMENT_ROOT'])) {
	if (isset($_SERVER['PATH_TRANSLATED'])) {
		$_SERVER['DOCUMENT_ROOT'] = str_replace('\\', '/', substr(str_replace('\\\\', '\\', $_SERVER['PATH_TRANSLATED']), 0, 0 - strlen($_SERVER['PHP_SELF'])));
	}
}

if (!isset($_SERVER['REQUEST_URI'])) { 
	$_SERVER['REQUEST_URI'] = substr($_SERVER['PHP_SELF'], 1); 
	
	if (isset($_SERVER['QUERY_STRING'])) { 
		$_SERVER['REQUEST_URI'] .= '?' . $_SERVER['QUERY_STRING']; 
	} 
}

// Base de datos
$db = new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

// Log 
$log = new Log(ERROR_FILENAME);

// Request
$request = new Request();

// Session
$session = new Session();

// Template
$template = new Template();

function actualizaCache($db) {
	$cache = new Cache();
	$temp = Configuracion::getConfiguracionById($db, 'titulo_pagina');
	if ($temp != null) {
		$cache->tituloPagina = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'descripcion_pagina');
	if ($temp != null) {
		$cache->descripcionPagina = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'url_portal');
	if ($temp != null) {
		$cache->urlPortal = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'url_portal_fb');
	if ($temp != null) {
		$cache->urlPortalFB = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'url_portal_fb_corto');
	if ($temp != null) {
		$cache->urlPortalFBCorto = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'url_app_fb');
	if ($temp != null) {
		$cache->urlAppFB = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'fb_app_id');
	if ($temp != null) {
		$cache->fbAppId = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'fb_app_secret');
	if ($temp != null) {
		$cache->fbAppSecret = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'fb_like_page_id');
	if ($temp != null) {
		$cache->fbLikePageId = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'fb_permissions');
	if ($temp != null) {
		$cache->fbPermissions = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'url_imagenes_facebook');
	if ($temp != null) {
		$cache->urlImagenesFacebook = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'pagination_limit_apodo');
	if ($temp != null) {
		$cache->paginationLimit = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'youtube_video_id');
	if ($temp != null) {
		$cache->youtubeVideoId = $temp->valor;
	}
	$temp = Configuracion::getConfiguracionById($db, 'ultima_modificacion');
	if ($temp != null) {
		$cache->ultimaModificacion = $temp->valor;
	}
	return $cache;
}

// Obtiene la caché de variables
$cache = $session->getSession('cache');
if ($cache != null) {
	$temp = Configuracion::getConfiguracionById($db, 'ultima_modificacion');
	if ($cache->ultimaModificacion != $temp->valor) {
		$cache = actualizaCache($db);
		$session->setSession('cache', $cache);
	}
} else {
	$cache = actualizaCache($db);
	$session->setSession('cache', $cache);
}

// Se inicia facebook y se obtienen las variables de base de datos.
$config = array();
$config['appId'] = $cache->fbAppId;
$config['secret'] = $cache->fbAppSecret;
$config['fileUpload'] = false;
$config['cookie'] = true;
$facebook = new Facebook($config);

$signed_request = $facebook->getSignedRequest();
if (isset($signed_request)) {
	if (isset($signed_request["app_data"])) {
		$app_data = $signed_request["app_data"];
		$arreglo = Utils::jsonToArray($app_data);
		if (isset($arreglo) && count($arreglo) > 0) {
			foreach($arreglo as $llave => $valor) {
				if (!$request->isRequest($llave)) {
					$request->setRequest($llave, $valor);
				}
			}
		}
	}
	if (isset($signed_request["page"])) {
		$page = $signed_request["page"];
		$liked = $page["liked"];
	}
	if (isset($signed_request["user_id"])) {
		$usuarioFB = $signed_request["user_id"];
	}
}

$qs = "";
foreach($request->request as $llave => $valor) {
	$qs .= $llave.'='.$valor.'&';
}
substr_replace($qs, "", -1);
$cache->urlRedirect = $cache->urlPortalFB."?app_data=".Utils::querystringToJson($qs);

// Se definen variables globales
define('ACT_LOGIN', 0);
define('ACT_SUBIR_APODO', 1);
define('ACT_ASIGNAR_APODO', 2);
define('ACT_VISITAR_APODO', 3);
define('ACT_COMPARTIR_APODO', 4);
define('ACT_CALIFICAR_APODO', 5);
define('ACT_REPORTAR_APODO', 6);

try {
	// Obtiene el usuario de facebook.
	if (!isset($usuarioFB) || $usuarioFB <= 0) {
		$usuarioFB = FacebookHelper::getUsuario($facebook);
	}
	
	if ($usuarioFB) {
		// Si no se obtuvo el like por medio del signed_request se pregunta a FB.
		if (!isset($liked)) {
			$liked = FacebookHelper::getLikeID($facebook, $usuarioFB, $cache->fbLikePageId);
		}
		
		if ($request->isRequest('request_ids')) {
			FacebookHelper::borrarRequest($facebook, $request->getRequest('request_ids'));
		}
		
		// Sabemos que está autenticado el usuario de facebook
		$usuario = $session->getSession('usuario');
		
		if ($usuario == null || $usuario->id != $usuarioFB) {
			// Obtiene el usuario registrado
			$usuario = Usuario::getUsuarioById($db, $usuarioFB);
		}
		
		if ($usuario == null) {
			// Usuario NO registrado en nuestro sistema
			$perfilFB = FacebookHelper::getPerfil($facebook, $usuarioFB); // Obtiene el perfil de facebook
			
			if ($perfilFB) {
				$usuario = new Usuario();
				$usuario->id = $usuarioFB;
				$usuario->nombre = $perfilFB['first_name'];
				$usuario->apellido = $perfilFB['last_name'];
				$usuario->email = $perfilFB['email'];
				$usuario->acepto = true;
				if ($liked) {
					if ($session->isSession('nuevo_like') && !$session->getSession('nuevo_like')) {
						$usuario->esFan = 2;
					} else {
						$usuario->esFan = 1;
					}
				} else {
					$usuario->esFan = 0;
				}
				$usuario = Usuario::guardar($db, $usuario);
				
				/* Postea en Facebook */
				$postFacebook = new PostFacebook();
				$postFacebook->titulo = 'Wikiapodos';
				$postFacebook->descripcion = 'Yo ya estoy viendo y poniendo apodos usando Wikiapodos.';
				$postFacebook->urlDestino = $cache->urlPortalFB;
				$postFacebook->urlImagen = $cache->urlPortal.'images/logo.png?t='.$cache->ultimaModificacion;
				$postFacebook->urlPortal = $cache->urlPortalFB;
				FacebookHelper::publicaEnMuro($facebook, $usuario->id, $postFacebook);
			}
			
			if (!$session->isSession('nuevo_like')) {
				$session->setSession('nuevo_like', $liked);
			}
		}
		
		// Realiza login
		if ($session->getSession('usuario') == null) {
			Usuario::registraAcceso($db, $usuario);
		}
		if (FacebookHelper::getNumAmigos($facebook, $usuario->id) != count($usuario->amigos)) {
			$usuario->amigos = FacebookHelper::getAmigos($facebook, $usuario->id);
		}
		$session->setSession('usuario', $usuario);
	} else {
		$session->unsetSession('usuario');
		
		if (!$session->isSession('nuevo_like')) {
			$session->setSession('nuevo_like', $liked);
		}
	}
} catch (FacebookApiException $e) {
	$log->write('FacebookApiException: ' . $e);
}
if (isset($liked) && !$liked) {
	$request->setRequest('page', 'like');
} else if ($request->isRequest('request_ids') && !$request->isRequest('page')) {
	$request->setRequest('page', 'apodos');
	$request->setRequest('tipo', 'asignados');
	$request->setRequest('forzar', 'permisos');
}
?>