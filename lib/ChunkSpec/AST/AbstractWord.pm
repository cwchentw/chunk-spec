package ChunkSpec::AST::AbstractWord;
use parent 'ChunkSpec::AST';

use v5.36;


use constant {
    CATEGORY => 'category',
    FORM     => 'form',
};


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD);
    bless $self, $class;
}

sub emit_ir($self) {
    my $word = {};

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_CATEGORY) {
            my $category = $child->emit_ir();

            $word->{+CATEGORY} = $category;
        }

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_FORM) {
            my $form = $child->emit_ir();

            $word->{+FORM} = $form;
        }

        $self->next();
    }

    $self->rewind();

    $word;
}

sub emit_line_number($self) {
    my $line_no = -1;

    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_CATEGORY) {
            $line_no = $child->emit_line_number();
            last;
        }

        if ($child->type() eq ChunkSpec::AST->TYPE_ABSTRACT_WORD_FORM) {
            $line_no = $child->emit_line_number();
            last;
        }

        $self->next();
    }

    $self->rewind();

    $line_no;
}

1;
