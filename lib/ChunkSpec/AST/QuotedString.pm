package ChunkSpec::AST::QuotedString;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_QUOTED_STRING);
    bless $self, $class;
}

sub emit_ir($self) {
    substr($self->peek()->content(), 1, -1);
}

sub emit_line_number($self) {
    $self->peek()->line_number();
}

1;
