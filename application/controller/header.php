<?php
	// Importación de modelos

	// Declaraciones de variables
	global $cache, $facebook, $request, $session;
	
	$page = $request->getRequest('page');
	$usuario = $session->getSession('usuario');
	
	// Declaraciones de funciones
	
	// Controles
	
	// Variables de template
	$titulo = $cache->tituloPagina;
	$descripcion = $cache->descripcionPagina;
?>