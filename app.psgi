use strict;
use warnings;
use File::Basename qw/ dirname /;
use File::Spec;
use Plack::Builder;
use Zebra::Config;
use Zebra::Web;
my $mount = Zebra::Config->param('mount');

builder {
    enable 'ReverseProxy';
    enable 'Log::Minimal', (
        autodump => 1,
        loglevel => 'INFO',
    );
    enable 'Static', (
        path => qr{^/assets/},
        root => File::Spec->catdir(dirname(__FILE__)),
    );

    mount $mount => Zebra::Web->to_app( );
};
