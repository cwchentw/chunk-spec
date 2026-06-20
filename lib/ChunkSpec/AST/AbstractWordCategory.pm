package ChunkSpec::AST::AbstractWordCategory;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_CATEGORY);
    bless $self, $class;
}

sub emit_ir($self) {
    my $s = '';

    while ($self->has_next()) {
        my $peek = $self->peek();

        $s .= $peek->content();

        $self->next();
    }

    $self->rewind();

    $s;
}

sub emit_line_number($self) {
    $self->peek()->line_number();
}

1;
