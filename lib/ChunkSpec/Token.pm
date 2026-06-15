package ChunkSpec::Token;
use parent 'Token';

use v5.36;


use constant {
    TYPE_COMMENT             => 'comment',
    TYPE_TEXT                => 'text',
    TYPE_SPACE               => 'space',
    TYPE_NEWLINE             => 'newline',
    TYPE_STATEMENT           => 'statement',
    TYPE_ABSTRACT_WORD_PAREN => 'abstract_word_paren',
    TYPE_TOKEN_SEPARATOR     => 'token_separator',
    TYPE_METADATA            => 'metadata',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
