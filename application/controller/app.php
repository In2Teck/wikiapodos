<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $request, $session, $template;
	
	// Declaraciones de funciones
	
	// Controles
	$destacados = Apodo::getDestacados($db, 3);
	
	// Variables de template
	$listaDefiniciones = $template->fetch('listaDefiniciones');
	$usuario = $session->getSession('usuario');
	
	if ($usuario == null) {
		$permisos = $template->fetch('permisos');
	} else {
		if ($session->isSession('nuevo')) {
			if ($session->getSession('nuevo')) {
				$session->setSession('nuevo', false);
			}
		} else if ($request->isRequest('nuevo') && $request->getRequest('nuevo') == 'true') {
			$session->setSession('nuevo', true);
		}
		
		$amigos = $usuario->amigos;
	
		$amigos_ids = array();
		for ($i = 0; $i < count($amigos); $i++){
			$amigos_ids[] = $amigos[$i]['uid'];
		}
	
		$amigos_con_apodo = Apodo::getAmigosConApodo($db, implode(",", $amigos_ids));
	}
?>