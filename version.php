<?php
define('MODX_API_MODE', true);
require 'index.php';

$modx->setLogTarget('ECHO');
$modx->setLogLevel(modX::LOG_LEVEL_INFO);

echo $modx->getVersionData()['full_version'];
