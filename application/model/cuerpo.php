<?php
	class Cuerpo {
		public $id;
		public $orden;
		public $descripcion;
		public $imagenUrl;
		public $fechaCreacion;
		public $fechaActualizacion;
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['id'])) {
					$this->id = $renglon['id'];
				}
				if (isset($renglon['orden'])) {
					$this->orden = $renglon['orden'];
				}
				if (isset($renglon['descripcion'])) {
					$this->descripcion = $renglon['descripcion'];
				}
				if (isset($renglon['imagen_url'])) {
					$this->imagenUrl = $renglon['imagen_url'];
				}
				if (isset($renglon['fecha_creacion'])) {
					$this->fechaCreacion = $renglon['fecha_creacion'];
				}
				if (isset($renglon['fecha_actualizacion'])) {
					$this->fechaActualizacion = $renglon['fecha_actualizacion'];
				}
			}
		}
		
		/**
	 	* Método que regresa todos los cuerpos.
	 	* @param db referencia a la base de datos.
	 	*
	 	* @return lista de cuerpos
	 	*/
		static function getCuerpos($db) {
			$query = sprintf("SELECT *
							  FROM cuerpos o
							  ORDER BY orden ASC");
			$resultados = $db->query($query);
			
			$cuerpos = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$cuerpo = new Cuerpo($renglon);
					$cuerpos[$i++] = $cuerpo;
				}
			}
			return $cuerpos;
		}
		
		/**
	 	* Método que regresa un cuerpo
	 	* @param db referencia a la base de datos.
	 	* @param id del cuerpo
	 	*
	 	* @return cuerpo
	 	*/
		static function getCuerpoById($db, $id) {
			$query = sprintf("SELECT *
							  FROM cuerpos c
							  WHERE id = %s",
						$db->escape($id));
			$resultados = $db->query($query);
			
			$cuerpo = null;
			if ($resultados->num_rows > 0) {
				$cuerpo = new Cuerpo($resultados->row);
			}
			return $cuerpo;
		}
	}
?>