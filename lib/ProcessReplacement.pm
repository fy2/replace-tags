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
    
    my $check_template_dir = CheckTemplateDir->new(
                                                     template_dir_path => $replace_tags->template_dir_path
                                                   , suffix            => $replace_tags->suffix );
    
    my $path_tiny = $check_template_dir->validate_directory; 
    
    my $suffix = $replace_tags->suffix;
    
    my $replacements_array_ref = _get_replacements($replace_tags); 
     
    foreach my $original_file ( $path_tiny->children( qr/$suffix$/i ) ) {

        #my $destination_file = _create_destination_file($original_file);
        my $destination_file = Path::Tiny->tempfile( TEMPLATE => "temporaryXXXXXXXX");
        
        _replace_tags_in_file($replacements_array_ref, $original_file, $destination_file);
        
        if ( $replace_tags->backup ) {
            $original_file->move($original_file . '.bak') or die "Move failed: $!";;
            $destination_file->move($original_file) or die "Move failed: $!";;
        } else {
            $destination_file->move($original_file) or die "Move failed: $!";;    
        }
    }
}

sub _create_destination_file {
    my ($original_file) = @_;

    my $destination_file_tiny = Path::Tiny->new($original_file .'.bak');
    
    if ( $destination_file_tiny->exists ) {
        ReplaceTags::Exception::FileAlreadyExists->throw($destination_file_tiny->stringify . ' already exists!');
    }

    return $destination_file_tiny;
}


sub _replace_tags_in_file {
    my ($replacements, $original_file, $destination_file) = @_;
 
    my $original_fh    = $original_file->filehandle('<');
    my $destination_fh = $destination_file->filehandle('>');
        
    while (<$original_fh>) {
        my $line = $_;
        
        foreach my $replacement (@$replacements) {
            my $tag_regex = $replacement->quoted_regex;
            my $value     = $replacement->value;
            
            $line =~ s/$tag_regex/$value/g;

        }
        print $destination_fh $line;
    }
    
    close $original_fh;
    close $destination_fh;
    
} 

sub _get_replacements {
    my $replace_tags = shift;
    
    my @replacements;
    
    my $special_char = $replace_tags->tag_wrapper; # i.e. '!' char
    
    foreach my $tag ( $replace_tags->keys_in_replacements ) {
        my $value =  $replace_tags->get_replacement_key($tag);
        my $replacement = Replacement->new(tag => $special_char. $tag . $special_char
                                         , value => $value);
        push @replacements, $replacement;
    }
    
    return \@replacements;
}
                  
no Moose;
__PACKAGE__->meta->make_immutable;
