use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Differences;
use FindBin;
use Replacement;
use ReplaceTags;

BEGIN { use_ok("ProcessReplacement"); }



my $process = ProcessReplacement->new();
isa_ok($process, 'ProcessReplacement');

can_ok($process, 'run_replacements');

throws_ok { $process->run_replacements } 'ReplaceTags::Exception::ArgumentMissing', 'Exception is raised if a ReplaceTags object is not provided.';


my %replacements = ( expires => 'Mon, 31 Dec 2012 12:00:00 GMT'
                   , title   => 'Replace Tags'
                   , content => 'Hello, World!');
                   
my $replace_tags = ReplaceTags->new( replacements => \%replacements
                                   , suffix => '.tpl'
                                   , template_dir_path => "$FindBin::RealBin/data"
                                   , tag_wrapper => '!'
                                   , backup => 0 );

#carry out the actual replacements:
$process->run_replacements($replace_tags); 


open my $fh, "$FindBin::RealBin/data/home.tpl" or die "cannot open file $!";
my $replaced_string;
while(<$fh>) {
    $replaced_string .= $_;
}
close $fh;

my $expected_string = get_expected_string();

eq_or_diff $replaced_string, $expected_string, "Testing if replacements went well";

revert_replacements("$FindBin::RealBin/data/home.tpl");

done_testing();


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

sub revert_replacements {
    my $file = shift;
    open my $fhandle, ">$file" or die $!;
    print $fhandle  get_original_string();
    close $fhandle;
}