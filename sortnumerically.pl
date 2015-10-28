#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %numbers;

sub manual_entry {
    print STDOUT "Enter the numbers in english:\n";

    while(my $t = <STDIN>){
        if($t eq "\n" || $t eq ""){
            last;
        }
        chomp($t);
        $numbers{$t} = 0;
    }
}

sub file_entry {
    while (my $file = shift) {
        $numbers{$file} = 0;
    }
}
if(scalar @_){
    file_entry @_;
}else{
    manual_entry();
}

foreach my $key (keys %numbers){
  my $number = $key;
  $number =~ s/one/1/ig;
  $number =~ s/two/2/ig;
  $number =~ s/three/3/ig;
  $number =~ s/four/4/ig;
  $number =~ s/five/5/ig;
  $number =~ s/six/6/ig;
  $number =~ s/seven/7/ig;
  $number =~ s/eight/8/ig;
  $number =~ s/nine/9/ig;
  $number =~ s/zero/0/ig;
  $number =~ s/ten/10/ig;
  $number =~ s/eleven/11/ig;
  $number =~ s/twelve/12/ig;
  $number =~ s/thirteen/13/ig;
  $number =~ s/fourteen/14/ig;
  $number =~ s/fifteen/15/ig;
  $number =~ s/sixteen/16/ig;
  $number =~ s/seventeen/17/ig;
  $number =~ s/eighteen/18/ig;
  $number =~ s/nineteen/19/ig;
  $number =~ s/twenty/20/ig;
  $number =~ s/thirty/30/ig;
  $number =~ s/forty/40/ig;
  $number =~ s/fifty/50/ig;
  $number =~ s/sixty/60/ig;
  $number =~ s/seventy/70/ig;
  $number =~ s/eighty/80/ig;
  $number =~ s/ninety/90/ig;
  $number =~ s/thousand/\*1000/ig;
  $number =~ s/hundred/\*100/ig;
  $number =~ s/millon/\*1000000/ig;
  $number =~ s/\s\*/\*/g;
  $number =~ s/\s/+/g;
  $numbers{$key} = eval $number;
}


foreach (sort { ($numbers{$b} <=> $numbers{$a}) } keys %numbers)
{
    print STDOUT "$_\n";
}
