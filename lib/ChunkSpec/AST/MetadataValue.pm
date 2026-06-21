package ChunkSpec::AST::MetadataValue;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_METADATA_VALUE);
    bless $self, $class;
}

sub emit_ir($self) {
    my $s = '';

    while ($self->has_next()) {
        my $peek = $self->peek();

        $s .= $peek->emit_ir();

        $self->next();
    }

    $self->rewind();

    $s;
}

1;
