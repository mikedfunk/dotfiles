<?php
declare(strict_types=1);

namespace %namespace%;

use PhpSpec\ObjectBehavior;
use Prophecy\Argument;

/**
 * Specification unit test
 *
 * @see \%subject%
 */
final class %name% extends ObjectBehavior
{

    public function it_is_initializable()
    {
        $this->shouldHaveType('%subject%');
    }
}
