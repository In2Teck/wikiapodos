<?php
class Template {
	public function fetch($filename) {
		$fileController = DIR_CONTROLLER . $filename . '.php';
		$file = DIR_TEMPLATE . $filename . '.tpl';
    
    	if (file_exists($fileController)) {
    		require_once $fileController;
    	}
    
		if (file_exists($file)) {
      		ob_start();
      
	  		include($file);
      
	  		$content = ob_get_contents();

      		ob_end_clean();

      		return $content;
    	} else if (!file_exists($fileController)) {
			trigger_error('Error: No se pudo cargar el template ' . $file . '!');
			exit();				
    	}	
	}
}
?>