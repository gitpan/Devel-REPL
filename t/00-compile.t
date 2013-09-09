use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.027

use Test::More 0.94 tests => 39 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Devel/REPL.pm',
    'Devel/REPL/Error.pm',
    'Devel/REPL/Meta/Plugin.pm',
    'Devel/REPL/Plugin.pm',
    'Devel/REPL/Plugin/B/Concise.pm',
    'Devel/REPL/Plugin/Colors.pm',
    'Devel/REPL/Plugin/Commands.pm',
    'Devel/REPL/Plugin/Completion.pm',
    'Devel/REPL/Plugin/CompletionDriver/Globals.pm',
    'Devel/REPL/Plugin/CompletionDriver/INC.pm',
    'Devel/REPL/Plugin/CompletionDriver/Keywords.pm',
    'Devel/REPL/Plugin/CompletionDriver/LexEnv.pm',
    'Devel/REPL/Plugin/CompletionDriver/Methods.pm',
    'Devel/REPL/Plugin/CompletionDriver/Turtles.pm',
    'Devel/REPL/Plugin/DDC.pm',
    'Devel/REPL/Plugin/DDS.pm',
    'Devel/REPL/Plugin/DumpHistory.pm',
    'Devel/REPL/Plugin/FancyPrompt.pm',
    'Devel/REPL/Plugin/FindVariable.pm',
    'Devel/REPL/Plugin/History.pm',
    'Devel/REPL/Plugin/Interrupt.pm',
    'Devel/REPL/Plugin/LexEnv.pm',
    'Devel/REPL/Plugin/MultiLine/PPI.pm',
    'Devel/REPL/Plugin/Nopaste.pm',
    'Devel/REPL/Plugin/OutputCache.pm',
    'Devel/REPL/Plugin/PPI.pm',
    'Devel/REPL/Plugin/Packages.pm',
    'Devel/REPL/Plugin/Peek.pm',
    'Devel/REPL/Plugin/ReadLineHistory.pm',
    'Devel/REPL/Plugin/Refresh.pm',
    'Devel/REPL/Plugin/ShowClass.pm',
    'Devel/REPL/Plugin/Timing.pm',
    'Devel/REPL/Plugin/Turtles.pm',
    'Devel/REPL/Profile.pm',
    'Devel/REPL/Profile/Default.pm',
    'Devel/REPL/Profile/Minimal.pm',
    'Devel/REPL/Script.pm'
);

my @scripts = (
    'examples/dbic_project_profile.pl',
    'script/re.pl'
);

# no fake home requested

use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    my $stdin = '';     # converted to a gensym by open3
    my $stderr = IO::Handle->new;
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';

    my $pid = open3($stdin, '>&STDERR', $stderr, qq{$^X -Mblib -e"require q[$lib]"});
    waitpid($pid, 0);
    is($? >> 8, 0, "$lib loaded ok");

    if (my @_warnings = <$stderr>)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}

use File::Spec;
foreach my $file (@scripts)
{ SKIP: {
    open my $fh, '<', $file or warn("Unable to open $file: $!"), next;
    my $line = <$fh>;
    close $fh and skip("$file isn't perl", 1) unless $line =~ /^#!.*?\bperl\b\s*(.*)$/;

    my $flags = $1;

    my $stdin = '';     # converted to a gensym by open3
    my $stderr = IO::Handle->new;
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';

    my $pid = open3($stdin, '>&STDERR', $stderr, qq{$^X -Mblib $flags -c $file});
    waitpid($pid, 0);
    is($? >> 8, 0, "$file compiled ok");

   # in older perls, -c output is simply the file portion of the path being tested
    if (my @_warnings = grep { !/\bsyntax OK$/ }
        grep { chomp; $_ ne (File::Spec->splitpath($file))[2] } <$stderr>)
    {
        # temporary measure - win32 newline issues?
        warn map { _show_whitespace($_) } @_warnings;
        push @warnings, @_warnings;
    }
} }

sub _show_whitespace
{
    my $string = shift;
    $string =~ s/\012/[\\012]/g;
    $string =~ s/\015/[\\015]/g;
    $string =~ s/\t/[\\t]/g;
    $string =~ s/ /[\\s]/g;
    return $string;
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};

BAIL_OUT("Compilation problems") if !Test::More->builder->is_passing;
