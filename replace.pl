#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(firstidx);

my @originals;
my @replaces;
my @indexes;
my $sentence;
my $text;

print STDOUT "Please enter 1 line of text\n";
$sentence = <>;
chomp($sentence);
print STDOUT "Please, enter space separated strings to match and replace (one pair per line).\n";
while(<>){
  if($_ eq "\n"){
      last;
  }
  my @tmp = split(/\s/,$_);
  if((scalar @tmp) == 2){
    push @originals, $tmp[0];
    push @replaces, $tmp[1];
  }else{
    print STDERR "Error: please enter 2 values for line, original text and replace text, space separated\n";
  }
}
#Cases to do test: when replace text are substring of other replce or origin text
#or a mix that after one or more replace ex. zZ  zzZ

for my $r (0..scalar @originals){
  if(firstidx{$_ eq @replaces[$r]} @originals ){
    $sentence =~ s/$originals[$r]/$replaces[$r]/;
    splice @originals,$r,1;
    splice @replaces,$r,1;
  }
}

for my $r (0..$#originals){
    $sentence =~ s/$originals[$r]/$replaces[$r]/;
}

print STDOUT "$sentence\n";

 __END__
