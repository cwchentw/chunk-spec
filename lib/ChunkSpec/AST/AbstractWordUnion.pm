package ChunkSpec::AST::AbstractWordUnion;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_ABSTRACT_WORD_UNION);
    bless $self, $class;
}

1;
