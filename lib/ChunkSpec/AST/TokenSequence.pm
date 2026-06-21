package ChunkSpec::AST::TokenSequence;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_TOKEN_SEQUENCE);
    bless $self, $class;
}

sub emit_ir($self) {
    my $seq = [];

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_EXPRESSION) {
            my $expr = $child->emit_ir();

            push @{$seq}, $expr;
        }

        if ($child->type() eq ChunkSpec::AST->TYPE_TEXT) {
            my $t = $child->emit_ir();

            push @{$seq}, $t;
        }

        if ($child->type() eq ChunkSpec::AST->TYPE_QUOTED_STRING) {
            my $t = $child->emit_ir();

            push @{$seq}, $t;
        }

        $self->next();
    }

    $self->rewind();

    $seq;
}

sub emit_line_number($self) {
    my $line_no = -1;

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_EXPRESSION) {
            $line_no = $child->emit_line_number();
        }

        if ($child->type() eq ChunkSpec::AST->TYPE_TEXT) {
            $line_no = $child->emit_line_number();
        }

        last;
    }

    $self->rewind();

    $line_no;
}

1;
