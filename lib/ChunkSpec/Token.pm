package ChunkSpec::Token;
use parent 'Token';

use v5.36;


use constant {
    TYPE_UNKNOWN             => 'unknown',
    TYPE_COMMENT             => 'comment',
    TYPE_TEXT                => 'text',
    TYPE_NEWLINE             => 'newline',
    TYPE_STATEMENT           => 'statement',
    TYPE_ABSTRACT_WORD_PAREN => 'abstract_word_paren',
    TYPE_ABSTRACT_WORD_FORM  => 'abstract_word_form',
    TYPE_TOKEN_SEPARATOR     => 'token_separator',
    TYPE_METADATA            => 'metadata',
    TYPE_ASSIGNMENT          => 'assignment',
    TYPE_COMPILER_DIRECTIVE  => 'compiler_directive',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
