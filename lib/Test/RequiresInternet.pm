use strict;
use warnings;
package Test::RequiresInternet;

# ABSTRACT: Easily test network connectivity

=head1 SYNOPSIS

  use Test::More;
  use Test::RequiresInternet ('www.example.com' => 80, 'foobar.io' => 25);

  # if you reach here, sockets successfully connected to hosts/ports above

  ok(do_that_internet_thing());

  done_testing();

=head1 OVERVIEW

This module is intended to easily test network connectivity before functional 
tests begin to non-local Internet resources.  It does not require any modules
beyond those supplied in core Perl.

If you do not specify a host/port pair, then the module defaults to using
C<www.google.com> on port C<80>.  If you do specify a host and port, they 
must be specified in B<pairs>. It is a fatal error to omit one or the other.

If the environment variable C<NO_NETWORK_TESTING> is set, then the tests
will be skipped without attempting any socket connections.

If the sockets cannot connect to the specified hosts and ports, the exception
is caught, reported and the tests skipped.

=cut

use Socket;

sub import {
    skip_all("NO_NETWORK_TESTING") if env("NO_NETWORK_TESTING");

    my $argc = scalar @_;
    if ( $argc == 0 ) {
        push @_, 'www.google.com', 80;
    }
    elsif ( $argc % 2 != 0 ) {
        die "Must supply a server and a port. You supplied " . join ", ", @_ . "\n";
    }

    my %svrs = { @_ };

    foreach my $host ( @_ ) {
        my $port = shift;

        local $@;

        eval "make_socket($host, $port)";

        if ( $@ ) {
            skip_all("$@");
        }
    }
}

sub make_socket {
    my ($host, $port) = @_;

    if ($port =~ /\D/) { $port = getservbyname($port, "tcp") }
    die "Could not find a port number for $port\n" unless $port;

    my $iaddr = inet_aton($host) or die "no host: $host";

    my $paddr = sockaddr_in($port, $iaddr);
    my $proto = getprotobyname("tcp");

    socket(my $sock, PF_INET, SOCK_STREAM, $proto) or die "socket: $!";
    connect($sock, $paddr) or die "connect: $!";
    close ($sock) or die "close: $!";

    1;
}

sub env {
    exists $ENV{$_[0]} && $ENV{$_[0]} eq '1'
}

sub skip_all {
    my $reason = shift;
    print "1..0 # Skipped: $reason";
    exit 0;
}

1;
