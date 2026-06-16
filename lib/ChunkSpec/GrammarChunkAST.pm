package ChunkSpec::GrammarChunkAST;
use parent 'ChunkSpec::StatementAST';

use v5.36;


use constant {
    PATTERN => 'pattern',
};


sub new($class) {
    my $self = $class->SUPER::new();
    $self->{PATTERN} = [];
    bless $self, $class;
}

sub pattern ($self) {
    $self->{PATTERN};
}

sub add_pattern($self, $p) {
    push @{$self->{PATTERN}}, $p;
}

1;
