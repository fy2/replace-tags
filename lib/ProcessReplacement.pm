package ProcessReplacement;
use Moose;
use ReplaceTags::Exception;
use CheckTemplateDir;
use Path::Tiny;

sub run_replacements {
    my ($self, $replace_tags) = @_;
    
    if (not $replace_tags ) {
         ReplaceTags::Exception::ArgumentMissing->throw('You need to provide a ReplaceTags object');
    }
    
    my $check_template_dir = CheckTemplateDir->new(template_dir_path => $replace_tags->template_dir_path
                                                 , suffix            => $replace_tags->suffix);
    
    my $path_tiny = $check_template_dir->validate_directory; 
    my $suffix = $replace_tags->suffix;
    my $replacements_array_ref = $self->_get_tags_and_values($replace_tags); 
     
    foreach my $input_file ( $path_tiny->children( qr/$suffix$/i ) ) {

        my $output_file = Path::Tiny->tempfile( TEMPLATE => "temporaryXXXXXXXX");        
        $self->_replace_tags($replacements_array_ref, $input_file, $output_file);
        
        if ( $replace_tags->backup ) {
            my $bak_filename = $input_file . '.bak';
            
            $input_file->move($bak_filename) or die "Move failed: $!";
            $output_file->move($input_file)   or die "Move failed: $!";

        } else {
            $output_file->move($input_file) or die "Move failed: $!";;    
        }
    }
}

sub _replace_tags {
    my ($self, $replacements, $input_file, $output_file) = @_;
 
    my $in_fh  = $input_file->filehandle('<');
    my $out_fh = $output_file->filehandle('>');
        
    while (<$in_fh>) {
        my $line = $_;
        
        foreach my $replacement (@$replacements) {
            my $tag_regex = $replacement->[0];
            my $value     = $replacement->[1];
            
            $line =~ s/$tag_regex/$value/g;

        }
        print $out_fh $line;
    }
    
    close $in_fh;
    close $out_fh;
    
} 

sub _get_tags_and_values {
    my ($self, $replace_tags) = @_;
    
    my @replacements;
    
    my $special_char = $replace_tags->tag_wrapper; # i.e. '!' char
    
    foreach my $tag ( $replace_tags->keys_in_replacements ) {
        my $value =  $replace_tags->get_replacement_key($tag);
        $tag = $special_char . $tag . $special_char; #flank tag with the default enclosing character (i.e an "!")
        my $qr = qr/$tag/i;
        push @replacements, [$qr, $value];
    }
    
    return \@replacements;
}
                  
no Moose;
__PACKAGE__->meta->make_immutable;


=head1 NAME

ProcessReplacement

=head1 SYNOPSIS

    use ProcessReplacement;
    
    my $processor = ProcessReplacement->new();
    $processor->run_replacements($replace_tags_obj);
     
    
=head1 DESCRIPTION

This module does carry out the actual replacements
according to the parameters of a "ReplaceTags" object.
ReplaceTags object has to be provided to its 
"run_replacements" method as shown above.

=head2 Methods

=over 12

=item C<run_replacements>

This carries out the actual replacements.
It will use the options provided by ReplaceTags obj.

=item C<_get_tags_and_values>

This returns an array of arrays. The arrays contain
individual tag/value pairs where the tag strings are
converted into Regexp objects (using perl's 'qr' operator). 

=item C<_replace_tags>

This uses the array of arrays (mentioned above) on a given
input file in order to replace the tags with values. It writes
its output to another output file. 

=back

=cut