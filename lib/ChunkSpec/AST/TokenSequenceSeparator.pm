package ChunkSpec::AST::TokenSequenceSeparator;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_TOKEN_SEQUENCE_SEPARATOR);
    bless $self, $class;
}

1;
