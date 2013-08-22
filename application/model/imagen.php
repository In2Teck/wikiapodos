<?php
	class Imagen {
		public $id;
		public $cuerpoId;
		public $objetoId;
		public $imagenUrl;
		public $fechaCreacion;
		public $fechaActualizacion;
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['id'])) {
					$this->id = $renglon['id'];
				}
				if (isset($renglon['cuerpo_id'])) {
					$this->cuerpoId = $renglon['cuerpo_id'];
				}
				if (isset($renglon['objeto_id'])) {
					$this->objetoId = $renglon['objeto_id'];
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
	 	* Método que regresa todas las imagenes.
	 	* @param db referencia a la base de datos.
	 	*
	 	* @return lista de imagenes
	 	*/
		static function getImagenes($db) {
			$query = sprintf("SELECT *
							  FROM imagenes i
							  ORDER BY cuerpo_id ASC, objeto_id ASC");
			$resultados = $db->query($query);
			
			$imagenes = array();
			if ($resultados->num_rows > 0) {
				$i = 0;
				foreach ($resultados->rows as $renglon) {
					$imagen = new Imagen($renglon);
					$imagenes[$i++] = $imagen;
				}
			}
			return $imagenes;
		}
	}
?>