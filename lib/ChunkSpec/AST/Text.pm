package ChunkSpec::AST::Text;
use parent 'ChunkSpec::AST';

use v5.36;


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_TEXT);
    bless $self, $class;
}

sub emit_ir($self) {
    $self->peek()->content();
}

sub emit_line_number($self) {
    $self->peek()->line_number();
}

1;
