package ChunkSpec::Error;

use v5.36;


use constant {
    MESSAGE => 'message',
};


sub new($class, $msg) {
    my $self = {};
    $self->{MESSAGE} = $msg;
    bless $self, $class;
}

sub error($self) {
    die "Abstract subroutine 'error' not implemented";
}

1;
