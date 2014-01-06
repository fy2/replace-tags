package Replacement;
use strict;
use warnings;
use Moose;

has 'tag' => (is => 'ro'
                     , isa => 'Str'
                     , required => 1
                     , trigger => \&_make_quoted_regex);

has 'value' =>   (is => 'ro'
                      , isa => 'Str'
                      , required => 1);
                      
has 'quoted_regex' => (is => 'rw', isa => 'Regexp');

sub _make_quoted_regex {
     my ( $self, $tag ) = @_;
     my $quoted_re = qr/$tag/i;
     $self->quoted_regex($quoted_re);    
}


no Moose;
__PACKAGE__->meta->make_immutable;