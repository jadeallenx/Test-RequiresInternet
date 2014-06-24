#!perl

use Test::More;
use Test::RequiresInternet ( 'www.google.com' => 80, 'www.yahoo.com' => 80 );

ok(1);
done_testing();
