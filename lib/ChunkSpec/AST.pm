package ChunkSpec::AST;
use parent 'AST';

use v5.36;


use constant {
    TYPE_COMMENT   => 'comment',
    TYPE_NEWLINE   => 'newline',
    TYPE_STATEMENT => 'statement',

    TYPE_ABSTRACT_WORD_EXPRESSION => 'abstract_word_expression',
    TYPE_ABSTRACT_WORD            => 'abstract_word',
    TYPE_ABSTRACT_WORD_PAREN      => 'abstract_word_paren',
    TYPE_ABSTRACT_WORD_CATEGORY   => 'abstract_word_category',
    TYPE_ABSTRACT_WORD_FORM       => 'abstract_word_form',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

1;
