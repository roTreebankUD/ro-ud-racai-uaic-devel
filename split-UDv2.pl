#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

my $TEST_RATIO = 0.075;
my (@data, $docname);
open my $TEST, '>', 'ro-ud-test.conllu';
open my $DEV, '>', 'ro-ud-dev.conllu';
open my $TRAIN, '>', 'ro-ud-train.conllu';

sub flush {
    my ($header) = @_;
    my $min_lines = int(@data * $TEST_RATIO);
    my $printed = 0;
    say $DEV $header;
    say $DEV $data[$printed++] while $printed < $min_lines or $data[$printed-1] ne '';
    say $TEST $header;
    say $TEST $data[$printed++] while $printed < 2*$min_lines or $data[$printed-1] ne '';
    say $TRAIN $header;
    say $TRAIN $data[$printed++] while $printed < @data;
    @data = ();
}

while (<>){
    chomp;
    if (/^# (.+)/) {
        flush("# newdoc id = $docname") if defined $docname;
        $docname = $1;
    } else {
        push @data, $_;
    }
}
flush("# newdoc id = $docname");
close $DEV;
close $TEST;
close $TRAIN;
