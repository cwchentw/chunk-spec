package ChunkSpec::AST::GrammarChunkStatement;
use parent 'ChunkSpec::AST::Statement';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST::Statement->TYPE_GRAMMAR_CHUNK_STATEMENT);
    bless $self, $class;
}

1;
