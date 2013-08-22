<?php
header('P3P:CP="IDC DSP COR ADM DEVi TAIi PSA PSD IVAi IVDi CONi HIS OUR IND CNT"');
ini_set('session.use_cookies', 'On');
ini_set('session.use_trans_sid', 'Off');
ini_set('session.gc_maxlifetime', 144000);
ini_set('session.cookie_lifetime', 144000);
ini_set('session.gc_divisor', 1000);
			
session_set_cookie_params(0, '/');
session_start();
?>