#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(firstidx);
use Data::Dumper;

my %originals;
my $sentence;

print STDOUT "Please enter 1 line of text\n";
$sentence = <>;
chomp($sentence);

print STDOUT "Please, enter space separated strings to match and replace (one pair per line).\n";
while(<>){
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

foreach my $o (sort keys %originals){
  $sentence =~ s/([^_])$o([^_])?/$1_$originals{$o}_$2/g;
}
$sentence =~ s/_//g;

say STDOUT "$sentence";

 __END__
