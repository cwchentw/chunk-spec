package ChunkSpec::AST::AbstractWordExpression;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_EXPRESSION);
    bless $self, $class;
}

sub emit_ir($self) {
    my $expr = [];

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD) {
            my $word = $child->emit_ir();

            push @{$expr}, $word;
        }

        $self->next();
    }

    $self->rewind();

    $expr;
}

sub emit_line_number($self) {
    my $line_no = -1;

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD) {
            $line_no = $child->emit_line_number();

            last;
        }

        $self->next();
    }

    $self->rewind();

    $line_no;
}

1;
