<?php
require_once DIR_MODEL.'postFacebook.php';

class FacebookHelper {
	static function getUsuario($facebook) {
		$usuario = $facebook->getUser();
		return $usuario;
	}

	static function getLikeID($facebook, $usuarioID, $pageID) {
		$likeID = $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT source_id FROM connection WHERE source_id ='".$usuarioID."' AND target_id = '".$pageID."'"
			));
		return $likeID;
	}
	
	static function getPerfil($facebook, $id) {
		$perfil = $facebook->api('/' . $id); // Obtiene el perfil de facebook
		return $perfil;
	}
	
	static function getUserName($facebook, $usuarioID) {
		$amigo =  $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT uid, first_name, last_name FROM user WHERE uid = ".$usuarioID
			));
		$usuario = new Usuario();
		$usuario->id = $amigo[0]['uid'];
		$usuario->nombre = $amigo[0]['first_name'];
		$usuario->apellido = $amigo[0]['last_name'];
		return $usuario;
	}
	
	static function getUsuarios($facebook, $usuarios) {
		$usuariosIDarray = array();
		foreach($usuarios as $usuarioTemp) {
			$usuariosIDarray[] = $usuarioTemp->id;
		}

		$amigos =  $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT uid, first_name, last_name FROM user WHERE uid in (".implode(',',$usuariosIDarray).")"
			));
		
		$listaAmigos = array();
		foreach ($amigos as $amigo) {
			$usuario = new Usuario();
			$usuario->id = $amigo['uid'];
			$usuario->nombre = $amigo['first_name'];
			$usuario->apellido = $amigo['last_name'];
			$listaAmigos[] = $usuario;
		}
		return $listaAmigos;
	}
	
	static function getUserLink($facebook, $usuarioID) {
		$username =  $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT profile_url FROM user WHERE uid = ".$usuarioID
			));
		return $username[0]['profile_url'];
	}
	
	static function getAmigosParticipando($facebook, $usuarioID) {
		$amigos = $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT uid FROM user WHERE has_added_app=1 and uid IN (SELECT uid2 FROM friend WHERE uid1 =".$usuarioID.")"
			));
		$listaAmigos = array();
		foreach ($amigos as $amigo) {
			$listaAmigos[] = $amigo['uid'];
		}
		return $listaAmigos;
	}
	
	static function getAmigos($facebook, $usuarioID) {
		$amigos = $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT uid, name FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 =".$usuarioID.") ORDER BY name"
			));		
				
		return $amigos;
	}
	
	static function getNumAmigos($facebook, $usuarioID) {
		$conteo = $facebook->api(
			array(
				'method' => 'fql.query',
				'query' => "SELECT '' FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 =".$usuarioID.")"
			));
		return count($conteo);
	}
	
	static function publicaEnMuro($facebook, $usuarioID, $postFacebook) {
		try {
			if ($postFacebook) {
				if ($facebook->api('/'.$usuarioID.'/feed', 'POST', $postFacebook->generaAttachment())) {
					return true;
				}
			}
		} catch(Exception $e) {
		}
		return false;
	}
	
	static function validaPermisos($facebook) {
		$perms = $facebook->api(array(
			"method"    => "fql.query",
			"query"     => "SELECT email,publish_stream,read_stream FROM permissions WHERE uid=me()"
		));
		if (count($perms) == 0) {
			return false;
		}
		foreach($perms[0] as $k=>$v) {
			if ($v === "1") {
				continue;
			}
			return false;
		}
		return true;
	}
	
	static function borrarRequest($facebook, $request_ids) {
	
		global $log;
		
		$user_id = $facebook->getUser();

		$request_ids = explode(',', $request_ids);

		//for each request_id, build the full_request_id and delete request 
		foreach ($request_ids as $request_id) {
  			$full_request_id = $request_id . '_' . $user_id;   

  			try {
    			$delete_success = $facebook->api("/$full_request_id",'DELETE');
    			return $delete_success;
    			/*if ($delete_success) {
      				$log->write("Successfully deleted " . $full_request_id);
      			} else {
      				$log->write("Delete failed".$full_request_id);
    			}*/
  			} catch (FacebookApiException $e) {
    			//$log->write("Error al borrar request");
    			return false;
  			}
		}
	}
}
?>