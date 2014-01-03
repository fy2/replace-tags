use strict;
use warnings;

use Test::More;

BEGIN { use_ok("ReplaceTags");  }

my $rt = ReplaceTags->new(
      expires => 'Mon, 31 Dec 2012 12:00:00 GMT'
    , title   => 'Replace Tags'
    , content => 'Hello, World!'
);

isa_ok($rt, 'ReplaceTags');

can_ok($rt, 'run');


done_testing();