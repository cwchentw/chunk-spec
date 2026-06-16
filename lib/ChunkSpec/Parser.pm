package  ChunkSpec::Parser;
use parent 'Parser';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    bless $self, $class;
}

sub parse($self, $lexer) {
    while ($lexer->has_next()) {
        my $peek = $lexer->peek();

        # Dump anything.
        say $peek->format();

        # Discard anything.
        $lexer->next();
    }
}

1;
