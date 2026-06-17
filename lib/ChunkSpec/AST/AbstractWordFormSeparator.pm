package ChunkSpec::AST::AbstractWordFormSeparator;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_FORM_SEPARATOR);
    bless $self, $class;
}

1;
