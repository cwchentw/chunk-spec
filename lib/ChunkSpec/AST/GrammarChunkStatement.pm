package ChunkSpec::AST::GrammarChunkStatement;
use parent 'ChunkSpec::AST';

use v5.36;


use constant {
    PATTERN => 'pattern',
    LINE    => 'line',
};


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_GRAMMAR_CHUNK_STATEMENT);
    bless $self, $class;
}

sub emit_ir($self) {
    my $chunk = {};

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_TOKEN_SEQUENCE) {
            my $pattern = $child->emit_ir();
            my $line_no = $child->emit_line_number();

            $chunk->{+PATTERN} = $pattern;
            $chunk->{+LINE} = $line_no if ($line_no > 0);
        }

        $self->next();
    }

    $chunk;
}

1;
