#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(firstidx);
use Data::Dumper;


sub main{
    my %originals;
    my $sentence;

    print STDOUT "Please enter 1 line of text\n";
    $sentence = <>;
    chomp($sentence);

    print STDOUT "Please, enter space separated strings to match and replace (one pair per line).\n";
    while(<STDIN>){
      if($_ eq "\n"){
          last;
      }
      my @tmp = split(/\s/,$_);
      if(scalar @tmp == 2){
        $originals{$tmp[0]} = $tmp[1];
      }else{
        print STDERR "Error: please enter 2 values for line, original text and replace text, space separated\n";
      }
    }
    my $originals = join('|', keys %originals);
    $sentence =~ s/($originals)/$originals{$1}/g;

    say STDOUT "$sentence";
}
main();

 __END__
