package Zebra::Web;
use strict;
use warnings;
use utf8;
use parent qw/ Zebra Amon2::Web /;
use Log::Minimal;
use Try::Tiny;

# dispatcher
use Zebra::Web::Dispatcher;
sub dispatch
{
    my $c = shift;

    try {
        return Zebra::Web::Dispatcher->dispatch($c) or die "response is not generated";
    } catch {
        critf $_;
        return $c->res_500( );
    };
}

sub res_404 { $_[0]->res_with_code(404) }
sub res_500 { $_[0]->res_with_code(500) }

sub res_with_code
{
    my ($c, $status) = @_;
    my $content = $c->create_view->render("$status.tx");

    return $c->create_response($status, [
            'Content-Type'   => 'text/html; charset=utf-8',
            'Content-Length' => length($content),
        ], [$content],
    );
}

# load plugins
__PACKAGE__->load_plugins('Web::JSON');

# setup view class
use Zebra::Web::View;
{
    my $view = Zebra::Web::View->make_instance(__PACKAGE__);
    sub create_view { $view }
}

# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

1;
