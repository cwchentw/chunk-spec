package ChunkSpec::AST;
use parent 'Parse::AST';

use v5.36;


use constant {
    TYPE_STATEMENT  => 'statement',
    TYPE_NEWLINE    => 'newline',
    TYPE_ASSIGNMENT => 'assignment',

    TYPE_COMMENT        => 'comment',
    TYPE_TOKEN_SEQUENCE => 'token_sequence',
    TYPE_METADATA       => 'metadata',

    TYPE_ABSTRACT_WORD_EXPRESSION     => 'abstract_word_expression',
    TYPE_ABSTRACT_WORD                => 'abstract_word',
    TYPE_ABSTRACT_WORD_CATEGORY       => 'abstract_word_category',
    TYPE_ABSTRACT_WORD_FORM           => 'abstract_word_form',
    TYPE_ABSTRACT_WORD_PAREN          => 'abstract_word_paren',
    TYPE_ABSTRACT_WORD_UNION          => 'abstract_word_union',
    TYPE_ABSTRACT_WORD_FORM_SEPARATOR => 'abstract_word_form_separator',

    TYPE_TOKEN_SEQUENCE_SEPARATOR => 'token_sequence_separator',
    TYPE_TOKEN                    => 'token',

    TYPE_METADATA_SEPARATOR => 'metadata_separator',
    TYPE_METADATA_KEY       => 'metadata_key',
    TYPE_METADATA_VALUE     => 'metadata_value',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
