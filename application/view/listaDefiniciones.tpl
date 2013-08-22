<div class="definiciones">
	<div class="letra" letra="a">A</div>
	<div class="letra" letra="b">B</div>
	<div class="letra" letra="c">C</div>
	<div class="letra" letra="d">D</div>
	<div class="letra" letra="e">E</div>
	<div class="letra" letra="f">F</div>
	<div class="letra" letra="g">G</div>
	<div class="letra" letra="h">H</div>
	<div class="letra" letra="i">I</div>
	<div class="letra" letra="j">J</div>
	<div class="letra" letra="k">K</div>
	<div class="letra" letra="l">L</div>
	<div class="letra" letra="m">M</div>
	<div class="letra" letra="n">N</div>
	<div class="letra" letra="o">O</div>
	<div class="letra" letra="p">P</div>
	<div class="letra" letra="q">Q</div>
	<div class="letra" letra="r">R</div>
	<div class="letra" letra="s">S</div>
	<div class="letra" letra="t">T</div>
	<div class="letra" letra="u">U</div>
	<div class="letra" letra="v">V</div>
	<div class="letra" letra="w">W</div>
	<div class="letra" letra="x">X</div>
	<div class="letra" letra="y">Y</div>
	<div class="letra" letra="z">Z</div>
</div>
<div class="definiciones_apodos">
	<?php
		$letra = '0';
		$par = false;
		$paginador = 1;
		$contador = 0;
		foreach ($apodos as $apodo) {
			// Se obtiene la nueva letra
			$letraTemp = Utils::limpiaCaracteres(substr($apodo->nombre, 0, 2));
			$letraTemp = substr($letraTemp, 0, 1);
			
			if ($contador >= $limitePaginador) {
				// La página anterior llegó al límite del paginador.
				if ($letraTemp == $letra) {
					// Sólo si se sigue dentro de la misma letra se considera poner el paginador
					$par = false;
					$paginador++;
					$contador = 0;
					
					if ($paginador <= 2) {
						// Es la primera página
						echo '<div class="paginador"><img class="anterior deshabilitado" src="images/paginador_anterior_deshabilitado.png" /><img class="siguiente over" src="images/paginador_siguiente.png" /></div>';
						echo '</div><div class="pagina" pagina="' . $paginador . '">';
					} else {
						// Es otra página
						echo '<div class="paginador"><img class="anterior over" src="images/paginador_anterior.png" /><img class="siguiente over" src="images/paginador_siguiente.png" /></div>';
						echo '</div><div class="pagina" pagina="' . $paginador . '">';
					}
				}
			}
			
			if ($letraTemp != $letra) {
				// Va a haber cambio de letra
				if ($letra != '0') {
					// No es el primer cuadro
					if ($contador != 0 && $paginador > 1) {
						// Tiene varias páginas y no está en el último elemento
						for (; $contador < $limitePaginador; $contador++, $par = !$par) {
							echo '<div class="apodo deshabilitado" par="' . ($par ? 'true' : 'false') . '"></div>';
						}
						echo '<div class="paginador"><img class="anterior over" src="images/paginador_anterior.png" /><img class="siguiente deshabilitado" src="images/paginador_siguiente_deshabilitado.png" /></div>';
					} else if ($contador != 0) {
						// Es la primera página y no está completo
						for (; $contador < ($limitePaginador + 1); $contador++, $par = !$par) {
							echo '<div class="apodo deshabilitado" par="' . ($par ? 'true' : 'false') . '"></div>';
						}
					}
					echo '</div></div>';
				}
				
				// Se vuelven a iniciar los valores
				$letra = $letraTemp;
				$par = false;
				$paginador = 1;
				$contador = 0;
				
				echo '<div class="apodos" letra="' . $letra . '">';
				echo '<div class="pagina" pagina="' . $paginador . '">';
			}
			
			// Se ponen los valores del apodo
			echo '<div class="apodo" par="' . ($par ? 'true' : 'false') . '" onclick="loadTemplate(\'apodo\',\'id=' . $apodo->id . '\')">' . Utils::limitaCaracteres($apodo->getNombreApodo(), 22) . '</div>';
			$par = !$par;
			$contador++;
		}
		
		if ($contador != 0 && $paginador > 1) {
			for (; $contador < $limitePaginador; $contador++, $par = !$par) {
				echo '<div class="apodo deshabilitado" par="' . ($par ? 'true' : 'false') . '"></div>';
			}
			echo '<div class="paginador"><img class="anterior" src="images/paginador_anterior.png" /><img class="siguiente deshabilitado" src="images/paginador_siguiente_deshabilitado.png" /></div>';
		} else if ($contador != 0) {
			for (; $contador < ($limitePaginador + 1); $contador++, $par = !$par) {
				echo '<div class="apodo deshabilitado" par="' . ($par ? 'true' : 'false') . '"></div>';
			}
		}
		echo '</div></div>';
	?>
