<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es_MX" xml:lang="es_MX"
      xmlns:og="http://opengraphprotocol.org/schema/"
      xmlns:fb="http://ogp.me/ns/fb#"
      style="overflow: hidden">
	<head>
		<title><?php echo $titulo; ?></title>
		<meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
	
		<!-- INICIO: Open Graph de Facebook -->
		<meta property="og:site name" content="<?php echo $titulo; ?>" />
		<meta property="og:title" content="<?php echo $titulo; ?>" />
		<meta property="og:type" content="website" />
		<meta property="og:description" content="<?php echo $descripcion; ?>" />
		<meta property="og:url" content="<?php echo $cache->urlPortalFB; ?>" />
		<meta property="og:image" content="<?php echo $cache->urlPortal; ?>/images/logo.png?t=<?php echo $cache->ultimaModificacion; ?>" />
		<!-- FIN: Open Graph de Facebook -->

		<?php if (isset($icono)) { ?>
			<link href="<?php echo $icon; ?>" rel="icono" />
		<?php } ?>
		
		<!-- Hojas de estilo -->
		<link rel="stylesheet" href="stylesheet/ui-darkness/jquery-ui-1.10.2.custom.min.css" />
		<link rel="stylesheet" type="text/css" href="stylesheet/stylesheet.css<?php echo '?t='.$cache->ultimaModificacion; ?>" />
		<link rel="stylesheet" type="text/css" href="stylesheet/stylesheet_ricardo.css<?php echo '?t='.$cache->ultimaModificacion; ?>" />
		<link rel="stylesheet" href="stylesheet/csphotoselector.css" />
		
		<!-- Librerias JQUERY -->
		<script type="text/javascript" src="javascript/jquery/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="javascript/jquery/jquery-ui-1.10.2.custom.min.js"></script>
		<script type="text/javascript" src="javascript/jquery/spin/spin.js"></script>
		<script type="text/javascript" src="javascript/jquery/imagesloaded.pkgd.min.js"></script>
		
		<!-- Librerias proyecto -->
		<script type="text/javascript" src="javascript/common.js<?php echo '?t='.$cache->ultimaModificacion; ?>"></script>
		
		<!--[if IE]>
			<script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<!--[if IE 7]>
			<link rel="stylesheet" type="text/css" href="stylesheet/ie7.css" />
		<![endif]-->
		<!--[if lt IE 7]>
			<link rel="stylesheet" type="text/css" href="stylesheet/ie6.css" />
			<script type="text/javascript" src="javascript/DD_belatedPNG_0.0.8a-min.js"></script>
			<script type="text/javascript">
				DD_belatedPNG.fix('#logo img');
			</script>
		<![endif]-->

		<script type="text/javascript">
			$(document).ready(function() {
				if ( /android|webos|iphone|ipad|ipod|blackberry|iemobile/i.test(navigator.userAgent.toLowerCase()) ) {
					redirectToMobile();
				} else if (referrerIsFacebookApp()) {
					redirectToServer();
				} else {
					$('#page').show();
					actualizaBotones();
				}
			});
			
			util = {
				qsToObject:
					function (qs) {
						var o = {};
						qs.replace(
							new RegExp("([^?=&]+)(=([^&]*))?", "g"),
							function ($0, $1, $2, $3) { o[$1] = $3; }
						);
						return o;
					},
				objectToQs:
					function (o) {
						var str = [];
						for (var k in o)
							str.push(k + "=" + o[k]);
						return str.join("&");
					}
			}
			
			function redirectToMobile() {
				top.location = '<?php echo $cache->urlPortal; ?>listado.php';
			}

			function redirectToServer() {
				var json = util.qsToObject(location.search);
				var qs = '?app_data=' + encodeURIComponent(JSON.stringify(json));
				top.location = '<?php echo $cache->urlPortalFB; ?>' + qs;
			}
			
			function referrerIsFacebookApp() {
				var isInIFrame = (window.location != window.parent.location) ? true : false;
				if (document.URL) {
					if (isInIFrame) {
						return document.referrer.indexOf("apps.facebook.com") != -1;
					} else {
						return document.URL.indexOf("cuervotradicional.com") != -1
								|| document.URL.indexOf("apps.t2omedia.com.mx") != -1
								|| document.URL.indexOf("apps.facebook.com") != -1
								|| document.URL.indexOf("apodoespecial.mx") != -1;
					}
				}
				return false;
			}
		</script>
	</head>
