#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Test::RequiresInternet' ) || print "Bail out!\n";
}

diag( "Testing Test::RequiresInternet $Test::RequiresInternet::VERSION, Perl $], $^X" );
