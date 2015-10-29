#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Math::Complex;


sub main(){
    my $var_a=0;
    my $var_b=0;
    my $var_c=0;

    ($var_a, $var_b, $var_c)=@ARGV;
  if($var_b**2 < 4*$var_a*$var_c){
    print STDOUT "Solution is not a real number \n";
    return $var_b**2 < 4*$var_a*$var_c;
    }elsif(4*$var_a*$var_c==$var_b**2){
        my $x1 = (-$var_b)/(2*$var_a);
        print STDOUT "Solution has one one value: $x1\n";
    }else{
      my $x1 = (-$var_b-sqrt($var_b**2 - 4*$var_a*$var_c))/(2*$var_a);
      my $x2 = (-$var_b+sqrt($var_b**2 - 4*$var_a*$var_c))/(2*$var_a);
      print STDOUT "Solution 1 for x: $x1\n";
      print STDOUT "Solution 2 for x: $x2\n";
  }

  return 0;
}

main();

__END__
