package ReplaceTags;

use File::Glob;
use Cwd qw/ abs_path /;

my $template_dir;
my @templates;
my $replacements;

sub run {
	$replacements = shift;

	$template_dir = abs_path( __FILE__ );
	$template_dir =~ s#/[^/]*$##;
	$template_dir .= '/../templates';

	process();
}

sub process {
	my @templates = glob( $template_dir . '/*.tpl' );

	for my $template ( @templates ) {

		open FH, "<$template" or die "Cannot open $template";

		my $data = do { local $/; <FH> };

		$data =~ s/!expires!/$replacements->{expires}/ig;
		$data =~ s/!title!/$replacements->{title}/ig;
		$data =~ s/!content!/$replacements->{content}/ig;

		close FH;

		open FH, ">$template" or die "Cannot open $template";
		print FH $data;
		close FH;
	}
}

1;
