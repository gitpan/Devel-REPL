package Devel::REPL::Plugin::Pager;

use Moose::Role;
use IO::Handle;
use IO::Pager;

around 'print' => sub {
  my $orig = shift;
  my $self = shift;
  local $STDOUT = IO::Pager->new(*STDOUT);
  $self->$orig(@_);
};

1;
