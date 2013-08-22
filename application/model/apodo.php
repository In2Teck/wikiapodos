<?php

	require_once(DIR_MODEL . 'usuario.php');
	
	class Apodo {
		public $id;
		public $autorId;
		public $nombre;
		public $prefijo;
		public $descripcion;
		public $imagenUrl;
		public $urlCorto;
		public $calificacion;
		public $visible;
		public $destacado;
		public $fechaCreacion;
		public $fechaActualizacion;
		
		public $autor;
		public $tags;
		
		// Propiedades para Apodo_Usuario para el usuario actual.
		public $usuarioDesdeId;
		public $usuarioDesdeNombre;
		public $usuarioParaId;
		public $usuarioParaNombre;
		public $status;
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['id'])) {
					$this->id = $renglon['id'];
				}
				if (isset($renglon['autor_id'])) {
					$this->autorId = $renglon['autor_id'];
				}
				if (isset($renglon['nombre'])) {
					$this->nombre = $renglon['nombre'];
				}
				if (isset($renglon['prefijo'])) {
					$this->prefijo = $renglon['prefijo'];
				}
				if (isset($renglon['descripcion'])) {
					$this->descripcion = $renglon['descripcion'];
				}
				if (isset($renglon['imagen_url'])) {
					$this->imagenUrl = $renglon['imagen_url'];
				}
				if (isset($renglon['url_corto'])) {
					$this->urlCorto = $renglon['url_corto'];
				}
				if (isset($renglon['calificacion'])) {
					$this->calificacion = $renglon['calificacion'];
				}
				if (isset($renglon['visible'])) {
					$this->visible = $renglon['visible'];
				}
				if (isset($renglon['destacado'])) {
					$this->destacado = $renglon['destacado'];
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
				if (isset($renglon['usuario_desde_nombre'])) {
					$this->usuarioDesdeNombre = $renglon['usuario_desde_nombre'];
				}
				if (isset($renglon['usuario_para_id'])) {
					$this->usuarioParaId = $renglon['usuario_para_id'];
				}
				if (isset($renglon['usuario_para_nombre'])) {
					$this->usuarioParaNombre = $renglon['usuario_para_nombre'];
				}
				if (isset($renglon['status'])) {
					$this->status = $renglon['status'];
				}
			}
		}
		
		function getNombreApodo() {
			return $this->prefijo . ' ' . $this->nombre;
		}
		
		/**
	 	* Método que regresa todos los apodos.
	 	* @param db referencia a la base de datos.
	 	*
	 	* @return lista de apodos
	 	*/
		static function getApodos($db) {
			$query = sprintf("SELECT *
							  FROM apodos a
							  ORDER BY nombre ASC");
			$resultados = $db->query($query);
			
			$apodos = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$apodo = new Apodo($renglon);
					$apodos[$i++] = $apodo;
				}
			}
			return $apodos;
		}
		
		/**
	 	* Método que regresa apodos destacados.
	 	* @param db referencia a la base de datos.
	 	* @param limite numero de apodos que se desean obtener.
	 	*
	 	* @return lista de apodos
	 	*/
		static function getDestacados($db, $limite) {
			$query = sprintf("SELECT *, (SELECT COUNT(*) FROM apodos_usuarios au where au.apodo_id = a.id) as tags
							  FROM apodos a
							  ORDER BY a.destacado DESC, tags DESC
							  LIMIT %s",
						$db->escape($limite));
			$resultados = $db->query($query);
			
			$apodos = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$apodo = new Apodo($renglon);
					$apodo->tags = Usuario::getTagsApodo($db, $apodo->id, array(),10);
					$apodos[$i++] = $apodo;
				}
			}
			return $apodos;
		}
		
		/**
	 	* Método que regresa un apodo
	 	* @param db referencia a la base de datos.
	 	* @param id del apodo
	 	*
	 	* @return apodo
	 	*/
		static function getApodoById($db, $id, $amigos) {
			$query = sprintf("SELECT *
							  FROM apodos a
							  WHERE id = '%s'",
						$db->escape($id));
			$resultados = $db->query($query);
			
			$apodo = null;
			if ($resultados->num_rows > 0) {
				$apodo = new Apodo($resultados->row);
				$apodo->autor = Usuario::getUsuarioById($db, $apodo->autorId);
				$apodo->tags = Usuario::getTagsApodo($db, $apodo->id, $amigos);
			}
			return $apodo;
		}
		
		/**
	 	* Método que persiste el apodo en base de datos
	 	* @param db referencia a la base de datos.
	 	* @param apodo que se desea guardar
	 	*
	 	* @return apodo guardado
	 	*/
		static function guardar($db, $apodo) {
			$query = sprintf("insert into apodos (autor_id, nombre, prefijo, descripcion, imagen_url, url_corto, calificacion, visible, destacado, fecha_creacion, fecha_actualizacion) 
								values ('%s', '%s', '%s', '%s', '%s', '%s', %s, %s, %s, sysdate(), sysdate())",
								$db->escape($apodo->autorId),
								$db->escape($apodo->nombre),
								$db->escape($apodo->prefijo),
								$db->escape($apodo->descripcion),
								$db->escape($apodo->imagenUrl),
								$db->escape($apodo->urlCorto),
								$db->escape($apodo->calificacion),
								$db->escape($apodo->visible),
								$db->escape($apodo->destacado)
						);
			$resultado = $db->query($query);
			if ($db->countAffected() > 0) {
				return $db->getLastId();
			}
			return null;
		}
		
		/**
	 	* Método que actualiza el url corto generado por bit.ly después de crear el apodo
	 	* @param db referencia a la base de datos.
	 	* @param apodoId  id del apodo
	 	* @param urlCorto  url corto del apodo
	 	*/
		static function actualizarUrlCorto($db, $apodoId, $urlCorto) {
			$query = sprintf("UPDATE apodos SET url_corto = '%s' WHERE id = %s",
							$db->escape($urlCorto),
							$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			return $resultado;
		}
		
		/**
	 	* Método que inserta las invitaciones de apodo que hace un usuario a otro
	 	* @param db referencia a la base de datos.
	 	* @param apodo que se desea guardar
	 	*
	 	* @return apodo guardado
	 	*/
		static function guardarInvitaciones($db, $usuarioId, $apodoId, $amigos) {
			foreach($amigos as $amigoId) {
				$query = sprintf("insert into apodos_usuarios (usuario_desde_id, usuario_para_id, apodo_id, status, visible, fecha_creacion, fecha_actualizacion) 
								values ('%s', '%s', %s, 1, 1, sysdate(), sysdate())",
								$db->escape($usuarioId),
								$db->escape($amigoId),
								$db->escape($apodoId)
						);
				$resultado = $db->query($query);
			}
			return true;
		}
		
		
		static function getAmigosConApodo($db, $amigos_ids) {
			$query = sprintf("SELECT DISTINCT usuario_para_id as facebook_id
							  FROM apodos_usuarios au
							  WHERE au.usuario_para_id IN (%s)
							  	AND au.visible = 1
							  	AND au.status = 1",
						$db->escape($amigos_ids));
			$resultados = $db->query($query);
			
			$amigos = array();
			if ($resultados->num_rows > 0) {
				foreach ($resultados->rows as $renglon) {
					$amigo = new Usuario($renglon);
					$amigos[] = $amigo;
				}
			}
			
			global $facebook;
			$amigos = FacebookHelper::getUsuarios($facebook, $amigos);
			return $amigos;
		}
		
		
		static function getApodosAsignados($db, $usuarioId) {
			$query = sprintf("SELECT a.*, au.usuario_desde_id, au.usuario_para_id, au.status, au.visible, CONCAT(u.nombre,' ', u.apellido) as usuario_desde_nombre
							  FROM apodos a, apodos_usuarios au, usuarios u
							  WHERE a.id = au.apodo_id
							  	AND au.usuario_para_id = '%s'
							  	AND au.visible = 1
							  	AND au.usuario_desde_id = u.facebook_id
							  ORDER BY au.status ASC, au.fecha_actualizacion DESC",
						$db->escape($usuarioId));
			$resultados = $db->query($query);
			
			$apodos = null;
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$apodo = new Apodo($renglon);
					$apodos[$i++] = $apodo;
				}
			}
			return $apodos;
		}
		
		static function getApodosCreados($db, $usuarioId) {
			$query = sprintf("SELECT *
							  FROM apodos a
							  WHERE autor_id = '%s'
							  ORDER BY a.fecha_creacion DESC",
						$db->escape($usuarioId));
			$resultados = $db->query($query);
			
			$apodos = null;
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$apodo = new Apodo($renglon);
					$apodo->tags = Usuario::getTagsApodo($db, $apodo->id, array(), 9);
					$apodos[$i++] = $apodo;
				}
			}
			return $apodos;
		}
		
		static function getApodosAceptados($db, $usuarioId) {
			$query = sprintf("SELECT a.*, au.usuario_desde_id, au.usuario_para_id, au.status, au.visible
							  FROM apodos a, apodos_usuarios au
							  WHERE a.id = au.apodo_id
							  	AND au.usuario_para_id = '%s'
							  	AND au.visible = 1
							  	AND au.status = 1
							  ORDER BY au.fecha_actualizacion DESC",
						$db->escape($usuarioId));
			$resultados = $db->query($query);
			
			$apodos = null;
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$apodo = new Apodo($renglon);
					$apodo->tags = Usuario::getTagsApodo($db, $apodo->id, array(), 9);
					$apodos[$i++] = $apodo;
				}
			}
			return $apodos;
		}
		
		static function getApodosUsuariosAmigos($db, $idApodo, $amigos_ids) {
			$query = sprintf("SELECT *
							  FROM apodos_usuarios au
							  WHERE au.usuario_para_id IN (%s)
									AND au.apodo_id = '%s'
							  ORDER BY au.fecha_actualizacion DESC ",
							  $amigos_ids,
							  $db->escape($idApodo));
			$resultado = $db->query($query);
			
			$amigos = array();
			if ($resultado->num_rows > 0) {
				foreach ($resultado->rows as $registro) {
					$amigo = new Usuario();
					$amigo->id = $registro['usuario_para_id'];
					$amigo->status = $registro['status'];
					$amigos[] = $amigo;
				}
			}
			
			return $amigos;
		}
		
		static function aceptarInvitacion($db, $usuarioId, $apodoId) {
			$query = sprintf("UPDATE apodos_usuarios
							  SET status = 1, fecha_actualizacion = sysdate()
							  WHERE usuario_para_id = '%s'
							  	AND apodo_id = '%s'
							  	AND status = 0",
							$db->escape($usuarioId),
							$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			return $db->countAffected() > 0;
		}
		
		static function rechazarInvitacion($db, $usuarioId, $apodoId) {
			$query = sprintf("UPDATE apodos_usuarios
							  SET status = 2, fecha_actualizacion = sysdate()
							  WHERE usuario_para_id = '%s'
							  	AND apodo_id = '%s'",
							$db->escape($usuarioId),
							$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			return $db->countAffected() > 0;
		}
		
		/**
	 	* Método que revisa si un apodo ya existe en la base de datos
	 	* @param db referencia a la base de datos.
	 	* @param apodo objeto apodo
	 	*
	 	* @return true si el apodo existe, false si el apodo no existe
	 	*/
		static function existeApodo($db, $apodo) {
			$apodoNombre = $apodo->prefijo.' '.Utils::limpiaCaracteres($apodo->nombre);
			
			$query = sprintf("SELECT *
							  FROM apodos");
			$resultados = $db->query($query);
			
			if ($resultados->num_rows > 0) {
				foreach ($resultados->rows as $renglon) {
					$apodoDB = new Apodo($renglon);
					$apodoDBNombre = $apodoDB->prefijo.' '.Utils::limpiaCaracteres($apodoDB->nombre);
					if ($apodoNombre == $apodoDBNombre) {
						return true;
					}
				}
				return false;
			}
		}
		
		
	}
?>