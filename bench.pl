use strict;
use warnings;
use utf8;
use feature qw/say/;

use IPC::Open3 qw/open3/;
use JSON::PP;
use List::Util qw/reduce/;
use Encode qw/encode_utf8/;

my $JSON = JSON::PP->new->utf8;

main(@ARGV);
exit;

sub main {
    my $ip = shift @ARGV
        or die "Usage: $0 127.0.0.1";

    my $test_datas = load_test_datas();
    my $res = run_benchmark($ip, $test_datas);
    my ($summary, $score) = calculate_score($res);
    say "RESULT: $summary";
    say "SCORE: $score";
    for my $violation (@{ $res->{violations} }) {
        say encode_utf8($violation->{description});
    }
}

sub load_test_datas { $JSON->decode(slurp("testsets.json")) }
sub choice { $_[int rand scalar @_] }

sub slurp {
    my $file = shift;
    open my $fh, '<', $file or die $!;
    local $/;
    return <$fh>;
}

sub run_benchmark {
    my ($ip, $test_datas) = @_;

    my @cmd = (
        'java', -jar => 'bench.jar',
        'net.isucon.isucon5q.bench.scenario.Isucon5Qualification', $ip
    );
    my $pid = open3(my $in, my $out, 0, @cmd) or die $!;
    while (my $line = <$out>) {
        chomp $line;
        last if $line eq 'reading stdin';
    }

    my $test_data = choice(@$test_datas);
    print {$in} $JSON->encode($test_data);
    close $in;

    my $in_res = 0;
    my $res = '';
    while (my $line = <$out>) {
        chomp $line;
        $in_res = 1       if $line eq '{';
        $res .= "$line\n" if $in_res;
        $in_res = 0       if $line eq '}';
    }

    close $out;
    wait;

    return $JSON->decode($res);
}

## copied from https://github.com/isucon/isucon5-qualify/blob/master/eventapp/lib/score.rb and arranged
## MIT Licence: https://github.com/isucon/isucon5-qualify#license
## Copyright (c) 2015 tagomoris, kamipo, najeira, hkurokawa, making, xerial
sub calculate_score {
    my $res = shift;
    my $base_score  = $res->{responses}->{success}    + $res->{responses}->{redirect}  * 0.1;
    my $minus_score = $res->{responses}->{error} * 10 + $res->{responses}->{exception} * 20;

    my $too_slow_penalty = 0;
    my @too_slow_responses = grep { $_->{description} =~ /アプリケーションが \d+ ミリ秒以内に応答しませんでした/ } @{ $res->{violations} };
    if (@too_slow_responses) {
        $too_slow_penalty = 100 * reduce { $a + $b } map { $_->{number} } @too_slow_responses;
    }

    my $score = $base_score - $minus_score - $too_slow_penalty;
       $score = 0 if $score < 0;

    my $summary = ($res->{valid} && $score > 0) ? "success" : "fail";
    return ($summary, $score);
}
