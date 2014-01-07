use strict;
use warnings;
use Test::More;
use Test::Warn;
use Test::Exception;
use Path::Tiny;
use FindBin;

BEGIN { use_ok("CheckTemplateDir"); }

my $check = CheckTemplateDir->new( template_dir_path => "$FindBin::RealBin/templates", suffix => '.tpl');

isa_ok($check, 'CheckTemplateDir');
can_ok($check, 'validate_directory');

# a non existing directory:
$check = CheckTemplateDir->new( template_dir_path => 'A/Non/Existing/Dir', suffix => '.tpl');
                              
throws_ok { $check->validate_directory } 'ReplaceTags::Exception::DirDoesNotExist', 'An Exception is thrown when target directory does not exist.';

# an existing directory with no files that match a given suffix:
$check = CheckTemplateDir->new( template_dir_path => "$FindBin::RealBin/templates", suffix => '.ABSENT');

warning_is { $check->validate_directory  } "No files with the '.ABSENT' suffix found. Nothing will be done.", 'When no matching files found, we get a warning.';

# an existing directory with matching files:
$check = CheckTemplateDir->new( template_dir_path => "$FindBin::RealBin/templates", suffix => '.tpl');

warnings_are { $check->validate_directory } [], "No warnings issued when matching files found.";

is(ref ($check->validate_directory), 'Path::Tiny', 'validate_directory() returned a Path::Tiny object for the validated dir');

done_testing();