<?php
	class Objeto {
		public $id;
		public $categoriaId;
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
				if (isset($renglon['categoria_id'])) {
					$this->categoriaId = $renglon['categoria_id'];
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
	 	* Método que regresa todos los objetos.
	 	* @param db referencia a la base de datos.
	 	* @param categoriaId el id de la categoria.
	 	*
	 	* @return lista de objetos
	 	*/
		static function getObjetos($db, $categoriaId) {
			$query = sprintf("SELECT *
							  FROM objetos o
							  WHERE categoria_id = %s
							  ORDER BY orden ASC",
						$db->escape($categoriaId));
			$resultados = $db->query($query);
			
			$objetos = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$objeto = new Objeto($renglon);
					$objetos[$i++] = $objeto;
				}
			}
			return $objetos;
		}
		
		/**
	 	* Método que regresa un objeto
	 	* @param db referencia a la base de datos.
	 	* @param id del objeto
	 	*
	 	* @return objeto
	 	*/
		static function getObjetoById($db, $id) {
			$query = sprintf("SELECT *
							  FROM objetos c
							  WHERE id = %s",
						$db->escape($id));
			$resultados = $db->query($query);
			
			$objeto = null;
			if ($resultados->num_rows > 0) {
				$objeto = new Objeto($resultados->row);
			}
			return $objeto;
		}
	}
?>