package ReplaceTags;
use Moose;
use ReplaceTags::Exception;
use MooseX::StrictConstructor;
use ProcessReplacement;
use Path::Tiny;
use FindBin;

has 'backup'            => (is => 'rw', isa => 'Bool', default => 0);
has 'suffix'            => (is => 'rw', isa => 'Str',  default => '.tpl');
has 'template_dir_path' => (is => 'rw', isa => 'Str',  default => "$FindBin::RealBin/templates");
has 'tag_wrapper'       => (is => 'rw', isa => 'Str',  default => '!');

has 'replacements' => (
      traits => ['Hash']
    , is     => 'rw'
    , isa  => 'HashRef[Str]'
    , default => sub { {} }
    , handles => {
            keys_in_replacements => 'keys'
          , get_replacement_key  => 'get'
          , set_replacement_key  => 'set'
    }
    , required => 1
);

sub run {
  
    my $processor = ProcessReplacement->new();
    
    if ( ref($_[0]) eq 'ReplaceTags' ) {   # Called in an object oriented way:
        return $processor->run_replacements($_[0]);
    }
    elsif (ref($_[0]) eq 'HASH' ) { #Called directly using package variable
        my $replace_tags = ReplaceTags->new( replacements => $_[0] );
        return $processor->run_replacements($replace_tags);
    } 
    else {
        ReplaceTags::Exception::ArgumentMissing->throw('You need to provide a HashRef of replacement tag and values.');
    }
}


no Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

ReplaceTags

=head1 SYNOPSIS

    use ReplaceTags;
    
    # OOP way:
    my %replacements = (
      expires => 'Mon, 31 Dec 2012 12:00:00 GMT'
    , title   => 'Replace Tags'
    , content => 'Hello, World!');
    
    my $replace_tags = ReplaceTags->new( 
      replacements => \%replacements               # This is a required paramater.
    , suffix       => '.tpl'                       # defaults to '.tpl'
    , template_dir_path => '/path/to/template/dir' # defaults to 'templates' in script bin dir.
    , backup => 0                                  # defaults to 0 (i.e. no backup)
    , tag_wrapper => '!'                           # defaults to '!' 
    );
    
    $replace_tags->run();
    
    
    # Non OOP way:
    ReplaceTags::run(\%replacements);
    
=head1 DESCRIPTION

This module is used to replace tags
in a directory of template files with 
a set of values.

=head2 Methods

=over 12

=item C<run>

This method carries out the replacements.

=back

=cut