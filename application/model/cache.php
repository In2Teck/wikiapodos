<?php
	class Cache {
		// Título de la página
		public $tituloPagina;
		// Descripción de la página
		public $descripcionPagina;
		
		// URL del portal
		public $urlPortal;
		// URL del portal dentro de facebook
		public $urlPortalFB;
		// URL corto del portal dentro de facebook
		public $urlPortalFBCorto;
		// URL de la app dentro de facebook
		public $urlAppFB;
		// Id del app de facebook
		public $fbAppId = '288059641339246';
		// Secret del app de facebook
		public $fbAppSecret = '351d16a6b16d21d2fbd4af74b0b97d63';
		// ID de la página de facebook
		public $fbLikePageId = '116098461808546';
		// ID de la página de facebook
		public $fbPermissions;
		
		// URL donde se encuentran las imágenes de facebook {id} se sustituye
		public $urlImagenesFacebook;
		
		// Limite de de elementos por página en las galerias.
		public $paginationLimit = 15;
		
		// ID del video de youtube a mostrar
		public $youtubeVideoId;
		
		// Última modificacion de las variables en base de datos.
		public $ultimaModificacion;
		
		public $nuevo;
	}
?>