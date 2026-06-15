package ChunkSpec::Lexer;

use v5.36;

use ChunkSpec::Token;

use constant {
    TOKENS => 'tokens',
    INDEX => 'index',
};

sub new($class) {
    my $self = {};
    $self->{TOKENS} = ();
    $self->{INDEX} = 0;
    bless $self, $class;
}

sub has_next($self) {
    my $index = $self->{INDEX};
    my $len = scalar @{$self->{TOKENS}};
    $index < $len;
}

sub next($self) {
    my $i = $self->{INDEX};
    my $t = @{$self->{TOKENS}}[$i];
    ($self->{INDEX})++;
    $t;
}

sub peek($self) {
    my $i = $self->{INDEX};
    my $t = @{$self->{TOKENS}}[$i];
    $t;
}

sub lex($self, $s, $l) {
    my $i = 0;
    my $len = length($s);

    while ($i < $len) {
        my $peek = substr($s, $i, 1);
        my $j = $i;

        if (is_newline($peek)) {
            my $t = ChunkSpec::Token->new();

            $t->set_type(ChunkSpec::Token->TYPE_NEWLINE);
            $t->set_content($peek);

            $t->set_line_number($l);
            $t->set_column_number($i + 1);

            $j++;

            push @{$self->{TOKENS}}, $t;

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

            push @{$self->{TOKENS}}, $t;

            $i = $j;
        }
        else {
            # Discard anything else.
            $j++;
            $i = $j;
        }
    }
}

sub is_newline($s) {
    $s eq "\n";
}

sub is_text($s) {
    $s =~ /[\p{L}\p{N}]/;
}

1;