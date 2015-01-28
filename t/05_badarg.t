#!perl

use Test::More tests => 1;
require Test::RequiresInternet;

eval {
        Test::RequiresInternet->import('www.google.com');
};

diag $@;

ok( $@ ? 1 : 0 );

