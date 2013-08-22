<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	require_once(DIR_MODEL . 'calificacion.php');
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $request, $session, $template;
	
	// Variables de template
	$listaDefiniciones = $template->fetch('listaDefiniciones');
	$usuario = $session->getSession('usuario');
	
	if ($usuario == null) {
		$permisos = $template->fetch('permisos');
	} else {
		$idApodo = $request->getRequest('id');
		if ($idApodo != null) {
			$apodo = Apodo::getApodoById($db, $idApodo, $usuario->amigos);
		}
		$asignarAmigo = $request->getRequest('asignar');
	
		$calificacion =	Calificacion::getUsuarioCalificacion($db, $usuario->id, $idApodo);
	
		$amigos = $usuario->amigos;
	
		$amigos_ids = array();
		for ($i = 0; $i < count($amigos); $i++){
			$amigos_ids[] = $amigos[$i]['uid'];
			$amigos[$i]['status'] = -1;
		}
	
		$amigos_apodos_usuarios = Apodo::getApodosUsuariosAmigos($db, $idApodo, implode(",", $amigos_ids));
		
		for ($i = 0; $i < count($amigos_apodos_usuarios); $i++) {
			for ($j = 0; $j < count($amigos); $j++) {
				if ($amigos_apodos_usuarios[$i]->id == $amigos[$j]['uid']){
					$amigos[$j]['status'] = $amigos_apodos_usuarios[$i]->status;
				}
			}
		}
	}
	
	// Declaraciones de funciones
	
	// Controles
	
?>