<body>
	<!-- Integración con facebook -->
	<div id="fb-root"></div>
	<script type="text/javascript">
		var user_id;
		
		function loginResult() {
			FB.api('/me', function(response) {
				user_id = response.id;
			});
		}
		
		function login(id, perms, uri) {
			var params = window.location.toString().slice(window.location.toString().indexOf('?'));
			params = params.toString().replace(/&/g, "%26");
			top.location = 'https://graph.facebook.com/oauth/authorize?client_id='+id+'&scope='+perms+'&redirect_uri='+uri+params;
		}
		
		window.fbAsyncInit = function() {
			FB.init({
				appId: "<?php echo $facebook->getAppID(); ?>",
				status: true,
				cookie: true,
				xfbml: true,
				channelUrl : '<?php echo $cache->urlPortal; ?>channel.html'
			});
			FB.Event.subscribe('auth.login', function(response) {
				FB.getLoginStatus(
					function(response) {
						if (response.authResponse) {
							loginResult();
						} else {
							<?php if ($usuario != null) { ?>
							redirect("<?php echo $facebook->getAppID(); ?>", "<?php echo $cache->fbPermissions; ?>", "<?php echo $cache->urlPortalFB . '?page=app'; ?>");
							<?php } ?>
						}
					}
				);
			});
			FB.Canvas.setAutoGrow();
		};
		(function() {
			var e = document.createElement('script'); e.async = true;
			e.src = document.location.protocol + "//connect.facebook.net/es_LA/all.js";
			document.getElementById('fb-root').appendChild(e);
		}());
	</script>
	<input type="hidden" id="signed_request" name="signed_request" value="<? print $_REQUEST['signed_request']; ?>">
	<div id="page" style="display: none;">
		<div id="loader"><div id="spinner"></div></div>
		<div id="ayuda_wikiapodos">
			<img id="ayuda_cerrar" src="images/ayuda_cerrar.png" />
			<img id="ayuda_1" src="images/ayuda_app_1.png" />
			<img id="ayuda_2" src="images/ayuda_app_2.png" />
			<img id="ayuda_3" src="images/ayuda_app_3.png" />
			<img id="ayuda_4" src="images/ayuda_app_4.png" />
			<img id="ayuda_5" src="images/ayuda_app_5.png" />
			<img id="ayuda_6" src="images/ayuda_app_6.png" />
		</div>
		<div id="ayuda_creador">
			<img id="ayuda_cerrar" src="images/ayuda_cerrar.png" />
			<img id="ayuda_1" src="images/ayuda_app_1.png" />
			<img id="ayuda_2" src="images/ayuda_creador_1.png" />
			<img id="ayuda_3" src="images/ayuda_creador_2.png" />
			<img id="ayuda_4" src="images/ayuda_creador_3.png" />
			<img id="ayuda_5" src="images/ayuda_creador_4.png" />
			<img id="ayuda_6" src="images/ayuda_creador_5.png" />
		</div>
		<div id="header">
			<ul id="menu">
				<li><img id="mnu_default" class="over" src="images/mnu_apodos.png" alt="Apodos" onclick="loadTemplate('default')"/></li>
				<li><img id="mnu_app" class="over" src="images/mnu_wikiapodos.png" alt="Wikiapodos" onclick="loadTemplate('app','seccion=principal')"/></li>
			</ul>
		</div>
		<div id="content">