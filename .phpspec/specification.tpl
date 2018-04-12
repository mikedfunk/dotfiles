<?php
/**
 * %name%
 *
 * @copyright Leaf Group, Ltd. All Rights Reserved.
 */
namespace %namespace%;

use PhpSpec\ObjectBehavior;
use Prophecy\Argument;

/**
 * Specification unit test for %subject%.
 *
 * @see \%subject%
 *
 * @author Michael Funk <mike.funk@leafgroup.com>
 */
class %name% extends ObjectBehavior
{

    /**
     * it_is_initializable
     */
    public function it_is_initializable()
    {
        $this->shouldHaveType('%subject%');
    }
}
