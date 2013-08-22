<?php
require_once "json.php";

class Utils
{
	static function querystringToJson($qs) {
		parse_str($qs, $arreglo);
		$json = json_encode($arreglo);
		return urlencode($json);
	}
	
	static function jsonToArray($json) {
		$qs = urldecode($json);
		$qs = substr($qs, 0, strpos($qs, '}') + 1);
		$arreglo = json_decode($qs);
		return $arreglo;
	}
	
	static function generaUrlThumbnail($url, $idUsuario) {
		return str_replace("{id}", $idUsuario, $url);
	}
	
	static function generaUrlFoto($url, $idFoto) {
		return $url."?app_data=".
			Utils::querystringToJson("page=foto&nombreTemplate=urlFoto&id=".$idFoto);
	}
	
	static function generaUrlVideo($url, $mobile = false) {
		return $url."?app_data=".
			Utils::querystringToJson("page=galeria" . ($mobile ? '&mobile=true' : ''));
	}
	
	static function limitaCaracteres($cadena, $limite) {
		if (strlen($cadena) >= $limite) {
			return substr($cadena, 0, $limite - 2) . '...';
		}
		return $cadena;
	}
	
	static function limpiaCaracteres($cadena) {
		$cadena = strtolower($cadena);
		$cadena = preg_replace('/\s/', '', $cadena);
		$cadena = preg_replace('/(À|Á|Ä|à|á|â|ã|ä|å)/', 'a', $cadena);
		$cadena = preg_replace('/æ/', 'ae', $cadena);
		$cadena = preg_replace('/ç/', 'c', $cadena);
		$cadena = preg_replace('/(È|É|Ë|è|é|ê|ë)/', 'e', $cadena);
		$cadena = preg_replace('/(Ì|Í|Ï|ì|í|î|ï)/', 'i', $cadena);
		$cadena = preg_replace('/Ñ|ñ/', 'n', $cadena);
		$cadena = preg_replace('/(Ò|Ó|Ö|ò|ó|ô|õ|ö)/', 'o', $cadena);
		$cadena = preg_replace('/œ/', 'oe', $cadena);
		$cadena = preg_replace('/(Ù|Ú|Ü|ù|ú|û|ü)/', 'u', $cadena);
		$cadena = preg_replace('/(Ÿ|ý|ÿ)/', 'y', $cadena);
		$cadena = preg_replace('/\W/', '', $cadena);

		return $cadena;
	}
	
	static function obtienePalabrasProhibidas() {
		return file(DIR_SYSTEM . 'palabras_prohibidas.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
	}
	
	static function verificaPalabrasProhibidas($cadena) {
		$lista = Utils::obtienePalabrasProhibidas();
		foreach ($lista as $palabra) {
			if (preg_match("/$palabra/i", $cadena)) {
				return false;
			}
		}
		return true;
	}
	
	static function obtieneUrlCorta($url) {
		// Url bitly
		$bitly = 'https://api-ssl.bitly.com/v3/shorten?access_token=e79f012c60399020a7c4f10d92fa0b089d10e7e3&longUrl=' . $url;
	
		//Se obtiene el contenido
		$response = file_get_contents($bitly);
	
		//Se parsea la respuesta
		$json = @json_decode($response, true);
		return $json['data']['url'];
	}
}
