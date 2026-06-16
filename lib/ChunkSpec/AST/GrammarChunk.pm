package ChunkSpec::AST::GrammarChunk;
use parent 'ChunkSpec::AST::Statement';

use v5.36;


use constant {
    PATTERN => 'pattern',
};


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST::Statement->TYPE_GRAMMAR_CHUNK_STATEMENT);
    $self->{PATTERN} = [];
    bless $self, $class;
}

sub pattern ($self) {
    $self->{PATTERN};
}

sub add_pattern($self, $p) {
    push @{$self->{PATTERN}}, $p;
}

1;
