package  ChunkSpec::Parser;
use parent 'Parse::Parser';

use v5.36;
use builtin qw(true false);

use ChunkSpec::AST;
use ChunkSpec::AST::TokenSequence;
use ChunkSpec::AST::Token;
use ChunkSpec::AST::TokenSequenceSeparator;
use ChunkSpec::AST::QuotedString;
use ChunkSpec::AST::AbstractWordExpression;
use ChunkSpec::AST::AbstractWord;
use ChunkSpec::AST::AbstractWordCategory;
use ChunkSpec::AST::AbstractWordForm;
use ChunkSpec::AST::AbstractWordParen;
use ChunkSpec::AST::AbstractWordUnion;
use ChunkSpec::AST::AbstractWordFormSeparator;
use ChunkSpec::AST::Metadata;
use ChunkSpec::AST::MetadataKey;
use ChunkSpec::AST::MetadataValue;
use ChunkSpec::AST::MetadataSeparator;
use ChunkSpec::AST::Assignment;
use ChunkSpec::AST::Comment;
use ChunkSpec::AST::CommentStatement;
use ChunkSpec::AST::GrammarChunkStatement;


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
        elsif ($peek->is_text()) {
            $self->add_ast($self->parse_grammar_chunk_statement($lexer));
        }
        else {
            # Discard anything else.
            $lexer->next();
        }
    }
}

sub parse_comment_statement($self, $lexer) {
    my $stmt = ChunkSpec::AST::CommentStatement->new();

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_comment()) {
            my $comment = ChunkSpec::AST::Comment->new();
            $comment->add_child($peek);

            $stmt->add_child($comment);

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
    my $stmt = ChunkSpec::AST::GrammarChunkStatement->new();

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_abstract_word_left_paren()) {
            my $seq = $self->parse_token_sequence($lexer);

            $stmt->add_child($seq);
        }
        elsif ($peek->is_text()) {
            my $seq = $self->parse_token_sequence($lexer);

            $stmt->add_child($seq);
        }
        elsif ($peek->is_quoted_string()) {
            my $seq = $self->parse_token_sequence($lexer);

            $stmt->add_child($seq);
        }
        elsif ($peek->is_metadata_separator()) {
            my $meta = $self->parse_metadata($lexer);

            $stmt->add_child($meta);
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

sub parse_token_sequence($self, $lexer) {
    my $seq = ChunkSpec::AST::TokenSequence->new();

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_abstract_word_left_paren()) {
            my $expr = $self->parse_abstract_word_expression($lexer);

            $seq->add_child($expr);
        }
        elsif ($peek->is_text()) {
            my $t = ChunkSpec::AST::Token->new();
            $t->add_child($peek);

            $seq->add_child($t);

            $lexer->next();
        }
        elsif ($peek->is_quoted_string()) {
            my $t = ChunkSpec::AST::QuotedString->new();
            $t->add_child($peek);

            $seq->add_child($t);

            $lexer->next();
        }
        elsif ($peek->is_token_sequence_seperator()) {
            my $sep = ChunkSpec::AST::TokenSequenceSeparator->new();
            $sep->add_child($peek);

            $seq->add_child($sep);

            $lexer->next();
        }
        elsif ($peek->is_metadata_separator()) {
            last;
        }
        else {
            last;
        }
    }

    $seq;
}

sub parse_abstract_word_expression($self, $lexer) {
    my $expr = ChunkSpec::AST::AbstractWordExpression->new();

    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        if ($peek->is_abstract_word_left_paren()) {
            my $paren = ChunkSpec::AST::AbstractWordParen->new();
            $paren->add_child($peek);

            $expr->add_child($paren);

            $lexer->next();
        }
        elsif ($peek->is_abstract_word_right_paren()) {
            my $paren = ChunkSpec::AST::AbstractWordParen->new();
            $paren->add_child($peek);

            $expr->add_child($paren);

            $lexer->next();
            last;
        }
        elsif ($peek->is_text()) {
            my $word = $self->parse_abstract_word($lexer);

            $expr->add_child($word);
        }
        elsif ($peek->is_abstract_word_union()) {
            my $union = ChunkSpec::AST::AbstractWordUnion->new();
            $union->add_child($peek);

            $expr->add_child($union);

            $lexer->next();
        }
        else {
            $self->parse_grammar_chunk_statement($lexer);
        }
    }

    $expr;
}

sub parse_abstract_word($self, $lexer) {
    my $word = ChunkSpec::AST::AbstractWord->new();

    my $peek;
    my $has_form = false;
    my $category;
    my $sep;
    my $form;
    while ($lexer->has_next()) {
        $peek = $lexer->peek();

        if ($peek->is_abstract_word_form_separator()) {
            $sep = ChunkSpec::AST::AbstractWordFormSeparator->new() if (not defined($sep));
            $sep->add_child($peek);

            $has_form = true;

            $lexer->next();
            next;
        }

        if ($peek->is_text() or $peek->is_quote_literal()) {
            if ($has_form) {
                $form = ChunkSpec::AST::AbstractWordForm->new() if (not defined($form));
                $form->add_child($peek);
            }
            else {
                $category = ChunkSpec::AST::AbstractWordCategory->new() if (not defined($category));
                $category->add_child($peek);
            }

            $lexer->next();
            next;
        }

        last;
    }

    $word->add_child($category) if ($category);
    $word->add_child($sep) if ($sep);
    $word->add_child($form) if ($form);

    $word;
}

sub parse_metadata($self, $lexer) {
    my $meta = ChunkSpec::AST::Metadata->new();

    my $peek;
    my $has_metadata = false;
    my $has_assignment = false;
    my $metadata_separator;
    my $assignment;
    my $key;
    my $value;
    while ($lexer->has_next()) {
        $peek = $lexer->peek();

        if ($peek->is_metadata_separator()) {
            last if ($has_metadata);

            my $sep = ChunkSpec::AST::MetadataSeparator->new();
            $sep->add_child($peek);
            $metadata_separator = $sep;

            $has_metadata = true;

            $lexer->next();
            next;
        }

        if ($peek->is_assignment()) {
            my $a = ChunkSpec::AST::Assignment->new();
            $a->add_child($peek);

            $assignment = $a;

            $has_assignment = true;

            $lexer->next();
            next;
        }

        if ($peek->is_text() or $peek->is_quote_literal() or $peek->is_quoted_string()) {
            if ($has_assignment) {
                $value = ChunkSpec::AST::MetadataValue->new() if (not defined($value));
                $value->add_child($peek);
            }
            else {
                $key = ChunkSpec::AST::MetadataKey->new() if (not defined($key));
                $key->add_child($peek);
            }

            $lexer->next();
            next;
        }

        last;
    }

    $meta->add_child($metadata_separator) if ($metadata_separator);
    $meta->add_child($key) if ($key);
    $meta->add_child($assignment) if ($assignment);
    $meta->add_child($value) if ($value);

    $meta;
}

1;
