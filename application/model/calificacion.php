<?php
	class Calificacion {
		public $id;
		public $usuarioId;
		public $apodoId;
		public $calificacion;
		
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['id'])) {
					$this->id = $renglon['id'];
				}
				if (isset($renglon['usuario_id'])) {
					$this->usuarioId = $renglon['usuario_id'];
				}
				if (isset($renglon['apodo_id'])) {
					$this->apodoId = $renglon['apodo_id'];
				}
				if (isset($renglon['calificacion'])) {
					$this->calificacion = $renglon['calificacion'];
				}
			}
		}
		
		static function getUsuarioCalificacion($db, $usuarioId, $apodoId) {
			$query = sprintf("select * from calificaciones where usuario_id = '%s' and apodo_id = '%s'",
						$db->escape($usuarioId),
						$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				$calificacion = new Calificacion($resultado->row);
				return $calificacion->calificacion;
			}
			return 0;
		}
		
		static function getCalificacionPromedio($db, $apodoId) {
			$query = sprintf("SELECT calificacion FROM apodos WHERE id = %s",
						$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				$calificacion = new Calificacion($resultado->row);
				return $calificacion->calificacion;
			}
			return 0;
		}
		
		static function actualizarCalificacion($db, $usuarioId, $apodoId, $calificacion) {
			
			$query = sprintf("select * from calificaciones where usuario_id = '%s' and apodo_id = %s",
						$db->escape($usuarioId),
						$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				// Si ya existe una calificación de ese apodo y ese usuario actualizamos la calificación
				
				$query = sprintf("UPDATE calificaciones SET calificacion = %s, fecha_actualizacion = sysdate() 
								WHERE usuario_id = '%s' and apodo_id = %s",
								$db->escape($calificacion),
								$db->escape($usuarioId),
								$db->escape($apodoId)
						);
				$resultado = $db->query($query);
				return $resultado;
				
			} else {
				// Si no existe una calificación la insertamos
				
				$query = sprintf("INSERT INTO calificaciones (usuario_id, apodo_id, calificacion, fecha_creacion, fecha_actualizacion) 
								VALUES ('%s', %s, %s, sysdate(), sysdate())",
								$db->escape($usuarioId),
								$db->escape($apodoId),
								$db->escape($calificacion)
						);
				$resultado = $db->query($query);
				if ($db->countAffected() > 0) {
					return true;
				}
			}
		}
		
		static function actualizarCalificacionPromedio($db, $apodoId) {
			$query = sprintf("UPDATE apodos SET calificacion = (SELECT IF(AVG(c.calificacion), AVG(c.calificacion),0) FROM calificaciones c WHERE c.apodo_id = %s) WHERE id = %s",
							$db->escape($apodoId),
							$db->escape($apodoId)
					);
			$resultado = $db->query($query);
			return $resultado;
		}
	}
?>