#!/usr/bin/perl
use warnings;
use strict;

my ($s);
if ($#ARGV eq -1) {
    $s = 0; 
}
else {
    $s = $ARGV[0];
    shift @ARGV;
}
while (<>) {
    if (/(.+[Ss]tart\=)(\d+)(.*)$/) {
        print "$1", $2 + $s;
        print "$3" if defined $3;
        print "\n";
    }
    else {
        print;
    }
}
