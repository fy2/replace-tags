use strict;
use warnings;
use Test::More;
use FindBin;

BEGIN { use_ok("ProcessReplacement"); }



my $process = ProcessReplacement->new(   template_file => "$FindBin::RealBin/data/home.tpl"
                                       , regex        => "bla"     
                                       , backup       => 1 
                                     );


done_testing();
