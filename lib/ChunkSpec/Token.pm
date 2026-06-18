package ChunkSpec::Token;
use parent 'Parse::Token';

use v5.36;


use constant {
    TYPE_TEXT      => 'text',
    TYPE_STATEMENT => 'statement',
    TYPE_NEWLINE   => 'newline',

    TYPE_COMMENT => 'comment',

    TYPE_ABSTRACT_WORD_PAREN           => 'abstract_word_paren',
    TYPE_ABSTRACT_WORD_FORM_SEPARATOR  => 'abstract_word_form_seperator',
    TYPE_ABSTRACT_WORD_UNION           => 'abstract_word_union',

    TYPE_TOKEN_SEQUENCE_SEPARATOR => 'token_separator',

    TYPE_METADATA           => 'metadata',
    TYPE_METADATA_SEPARATOR => 'metadata_separator',
    TYPE_ASSIGNMENT         => 'assignment',

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

sub is_assignment($self) {
    $self->type() eq TYPE_ASSIGNMENT;
}

sub is_token_sequence_seperator($self) {
    $self->type eq TYPE_TOKEN_SEQUENCE_SEPARATOR;
}

sub is_metadata_separator($self) {
    $self->type eq TYPE_METADATA_SEPARATOR;
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

sub is_abstract_word_form_separator($self) {
    $self->type() eq TYPE_ABSTRACT_WORD_FORM_SEPARATOR;
}

1;
