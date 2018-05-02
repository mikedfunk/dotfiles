<?php

return PhpCsFixer\Config::create()
    ->setRules([
        // "array_syntax" => ["syntax" => 'short'], // this would mean a ton of changes
        'align_multiline_comment' => ['comment_type' => 'phpdocs_like'], // Each line of multi-line DocComments must have an asterisk [PSR-5] and must be aligned with the first one.
        'array_indentation' => true, // Each element of an array must be indented exactly once.
        'cast_spaces' => ['space' => 'none'], // A single space or none should be between cast and variable.
        'class_attributes_separation' => ['elements' => ['method']], // Class, trait and interface elements must be separated with one blank line.
        'combine_consecutive_issets' => true, // Using isset($var) && multiple times should be done in one call.
        'combine_consecutive_unsets' => true, // Calling unset on multiple items should be done in one call.
        'comment_to_phpdoc' => true, // Comments with annotation should be docblock. @risky
        'lowercase_cast' => true,
        'lowercase_constants' => true, // The PHP constants true, false, and null MUST be in lower case.
        'method_chaining_indentation' => true, // Method chaining MUST be properly indented. Method chaining with different levels of indentation is not supported.
        'multiline_comment_opening_closing' => true, // DocBlocks must start with two asterisks, multiline comments must start with a single asterisk, after the opening slash. Both must end with a single asterisk before the closing slash.
        'native_function_casing' => true,
        // 'new_with_braces' => true, // matt doesn't like this
        'no_blank_lines_after_phpdoc' => true, // There should not be blank lines between docblock and the documented element.
        'no_empty_comment' => true,
        'no_empty_phpdoc' => true,
        'no_empty_statement' => true,
        'no_short_bool_cast' => true,
        'no_unused_imports' => true,
        'no_useless_return' => true,
        'ordered_imports' => true,
        // 'phpdoc_no_empty_return' => true, // matt doesn't like this
        'phpdoc_no_useless_inheritdoc' => true, // Classy that does not inherit must not have @inheritdoc tags.
        'phpdoc_scalar' => true,
        'phpdoc_trim' => true,
        'phpdoc_types' => true, // The correct case must be used for standard PHP types in PHPDoc.
        'phpdoc_var_without_name' => true, /** @var and @type annotations should not contain the variable name. */
        'return_type_declaration' => true, // There should be one or no space before colon, and one space after it in return type declarations, according to configuration.
        'short_scalar_cast' => true, // Cast (boolean) and (integer) should be written as (bool) and (int), (double) and (real) as (float).
        // 'single_line_comment_style' => true, // this breaks local @var
        // 'single_quote' => true, // cool but this fills the commit with a ton of unnecessary changes
        'ternary_to_null_coalescing' => true, // Use null coalescing operator ?? where possible. Requires PHP >= 7.0.
        // 'trailing_comma_in_multiline_array' => true, // likewise - good but really fills the commit
        'visibility_required' => true, // Visibility MUST be declared on all properties and methods; abstract and final MUST be declared before the visibility; static MUST be declared after the visibility.
    ])
    ->setRiskyAllowed(true);
