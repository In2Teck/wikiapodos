<?php
	class Usuario {
		public $id;
		public $nombre;
		public $apellido;
		public $email;
		public $esFan;
		public $fechaCreacion;
		public $fechaActualizacion;
		
		public $amigos = array();
		
		// Propiedades para Apodo_Usuario para el usuario actual.
		public $usuarioDesdeId;
		public $usuarioParaId;
		public $status;
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['facebook_id'])) {
					$this->id = $renglon['facebook_id'];
				}
				if (isset($renglon['nombre'])) {
					$this->nombre = $renglon['nombre'];
				}
				if (isset($renglon['apellido'])) {
					$this->apellido = $renglon['apellido'];
				}
				if (isset($renglon['email'])) {
					$this->email = $renglon['email'];
				}
				if (isset($renglon['es_fan'])) {
					$this->esFan = $renglon['es_fan'];
				}
				if (isset($renglon['fecha_creacion'])) {
					$this->fechaCreacion = $renglon['fecha_creacion'];
				}
				if (isset($renglon['fecha_actualizacion'])) {
					$this->fechaActualizacion = $renglon['fecha_actualizacion'];
				}
				
				if (isset($renglon['usuario_desde_id'])) {
					$this->usuarioDesdeId = $renglon['usuario_desde_id'];
				}
				if (isset($renglon['usuario_para_id'])) {
					$this->usuarioParaId = $renglon['usuario_para_id'];
				}
				if (isset($renglon['status'])) {
					$this->status = $renglon['status'];
				}
			}
		}
		
		static function getUsuarioById($db, $idUsuario) {
			$query = sprintf("SELECT *
							  FROM usuarios
							  WHERE facebook_id = '%s'",
						$db->escape($idUsuario));
			$resultado = $db->query($query);
			if ($resultado->num_rows > 0) {
				$usuario = new Usuario($resultado->row);
				return $usuario;
			}
			return null;
		}
		
		static function getUsuariosById($db, $usuariosId, $limite = '100') {
			$listaUsuarios = '';
			if (isset($usuariosId) && count($usuariosId) > 0) {
				$listaUsuarios = 'in (';
				foreach($usuariosId as $idUsuario) {
					$listaUsuarios .= $db->escape($idUsuario).',';
				}
				$listaUsuarios = substr_replace($listaUsuarios, "", -1);
				$listaUsuarios .= ')';
			}
			$query = sprintf("select * from usuarios
								where facebook_id %s
									and es_fan > 0
								order by fecha_actualizacion
								DESC LIMIT %s",
						$listaUsuarios,
						$limite);
			$resultado = $db->query($query);
			
			$usuarios = array();
			if ($resultado->num_rows > 0) {
				foreach ($resultado->rows as $registro) {
					$usuarios[] = new Usuario($registro);
				}
			}
			return $usuarios;
		}
		
		static function getUsuariosRandom($db, $usuariosId, $limite = '100') {
			$listaUsuarios = '';
			if (isset($usuariosId) && count($usuariosId) > 0) {
				$listaUsuarios = 'not in (';
				foreach($usuariosId as $idUsuario) {
					$listaUsuarios .= $db->escape($idUsuario).',';
				}
				$listaUsuarios = substr_replace($listaUsuarios, "", -1);
				$listaUsuarios .= ')';
			}
			$query = sprintf("select * from usuarios
								where facebook_id %s
									and es_fan > 0
								order by fecha_actualizacion
								DESC LIMIT %s",
						$listaUsuarios,
						$limite);
			$resultado = $db->query($query);
			
			$usuarios = array();
			if ($resultado->num_rows > 0) {
				foreach ($resultado->rows as $registro) {
					$usuarios[] = new Usuario($registro);
				}
			}
			return $usuarios;
		}
		
		static function guardar($db, $usuario) {
			$query = sprintf("INSERT INTO usuarios (facebook_id, nombre, apellido, email, es_fan, fecha_creacion, fecha_actualizacion) 
								VALUES ('%s', '%s', '%s', '%s', %s, sysdate(), sysdate())",
								$db->escape($usuario->id),
								$db->escape($usuario->nombre),
								$db->escape($usuario->apellido),
								$db->escape($usuario->email),
								$usuario->esFan
						);
			$resultado = $db->query($query);
			if ($db->countAffected() > 0) {
				return Usuario::getUsuarioById($db, $usuario->id);
			}
			return null;
		}
		
		static function actualizar($db, $usuario) {
			$query = sprintf("UPDATE usuarios SET nombre = '%s', apellido = '%s', email = '%s', es_fan = %s
								WHERE facebook_id = '%s'",
								$db->escape($usuario->nombre),
								$db->escape($usuario->apellido),
								$db->escape($usuario->email),
								$usuario->esFan,
								$usuario->acepto,
								$db->escape($usuario->id)
						);
			$db->query($query);
			return Usuario::getUsuarioById($db, $usuario->id);
		}
		
		static function registraAcceso($db, $usuario) {
			$query = sprintf("UPDATE usuarios SET fecha_actualizacion = sysdate()
								WHERE facebook_id = '%s'",
								$db->escape($usuario->id)
						);
			$resultado = $db->query($query);
			return $resultado;
		}
		
		static function getTagsApodo($db, $id, $amigos = array(), $limite = 0) {
			$usuarios = array();
						
			$idAmigos = '0';
			if (count($amigos) > 0) {
				foreach ($amigos as $amigo){
					$idAmigos = $idAmigos.", '".$amigo['uid']."'";
				}
			}
						
			$query = sprintf("SELECT au.usuario_para_id AS facebook_id
							  FROM apodos_usuarios au
							  WHERE au.usuario_para_id IN (%s)
									AND au.status = 1
									AND au.visible = 1
									AND au.apodo_id = '%s'
							  ORDER BY au.fecha_actualizacion DESC ",
							  $idAmigos,
							  $db->escape($id));
			if ($limite > 0) {
				$query .= "LIMIT " . $limite;
			}
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				foreach ($resultado->rows as $registro) {
					$usuarios[] = new Usuario($registro);
				}
				$limite -= $resultado->num_rows;
			}
			
			$query = sprintf("SELECT au.usuario_para_id AS facebook_id
							  FROM apodos_usuarios au
							  WHERE au.usuario_para_id NOT IN (%s)
									AND au.status = 1
									AND au.visible = 1
									AND au.apodo_id = '%s'
							  ORDER BY au.fecha_actualizacion DESC ",
							  $idAmigos,
							  $db->escape($id));
			if ($limite > 0) {
				$query .= "LIMIT " . $limite;
			}
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				foreach ($resultado->rows as $registro) {
					$usuarios[] = new Usuario($registro);
				}
			}
			
			global $facebook;
			$usuarios = FacebookHelper::getUsuarios($facebook, $usuarios);
			
			return $usuarios;
		}
	}
?>