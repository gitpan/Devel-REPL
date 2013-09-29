package Devel::REPL::Error;
BEGIN {
  $Devel::REPL::Error::AUTHORITY = 'cpan:PHAYLON';
}
{
  $Devel::REPL::Error::VERSION = '1.003025';
}
use Moose;

# FIXME get nothingmuch to refactor and release his useful error object

has type => (
  isa => "Str",
  is  => "ro",
  required => 1,
);

has message => (
  isa => "Str|Object",
  is  => "ro",
  required => 1,
);

sub stringify {
  my $self = shift;

  sprintf "%s: %s", $self->type, $self->message;
}
__PACKAGE__

__END__
