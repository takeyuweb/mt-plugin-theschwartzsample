package TheSchwartzSample::Plugin;
use strict;

our $plugin = MT->component( 'TheSchwartzSample' );

sub insert {
    my ( $timeout, $message ) = @_;
    
    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname( 'TheSchwartzSample::Worker' );
    $job->run_after( time + $timeout );
    $job->grabbed_until( 60 );
    $job->arg( { message => $message } );
    $job->coalesce( 'TheSchwartzSampleWorkerGroup' );
    MT::TheSchwartz->insert( $job );
}

1;