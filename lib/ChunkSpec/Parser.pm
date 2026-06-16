package  ChunkSpec::Parser;
use parent 'Parser';

use v5.36;

use ChunkSpec::StatementAST;
use ChunkSpec::AST;

sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

sub parse($self, $lexer) {
    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_comment()) {
            $self->add_ast($self->parse_comment_statement($lexer));
        }
        else {
            # Discard anything else.
            $lexer->next();
        }
    }
}

sub parse_comment_statement($self, $lexer) {
    my $stmt = ChunkSpec::StatementAST->new();
    $stmt->set_type(ChunkSpec::StatementAST->TYPE_COMMENT_STATEMENT);

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_comment()) {
            my $ast = ChunkSpec::AST->new();        
            $ast->set_type(ChunkSpec::AST->TYPE_COMMENT);
            $ast->add_child($peek);

            $stmt->add_child($ast);

            $lexer->next();
        }
        elsif ($peek->is_newline()) {
            my $ast = ChunkSpec::AST->new();
            $ast->set_type(ChunkSpec::AST->TYPE_NEWLINE);
            $ast->add_child($peek);

            $stmt->add_child($ast);

            $lexer->next();
            last;
        }
        else {
            $self->parse($lexer);
        }
    }

    $stmt;
}

1;
