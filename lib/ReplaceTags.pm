package ReplaceTags;
use Moose;
use ReplaceTags::Exception;
use Path::Tiny;
use Data::Dumper;
use FindBin;

 

has 'replacements' => (
      traits => ['Hash']
    , is     => 'rw'
    , isa  => 'HashRef[Str]'
    , default => sub { {} }
    , handles => {
            exists_in_replacements => 'exists'
          , keys_in_replacements => 'keys'
          , get_replacement_key  => 'get'
          , set_replacement_key  => 'set'
    }
);

has 'template_dir' => (
      is => 'rw'
    , isa => 'Path::Tiny'
    , builder => '_build_default_dir'
);

# Backwards compatibility
# We provide a default dir to 'templates' dir
sub _build_default_dir {
    return Path::Tiny->new("$FindBin::RealBin/templates");
}
  
sub run {
    my $self;
    my $replace_tags = ReplaceTags->new( @_ );
    return $replace_tags;
}

# We enable here both HASH ref and list way of providing arguments.
# The arguments are then passed to hash trait attribute "replacements"
# which will consequently be accessible once the object is created.  
around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
        
    if ( scalar @_ == 1 and ref($_[0]) eq 'HASH' ) { #arguments were provided as a HASH ref:
    
        return $class->$orig( replacements => $_[0] );
    }
    elsif (scalar @_ >=2) { #list of "key=>value" pairs (without curly brackets):
    
        my %args = @_;
        return $class->$orig( replacements => \%args );
    }
    else { #something is wrong:
    
        ReplaceTags::Exception::ArgumentMissing->throw("Replacement arguments missing.");
    }          
};

no Moose;
__PACKAGE__->meta->make_immutable;