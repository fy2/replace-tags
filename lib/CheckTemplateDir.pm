package CheckTemplateDir;
use ReplaceTags::Exception;
use Moose;

has 'dir' => (
    is       => 'ro'
  , isa      => 'Path::Tiny'
  , required => 1
  );

has 'suffix' => (
    is       => 'ro'
  , isa      => 'Str'
  , required => 1
  );
  
sub check_directory {
    my $self = shift;
    if (not $self->dir->exists) {
        ReplaceTags::Exception::DirDoesNotExist->throw($self->dir->dirname . ' does not exist!');
    }
    
    my $suffix = $self->suffix;
    if ( scalar $self->dir->children( qr/$suffix$/i )  == 0 ) {
        warn "No files with the '". $self->suffix . "' suffix found. Nothing will be done.";
    }
    
    
}

no Moose;
__PACKAGE__->meta->make_immutable;