package ChunkSpec::Lexer;
use parent 'Parse::Lexer';

use v5.36;

use ChunkSpec::Token;


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

sub lex($self, $s, $l) {
    my $i = 0;
    my $len = length($s);

    while ($i < $len) {
        my $peek = substr($s, $i, 1);
        my $j = $i;

        if (is_comment($peek)) {
            my $t = ChunkSpec::Token->new();

            while ($j < $len && !is_newline(substr($s, $j, 1))) {
                $j++;
            }

            $t->set_type(ChunkSpec::Token->TYPE_COMMENT);
            $t->set_content(substr($s, $i, $j - $i));

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_abstract_word_paren($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_ABSTRACT_WORD_PAREN);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_abstract_word_form($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_ABSTRACT_WORD_FORM);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_abstract_word_union($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_ABSTRACT_WORD_UNION);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_token_seperator($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_TOKEN_SEPARATOR);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_metadata($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_METADATA);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_assignment($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_ASSIGNMENT);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_newline($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_NEWLINE);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_statement($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_STATEMENT);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_compiler_directive($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_COMPILER_DIRECTIVE);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_text($peek)) {
            my $t = ChunkSpec::Token->new();

            while ($j < $len && is_text(substr($s, $j, 1))) {
                $j++;
            }

            $t->set_type(ChunkSpec::Token->TYPE_TEXT);
            $t->set_content(substr($s, $i, $j - $i));

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_unknown($peek)) {
            my $t = ChunkSpec::Token->new();

            while ($j < $len && is_unknown(substr($s, $j, 1))) {
                $j++;
            }

            $t->set_type(ChunkSpec::Token->TYPE_UNKNOWN);
            $t->set_content(substr($s, $i, $j - $i));

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $self->add_token($t);

            $i = $j;
        }
        else {
            # Edge cases.
            # Discard them if any.
            $j++;
            $i = $j;
        }
    }
}

sub is_comment($s) {
    $s eq '#';
}

sub is_newline($s) {
    $s eq "\n";
}

sub is_statement($s) {
    $s eq ';';
}

sub is_abstract_word_paren($s) {
    $s eq '<' or $s eq '>';
}

sub is_abstract_word_form($s) {
    $s eq ':';
}

sub is_abstract_word_union($s) {
    $s eq '|';
}

sub is_token_seperator($s) {
    $s eq ',';
}

sub is_metadata($s) {
    $s eq '&';
}

sub is_assignment($s) {
    $s eq '=';
}

sub is_compiler_directive($s) {
    $s eq '@';
}

sub is_text($s) {
    $s =~ /[\'\_\-\p{L}\p{N} \t\/]/;
}

sub is_unknown($s) {
    $s !~ /[
        \#      # Comment
        \n      # Newline
        \;      # Statement
        \<\>    # Abstract word paren
        \:      # Abstract word form
        \|      # Abstract word union
        \,      # Token sequence
        \&      # Metadata
        \=      # Assignment
        \@      # Compiler directive
        '\_\-\p{L}\p{N}\ \t\/  # Text
    ]/x;
}


1;
