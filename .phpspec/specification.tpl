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
class %name% extends ObjectBehavior
{

    /** @test */
    public function it_is_initializable()
    {
        $this->shouldHaveType('%subject%');
    }
}
