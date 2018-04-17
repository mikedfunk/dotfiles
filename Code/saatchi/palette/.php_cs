<?php

return PhpCsFixer\Config::create()
    ->setRules([
        // "array_syntax" => ["syntax" => 'short'], // this would mean a ton of changes
        'lowercase_cast' => true,
        'native_function_casing' => true,
        // 'new_with_braces' => true, // matt doesn't like this
        'no_empty_comment' => true,
        'no_empty_phpdoc' => true,
        'no_empty_statement' => true,
        'no_short_bool_cast' => true,
        // 'no_unused_imports' => true,
        'no_useless_return' => true,
        'ordered_imports' => true,
        // 'phpdoc_no_empty_return' => true, // matt doesn't like this
        'phpdoc_scalar' => true,
        'phpdoc_trim' => true,
        'comment_to_phpdoc' => true,
        // 'single_line_comment_style' => true, // this breaks local @var
        // 'single_quote' => true, // cool but this fills the commit with a ton of unnecessary changes
        // 'trailing_comma_in_multiline_array' => true, // likewise - good but really fills the commit
    ])
    ->setRiskyAllowed(true);
