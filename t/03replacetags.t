use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin;

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
    , keep_originals => 0
);

isa_ok($rt, 'ReplaceTags');

can_ok($rt, 'run');

# It should die if we forget to provide replacement hash argument:
dies_ok { ReplaceTags::run() } 'Has died as expected.';

is_deeply( [sort $rt->keys_in_replacements], [ qw(content expires title) ], 'All keys are received.');

is($rt->get_replacement_key('title'), 'Replace Tags', "The 'title' key has the correct value.");

# template dir defaults to the dir where the current script runs, i.e.:
is($rt->template_dir_path, "$FindBin::RealBin/templates", 'Path::Tiny path is correct.');

#let's change the dirname into "data":
$rt->template_dir_path( "$FindBin::RealBin/data" );

#is( $rt->_path_tiny_obj->stringify, "$FindBin::RealBin/data", 'Path::Tiny path is revised correctly.');


done_testing();