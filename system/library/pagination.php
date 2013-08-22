<?php
final class Pagination {
	public $total = 0;
	public $page = 1;
	public $limit = 20;
	public $num_links = 5;
	public $url = '';
	public $style_links = 'paginatorLinks';
	 
	public function render() {
		$total = $this->total;
		
		if ($this->page < 1) {
			$page = 1;
		} else {
			$page = $this->page;
		}
		
		if (!$this->limit) {
			$limit = 10;
		} else {
			$limit = $this->limit;
		}
		
		$num_links = $this->num_links;
		$num_pages = ceil($total / $limit);
		
		$output = '<div class="paginador">';
		
		if ($page > 1) {
			$output .= ' <a href="' . str_replace('{page}', $page - 1, $this->url) . '"><div class="paginadorAtras"> </div></a> ';
    	}

		if ($num_pages > 1) {
			if ($num_pages <= $num_links) {
				$start = 1;
				$end = $num_pages;
			} else {
				$start = $page - floor($num_links / 2);
				$end = $page + floor($num_links / 2);
			
				if ($start < 1) {
					$end += abs($start) + 1;
					$start = 1;
				}
						
				if ($end > $num_pages) {
					$start -= ($end - $num_pages);
					$end = $num_pages;
				}
			}
			for ($i = $start; $i <= $end; $i++) {
				if ($i == $page) {
					$output .= ' <div class="paginadorPagina paginadorActual"><div class="paginadorNumero">' . $i . '</div></div> ';
				} else {
					$output .= ' <a href="' . str_replace('{page}', $i, $this->url) . '"><div class="paginadorPagina"><div class="paginadorNumero">' . $i . '</div></div></a> ';
				}
			}
		}
		
   		if ($page < $num_pages) {
			$output .= ' <a href="' . str_replace('{page}', $page + 1, $this->url) . '"><div class="paginadorAdelante"> </div></a> ';
		}
		$output .= '</div>';
		
		$find = array(
			'{start}',
			'{end}',
			'{total}',
			'{pages}'
		);
		
		$replace = array(
			($total) ? (($page - 1) * $limit) + 1 : 0,
			((($page - 1) * $limit) > ($total - $limit)) ? $total : ((($page - 1) * $limit) + $limit),
			$total, 
			$num_pages
		);
		
		return ($output ? $output : '');
	}
}
?>