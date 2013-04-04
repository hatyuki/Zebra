package Zebra::Web::View;
use strict;
use warnings;
use utf8;
use Carp ( );
use File::Spec ( );

use Text::Xslate 1.6001;
use Zebra::Web::ViewFunctions;

sub make_instance
{
    my ($class, $context) = @_;
    Carp::croak("Usage: Zebra::Web::View->make_instance(\$context_class)") if @_!=2;

    my $conf = $context->config->{xslate} || +{ };
    my $view = Text::Xslate->new( +{
            module   => [
                'Text::Xslate::Bridge::Star',
                'Zebra::Web::ViewFunctions',
            ],
            function => { },
            %$conf
        },
    );

    return $view;
}

1;
