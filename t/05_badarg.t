#!perl

use Test::More;
require Test::RequiresInternet;

eval {
        Test::RequiresInternet->import('www.google.com');
};

diag $@;

ok( $@ ? 1 : 0 );
done_testing();

