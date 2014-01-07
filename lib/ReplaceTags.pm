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