use strict;
use warnings;
use Test::More;
use Test::Warn;
use Test::Exception;
use Path::Tiny;
use FindBin;

BEGIN { use_ok("CheckTemplateDir"); }

my $check = CheckTemplateDir->new( dir    => Path::Tiny->new("$FindBin::RealBin/data"),
                                 , suffix => '.tpl'
                                 );  
isa_ok($check, 'CheckTemplateDir');
can_ok($check, 'check_directory');

# a non existing directory:
$check = CheckTemplateDir->new( dir    => Path::Tiny->new('A/Non/Existing/Dir'),
                              , suffix => '.tpl'
                              );
throws_ok { $check->check_directory } 'ReplaceTags::Exception::DirDoesNotExist', 'An Exception is thrown when target directory does not exist.';


# an existing directory with no files that match a given suffix:
$check = CheckTemplateDir->new( dir    => Path::Tiny->new("$FindBin::RealBin/data"),
                              , suffix => '.ABSENT'
                              );

warning_is { $check->check_directory  } "No files with the '.ABSENT' suffix found. Nothing will be done.", 'When no matching files found, we get a warning.';

# an existing directory with matching files:
$check = CheckTemplateDir->new( dir    => Path::Tiny->new("$FindBin::RealBin/data"),
                              , suffix => '.tpl'
                              );
warnings_are { $check->check_directory } [], "no warnings when there are matching files.";

done_testing();