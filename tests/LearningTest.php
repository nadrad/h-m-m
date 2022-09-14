<?php

declare(strict_types=1);

namespace Tests;

define('INCLUDE_BUT_NOT_EXECUTE', true);

require_once __DIR__ .'/../vendor/autoload.php';
require_once __DIR__ .'/../h-m-m';

use PHPUnit\Framework\TestCase;
use function Hmm\build_map;
use function Hmm\load_empty_map;
use function Hmm\mput;

final class LearningTest extends TestCase
{
    const TERMINAL_WIDTH = 80;
    const TERMINAL_HEIGHT = 60;

    private $mm = [];

    public function setUp(): void
    {
        $mm['max_parent_width']		= 25;
        $mm['max_leaf_width']		= 55;
        $mm['line_spacing']			= 1;
        $mm['terminal_width'] = self::TERMINAL_WIDTH;
        $mm['terminal_height'] = self::TERMINAL_HEIGHT;

        load_empty_map($mm);
        build_map($mm);

        $this->mm = $mm;
    }

    public function testEmptyMapHasExpectedShape(): void
    {
        $mapElement = $this->mm['map'][1];

        self::assertStringContainsString('root', $mapElement);
        self::assertStringStartsWith(str_repeat(' ', 3), $mapElement);
        self::assertStringStartsNotWith(str_repeat(' ', 4), $mapElement);
    }

    public function testMputWritesStringToDesiredCoordinates(): void
    {
        mput($this->mm, 10, 1, 'arbitrary');

        $mapElement = $this->mm['map'][1];

        self::assertStringContainsString(
            'arbitrary',
            $mapElement
        );
        self::assertEquals(10, mb_strpos($mapElement, 'arbitrary'));
        self::assertStringContainsString(
            'root',
            $mapElement
        );
    }
}
