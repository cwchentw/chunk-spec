package ChunkSpec::Token;
use parent 'Parse::Token';

use v5.36;


use constant {
    TYPE_UNKNOWN             => 'unknown',
    TYPE_COMMENT             => 'comment',
    TYPE_TEXT                => 'text',
    TYPE_NEWLINE             => 'newline',
    TYPE_STATEMENT           => 'statement',
    TYPE_ABSTRACT_WORD_PAREN => 'abstract_word_paren',
    TYPE_ABSTRACT_WORD_FORM  => 'abstract_word_form',
    TYPE_ABSTRACT_WORD_UNION => 'abstract_word_union',
    TYPE_TOKEN_SEPARATOR     => 'token_separator',
    TYPE_METADATA            => 'metadata',
    TYPE_ASSIGNMENT          => 'assignment',
    TYPE_COMPILER_DIRECTIVE  => 'compiler_directive',
};


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

sub is_comment($self) {
    $self->type() eq TYPE_COMMENT;
}

sub is_text($self) {
    $self->type() eq TYPE_TEXT;
}

sub is_newline($self) {
    $self->type() eq TYPE_NEWLINE;
}

sub is_statement($self) {
    $self->type() eq TYPE_STATEMENT;
}

sub is_abstract_word_left_paren($self) {
    $self->type() eq TYPE_ABSTRACT_WORD_PAREN
        and $self->content() eq '<';
}

sub is_abstract_word_right_paren($self) {
    $self->type() eq TYPE_ABSTRACT_WORD_PAREN
        and $self->content() eq '>';
}

sub is_abstract_word_union($self) {
    $self->type() eq TYPE_ABSTRACT_WORD_UNION;
}

sub is_abstract_word_form($self) {
    $self->type() eq TYPE_ABSTRACT_WORD_FORM;
}

1;
