package ChunkSpec::Error::MalformedQuotedString;
use parent 'ChunkSpec::Error::Token';

use v5.36;


sub new($class, $msg) {
    my $self = $class->SUPER::new($msg);
    $self->set_type(ChunkSpec::AST->TYPE_MALFORMED_QUOTED_STRING);
    bless $self, $class;
}

1;
