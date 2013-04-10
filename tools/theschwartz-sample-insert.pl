#!/usr/bin/env perl

# perl tools/theschwartz-sample-insert.pl timeout message

use strict;
use utf8;

use strict;
use warnings;

use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';

use Data::Dumper;

use MT;
use MT::Util;

package main;

my $mt = new MT or die MT->errstr;
$mt->{vtbl}                 = {};
$mt->{is_admin}             = 0;
$mt->{template_dir}         = 'cms';
$mt->{user_class}           = 'MT::Author';
$mt->{plugin_template_path} = 'tmpl';
$mt->run_callbacks( 'init_app', $mt );

my $timeout = $ARGV[0] || 0;
my $message = $ARGV[1] or die("no given message");

require TheSchwartzSample::Plugin;
TheSchwartzSample::Plugin::insert( $timeout, $message );


1;
