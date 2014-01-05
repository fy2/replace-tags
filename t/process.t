use strict;
use warnings;
use Test::More;
use FindBin;
use Test::Exception;

BEGIN { use_ok("ProcessReplacement"); }


my $regex1 = qr/!expires!/i;
my $regex2 = qr/!title!/i;
my $regex3 = qr/!content!/i;

my $regex_array = [ $regex1, $regex2, $regex3];

my $process = ProcessReplacement->new( regex_array => [ $regex1, $regex2, $regex3 ] );
isa_ok($process, 'ProcessReplacement');

dies_ok { ProcessReplacement->new() } 'Has died as expected when initiated without regex array.';
can_ok($process, 'replace_tags');

throws_ok { $process->replace_tags } 'ReplaceTags::Exception::ArgumentMissing', 'An Exception is thrown when argument is not provided.';

throws_ok { $process->replace_tags('/this/file/does/not/exist') } 'ReplaceTags::Exception::FileDoesNotExist', 'An Exception is thrown when file does not exist.';



done_testing();


__DATA__
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