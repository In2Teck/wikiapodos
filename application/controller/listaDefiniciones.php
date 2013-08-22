<?php
	// Importación de modelos
	require_once(DIR_MODEL . 'apodo.php');
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $session, $template;
	
	// Declaraciones de funciones
	
	// Controles
	$apodos = Apodo::getApodos($db);
	
	// Variables de template
	$limitePaginador = 7;
?>