package ChunkSpec::AST::CommentStatement;
use parent 'ChunkSpec::AST::Statement';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST::Statement->TYPE_COMMENT_STATEMENT);
    bless $self, $class;
}

1;
