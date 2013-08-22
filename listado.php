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
}

if (!ini_get('date.timezone')) {
	date_default_timezone_set('America/Mexico_City');
}
mb_internal_encoding('utf-8');

// Base de datos
$db = new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

// Log 
$log = new Log(ERROR_FILENAME);

require_once(DIR_MODEL . 'apodo.php');
$apodos = Apodo::getApodos($db);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es_MX" xml:lang="es_MX"
      xmlns:og="http://opengraphprotocol.org/schema/"
      xmlns:fb="http://ogp.me/ns/fb#">
	<head>
		<title>Wikiapodos Móvil</title>
		<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	
		<!-- INICIO: Open Graph de Facebook -->
		<meta property="og:site name" content="Wikiapodos" />
		<meta property="og:title" content="Wikiapodos" />
		<meta property="og:type" content="website" />
		<meta property="og:description" content="Listado de apodos." />
		<meta property="og:url" content="" />
		<meta property="og:image" content="" />
		<!-- FIN: Open Graph de Facebook -->
		
		<!-- Hojas de estilo -->
		<link rel="stylesheet" href="stylesheet/jc_especial.css" />
		<link rel="stylesheet" href="stylesheet/jquery/jquery.mobile.structure-1.3.2.min.css" />
		
		<!-- Librerias JQUERY -->
		<script type="text/javascript" src="javascript/jquery/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="javascript/jquery/jquery.mobile-1.3.1.min.js"></script>
		
		<style>
			.ui-content {
				border: 0.5em solid #9B1731;
				height: 100%;
			}
			
			.title {
				background-color: #9B1731;
				color: #FEE856;
				
				width: 100%;
				
				margin-left: -1em;
				padding-left: 1em;
				padding-right: 1em;
				margin-right: -1em;
				
				text-transform: uppercase;
				
				text-align: center;
			}
			
			.texto-seleccion {
				display: inline-block;
				
				text-align: center;
				
				text-transform: uppercase;
			}
			
			.selector {
				text-align: center;
			}
			
			.ui-select {
				display: inline-block;
				
				text-align: center !important;
			}
			
			.apodos {
				display: none;
			}
			
			.apodos .imagen {
				display: inline-block;
				
				width: 25%;
				
				vertical-align: top;
			}
			.apodos .imagen img {
				width: 100%;
				max-width: 250px;
				
				border: 0.3em solid #9B1731;
			}
			
			.apodos .descripcion {
				display: inline-block;
				
				width: 65%;
				
				padding-left: 1em;
				
				vertical-align: top;
				text-align: left;
				
				text-transform: uppercase;
			}
			
			.sinApodos {
				display: none;
				
				margin-bottom: 2em;
				
				text-align: center;
				
				text-transform: uppercase;
			}
			
			.footer {
				margin-top: 0.5em;
				margin-bottom: 1em;
				
				text-align: center;
			}
			
			/* Landscape phones and down */
			@media (max-width: 480px) {
				/* 16px > 1em */
				.ui-bar,
				.ui-loader-verbose h1,
				.ui-bar h1, .ui-bar h2, .ui-bar h3, .ui-bar h4, .ui-bar h5, .ui-bar h6,
				.ui-header .ui-title, 
				.ui-footer .ui-title,
				.ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				label.ui-submit,
				.ui-collapsible-heading,
				.ui-controlgroup-label,
				.ui-controlgroup .ui-checkbox label, .ui-controlgroup .ui-radio label,
				.ui-popup .ui-title,
				label.ui-select,
				label.ui-input-text,
				textarea.ui-input-text,
				.ui-li-heading,
				label.ui-slider,
				.ui-slider-switch .ui-slider-label {
					font-size: 16px;
					text-transform: uppercase;
				}
				.title {
					font-size: 38px;
				}
				.texto-seleccion, .sinApodos {
					font-size: 22px;
				}
				.ui-select {
					width: 66px !important;
				}
				.apodos .descripcion {
					font-size: 12px;
				}
				.logo {
					height: 33px;
					margin-top: 6px;
				}
			}

			/* Landscape phone to portrait tablet */
			@media (max-width: 767px) {
				/* 16px > 1em */
				.ui-bar,
				.ui-loader-verbose h1,
				.ui-bar h1, .ui-bar h2, .ui-bar h3, .ui-bar h4, .ui-bar h5, .ui-bar h6,
				.ui-header .ui-title, 
				.ui-footer .ui-title,
				.ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				label.ui-submit,
				.ui-collapsible-heading,
				.ui-controlgroup-label,
				.ui-controlgroup .ui-checkbox label, .ui-controlgroup .ui-radio label,
				.ui-popup .ui-title,
				label.ui-select,
				label.ui-input-text,
				textarea.ui-input-text,
				.ui-li-heading,
				label.ui-slider,
				.ui-slider-switch .ui-slider-label {
					font-size: 24px;
					text-transform: uppercase;
				}
				.title {
					font-size: 46px;
				}
				.texto-seleccion, .sinApodos {
					font-size: 32px;
				}
				.ui-select {
					width: 100px !important;
				}
				.apodos .descripcion {
					font-size: 18px;
				}
				.logo {
					height: 50px;
					margin-top: 10px;
				}
			}

			/* Portrait tablet to landscape and desktop */
			@media (min-width: 768px) and (max-width: 979px) {
				/* 16px > 1em */
				.ui-bar,
				.ui-loader-verbose h1,
				.ui-bar h1, .ui-bar h2, .ui-bar h3, .ui-bar h4, .ui-bar h5, .ui-bar h6,
				.ui-header .ui-title, 
				.ui-footer .ui-title,
				.ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				label.ui-submit,
				.ui-collapsible-heading,
				.ui-controlgroup-label,
				.ui-controlgroup .ui-checkbox label, .ui-controlgroup .ui-radio label,
				.ui-popup .ui-title,
				label.ui-select,
				label.ui-input-text,
				textarea.ui-input-text,
				.ui-li-heading,
				label.ui-slider,
				.ui-slider-switch .ui-slider-label {
					font-size: 32px;
					text-transform: uppercase;
				}
				.title {
					font-size: 75px;
				}
				.texto-seleccion, .sinApodos {
					font-size: 43px;
				}
				.ui-select {
					width: 133px !important;
				}
				.apodos .descripcion {
					font-size: 24px;
				}
				.logo {
					height: 66px;
					margin-top: 13px;
				}
			}

			/* Large desktop */
			@media (min-width: 980px) {
				/* 16px > 1em */
				.ui-bar,
				.ui-loader-verbose h1,
				.ui-bar h1, .ui-bar h2, .ui-bar h3, .ui-bar h4, .ui-bar h5, .ui-bar h6,
				.ui-header .ui-title, 
				.ui-footer .ui-title,
				.ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				.ui-fullsize .ui-btn-inner,
				label.ui-submit,
				.ui-collapsible-heading,
				.ui-controlgroup-label,
				.ui-controlgroup .ui-checkbox label, .ui-controlgroup .ui-radio label,
				.ui-popup .ui-title,
				label.ui-select,
				label.ui-input-text,
				textarea.ui-input-text,
				.ui-li-heading,
				label.ui-slider,
				.ui-slider-switch .ui-slider-label {
					font-size: 40px;
					text-transform: uppercase;
				}
				.title {
					font-size: 94px;
				}
				.texto-seleccion, .sinApodos {
					font-size: 54px;
				}
				.ui-select {
					width: 166px !important;
				}
				.apodos .descripcion {
					font-size: 30px;
				}
				.logo {
					height: 83px;
					margin-top: 16px;
				}
			}

		</style>
		
		<script>
			function seleccionarLetra(letra) {
				$('.apodos').hide();
				if ($('.apodos[letra="' + letra + '"]').length > 0) {
					$('.sinApodos').hide();
					$('.apodos[letra="' + letra + '"]').show();
				} else {
					$('.sinApodos').show();
				}
			}
			
			$(document).ready(function() {
				$('.selector').change(function() {
					seleccionarLetra($(this).find('option:selected').val());
				});
				
				seleccionarLetra('a');
			});
		</script>
	</head>
	<body>
		<div id="movil" data-role="page" data-theme="a">
			<div id="contenido" data-role="content">
				<div class="title">Wikiapodos <img class="logo" src="images/movil_logo.png" alt="José Cuervo Especial" /></div>
				<div class="selector" data-role="fieldcontain">
					<div class="texto-seleccion">Selecciona una letra:</label>
					<select name="select-native-1" id="select-native-1">
						<option value="a">A</option>
						<option value="b">B</option>
						<option value="c">C</option>
						<option value="d">D</option>
						<option value="e">E</option>
						<option value="f">F</option>
						<option value="g">G</option>
						<option value="h">H</option>
						<option value="i">I</option>
						<option value="j">J</option>
						<option value="k">K</option>
						<option value="l">L</option>
						<option value="m">M</option>
						<option value="n">N</option>
						<option value="o">O</option>
						<option value="p">P</option>
						<option value="q">Q</option>
						<option value="r">R</option>
						<option value="s">S</option>
						<option value="t">T</option>
						<option value="u">U</option>
						<option value="v">V</option>
						<option value="w">W</option>
						<option value="x">X</option>
						<option value="y">Y</option>
						<option value="z">Z</option>
					</select>
				</div>
				<?php
					$letra = "0";
					$primerDiv = true;
					foreach($apodos as $apodo) {
						$letraTemp = Utils::limpiaCaracteres(substr($apodo->nombre, 0, 2));
						$letraTemp = substr($letraTemp, 0, 1);
						if ($letraTemp != $letra) {
							if ($primerDiv) {
								$primerDiv = false;
							} else {
								echo '</div>';
							}
							$letra = $letraTemp;
							echo '<div class="apodos" letra="' . $letra . '" data-role="collapsible-set" data-theme="c" data-content-theme="d">';
						}
				?>
					<div class="collapsible" data-role="collapsible">
						<h3><?php echo $apodo->getNombreApodo(); ?></h3>
						<p>
							<span class="imagen"><img src="images/apodos/<?php echo $apodo->imagenUrl; ?>"/></span>
							<span class="descripcion"><?php echo $apodo->descripcion; ?></span>
						</p>
					</div>
				<?php
					}
					if (!$primerDiv) {
						echo '</div>';
					}
				?>
				<div class="sinApodos">
					Por el momento no hay apodos registrados que comiencen con esta letra.
				</div>
			</div>
		</div>
	</body>
</html