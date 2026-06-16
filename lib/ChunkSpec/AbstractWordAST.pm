package ChunkSpec::AbstractWordAST;
use parent 'ChunkSpec::AST';

use v5.36;

use constant {
    CATEGORY => 'category',
    FORM     => 'form',
};

sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
