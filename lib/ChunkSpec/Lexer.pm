package ChunkSpec::Lexer;
use parent 'Parse::Lexer';

use v5.36;
use builtin qw(true false);

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
        elsif (is_quote($peek)) {
            my $t = ChunkSpec::Token->new();

            if (substr($s, $j, 2) eq "''") {
                $t->set_type(ChunkSpec::Token->TYPE_QUOTE_LITERAL);

                $j += 2;
            }
            else {
                my $quoted = false;
                my $malformed = false;
                while ($j < $len) {
                    if (is_quote(substr($s, $j, 1))) {
                        if ($quoted) {
                            $j++;
                            last;
                        };

                        $j++;
                        $quoted = true;
                    }

                    if (is_newline(substr($s, $j, 1))) {
                        $malformed = true;
                        last;
                    }

                    $j++;
                }

                if ($malformed) {
                    $t->set_type(ChunkSpec::Token->TYPE_MALFORMED_QUOTED_STRING);
                }
                else {
                    $t->set_type(ChunkSpec::Token->TYPE_QUOTED_STRING);
                }
            }

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
        elsif (is_abstract_word_form_separator($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_ABSTRACT_WORD_FORM_SEPARATOR);
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
        elsif (is_token_sequence_seperator($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_TOKEN_SEQUENCE_SEPARATOR);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            $self->add_token($t);

            $i = $j;
        }
        elsif (is_metadata_separator($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_METADATA_SEPARATOR);
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

sub is_quote($s) {
    $s eq "'";
}

sub is_abstract_word_paren($s) {
    $s eq '<' or $s eq '>';
}

sub is_abstract_word_form_separator($s) {
    $s eq ':';
}

sub is_abstract_word_union($s) {
    $s eq '|';
}

sub is_token_sequence_seperator($s) {
    $s eq ',';
}

sub is_metadata_separator($s) {
    $s eq '&';
}

sub is_assignment($s) {
    $s eq '=';
}

sub is_text($s) {
    $s =~ /[\.\?\!\(\)\_\-\p{L}\p{N} \t\/]/;
}

sub is_unknown($s) {
    $s !~ /[
        \#      # Comment
        \n      # Newline
        \;      # Statement
        \'      # Quote
        \<\>    # Abstract word paren
        \:      # Abstract word form separator
        \|      # Abstract word union
        \,      # Token sequence
        \&      # Metadata
        \=      # Assignment
        '\.\?\!\(\)\_\-\p{L}\p{N}\ \t\/  # Text
    ]/x;
}


1;
