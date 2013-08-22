<?php
	// Importación de modelos
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $request, $session, $template;
	
	// Declaraciones de funciones
	
	// Controles
	
	// Variables de template
	$usuarios = Usuario::getUsuariosRandom($db, null, 13);
	$session->unsetSession('nuevo');
	
	$app_data = '{\"page\":\"app\",\"nuevo\":\"true\"}';
	if ($request->getRequest('page') == 'apodos') {
		$app_data = '{\"page\":\"apodos\",\"tipo\":\"asignados\",\"nuevo\":\"true\"}';
	} else if ($request->getRequest('page') == 'apodo') {
		if ($request->getRequest('asignar') == 'true') {
			$app_data = '{\"page\":\"apodo\",\"id\":\"' . $request->getRequest('id') . '\",\"nuevo\":\"true\",\"asignar\":\"true\"}';
		} else {
			$app_data = '{\"page\":\"apodo\",\"id\":\"' . $request->getRequest('id') . '\",\"nuevo\":\"true\"}';
		}
	}
	$urlRedireccion = $cache->urlPortalFB . '?app_data=' . $app_data;
?>