<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $request, $session, $template;
	
	// Declaraciones de funciones
	
	// Controles
	
	// Variables de template
	$listaDefiniciones = $template->fetch('listaDefiniciones');
	$usuario = $session->getSession('usuario');
	
	if ($usuario == null) {
		$permisos = $template->fetch('permisos');
	} else {
		$tipo = $request->getRequest('tipo');	
		$apodos = array();
		
		switch ($tipo) {
			case 'creados':
				$apodos = Apodo::getApodosCreados($db, $usuario->id);
				break;
			case 'asignados':
				$apodos = Apodo::getApodosAsignados($db, $usuario->id);
				break;
			default:
				$tipo = 'asignados';
				break;
		}
	}
?>