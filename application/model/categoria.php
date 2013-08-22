<?php
	require_once(DIR_MODEL . 'objeto.php');
	
	class Categoria {
		public $id;
		public $orden;
		public $descripcion;
		public $imagenUrl;
		public $fechaCreacion;
		public $fechaActualizacion;
		
		public $objetos;
		
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
	 	* Método que regresa todos las categorias.
	 	* @param db referencia a la base de datos.
	 	*
	 	* @return lista de categorias
	 	*/
		static function getCategorias($db) {
			$query = sprintf("SELECT *
							  FROM categorias c
							  ORDER BY orden ASC");
			$resultados = $db->query($query);
			
			$categorias = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$categoria = new Categoria($renglon);
					$categoria->objetos = Objeto::getObjetos($db, $categoria->id);
					$categorias[$i++] = $categoria;
				}
			}
			return $categorias;
		}
		
		/**
	 	* Método que regresa un categoria
	 	* @param db referencia a la base de datos.
	 	* @param id del categoria
	 	*
	 	* @return categoria
	 	*/
		static function getCategoriaById($db, $id) {
			$query = sprintf("SELECT *
							  FROM categorias c
							  WHERE id = %s",
						$db->escape($id));
			$resultados = $db->query($query);
			
			$categoria = null;
			if ($resultados->num_rows > 0) {
				$categoria = new Categoria($resultados->row);
				$categoria->objetos = Objeto::getObjetos($db, $categoria->id);
			}
			return $categoria;
		}
	}
?>