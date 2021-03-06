<?php
class Session {
	public $data = array();
			
  	public function __construct() {		
		if (!session_id()) {
			ini_set('session.use_cookies', 'On');
			ini_set('session.use_trans_sid', 'Off');
			
			session_set_cookie_params(0, '/');
			session_start();
		}
	
		$this->data =& $_SESSION;
	}
	
	public function isSession($key) {
		return isset($this->data[$key]);
	}
	
	public function getSession($key) {
		$value = null;
		if (isset($this->data[$key])) {
			$value = $this->data[$key];
		}
		return $value;
	}
	
	public function setSession($key, $value) {
		$this->data[$key] = $value;
	}
	
	public function unsetSession($key, $archivo = false) {
		if (isset($this->data[$key])) {
			unset($this->data[$key]);
		}
	}
}
?>