#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(firstidx);
use Data::Dumper;

my %originals;
my $sentence;
my %indexes;
my $mov = 0;
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

foreach my $o (keys %originals){
  my $tmpi = index $sentence, $o;
  if( $tmpi > -1 ){
    $indexes{$o} = $tmpi;
  }
}

 my @keys = sort { $indexes{$a} <=> $indexes{$b} } keys %indexes;
foreach my $key ( @keys ) {
  substr($sentence, $indexes{$key}+$mov, length($key)) = $originals{$key};
  $mov += length($originals{$key})-length($key);
}
print STDOUT "$sentence\n";

 __END__
