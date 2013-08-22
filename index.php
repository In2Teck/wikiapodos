<?php
/**
 * @copyright	Copyright (C) 2012 Rhapsodia Systems SA de CV. Derechos reservados.
 */

// Define separador de directorios
define('DS', DIRECTORY_SEPARATOR);

if (!defined('_STARTUP')) {
	define('PATH_BASE', dirname(__FILE__));
	require_once PATH_BASE.DS.'config.php';
	require_once PATH_BASE.DS.'startsession.php';
	require_once DIR_SYSTEM.'startup.php';
}

$home = $template->fetch('home');
echo $home;
?>