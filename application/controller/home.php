<?php
	// Importación de modelos
	
	// Declaraciones de variables
	global $request, $template;
	
	$paginaHeader = 'header';
	$paginaContenido = 'default';
	$paginaFooter = 'footer';
	
	// Declaraciones de funciones
	
	
	// Controles
	$paginaContenido = $request->getRequest('page');
	if (!isset($paginaContenido)) {
		$paginaContenido = 'app';
	}
	
	// Variables de template
	$header = $template->fetch($paginaHeader);
	$content = $template->fetch($paginaContenido);
	$footer = $template->fetch($paginaFooter);
?>