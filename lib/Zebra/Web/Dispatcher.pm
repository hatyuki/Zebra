package Zebra::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    return $_[0]->render('index.tx');
};

post '/generate' => sub {
    my $c = shift;
    my $qrcode = [ [ ] ];

    if (my $text = $c->request->param('text')) {
        $qrcode = $c->generator->plot($text);
    }

    return $c->render_json($qrcode);
};

1;
