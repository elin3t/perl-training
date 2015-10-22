#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use POSIX;

sub is_valid_integer {
   defined $_[0] && $_[0] =~ /^\d{1,6}$/;
}

sub is_prime_number{
  my $number = $_[0];
  if ($number % 2 == 0) {
    return 0;
  }

  for (my $var = 3; $var < sqrt $number; $var+=2) {
    if($number % $var == 0){
      return 0;
    }
  }
  return 1;
}
my @return;
my $limit = 2;
print STDOUT "welcome to Prime number list, \nplease enter a number between 1 and 1000000:\n";
$limit = <STDIN>;
chomp($limit);
if(is_valid_integer($limit) && $limit >= 1 && $limit <= 1000000){
  for(my $number = 1; $number<=$limit; $number+=2){
    if(is_prime_number($number)){
      push @return, $number;
    }
  }
  print STDOUT join(' ', @return);
}else{
  print STDERR "Please enter a valid number!\n"
}
__END__
