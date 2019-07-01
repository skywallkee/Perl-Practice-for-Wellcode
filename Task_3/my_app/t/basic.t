use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('MyApp');
$t->get_ok('/')->status_is(200)->content_like(qr/Mojolicious/i);
$t->get_ok('/login')->status_is(200)->content_like(qr/Mojolicious/i);
$t->get_ok('/register')->status_is(200)->content_like(qr/Mojolicious/i);

done_testing();
