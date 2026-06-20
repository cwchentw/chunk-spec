package ChunkSpec::AST::MetadataValue;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_METADATA_VALUE);
    bless $self, $class;
}

sub emit_ir($self) {
    $self->peek()->content();
}

1;
