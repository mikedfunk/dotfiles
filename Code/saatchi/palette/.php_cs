<?php

declare(strict_types=1);

use PhpCsFixer\Fixer\Import\OrderedImportsFixer;

$path = \shell_exec('phpenv prefix').
    '/composer/global/pedrotroller/php-cs-custom-fixer/vendor/autoload.php';
$path = \preg_replace("/[\r\n]*/", '', $path);
require_once $path;

$finder = PhpCsFixer\Finder::create()
    ->exclude('vendor')
    ->exclude('tests')
    ->exclude('spec')
    ->exclude('coverage')
    ->exclude('resources')
    ->exclude('bootstrap')
    ->exclude('storage')
    ->notPath('tags')
    ->notPath('composer.phar')
    ->notPath('_ide_helper.php');

return PhpCsFixer\Config::create()
    ->registerCustomFixers(new \PedroTroller\CS\Fixer\Fixers())
    ->setRules([
        'align_multiline_comment' => true, // Each line of multi-line DocComments must have an asterisk [PSR-5] and must be aligned with the first one. @PhpCsFixer
        'array_indentation' => true, // Each element of an array must be indented exactly once. @PhpCsFixer
        'array_syntax' => ['syntax' => 'short'], // PHP arrays should be declared using the configured syntax. @PhpCsFixer@Symfony
        'backtick_to_shell_exec' => true, // Converts backtick operators to shell_exec calls.
        'binary_operator_spaces' => true, // Binary operators should be surrounded by space as configured. @PhpCsFixer@Symfony
        'blank_line_after_namespace' => true, // There MUST be one blank line after the namespace declaration. @PSR2@PhpCsFixer@Symfony
        'blank_line_after_opening_tag' => true, // Ensure there is no code on the same line as the PHP open tag and it is followed by a blank line. @PhpCsFixer@Symfony
        'blank_line_before_return' => true, // An empty line feed should precede a return statement.
        // 'blank_line_before_statement' => true, // An empty line feed must precede any configured statement. @PhpCsFixer@Symfony
        'braces' => true, // The body of each structure MUST be enclosed by braces. Braces should be properly placed. Body of braces should be properly indented. @PSR2@PhpCsFixer@Symfony
        'cast_spaces' => ['space' => 'single'], // A single space or none should be between cast and variable. @PhpCsFixer@Symfony
        'class_attributes_separation' => true, // Class, trait and interface elements must be separated with one blank line. @PhpCsFixer@Symfony
        'class_definition' => true, // Whitespace around the keywords of a class, trait or interfaces definition should be one space. @PSR2@PhpCsFixer@Symfony
        'class_keyword_remove' => true, // Converts ::class keywords to FQCN strings.
        'combine_consecutive_issets' => true, // Using isset($var) && multiple times should be done in one call. @PhpCsFixer
        'combine_consecutive_unsets' => true, // Calling unset on multiple items should be done in one call. @PhpCsFixer
        'combine_nested_dirname' => true, // Replace multiple nested calls of dirname by only one call with second $level parameter. Requires PHP >= 7.0. @PHP70Migration:risky@PHP71Migration:risky
        'comment_to_phpdoc' => true, // Comments with annotation should be docblock when used on structural elements. @PhpCsFixer:risky
        'compact_nullable_typehint' => true, // Remove extra spaces in a nullable typehint. @PhpCsFixer
        'concat_space' => [
            'spacing' => 'one',
        ], // Concatenation should be spaced according configuration. @PhpCsFixer@Symfony
        'date_time_immutable' => true, // Class DateTimeImmutable should be used instead of DateTime.
        'declare_equal_normalize' => true, // Equal sign in declare statement should be surrounded by spaces or not following configuration. @PhpCsFixer@Symfony
        'declare_strict_types' => true, // Force strict types declaration in all files. Requires PHP >= 7.0. @PHP70Migration:risky@PHP71Migration:risky
        'dir_constant' => true, // Replaces dirname(__FILE__) expression with equivalent __DIR__ constant. @PhpCsFixer:risky@Symfony:risky
        'doctrine_annotation_array_assignment' => true, // Doctrine annotations must use configured operator for assignment in arrays. @DoctrineAnnotation
        'doctrine_annotation_braces' => true, // Doctrine annotations without arguments must use the configured syntax. @DoctrineAnnotation
        'doctrine_annotation_indentation' => true, // Doctrine annotations must be indented with four spaces. @DoctrineAnnotation
        'doctrine_annotation_spaces' => true, // Fixes spaces in Doctrine annotations. @DoctrineAnnotation
        'elseif' => true, // The keyword elseif should be used instead of else if so that all control keywords look like single words. @PSR2@PhpCsFixer@Symfony
        'encoding' => true, // PHP code MUST use only UTF-8 without BOM (remove BOM). @PSR1@PSR2@PhpCsFixer@Symfony
        'ereg_to_preg' => true, // Replace deprecated ereg regular expression functions with preg. @PhpCsFixer:risky@Symfony:risky
        'error_suppression' => true, // Error control operator should be added to deprecation notices and/or removed from other cases. @PhpCsFixer:risky@Symfony:risky
        'escape_implicit_backslashes' => true, // Escape implicit backslashes in strings and heredocs to ease the understanding of which are special chars interpreted by PHP and which not. @PhpCsFixer
        'explicit_indirect_variable' => true, // Add curly braces to indirect variables to make them clear to understand. Requires PHP >= 7.0. @PhpCsFixer
        'explicit_string_variable' => true, // Converts implicit variables into explicit ones in double-quoted strings or heredoc syntax. @PhpCsFixer
        // 'final_class' => true, // All classes must be final, except abstract ones and Doctrine entities.
        // 'final_internal_class' => true, // Internal classes should be final. @PhpCsFixer:risky
        'fopen_flag_order' => true, // Order the flags in fopen calls, b and t must be last. @PhpCsFixer:risky@Symfony:risky
        'fopen_flags' => true, // The flags in fopen calls must omit t, and b must be omitted or included consistently. @PhpCsFixer:risky@Symfony:risky
        'full_opening_tag' => true, // PHP code must use the long <?php tags or short-echo <?= tags and not other tag variations. @PSR1@PSR2@PhpCsFixer@Symfony
        'fully_qualified_strict_types' => true, // Transforms imported FQCN parameters and return types in function arguments to short version. @PhpCsFixer
        'function_declaration' => true, // Spaces should be properly placed in a function declaration. @PSR2@PhpCsFixer@Symfony
        'function_to_constant' => true, // Replace core functions calls returning constants with the constants. @PhpCsFixer:risky@Symfony:risky
        'function_typehint_space' => true, // Ensure single space between function's argument and its typehint. @PhpCsFixer@Symfony
        'general_phpdoc_annotation_remove' => true, // Configured annotations should be omitted from PHPDoc.
        'hash_to_slash_comment' => true, // Single line comments should use double slashes // and not hash #.
        // 'header_comment' => [
        //    'header' => '',
        //    'separate' => 'none',
        // ], // remove header comment (We only need class-level comment)
        'heredoc_indentation' => true, // Heredoc/nowdoc content must be properly indented. Requires PHP >= 7.3. @PHP73Migration
        'heredoc_to_nowdoc' => true, // Convert heredoc to nowdoc where possible. @PhpCsFixer
        'implode_call' => true, // Function implode must be called with 2 arguments in the documented order. @PhpCsFixer:risky@Symfony:risky
        'include' => true, // Include/Require and file path should be divided with a single space. File path should not be placed under brackets. @PhpCsFixer@Symfony
        'increment_style' => true, // Pre- or post-increment and decrement operators should be used if possible. @PhpCsFixer@Symfony
        'indentation_type' => true, // Code MUST use configured indentation type. @PSR2@PhpCsFixer@Symfony
        'is_null' => true, // Replaces is_null($var) expression with null === $var. @PhpCsFixer:risky@Symfony:risky
        'line_ending' => true, // All PHP files must use same line ending. @PSR2@PhpCsFixer@Symfony
        'linebreak_after_opening_tag' => true, // Ensure there is no code on the same line as the PHP open tag.
        // 'list_syntax' => true, // List (array destructuring) assignment should be declared using the configured syntax. Requires PHP >= 7.1.
        'logical_operators' => true, // Use && and || logical operators instead of and and or. @PhpCsFixer:risky
        'lowercase_cast' => true, // Cast should be written in lower case. @PhpCsFixer@Symfony
        'lowercase_constants' => true, // The PHP constants true, false, and null MUST be in lower case. @PSR2@PhpCsFixer@Symfony
        'lowercase_keywords' => true, // PHP keywords MUST be in lower case. @PSR2@PhpCsFixer@Symfony
        'lowercase_static_reference' => true, // Class static references self, static and parent MUST be in lower case. @PhpCsFixer@Symfony
        'magic_constant_casing' => true, // Magic constants should be referred to using the correct casing. @PhpCsFixer@Symfony
        'magic_method_casing' => true, // Magic method definitions and calls must be using the correct casing. @PhpCsFixer@Symfony
        'mb_str_functions' => true, // Replace non multibyte-safe functions with corresponding mb function.
        'method_argument_space' => true, // In method arguments and method call, there MUST NOT be a space before each comma and there MUST be one space after each comma. Argument lists MAY be split across multiple lines, where each subsequent line is indented once. When doing so, the first item in the list MUST be on the next line, and there MUST be only one argument per line. @PSR2@PhpCsFixer@Symfony
        'method_chaining_indentation' => true, // Method chaining MUST be properly indented. Method chaining with different levels of indentation is not supported. @PhpCsFixer
        'method_separation' => true, // Methods must be separated with one blank line.
        'modernize_types_casting' => true, // Replaces intval, floatval, doubleval, strval and boolval function calls with according type casting operator. @PhpCsFixer:risky@Symfony:risky
        'multiline_comment_opening_closing' => true, // DocBlocks must start with two asterisks, multiline comments must start with a single asterisk, after the opening slash. Both must end with a single asterisk before the closing slash. @PhpCsFixer
        'multiline_whitespace_before_semicolons' => true, // Forbid multi-line whitespace before the closing semicolon or move the semicolon to the new line for chained calls. @PhpCsFixer
        'native_constant_invocation' => true, // before constant invocation of internal constant to speed up resolving. Constant name match is case-sensitive, except for null, false and true. @PhpCsFixer:risky@Symfony:risky
        'native_function_casing' => true, // Function defined by PHP should be called using the correct casing. @PhpCsFixer@Symfony
        'native_function_invocation' => true, // before function invocation to speed up resolving. @PhpCsFixer:risky@Symfony:risky
        'native_function_type_declaration_casing' => true, // Native type hints for functions should use the correct case. @PhpCsFixer@Symfony
        'new_with_braces' => true, // All instances created with new keyword must be followed by braces. @PhpCsFixer@Symfony
        'no_alias_functions' => true, // Master functions shall be used instead of aliases. @PhpCsFixer:risky@Symfony:risky
        'no_alternative_syntax' => true, // Replace control structure alternative syntax to use braces. @PhpCsFixer
        'no_binary_string' => true, // There should not be a binary flag before strings. @PhpCsFixer
        'no_blank_lines_after_class_opening' => true, // There should be no empty lines after class opening brace. @PhpCsFixer@Symfony
        'no_blank_lines_after_phpdoc' => true, // There should not be blank lines between docblock and the documented element. @PhpCsFixer@Symfony
        // 'no_blank_lines_before_namespace' => true, // There should be no blank lines before a namespace declaration.
        'no_break_comment' => true, // There must be a comment when fall-through is intentional in a non-empty case body. @PSR2@PhpCsFixer@Symfony
        'no_closing_tag' => true, // The closing ? > tag MUST be omitted from files containing only PHP. @PSR2@PhpCsFixer@Symfony
        'no_empty_comment' => true, // There should not be any empty comments. @PhpCsFixer@Symfony
        'no_empty_phpdoc' => true, // There should not be empty PHPDoc blocks. @PhpCsFixer@Symfony
        'no_empty_statement' => true, // Remove useless semicolon statements. @PhpCsFixer@Symfony
        'no_extra_blank_lines' => true, // Removes extra blank lines and/or blank lines following configuration. @PhpCsFixer@Symfony
        'no_extra_consecutive_blank_lines' => true, // Removes extra blank lines and/or blank lines following configuration.
        'no_homoglyph_names' => true, // Replace accidental usage of homoglyphs (non ascii characters) in names. @PhpCsFixer:risky@Symfony:risky
        'no_leading_import_slash' => true, // Remove leading slashes in use clauses. @PhpCsFixer@Symfony
        'no_leading_namespace_whitespace' => true, // The namespace declaration line shouldn't contain leading whitespace. @PhpCsFixer@Symfony
        'no_mixed_echo_print' => true, // Either language construct print or echo should be used. @PhpCsFixer@Symfony
        'no_multiline_whitespace_around_double_arrow' => true, // Operator => should not be surrounded by multi-line whitespaces. @PhpCsFixer@Symfony
        'no_multiline_whitespace_before_semicolons' => true, // Multi-line whitespace before closing semicolon are prohibited.
        'no_null_property_initialization' => true, // Properties MUST not be explicitly initialized with null except when they have a type declaration (PHP 7.4). @PhpCsFixer
        'no_php4_constructor' => true, // Convert PHP4-style constructors to __construct.
        'no_short_bool_cast' => true, // Short cast bool using double exclamation mark should not be used. @PhpCsFixer@Symfony
        'no_short_echo_tag' => true, // Replace short-echo <?= with long format <?php echo syntax. @PhpCsFixer
        'no_singleline_whitespace_before_semicolons' => true, // Single-line whitespace before closing semicolon are prohibited. @PhpCsFixer@Symfony
        'no_spaces_after_function_name' => true, // When making a method or function call, there MUST NOT be a space between the method or function name and the opening parenthesis. @PSR2@PhpCsFixer@Symfony
        'no_spaces_around_offset' => true, // There MUST NOT be spaces around offset braces. @PhpCsFixer@Symfony
        'no_spaces_inside_parenthesis' => true, // There MUST NOT be a space after the opening parenthesis. There MUST NOT be a space before the closing parenthesis. @PSR2@PhpCsFixer@Symfony
        'no_superfluous_elseif' => true, // Replaces superfluous elseif with if. @PhpCsFixer
        'no_superfluous_phpdoc_tags' => true, // Removes @param and @return tags that don't provide any useful information. @PhpCsFixer@Symfony
        'no_trailing_comma_in_list_call' => true, // Remove trailing commas in list function calls. @PhpCsFixer@Symfony
        'no_trailing_comma_in_singleline_array' => true, // PHP single-line arrays should not have trailing comma. @PhpCsFixer@Symfony
        'no_trailing_whitespace' => true, // Remove trailing whitespace at the end of non-blank lines. @PSR2@PhpCsFixer@Symfony
        'no_trailing_whitespace_in_comment' => true, // There MUST be no trailing spaces inside comment or PHPDoc. @PSR2@PhpCsFixer@Symfony
        'no_unneeded_control_parentheses' => true, // Removes unneeded parentheses around control statements. @PhpCsFixer@Symfony
        'no_unneeded_curly_braces' => true, // Removes unneeded curly braces that are superfluous and aren't part of a control structure's body. @PhpCsFixer@Symfony
        'no_unneeded_final_method' => true, // A final class must not have final methods. @PhpCsFixer@Symfony
        'no_unreachable_default_argument_value' => true, // In function arguments there must not be arguments with default values before non-default ones. @PhpCsFixer:risky
        'no_unset_cast' => true, // Variables must be set null instead of using (unset) casting. @PhpCsFixer
        'no_unset_on_property' => true, // Properties should be set to null instead of using unset. @PhpCsFixer:risky
        'no_unused_imports' => true, // Unused use statements must be removed. @PhpCsFixer@Symfony
        'no_useless_else' => true, // There should not be useless else cases. @PhpCsFixer
        'no_useless_return' => true, // There should not be an empty return statement at the end of a function. @PhpCsFixer
        'no_whitespace_before_comma_in_array' => true, // In array declaration, there MUST NOT be a whitespace before each comma. @PhpCsFixer@Symfony
        'no_whitespace_in_blank_line' => true, // Remove trailing whitespace at the end of blank lines. @PhpCsFixer@Symfony
        'non_printable_character' => true, // Remove Zero-width space (ZWSP), Non-breaking space (NBSP) and other invisible unicode symbols. @PHP70Migration:risky@PHP71Migration:risky@PhpCsFixer:risky@Symfony:risky
        'normalize_index_brace' => true, // Array index should always be written by using square braces. @PhpCsFixer@Symfony
        // 'not_operator_with_space' => true, // Logical NOT operators (!) should have leading and trailing whitespaces.
        // 'not_operator_with_successor_space' => true, // Logical NOT operators (!) should have one trailing whitespace.
        'object_operator_without_whitespace' => true, // There should not be space before or after object T_OBJECT_OPERATOR ->. @PhpCsFixer@Symfony
        'ordered_class_elements' => [
            'order' => [
                'use_trait',
                'constant_public',
                'constant_protected',
                'constant_private',
                'property_public',
                'property_protected',
                'property_private',
                'construct',
                'destruct',
                'method',
                // 'magic',
                // 'phpunit',
                // 'method_public',
                // 'method_protected',
                // 'method_private',
            ],
        ], // Orders the elements of classes/interfaces/traits. @PhpCsFixer
        // 'ordered_imports' => true, // Ordering use statements. @PhpCsFixer@Symfony
        'ordered_imports' => [
            'sortAlgorithm' => OrderedImportsFixer::SORT_ALPHA,
            'importsOrder' => [
                'class',
                'function',
                'const',
            ],
        ],
        'ordered_interfaces' => true, // Orders the interfaces in an implements or interface extends clause.
        'php_unit_construct' => true, // PHPUnit assertion method calls like ->assertSame(true, $foo) should be written with dedicated method like ->assertTrue($foo). @PhpCsFixer:risky@Symfony:risky
        'php_unit_dedicate_assert' => true, // PHPUnit assertions like assertInternalType, assertFileExists, should be used over assertTrue. @PHPUnit30Migration:risky@PHPUnit32Migration:risky@PHPUnit35Migration:risky@PHPUnit43Migration:risky@PHPUnit48Migration:risky@PHPUnit50Migration:risky@PHPUnit52Migration:risky@PHPUnit54Migration:risky@PHPUnit55Migration:risky@PHPUnit56Migration:risky@PHPUnit57Migration:risky@PHPUnit60Migration:risky@PHPUnit75Migration:risky
        'php_unit_dedicate_assert_internal_type' => true, // PHPUnit assertions like assertIsArray should be used over assertInternalType. @PHPUnit75Migration:risky
        'php_unit_expectation' => true, // Usages of ->setExpectedException* methods MUST be replaced by ->expectException* methods. @PHPUnit52Migration:risky@PHPUnit54Migration:risky@PHPUnit55Migration:risky@PHPUnit56Migration:risky@PHPUnit57Migration:risky@PHPUnit60Migration:risky@PHPUnit75Migration:risky
        'php_unit_fqcn_annotation' => true, // PHPUnit annotations should be a FQCNs including a root namespace. @PhpCsFixer@Symfony
        'php_unit_internal_class' => true, // All PHPUnit test classes should be marked as internal. @PhpCsFixer
        'php_unit_method_casing' => true, // Enforce camel (or snake) case for PHPUnit test methods, following configuration. @PhpCsFixer
        'php_unit_mock' => true, // Usages of ->getMock and ->getMockWithoutInvokingTheOriginalConstructor methods MUST be replaced by ->createMock or ->createPartialMock methods. @PHPUnit54Migration:risky@PHPUnit55Migration:risky@PHPUnit56Migration:risky@PHPUnit57Migration:risky@PHPUnit60Migration:risky@PHPUnit75Migration:risky
        'php_unit_mock_short_will_return' => true, // Usage of PHPUnit's mock e.g. ->will($this->returnValue(..)) must be replaced by its shorter equivalent such as ->willReturn(...). @PhpCsFixer:risky@Symfony:risky
        'php_unit_namespaced' => true, // HPUnit\Framework\TestCase instead of \PHPUnit_Framework_TestCase. @PHPUnit48Migration:risky@PHPUnit50Migration:risky@PHPUnit52Migration:risky@PHPUnit54Migration:risky@PHPUnit55Migration:risky@PHPUnit56Migration:risky@PHPUnit57Migration:risky@PHPUnit60Migration:risky@PHPUnit75Migration:risky
        'php_unit_no_expectation_annotation' => true, // Usages of @expectedException* annotations MUST be replaced by ->setExpectedException* methods. @PHPUnit32Migration:risky@PHPUnit35Migration:risky@PHPUnit43Migration:risky@PHPUnit48Migration:risky@PHPUnit50Migration:risky@PHPUnit52Migration:risky@PHPUnit54Migration:risky@PHPUnit55Migration:risky@PHPUnit56Migration:risky@PHPUnit57Migration:risky@PHPUnit60Migration:risky@PHPUnit75Migration:risky
        'php_unit_ordered_covers' => true, // Order @covers annotation of PHPUnit tests. @PhpCsFixer
        'php_unit_set_up_tear_down_visibility' => true, // Changes the visibility of the setUp() and tearDown() functions of PHPUnit to protected, to match the PHPUnit TestCase. @PhpCsFixer:risky
        'php_unit_size_class' => true, // All PHPUnit test cases should have @small, @medium or @large annotation to enable run time limits.
        'php_unit_strict' => true, // PHPUnit methods like assertSame should be used instead of assertEquals. @PhpCsFixer:risky
        'php_unit_test_annotation' => true, // Adds or removes @test annotations from tests, following configuration. @PhpCsFixer:risky
        'php_unit_test_case_static_method_calls' => true, // ramework\TestCase static methods must all be of the same type, either $this->, self:: or static::. @PhpCsFixer:risky
        'php_unit_test_class_requires_covers' => true, // Adds a default @coversNothing annotation to PHPUnit test classes that have no @covers* annotation. @PhpCsFixer
        'phpdoc_add_missing_param_annotation' => true, // PHPDoc should contain @param for all params. @PhpCsFixer
        // 'phpdoc_align' => [
        //     'align' => 'left',
        // ], // All items of the given phpdoc tags must be either left-aligned or (by default) aligned vertically. @PhpCsFixer@Symfony
        'phpdoc_annotation_without_dot' => true, // PHPDoc annotation descriptions should not be a sentence. @PhpCsFixer@Symfony
        'phpdoc_indent' => true, // Docblocks should have the same indentation as the documented subject. @PhpCsFixer@Symfony
        'phpdoc_inline_tag' => true, // Fix PHPDoc inline tags, make @inheritdoc always inline. @PhpCsFixer@Symfony
        // 'phpdoc_no_access' => true, // @access annotations should be omitted from PHPDoc. @PhpCsFixer@Symfony
        'phpdoc_no_alias_tag' => true, // No alias PHPDoc tags should be used. @PhpCsFixer@Symfony
        // 'phpdoc_no_empty_return' => true, // @return void and @return null annotations should be omitted from PHPDoc. @PhpCsFixer
        'phpdoc_no_package' => true, // @package and @subpackage annotations should be omitted from PHPDoc. @PhpCsFixer@Symfony
        'phpdoc_no_useless_inheritdoc' => true, // Classy that does not inherit must not have @inheritdoc tags. @PhpCsFixer@Symfony
        // 'phpdoc_order' => true, // Annotations in PHPDoc should be ordered so that @param annotations come first, then @throws annotations, then @return annotations. @PhpCsFixer
        'phpdoc_return_self_reference' => true, // The type of @return annotations of methods returning a reference to itself must the configured one. @PhpCsFixer@Symfony
        'phpdoc_scalar' => true, // Scalar types should always be written in the same form. int not integer, bool not boolean, float not real or double. @PhpCsFixer@Symfony
        'phpdoc_separation' => true, // Annotations in PHPDoc should be grouped together so that annotations of the same type immediately follow each other, and annotations of a different type are separated by a single blank line. @PhpCsFixer@Symfony
        'phpdoc_single_line_var_spacing' => true, // Single line @var PHPDoc should have proper spacing. @PhpCsFixer@Symfony
        'phpdoc_summary' => true, // PHPDoc summary should end in either a full stop, exclamation mark, or question mark. @PhpCsFixer@Symfony
        // 'phpdoc_to_comment' => true, // Docblocks should only be used on structural elements. @PhpCsFixer@Symfony
        'phpdoc_to_return_type' => true, // EXPERIMENTAL: Takes @return annotation of non-mixed types and adjusts accordingly the function signature. Requires PHP >= 7.0.
        'phpdoc_trim' => true, // PHPDoc should start and end with content, excluding the very first and last line of the docblocks. @PhpCsFixer@Symfony
        'phpdoc_trim_consecutive_blank_line_separation' => true, // Removes extra blank lines after summary and after description in PHPDoc. @PhpCsFixer@Symfony
        'phpdoc_types' => true, // The correct case must be used for standard PHP types in PHPDoc. @PhpCsFixer@Symfony
        'phpdoc_types_order' => [
            'null_adjustment' => 'always_last',
        ], // Sorts PHPDoc types. @PhpCsFixer@Symfony
        'phpdoc_var_annotation_correct_order' => true, // @var and @type annotations must have type and name in the correct order. @PhpCsFixer
        'phpdoc_var_without_name' => true, // @var and @type annotations should not contain the variable name. @PhpCsFixer@Symfony
        'pow_to_exponentiation' => true, // Converts pow to the ** operator. @PHP56Migration:risky@PHP70Migration:risky@PHP71Migration:risky
        'pre_increment' => true, // Pre incrementation/decrementation should be used if possible.
        'protected_to_private' => true, // Converts protected variables and methods to private where possible. @PhpCsFixer
        'psr0' => true, // Classes must be in a path that matches their namespace, be at least one namespace deep and the class name should match the file name.
        'psr4' => true, // Class names should match the file name. @PhpCsFixer:risky@Symfony:risky
        'random_api_migration' => true, // Replaces rand, srand, getrandmax functions calls with their mt_* analogs. @PHP70Migration:risky@PHP71Migration:risky
        'return_assignment' => true, // Local, dynamic and directly referenced variables should not be assigned and directly returned by a function or method. @PhpCsFixer
        'return_type_declaration' => true, // There should be one or no space before colon, and one space after it in return type declarations, according to configuration. @PhpCsFixer@Symfony
        'self_accessor' => true, // Inside class or interface element self should be preferred to the class name itself. @PhpCsFixer:risky@Symfony:risky
        'semicolon_after_instruction' => true, // Instructions must be terminated with a semicolon. @PhpCsFixer@Symfony
        'set_type_to_cast' => true, // Cast shall be used, not settype. @PhpCsFixer:risky@Symfony:risky
        'short_scalar_cast' => true, // Cast (boolean) and (integer) should be written as (bool) and (int), (double) and (real) as (float), (binary) as (string). @PhpCsFixer@Symfony
        'silenced_deprecation_error' => true, // Ensures deprecation notices are silenced.
        'simple_to_complex_string_variable' => true, // Converts explicit variables in double-quoted strings and heredoc syntax from simple to complex format (${ to {$). @PhpCsFixer
        'simplified_null_return' => true, // A return statement wishing to return void should not return null.
        'single_blank_line_at_eof' => true, // A PHP file without end tag must always end with a single empty line feed. @PSR2@PhpCsFixer@Symfony
        'single_blank_line_before_namespace' => true, // There should be exactly one blank line before a namespace declaration. @PhpCsFixer@Symfony
        'single_class_element_per_statement' => true, // There MUST NOT be more than one property or constant declared per statement. @PSR2@PhpCsFixer@Symfony
        'single_import_per_statement' => true, // There MUST be one use keyword per declaration. @PSR2@PhpCsFixer@Symfony
        'single_line_after_imports' => true, // Each namespace use MUST go on its own line and there MUST be one blank line after the use statements block. @PSR2@PhpCsFixer@Symfony
        'single_line_comment_style' => true, // Single-line comments and multi-line comments with only one line of actual content should use the // syntax. @PhpCsFixer@Symfony
        'single_quote' => true, // Convert double quotes to single quotes for simple strings. @PhpCsFixer@Symfony
        'single_trait_insert_per_statement' => true, // Each trait use must be done as single statement. @PhpCsFixer@Symfony
        'space_after_semicolon' => true, // Fix whitespace after a semicolon. @PhpCsFixer@Symfony
        'standardize_increment' => true, // Increment and decrement operators should be used if possible. @PhpCsFixer@Symfony
        'standardize_not_equals' => true, // Replace all <> with !=. @PhpCsFixer@Symfony
        'static_lambda' => true, // Lambdas not (indirect) referencing $this must be declared static.
        'strict_comparison' => true, // Comparisons should be strict. @PhpCsFixer:risky
        'strict_param' => true, // Functions should be used with $strict param set to true. @PhpCsFixer:risky
        'string_line_ending' => true, // All multi-line strings must use correct line ending. @PhpCsFixer:risky
        'switch_case_semicolon_to_colon' => true, // A case should be followed by a colon and not a semicolon. @PSR2@PhpCsFixer@Symfony
        'switch_case_space' => true, // Removes extra spaces between colon and case value. @PSR2@PhpCsFixer@Symfony
        'ternary_operator_spaces' => true, // Standardize spaces around ternary operator. @PhpCsFixer@Symfony
        'ternary_to_null_coalescing' => true, // Use null coalescing operator ?? where possible. Requires PHP >= 7.0. @PHP70Migration@PHP71Migration@PHP73Migration
        'trailing_comma_in_multiline_array' => true, // PHP multi-line arrays should have a trailing comma. @PhpCsFixer@Symfony
        'trim_array_spaces' => true, // Arrays should be formatted like function/method arguments, without leading or trailing single line space. @PhpCsFixer@Symfony
        'unary_operator_spaces' => true, // Unary operators should be placed adjacent to their operands. @PhpCsFixer@Symfony
        'visibility_required' => true, // Visibility MUST be declared on all properties and methods; abstract and final MUST be declared before the visibility; static MUST be declared after the visibility. @PHP71Migration@PHP73Migration@PSR2@PhpCsFixer@Symfony
        // 'void_return' => true, // Add void return type to functions with missing or empty return statements, but priority is given to @return annotations. Requires PHP >= 7.1. @PHP71Migration:risky
        'whitespace_after_comma_in_array' => true, // In array declaration, there MUST be a whitespace after each comma. @PhpCsFixer@Symfony
        // 'yoda_style' => true, // Write conditions in Yoda style (true), non-Yoda style (false) or ignore those conditions (null) based on configuration. @PhpCsFixer@Symfony

        // THIRD_PARTY FIXERS
        'PedroTroller/line_break_between_method_arguments' => ['max-length' => 90, 'automatic-argument-merge' => true], // 'max-args' => 4,
        'PedroTroller/comment_line_to_phpdoc_block' => true,

        // this is 3 fixers in one but I don't like one of them and there's no way to whitelist each fixer >:/ So I'll use the "deprecated" one-by-one versions instead.
        // 'PedroTroller/phpspec' => ['instanceof' => ['PhpSpec\ObjectBehavior']],
        'PedroTroller/phpspec_scenario_return_type_declaration' => ['instanceof' => ['PhpSpec\ObjectBehavior']],
        // 'PedroTroller/phpspec_scenario_scope' => ['instanceof' => ['PhpSpec\ObjectBehavior']], // WHY would I want to remove the `public` from each phpspec method?
        'PedroTroller/ordered_spec_elements' => ['instanceof' => ['PhpSpec\ObjectBehavior']],
    ])
    ->setRiskyAllowed(true)
    ->setFinder($finder);
