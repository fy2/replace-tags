use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin;
use Path::Tiny;

BEGIN { use_ok("ReplaceTags"); }

my %replacements = (
      expires => 'Mon, 31 Dec 2012 12:00:00 GMT'
    , title   => 'Replace Tags'
    , content => 'Hello, World!'
);

# Run the object oriented "new" method without brackets in arguments:
my $rt = ReplaceTags->new( 
      replacements => \%replacements
    , suffix       => '.tpl'
    , template_dir_path => "$FindBin::RealBin/templates"
    , backup => 0
);

isa_ok($rt, 'ReplaceTags');

can_ok($rt, 'run');

is_deeply( [sort $rt->keys_in_replacements], [ qw(content expires title) ], 'All keys are received.');

is($rt->get_replacement_key('title'), 'Replace Tags', "The 'title' key has the correct value.");

# template dir defaults to the dir where the current script runs, i.e.:
is($rt->template_dir_path, "$FindBin::RealBin/templates", 'Path::Tiny path is correct.');

# It should die if we forget to provide replacement hash argument:
dies_ok { ReplaceTags::run() } 'Has died as expected.';

# This should work fine:
lives_ok( sub {  ReplaceTags::run(\%replacements) }, 'Expecting to live in non OOP call' );
#Restore
my $input_file  = Path::Tiny->new("$FindBin::RealBin/templates/home.tpl");
$input_file->spew( get_original_string() );

lives_ok( sub {  $rt->run() }, 'Expecting to live in OOP call' );
#Restore
$input_file->spew( get_original_string() );

#Call in an object oriented way

done_testing();


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