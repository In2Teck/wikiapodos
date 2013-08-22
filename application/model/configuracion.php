<?php
	class Configuracion {
		public $id;
		public $llave;
		public $valor;
		
		function __construct($renglon=null) {
			if ($renglon) {
				if (isset($renglon['id'])) {
					$this->id = $renglon['id'];
				}
				if (isset($renglon['llave'])) {
					$this->llave = $renglon['llave'];
				}
				if (isset($renglon['valor'])) {
					$this->valor = $renglon['valor'];
				}
			}
		}
		
		static function getConfiguracionById($db, $id) {
			$query = sprintf("select * from configuraciones where llave = '%s'",
						$db->escape($id));
			$resultado = $db->query($query);
			
			if ($resultado->num_rows > 0) {
				$configuracion = new Configuracion($resultado->row);
				return $configuracion;
			}
			return null;
		}
	}
?>