package Devel::REPL::Plugin;
BEGIN {
  $Devel::REPL::Plugin::AUTHORITY = 'cpan:PHAYLON';
}
{
  $Devel::REPL::Plugin::VERSION = '1.003025';
}

use strict;
use warnings;
use Devel::REPL::Meta::Plugin;
use Moose::Role ();

sub import {
  my $target = caller;
  Devel::REPL::Meta::Plugin->initialize($target);
  goto &Moose::Role::import;
}

1;
