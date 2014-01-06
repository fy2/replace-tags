package ReplaceTags;
use Moose;
use ReplaceTags::Exception;
use Path::Tiny;
use Data::Dumper;
use FindBin;

has 'backup'            => (is => 'rw', isa => 'Bool', default => 0);
has 'suffix'            => (is => 'rw', isa => 'Str', default => '.tpl');
has 'template_dir_path' => (  is => 'rw', isa => 'Str', default => 
                              sub { return "$FindBin::RealBin/templates"; } 
                           );
has 'tag_wrapper' => (is => 'rw', isa => 'Str', default => '!');


                            
has 'replacements' => (
      traits => ['Hash']
    , is     => 'rw'
    , isa  => 'HashRef[Str]'
    , default => sub { {} }
    , handles => {
            keys_in_replacements => 'keys'
          , get_replacement_key  => 'get'
          , set_replacement_key  => 'set'
    }
    , required => 1
);

sub run {
    my $replacements_href = shift;
    #TODO: this should execute the replacements!
    return ReplaceTags->new( replacements => $replacements_href );    
}

sub process {
    my ($self) = @_;
    my $processor = ProcessReplacement->new($self);
}


no Moose;
__PACKAGE__->meta->make_immutable;