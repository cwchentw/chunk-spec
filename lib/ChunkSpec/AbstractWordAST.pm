package ChunkSpec::AbstractWordAST;
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

1;
