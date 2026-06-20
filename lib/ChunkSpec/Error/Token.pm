package ChunkSpec::Error::Token;
use parent qw(ChunkSpec::Token ChunkSpec::Error);

use v5.36;


sub new($class, $msg) {
    my $self = bless {}, $class;

    $self->ChunkSpec::Token::init(@_);

    $self->ChunkSpec::Error::init(@_);

    $self;
}

1;
