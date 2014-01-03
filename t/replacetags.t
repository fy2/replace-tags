use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin;

BEGIN { use_ok("ReplaceTags"); }


# Run the object oriented "new" method without brackets in arguments:
my $rt = ReplaceTags->new( 
      expires => 'Mon, 31 Dec 2012 12:00:00 GMT'
    , title   => 'Replace Tags'
    , content => 'Hello, World!'
);
isa_ok($rt, 'ReplaceTags');

# should throw an exception if we forget to provide arguments:
throws_ok { ReplaceTags::run()  } 'ReplaceTags::Exception::ArgumentMissing', 'ReplaceTags::Exception::ArgumentMissing has been thrown.';

can_ok($rt, 'run');

is_deeply( [sort $rt->keys_in_replacements], [ qw(content expires title) ], 'All keys are received.');

is($rt->get_replacement_key('title'), 'Replace Tags', "The 'title' key has the correct value.");

is( ref($rt->template_dir), 'Path::Tiny', 'Path::Tiny object is received.');


my $default_path = $rt->template_dir;
# template dir defaults to the dir where the current script runs, i.e.:
is($default_path, "$FindBin::RealBin/templates", 'Path::Tiny path is correct.');

#let's change the dirname into "data":
$rt->template_dir( Path::Tiny->new("$FindBin::RealBin/data") );

is($rt->template_dir, "$FindBin::RealBin/data", 'Path::Tiny path is revised correctly.');


done_testing();