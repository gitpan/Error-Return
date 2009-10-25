#!/usr/bin/env perl
use warnings;
use strict;
use Error ':try';
use Error::Return;
use Test::More tests => 3;
my $output;

sub doit {
    $output .= " in doit, before try\n";
    try {
        $output .= "  in try: start\n";
        RETURN 456;
        $output .= "  in try: end\n";
    }
    catch Error with {
        my $E = shift;
        $output .= "  caught error [$E]\n";
    };
    $output .= " in doit, after try\n";
}
$output .= "before doit\n";
my $x = doit();
$output .= "doit() returned [$x]\n";
$output .= "after doit\n";
is($output, <<EOEXPECT, 'output');
before doit
 in doit, before try
  in try: start
doit() returned [456]
after doit
EOEXPECT
is($x, 456, 'returned value');
is_deeply(\@Error::STACK, [], 'cleared @Error::STACK');
