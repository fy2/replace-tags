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


=head1 NAME

CheckTemplateDir

=head1 SYNOPSIS

    use CheckTemplateDir;
    
    my $check = CheckTemplateDir->new( template_dir_path => '/path/to/template/dir'
                                     , suffix => '.tpl');

    my $a_path_tiny_object = $check->validate_directory();
    
=head1 DESCRIPTION

This module is used to validate a directory.
It checks for any errors and if successful,
it will return a Path::Tiny object for the
validated directory.

=head2 Methods

=over 12

=item C<validate_directory>

This validates the directory and returns
a Path::Tiny object if the dir passes
its validation tests.

=back

=cut