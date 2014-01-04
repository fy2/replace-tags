package ReplaceTags;
use Moose;
use ReplaceTags::Exception;
use Path::Tiny;
use Data::Dumper;
use FindBin;
use Moose::Util::TypeConstraints;

has '_path_tiny_obj'    => (is => 'rw', isa => 'Path::Tiny');
has 'backup'            => (is => 'rw', isa => 'Bool', default => 0);
has 'suffix'            => (is => 'rw', isa => 'Str', default => '.tpl');
has 'template_dir_path' => (  is => 'rw', isa => 'Str', default => 
                              sub { return "$FindBin::RealBin/templates"; }
                            , trigger => \&_create_path_tiny_object);    

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
    , required => 1
);


sub run {
    my $replacements_href = shift;
    
    #TODO: this should execute the replacements!
    return ReplaceTags->new( replacements => $replacements_href );    
}



sub _create_path_tiny_object {
     my ( $self, $template_dir_path ) = @_;
     $self->_path_tiny_obj( Path::Tiny->new($template_dir_path) );
}

no Moose;
__PACKAGE__->meta->make_immutable;