</div>
<script>
	var ultimo = null;
	var timeout = null;
	var tiempo = 1000;
	$(document).ready(function() {
		$('.letra').mouseenter(function() {
			$('.definiciones_apodos').show();
			// Se quita timeout siempre que se selecciona una letra
			if (timeout != null) {
				clearTimeout(timeout);
			}
			// Se esconde el último elemento abierto al seleccionar una letra
			if (ultimo != null) {
				ultimo.css('visibility', 'hidden');
			}
			
			// Se obtiene el top de la letra y la altura del elemento
			var elementoHeight = parseInt($('.apodos[letra="' + $(this).attr('letra') + '"]').css('height'));
			var elementoTop = $(this).position().top - (elementoHeight / 2) + 5;
			if (elementoTop < 0) {
				elementoTop = 0;
			}
			
			// Si la suma de la altura y el elemento no sobrepasan el área se alinea
			//  con respecto a la letra. En otro caso se coloca al final del área.
			ultimo = $('.apodos[letra="' + $(this).attr('letra') + '"]');
			ultimo.css('visibility', 'visible');
			if ((elementoTop + elementoHeight) < 624) {
				ultimo.css('top', elementoTop);
			} else {
				ultimo.css('top', 'auto');
				ultimo.css('bottom', '0');
			}
		}).mouseleave(function() {
			// Al salir del elemento empieza el timeout para cerrar los apodos
			timeout = setTimeout(function() {
				if (ultimo != null) {
					ultimo.css('visibility', 'hidden');
					ultimo = null;
					$('.definiciones_apodos').hide();
				}
			}, tiempo);
		});
		
		$('.apodos').mouseenter(function() {
			// Si ingresa a los apodos, se borran los timeouts.
			if (timeout != null) {
				clearTimeout(timeout);
			}
		}).mouseleave(function() {
			// Se activa el timeout al salir de los apodos.
			timeout = setTimeout(function() {
				if (ultimo != null) {
					ultimo.css('visibility', 'hidden');
					ultimo = null;
					$('.definiciones_apodos').hide();
				}
			}, tiempo);
		}).hover(function() {
			$('.letra[letra="' + $(this).attr('letra') + '"]').toggleClass("seleccionado");
		});
		
		$('.paginador .siguiente').not('.deshabilitado').click(function() {
			var paginaActual = $(this).parent().parent().attr('pagina');
			$(this).parent().parent().parent().find('[pagina="' + paginaActual + '"]').hide();
			paginaActual++;
			$(this).parent().parent().parent().find('[pagina="' + paginaActual + '"]').show();
		});
		
		$('.paginador .anterior').not('.deshabilitado').click(function() {
			var paginaActual = $(this).parent().parent().attr('pagina');
			$(this).parent().parent().parent().find('[pagina="' + paginaActual + '"]').hide();
			paginaActual--;
			$(this).parent().parent().parent().find('[pagina="' + paginaActual + '"]').show();
		});
	});
</script>