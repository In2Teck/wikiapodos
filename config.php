<?php
// DIR
define('DIR_ROOT',			realpath(dirname(__FILE__)).'/');
define('DIR_APPLICATION',	DIR_ROOT.'application/');
define('DIR_CONTROLLER',	DIR_APPLICATION.'controller/');
define('DIR_MODEL',			DIR_APPLICATION.'model/');
define('DIR_TEMPLATE',		DIR_APPLICATION.'view/');
define('DIR_IMAGE',			DIR_ROOT.'images/');
define('DIR_SYSTEM',		DIR_ROOT.'system/');
define('DIR_DATABASE',		DIR_SYSTEM.'database/');
define('DIR_LIBRARY',		DIR_SYSTEM.'library/');
define('DIR_LOGS',			DIR_SYSTEM.'logs/');

// DIR relativos
define('URL_IMAGE',			'images/');

// DB
define('DB_DRIVER',			'mysql');
define('DB_HOSTNAME',		'php1.apps.t2omedia.com.mx');
define('DB_USERNAME',		'rails');
define('DB_PASSWORD',		't2omedia');
define('DB_DATABASE',		'jc_wikiapodos');
define('DB_PREFIX',			'');

// Errores
define('ERROR_DISPLAY',		0);
define('ERROR_LOG',			1);
define('ERROR_FILENAME',	'error.txt');

// Modelos usados en sesión
require_once(DIR_MODEL . 'cache.php');
require_once(DIR_MODEL . 'configuracion.php');
require_once(DIR_MODEL . 'usuario.php');

// Librerias
require_once(DIR_SYSTEM . 'library/db.php');
require_once(DIR_SYSTEM . 'library/error.php');
require_once(DIR_SYSTEM . 'library/facebook.php');
require_once(DIR_SYSTEM . 'library/facebookHelper.php');
require_once(DIR_SYSTEM . 'library/image.php');
require_once(DIR_SYSTEM . 'library/json.php');
require_once(DIR_SYSTEM . 'library/log.php');
require_once(DIR_SYSTEM . 'library/pagination.php');
require_once(DIR_SYSTEM . 'library/request.php');
require_once(DIR_SYSTEM . 'library/session.php');
require_once(DIR_SYSTEM . 'library/template.php');
require_once(DIR_SYSTEM . 'library/utils.php');
?>