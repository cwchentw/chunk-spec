package ChunkSpec::AST::Metadata;
use parent 'ChunkSpec::AST';

use v5.36;
use builtin qw(true false);


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_METADATA);
    bless $self, $class;
}

sub emit_ir($self) {
    my $metadata = {};

    my $has_metadata = false;
    my $key;
    my $value;
    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_METADATA_KEY) {
            $key = $child->emit_ir();
            $metadata->{$key} = undef;
        }
        elsif ($child->type() eq ChunkSpec::AST->TYPE_METADATA_VALUE) {
            $value = $child->emit_ir();
            $metadata->{$key} = $value;
        }

        $self->next();
    }

    $self->rewind();

    $metadata;
}

1;
