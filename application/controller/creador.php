<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	require_once(DIR_MODEL . 'categoria.php');
	require_once(DIR_MODEL . 'cuerpo.php');
	require_once(DIR_MODEL . 'imagen.php');
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $session, $template;
	
	// Declaraciones de funciones
	
	// Controles
	
	// Variables de template
	$usuario = $session->getSession('usuario');
	
	if ($usuario == null) {
		$permisos = $template->fetch('permisos');
	} else {
		$categorias = Categoria::getCategorias($db);
		$cuerpos = Cuerpo::getCuerpos($db);
		$imagenes = Imagen::getImagenes($db);
		$apodos = Apodo::getApodos($db);
		
		$amigos = $usuario->amigos;
		$palabrasProhibidas = Utils::obtienePalabrasProhibidas();
		
		if ($session->isSession('nuevo_creador')) {
			if ($session->getSession('nuevo_creador')) {
				$session->setSession('nuevo_creador', false);
			}
		} else {
			$session->setSession('nuevo_creador', true);
		}
	}
?>