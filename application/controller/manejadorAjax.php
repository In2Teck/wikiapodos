<?php
	// Importación de modelos
	require_once(DIR_MODEL."postFacebook.php");
	require_once(DIR_MODEL."calificacion.php");
	require_once(DIR_MODEL."apodo.php");
	
	// Declaraciones de variables
	global $cache, $db, $facebook, $request, $template, $session;
	
	$usuario = $session->getSession('usuario');
	if (isset($usuario) && $usuario != null) {
		$usuarioId = $usuario->id;
	}
		
	$paginaTemplate = $request->getRequest('page');
	$accion = $request->getRequest('accion');
	$id = $request->getRequest('id');
	$funcion = $request->getRequest('funcion');
		
	// Declaraciones de funciones
	$content = '<response><error>Lo sentimos, hubo un error durante la conexión. Favor de intentar mas tarde.</error></response>';
	
	// Controles
	
	switch ($accion) {
		case 'template':
        	$content = $template->fetch($paginaTemplate);
        	break;
    	case 'funcion':
        	switch ($funcion) {
        		case 'actualizarCalificacion':
        			$apodoId = $request->getRequest('apodoId');
        			$calificacion = $request->getRequest('calificacion');
        			
        			if ($apodoId != null && $usuarioId != null && $calificacion != null) {
        				Calificacion::actualizarCalificacion($db, $usuarioId, $apodoId, $calificacion);
        				Calificacion::actualizarCalificacionPromedio($db, $apodoId);
        				$calificacionPromedio = Calificacion::getCalificacionPromedio($db, $apodoId);
        			}
        			
        			$content = '<response><calificacionPromedio>'. $calificacionPromedio .'</calificacionPromedio><success>true</success></response>';
        			
        			break;
        		case 'etiquetarAmigos':
        			$apodoId = $request->getRequest('apodoId');
        			$amigos = $request->getRequest('amigos');
        			        			
        			if ($apodoId != null && $amigos != null && $usuarioId != null) {
        				Apodo::guardarInvitaciones($db, $usuarioId, $apodoId, $amigos);
        			}
        			
        			break;
        		case 'crearApodo':
        			$apodoRequest = $request->getRequest('apodo');
        			
        			if ($apodoRequest != null) {
        				$apodo = new Apodo($apodoRequest);
        				$apodo->autorId = $usuarioId;
        				$apodo->calificacion = 0;
        				$apodo->visible = 1;
        				$apodo->destacado = 0;
        				$apodo->urlCorto = $cache->urlPortalFBCorto;
        				
        				if (Apodo::existeApodo($db, $apodo)) {
							$content = '<response><success>true</success><existeApodo>true</existeApodo></response>';
						} else if (substr($apodo->nombre, 0, 3) == 'el ' || substr($apodo->nombre, 0, 3) == 'la ') {
							$content = '<response><success>true</success><prefijo>true</prefijo></response>';
						} else if (!Utils::verificaPalabrasProhibidas(Utils::limpiaCaracteres($apodo->nombre))) {
							$content = '<response><success>true</success><palabraProhibida>true</palabraProhibida></response>';
						} else if (!Utils::verificaPalabrasProhibidas(Utils::limpiaCaracteres($apodo->descripcion))) {
							$content = '<response><success>true</success><palabraProhibida>true</palabraProhibida></response>';
						} else {
							// Se copia el avatar.
							$nuevaUrl = Utils::limpiaCaracteres($apodo->getNombreApodo()) . '_' . $usuarioId . '.png';
							$apodo->imagenUrl = substr($apodo->imagenUrl, 0, strpos($apodo->imagenUrl, '?'));
							copy(DIR_ROOT . $apodo->imagenUrl, DIR_ROOT . 'images/apodos/' . $nuevaUrl);
							unlink(DIR_ROOT . $apodo->imagenUrl);
							$apodo->imagenUrl = $nuevaUrl;
							
        					$apodoId = Apodo::guardar($db, $apodo);
							$content = '<response><success>true</success><apodoId>'. $apodoId .'</apodoId></response>';
							
							// Obtiene URL corta
							$url = $cache->urlPortalFB . '?app_data={"accion":"template","page":"apodo","id":"' . $apodoId . '"}';
        			        $urlCorto = Utils::obtieneUrlCorta($url);
        			        Apodo::actualizarUrlCorto($db, $apodoId, $urlCorto);
							
        			        /* Postea en Facebook */
        			        $apodo = Apodo::getApodoById($db, $apodoId, array());
        			        
							$postFacebook = new PostFacebook();
							$postFacebook->titulo = $apodo->getNombreApodo();
							$postFacebook->descripcion = 'He creado un APODO ESPECIAL en el WIKIAPODOS, chécalo aquí.';
							$postFacebook->urlDestino = $apodo->urlCorto;
							$postFacebook->urlImagen = $cache->urlPortal . 'images/apodos/' .$apodo->imagenUrl;
							$postFacebook->urlPortal = $apodo->urlCorto;
							FacebookHelper::publicaEnMuro($facebook, $usuario->id, $postFacebook);
						}
        			}
        			break;
        		case 'actualizarURLCorto':
        			$apodoId = $request->getRequest('apodoId');
        			$urlCorto = $request->getRequest('urlCorto');
        			
        			if ($apodoId != null && $urlCorto != null) {
        				Apodo::actualizarUrlCorto($db, $apodoId, $urlCorto);
        			}        			
        			break;
        		case 'aceptarApodo':
        			$apodoId = $request->getRequest('apodoId');
        			
        			if ($apodoId != null && $usuarioId != null) {
        				if (Apodo::aceptarInvitacion($db, $usuarioId, $apodoId)) {
        					$content = '<response><success>true</success></response>';
        					
        			        /* Postea en Facebook */
        			        $apodo = Apodo::getApodoById($db, $apodoId, array());
        			        
							$postFacebook = new PostFacebook();
							$postFacebook->titulo = $apodo->getNombreApodo();
							$postFacebook->descripcion = 'Me han puesto un APODO ESPECIAL, chécalo aquí.';
							$postFacebook->urlDestino = $apodo->urlCorto;
							$postFacebook->urlImagen = $cache->urlPortal . 'images/apodos/' . $apodo->imagenUrl;
							$postFacebook->urlPortal = $apodo->urlCorto;
							FacebookHelper::publicaEnMuro($facebook, $usuario->id, $postFacebook);
        				}
        			}
        			break;
        		case 'rechazarApodo':
        			$apodoId = $request->getRequest('apodoId');
        			
        			if ($apodoId != null && $usuarioId != null) {
        				if (Apodo::rechazarInvitacion($db, $usuarioId, $apodoId)) {
        					$content = '<response><success>true</success></response>';
        				}
        			}
        			break;
        		case 'crearAvatar':
        			$imagenes = $request->getRequest('imagenes');
					
					$nombre = $usuarioId . '.png';
					$urlTemp = DIR_IMAGE . 'temp/' . $nombre;
					copy(DIR_IMAGE. 'fondo_avatar.png', $urlTemp);
					
        			foreach ($imagenes as $imagen) {
        				$dest = imagecreatefrompng($urlTemp);
						$src = imagecreatefrompng(DIR_ROOT . $imagen);
						
						imagecopyresampled($dest, $src, 0, 0, 0, 0, 250, 250, 250, 250);
						imagepng($dest, $urlTemp);

						imagedestroy($dest);
						imagedestroy($src);
        			}
        			$content = '<response><success>true</success><url>images/temp/' . $nombre . '</url></response>';
        			break;
        		default:
        			break;
        	}
        	break;
	}
	// Variables de template
?>