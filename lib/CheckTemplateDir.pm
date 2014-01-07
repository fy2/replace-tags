package CheckTemplateDir;
use ReplaceTags::Exception;
use MooseX::StrictConstructor;
use Moose;

has 'template_dir_path' => (
    is       => 'ro'
  , isa      => 'Str'
  , required => 1
  );

has 'suffix' => (
    is       => 'ro'
  , isa      => 'Str'
  , required => 1
  );
  
sub validate_directory {
    
    my $self = shift;
    
    my $path_tiny_dir = Path::Tiny->new( $self->template_dir_path );
    
    if (not $path_tiny_dir->exists) {
        ReplaceTags::Exception::DirDoesNotExist->throw($path_tiny_dir->stringify . ' does not exist!');
    }

    my $suffix = $self->suffix;
    if ( scalar $path_tiny_dir->children( qr/$suffix$/i )  == 0 ) {
        warn "No files with the '". $self->suffix . "' suffix found. Nothing will be done.";
    }
    
    return $path_tiny_dir;
}

no Moose;
__PACKAGE__->meta->make_immutable;