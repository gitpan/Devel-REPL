use strict;
use warnings;
package Devel::REPL::Plugin::CompletionDriver::Turtles;
BEGIN {
  $Devel::REPL::Plugin::CompletionDriver::Turtles::AUTHORITY = 'cpan:PHAYLON';
}
{
  $Devel::REPL::Plugin::CompletionDriver::Turtles::VERSION = '1.003022';
}
use Devel::REPL::Plugin;
use Devel::REPL::Plugin::Completion;    # die early if cannot load
use namespace::autoclean;

sub BEFORE_PLUGIN {
    my $self = shift;
    $self->load_plugin('Completion');
}

around complete => sub {
  my $orig = shift;
  my ($self, $text, $document) = @_;

  my $prefix = $self->default_command_prefix;
  my $line_re = qr/^($prefix)(\w+)/;

  my @orig = $self->$orig($text, $document);

  if ( my ( $pre, $method ) = ( $text =~ $line_re ) ) {
    my $filter = qr/^\Q$method/;
    return (
      @orig,
      (
        map { "$pre$_" }
        grep { $_ =~ $filter }
        map { /^expr?_command_(\w+)/ ? $1 : () }
        map { $_->name }
        $self->meta->get_all_methods
      ),
    );
  } else {
    return @orig;
  }
};

__PACKAGE__

__END__

=head1 NAME

Devel::REPL::Plugin::CompletionDriver::Turtles - Complete Turtles-based commands

=head1 AUTHOR

Yuval Kogman E<lt>nothingmuch@woobling.orgE<gt>

=cut

