<?php

$finder = PhpCsFixer\Finder::create()
    ->exclude('composer.phar')
    ->exclude('tags')
    ->exclude('vendor')
    ;

return PhpCsFixer\Config::create()
    ->setRules([
        "array_syntax" => ["syntax" => 'short'], // this would mean a ton of changes
    ]);
