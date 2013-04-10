#!/usr/bin/env perl

# perl tools/theschwartz-sample-work.pl

use strict;
use utf8;

use strict;
use warnings;

use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';

use Data::Dumper;

use MT;
use MT::Util;

package main;

my $help            = 0;
my $verbose         = 0;
my $scoreboard;
my $randomize_jobs  = 0;

require Getopt::Long;
Getopt::Long::GetOptions(
    "scoreboard=s" => \$scoreboard,
    "randomly"     => \$randomize_jobs,
    "verbose"      => \$verbose,
);

my $mt = new MT or die MT->errstr;
$mt->{vtbl}                 = {};
$mt->{is_admin}             = 0;
$mt->{template_dir}         = 'cms';
$mt->{user_class}           = 'MT::Author';
$mt->{plugin_template_path} = 'tmpl';
$mt->run_callbacks( 'init_app', $mt );

my %cfg;
$cfg{verbose}    = $verbose;
$cfg{scoreboard} = $scoreboard;
$cfg{prioritize} = 1;
$cfg{randomize}  = $randomize_jobs;

my $client = eval {
    require MT::TheSchwartz;
    my $c = MT::TheSchwartz->new( %cfg );
};
if ( ( my $error = $@ ) && $verbose ) {
    print STDERR "Error initializing TheSchwartz: $error\n";
}

require TheSchwartzSample::Worker;
$client->can_do( 'TheSchwartzSample::Worker' );
$client->work_once();

1;
