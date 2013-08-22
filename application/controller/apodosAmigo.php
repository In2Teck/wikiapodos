<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	require_once(DIR_MODEL . 'usuario.php');
	
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
		$id = $request->getRequest('id');	
		$amigo = FacebookHelper::getUserName($facebook, $id);
		$nombreAmigo = $amigo->nombre;
		$apodos = Apodo::getApodosAceptados($db, $id);
					
	}
?>