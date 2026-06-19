package ChunkSpec::IR;

use v5.36;

use ChunkSpec::AST;


sub new($class) {
    my $self = {};
    bless $self, $class;
}

sub emit($self, $parser) {
    my $ir = [];

    while ($parser->has_next()) {
        my $ast = $parser->peek();

        if ($ast->type() eq ChunkSpec::AST->TYPE_GRAMMAR_CHUNK_STATEMENT) {
            my $chunk = $ast->emit_ir();

            push @{$ir}, $chunk;
        }

        $parser->next();
    }

    $ir;
}

1;
