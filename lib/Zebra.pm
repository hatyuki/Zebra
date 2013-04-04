package Zebra;
use strict;
use warnings;
use parent qw/ Amon2 /;
use Text::QRCode;
use Zebra::Config;

our $VERSION = '0.00';

sub load_config
{
    return Zebra::Config->current;
}

sub generator
{
    my $self = shift;
    $self->{generator} ||= Text::QRCode->new;

    return $self->{generator};
}

1;
