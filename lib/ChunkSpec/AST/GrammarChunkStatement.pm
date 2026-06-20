package ChunkSpec::AST::GrammarChunkStatement;
use parent 'ChunkSpec::AST';

use v5.36;

use Tie::IxHash;


use constant {
    PATTERN  => 'pattern',
    METADATA => 'metadata',
    LINE     => 'line',
};


sub new($class) {
    my $self = $class->SUPER::new();
    $self->set_type(ChunkSpec::AST->TYPE_GRAMMAR_CHUNK_STATEMENT);
    bless $self, $class;
}

sub emit_ir($self) {
    tie my %chunk, 'Tie::IxHash';

    my $line_no;
    while ($self->has_next()) {
        my $child = $self->peek();

        if ($child->type() eq ChunkSpec::AST->TYPE_TOKEN_SEQUENCE) {
            my $pattern = $child->emit_ir();
            $line_no = $child->emit_line_number();

            $chunk{+PATTERN} = $pattern;
        }
        elsif ($child->type() eq ChunkSpec::AST->TYPE_METADATA) {
            tie %{$chunk{+METADATA}}, 'Tie::IxHash' if (not defined($chunk{+METADATA}));

            my $m = $child->emit_ir();

            for my ($key, $value) (%{$m}) {
                $chunk{+METADATA}{$key} = $value;
            }
        }

        $self->next();
    }

    $chunk{+LINE} = $line_no if ($line_no > 0);

    \%chunk;
}

1;
