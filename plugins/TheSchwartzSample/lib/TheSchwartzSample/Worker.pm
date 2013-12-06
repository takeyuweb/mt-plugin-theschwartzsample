package TheSchwartzSample::Worker;
use strict;
use base qw( TheSchwartz::Worker );

use MT;
our $plugin = MT->component( 'TheSchwartzSample' );

# http://d.hatena.ne.jp/sfujiwara/20080404/1207298792
sub sighandler {
    warn "caught signal @_\n";
    no warnings 'redefine';
    *TheSchwartz::work_once = sub { exit };
}

sub work {
    my ( $class, $job ) = @_;
    $SIG{ HUP } = $SIG{ INT } = $SIG{ TERM } = \&sighandler;
    
    my @jobs = (); 
    push @jobs, $job;

    if ( my $key = $job->coalesce ) {
        require MT::TheSchwartz;
        my $c = MT::TheSchwartz->new;
        while ( my $coalesced_job = $c->find_job_with_coalescing_value( $class, $key ) ) {
            push @jobs, $coalesced_job;
        }
    }
    
    my $mt = MT->instance;
    foreach my $j ( @jobs ) {
        $mt->log( $plugin->translate( 'TheSchwartzSample::Worker: [_1]', $j->arg->{ message } ) );
        $j->completed();
    }
}

# ジョブを他のワーカーにつかませない秒数
# ジョブの実行にかかる時間より長くなるようにする
sub grab_for { 43200 }

1;
