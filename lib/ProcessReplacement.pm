package ProcessReplacement;
use Moose;
use ReplaceTags::Exception;

has 'regex_array' => (is => 'rw', isa => 'ArrayRef[Regexp]', required => 1);

sub replace_tags {
    my ($self, $file) = @_;
    if ( not defined($file) ) {
        ReplaceTags::Exception::ArgumentMissing->throw('You need to provide a file argument to replace_tags()');
    }
    
    open my $fh, '<', $file or ReplaceTags::Exception::FileDoesNotExist->throw("File ($file) does not exist.");
    
    
}

no Moose;
__PACKAGE__->meta->make_immutable;
