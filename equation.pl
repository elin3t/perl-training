#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Math::Complex;

my $a=0;
my $b=0;
my $c=0;

($a, $b, $c)=@ARGV;
sub main(){
  if($b**2 < 4*$a*$c){
    print STDOUT "Solution is not a real number \n";
    return $b**2 < 4*$a*$c;
  }
  my $x1 = (-$b-sqrt($b**2 - 4*$a*$c))/(2*$a);
  my $x2 = (-$b+sqrt($b**2 - 4*$a*$c))/(2*$a);
  print STDOUT "Solution 1 for x: $x1\n";
  print STDOUT "Solution 2 for x: $x2\n";

  return 0;
}

main();

__END__
