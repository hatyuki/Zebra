package Zebra::Web::ViewFunctions;
use strict;
use warnings;
use utf8;
use parent qw/ Exporter /;
use Module::Functions;
use File::Spec;

our @EXPORT = get_public_functions( );

sub uri_for { Amon2->context->uri_for(@_) }

{
    my %static_file_cache;
    sub static_file {
        my $fname = shift;
        my $c = Amon2->context;
        if (not exists $static_file_cache{$fname}) {
            my $fullpath = File::Spec->catfile($c->base_dir, $fname);
            $static_file_cache{$fname} = (stat $fullpath)[9];
        }
        return $c->uri_for(
            $fname, {
                't' => $static_file_cache{$fname} || 0
            }
        );
    }
}

1;
