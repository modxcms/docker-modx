<?php
require_once 'config.core.php';
require_once MODX_CORE_PATH . 'model/modx/modx.class.php';

$modx = new modX();
$modx->initialize('web');

echo $modx->getVersionData()['full_version'];
