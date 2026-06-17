package  ChunkSpec::Parser;
use parent 'Parse::Parser';

use v5.36;

use ChunkSpec::AST;
use ChunkSpec::AST::AbstractWord;
use ChunkSpec::AST::AbstractWordCategory;
use ChunkSpec::AST::AbstractWordForm;
use ChunkSpec::AST::Statement;
use ChunkSpec::AST::GrammarChunk;


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
        elsif ($peek->is_abstract_word_left_paren()) {
            $self->add_ast($self->parse_grammar_chunk_statement($lexer));
        }
        else {
            # Discard anything else.
            $lexer->next();
        }
    }
}

sub parse_comment_statement($self, $lexer) {
    my $stmt = ChunkSpec::AST::Statement->new();
    $stmt->set_type(ChunkSpec::AST::Statement->TYPE_COMMENT_STATEMENT);

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
            # Discard it.
            $lexer->next();
            last;
        }
        else {
            $self->parse($lexer);
        }
    }

    $stmt;
}

sub parse_grammar_chunk_statement($self, $lexer) {
    my $stmt = ChunkSpec::AST::GrammarChunk->new();

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_abstract_word_left_paren()) {
            my $expr = $self->parse_abstract_word_expression($lexer);

            $stmt->add_child($expr);
        }
        elsif ($peek->is_newline()) {
            # Discard newline.
            $lexer->next();
        }
        elsif ($peek->is_statement()) {
            my $ast = ChunkSpec::AST->new();
            $ast->set_type(ChunkSpec::AST->TYPE_STATEMENT);
            $ast->add_child($peek);

            $stmt->add_child($ast);

            $lexer->next();
            last;
        }
        else {
            # Discard anything else.
            $lexer->next();
        }
    }

    $stmt;
}

sub parse_abstract_word_expression($self, $lexer) {
    my $expr = ChunkSpec::AST->new();
    $expr->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_EXPRESSION);

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_abstract_word_left_paren()) {
            my $ast = ChunkSpec::AST->new();
            $ast->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_PAREN);
            $ast->add_child($peek);

            $expr->add_child($ast);

            $lexer->next();
        }
        elsif ($peek->is_text()) {
            my $word = $self->parse_abstract_word($lexer);

            $expr->add_child($word);
        }
        elsif ($peek->is_abstract_word_union()) {
            # Discard it.
            $lexer->next();
        }
        elsif ($peek->is_abstract_word_right_paren()) {
            # Discard it.
            $lexer->next();

            last;
        }
        else {
            $self->parse_grammar_chunk_statement($lexer);
        }
    }

    $expr;
}

sub parse_abstract_word($self, $lexer) {
    my $word = ChunkSpec::AST::AbstractWord->new();

    my $peek = $lexer->peek();

    if ($peek->is_text()) {
        my $category = ChunkSpec::AST::AbstractWordCategory->new();
        $category->add_child($peek);

        $word->add_child($category);

        $lexer->next();
        $peek = $lexer->peek();

        if ($peek->is_abstract_word_form()) {
            # Discard it.
            $lexer->next();

            $peek = $lexer->peek();

            if ($peek->is_text()) {
                my $form = ChunkSpec::AST::AbstractWordForm->new();
                $form->add_child($peek);

                $word->add_child($form);

                $lexer->next();
            }
        }
    }

    $word;
}

1;
