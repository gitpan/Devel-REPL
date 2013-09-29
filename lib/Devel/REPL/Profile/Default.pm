package Devel::REPL::Profile::Default;
BEGIN {
  $Devel::REPL::Profile::Default::AUTHORITY = 'cpan:PHAYLON';
}
{
  $Devel::REPL::Profile::Default::VERSION = '1.003025';
}

use Moose;
use namespace::autoclean;

# for backcompat only - Default was renamed to Standard

extends 'Devel::REPL::Profile::Standard';

1;
