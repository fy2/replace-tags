use strict;
use warnings;
use Test::More;
use Test::Exception;
BEGIN { use_ok('Replacement'); }

my $replacement = Replacement->new( tag => '!expires!'
                                  , value   => 'Mon, 31 Dec 2012 12:00:00 GMT');

isa_ok($replacement, 'Replacement');
dies_ok { Replacement->new() } 'Dies as expected (needs arguments).';

is($replacement->tag, '!expires!', 'Received template_str');
is($replacement->value, 'Mon, 31 Dec 2012 12:00:00 GMT', 'Received target_str');

can_ok($replacement, '_make_quoted_regex');

is(ref($replacement->quoted_regex), 'Regexp', 'quoted_regex returns a "Regexp" reference');

is($replacement->quoted_regex, qr/!expires!/i, 'quoted regex is correct i.e. "(?^i:!expires!)"');

done_testing();