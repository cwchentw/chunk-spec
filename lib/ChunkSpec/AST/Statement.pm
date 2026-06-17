package ChunkSpec::AST::Statement;
use parent 'Parse::AST';

use v5.36;

use constant {
    TYPE_COMMENT_STATEMENT       => 'comment_statement',
    TYPE_GRAMMAR_CHUNK_STATEMENT => 'grammar_chunk_statement',
};

sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
