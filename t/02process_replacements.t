use strict;
use warnings;
use Test::More  tests => 9;
use Test::Exception;
use Test::Differences;
use Test::MockObject;
use Data::Dumper;
use FindBin;
use ReplaceTags;

BEGIN { use_ok("ProcessReplacement"); }



my $process = ProcessReplacement->new();
isa_ok($process, 'ProcessReplacement');
can_ok($process, 'run_replacements');
can_ok($process, '_get_tags_and_values');


##################################
# Testing: '_get_tags_and_values'#
##################################
my $mock_replace_tags_obj = Test::MockObject->new();
$mock_replace_tags_obj->mock( 'keys_in_replacements' => sub { return sort qw(content expires title) });
$mock_replace_tags_obj->mock( 'backup'               => sub { return 0; });
$mock_replace_tags_obj->mock( 'template_dir_path'    => sub { return "$FindBin::RealBin/data"; });
$mock_replace_tags_obj->mock( 'suffix'               => sub { return '.tpl'; });
$mock_replace_tags_obj->mock( 'tag_wrapper'          => sub { return '!'} );
$mock_replace_tags_obj->mock( 'get_replacement_key'  => sub {
    my ($mock, $tag) = @_;
    my %replacement = ('expires' => 'Mon, 31 Dec 2012 12:00:00 GMT'
                      , 'title'   => 'Replace Tags'
                      , 'content' => 'Hello, World!');                       
    return $replacement{$tag};  
});
my $expected_array_ref = [ [qr/!content!/i, 'Hello, World!']
                         , [qr/!expires!/i, 'Mon, 31 Dec 2012 12:00:00 GMT']
                         , [qr/!title!/i, 'Replace Tags'] 
                         ];
                          
eq_or_diff $process->_get_tags_and_values($mock_replace_tags_obj)
         , $expected_array_ref
         , 'Tags are Correctly quoted + turned into regexps and stored in array of arrays';


###########################
# Testing: '_replace_tags'#
###########################
my $input_file  = Path::Tiny->new("$FindBin::RealBin/data/home.tpl");
my $output_file = Path::Tiny->tempfile( TEMPLATE => "temporaryXXXXXXXX");
$process->_replace_tags($expected_array_ref, $input_file, $output_file);

eq_or_diff $output_file->slurp, get_expected_string(), "Testing if replacements went well";


##############################
# Testing: 'run_replacements'#
##############################
throws_ok { $process->run_replacements } 'ReplaceTags::Exception::ArgumentMissing', 'Exception is raised if a ReplaceTags object is not provided.';
$process->run_replacements($mock_replace_tags_obj);

# As "backup => 0", input file will have been modified by "run_replacement".
eq_or_diff $input_file->slurp, get_expected_string(), "Testing if replacements went well";

# Restore input file (write the tags back)
$input_file->spew( get_original_string() );


##################################################
# Testing: 'run_replacements' with backup enabled#
##################################################

my $bak_filename = $input_file . '.bak';
my $bak_file =Path::Tiny->new($bak_filename);
$bak_file->remove;

$mock_replace_tags_obj->mock( 'backup' => sub { return 1; } );
$process->run_replacements($mock_replace_tags_obj);
is ( Path::Tiny->new($bak_file)->is_file, 1, 'Backup file was created.');

# Restore test data file dir
$bak_file->remove;
$input_file->spew( get_original_string() );






sub get_expected_string {
    return <<END;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html>
   <head>
      <title>Replace Tags</title>
      <meta HTTP-EQUIV="expires" CONTENT="Mon, 31 Dec 2012 12:00:00 GMT">
   </head>
   <body>
      <p>Hello, World!</p>
   </body>
</html>
END
}

sub get_original_string {
 return <<END;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html>
   <head>
      <title>!title!</title>
      <meta HTTP-EQUIV="expires" CONTENT="!expires!">
   </head>
   <body>
      <p>!content!</p>
   </body>
</html>
END
}