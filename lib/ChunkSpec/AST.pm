package ChunkSpec::AST;
use parent 'AST';

use v5.36;


use constant {
    TYPE_COMMENT => 'comment',
    TYPE_NEWLINE => 'newline',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
