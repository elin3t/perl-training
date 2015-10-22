#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX;

sub is_valid_integer {
   defined $_[0] && $_[0] =~ /^\d{1,6}$/;
}


my $limit = 2;
print STDOUT "welcome to Prime number list, \nplease enter a number between 2 and 1000000:\n";
$limit = <STDIN>;
chomp($limit);
if(is_valid_integer($limit) && $limit >= 2 && $limit <= 1000000){
  for my $number (2..$limit){
    my $isprime=1;
    for my $divs (2..(ceil($number/2))){
      if($number % $divs == 0){
        $isprime =0;
        last;
      }
    }
    if($isprime){
      print STDOUT "$number ";
    }
  }
  print STDOUT "\n";
}else{
  print STDERR "Please enter a valid number!\n"
}
__END__
