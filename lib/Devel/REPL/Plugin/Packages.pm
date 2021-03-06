use strict;
use warnings;
package Devel::REPL::Plugin::Packages;
BEGIN {
  $Devel::REPL::Plugin::Packages::AUTHORITY = 'cpan:PHAYLON';
}
$Devel::REPL::Plugin::Packages::VERSION = '1.003026';
use Devel::REPL::Plugin;
use namespace::autoclean;

our $PKG_SAVE;

has 'current_package' => (
  isa      => 'Str',
  is       => 'rw',
  default  => 'Devel::REPL::Plugin::Packages::DefaultScratchpad',
  lazy     => 1
);

around 'wrap_as_sub' => sub {
  my $orig = shift;
  my ($self, @args) = @_;
  my $line = $self->$orig(@args);
  # prepend package def before sub { ... }
  return q!package !.$self->current_package.qq!;\n${line}!;
};

around 'mangle_line' => sub {
  my $orig = shift;
  my ($self, @args) = @_;
  my $line = $self->$orig(@args);
  # add a BEGIN block to set the package around at the end of the sub
  # without mangling the return value (we save it off into a global)
  $line .= '
; BEGIN { $Devel::REPL::Plugin::Packages::PKG_SAVE = __PACKAGE__; }';
  return $line;
};

after 'execute' => sub {
  my ($self) = @_;
  # if we survived execution successfully, save the new package out the global
  $self->current_package($PKG_SAVE) if defined $PKG_SAVE;
};

around 'eval' => sub {
  my $orig = shift;
  my ($self, @args) = @_;
  # localise the $PKG_SAVE global in case of nested evals
  local $PKG_SAVE;
  return $self->$orig(@args);
};

package Devel::REPL::Plugin::Packages::DefaultScratchpad;
BEGIN {
  $Devel::REPL::Plugin::Packages::DefaultScratchpad::AUTHORITY = 'cpan:PHAYLON';
}
$Devel::REPL::Plugin::Packages::DefaultScratchpad::VERSION = '1.003026';
# declare empty scratchpad package for cleanliness

1;

__END__

=head1 NAME

Devel::REPL::Plugin::Packages - Keep track of which package the user is in

=head1 VERSION

version 1.003026

=cut
