# Run the WebGUIx tests

use strict;
use warnings;

use App::Prove;
use Getopt::Long;

my @args = (
    '-Ilib', '-It', "-r", 
);

GetOptions(
    'v'     => sub { push @args, '-v' },
);

my $WEBGUI_CONFIG   = $ARGV[0];
my $WEBGUI_ROOT     = $ARGV[1] || "/data/WebGUI";
$ENV{ WEBGUI_CONFIG } = $WEBGUI_ROOT . "/etc/" . $WEBGUI_CONFIG;

push @args, (
    "-I$WEBGUI_ROOT/lib", "-I$WEBGUI_ROOT/t/lib",
);

my $prove   = App::Prove->new;
$prove->process_args(@args);
$prove->run;

