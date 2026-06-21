package ChunkSpec::AST::Text;
use parent 'ChunkSpec::Error::Token';

use v5.36;


sub new($class, $msg) {
    my $self = $class->SUPER::new($msg);
    $self->set_type(ChunkSpec::AST->TYPE_UNKNOWN_TOKEN);
    bless $self, $class;
}

sub emit_ir($self) {
    $self->peek()->content();
}

sub emit_line_number($self) {
    $self->peek()->line_number();
}

1;
