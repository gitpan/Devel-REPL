package Devel::REPL::Profile::Default;
BEGIN {
  $Devel::REPL::Profile::Default::AUTHORITY = 'cpan:PHAYLON';
}
{
  $Devel::REPL::Profile::Default::VERSION = '1.003021';
}

use Moose;
use namespace::autoclean;

with 'Devel::REPL::Profile';

sub plugins { qw(
  Colors
  Completion
  CompletionDriver::INC
  CompletionDriver::LexEnv
  CompletionDriver::Keywords
  CompletionDriver::Methods
  History
  LexEnv
  DDS
  Packages
  Commands
  MultiLine::PPI
  ReadLineHistory
);}

sub apply_profile {
  my ($self, $repl) = @_;
  $repl->load_plugin($_) for $self->plugins;
}

1;
