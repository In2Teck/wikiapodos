<?php
	class PostFacebook {
		public $mensaje = '';	// Mensaje en el post
		public $titulo; 		// Título del post
		public $descripcion;	// Descripción del post
		public $urlDestino;		// URL destino a donde se redirecciona
		public $urlImagen;		// URL de la imagen que se muestra
		public $urlPortal;		// URL del portal
		
		public $idDe;
		public $idPara;
		
		function __construct($renglon=null) {
		}
		
		function generaAttachment() {
			 $attachment = array(
					'name' => $this->titulo,
					'link' => $this->urlDestino,
					'description' => $this->descripcion,
					'picture' => $this->urlImagen,
					'actions' => array (
							array(
								'name' => 'Participa',
								'link' => $this->urlPortal)
						)
					);
			if (isset($idDe)) {
				$attachment['from'] = $idDe;
			}
			if (isset($idPara)) {
				$attachment['to'] = $idPara;
			}
			return $attachment;
		}
	}
?>