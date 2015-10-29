#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %numbers;
my %equivalences=(
    one=>"1",
    two=>"2",
    three=>"3",
    four=>"4",
    five=>"5",
    six=>"6",
    seven=>"7",
    eight=>"8",
    nine=>"9",
    zero=>"0",
    ten=>"10",
    eleven=>"11",
    twelve=>"12",
    thirteen=>"13",
    fourteen=>"14",
    fifteen=>"15",
    sixteen=>"16",
    seventeen=>"17",
    eighteen=>"18",
    nineteen=>"19",
    twenty=>"20 ",
    thirty=>"30 ",
    forty=>"40 ",
    fifty=>"50 ",
    sixty=>"60 ",
    seventy=>"70 ",
    eighty=>"80 ",
    ninety=>"90 ",
    thousand=>"*1000",
    hundred=>"*100",
    millon=>"*1000000"
);

sub manual_entry {
    print STDOUT "Enter the numbers in english:\n";

    while(<STDIN>){
        if($_ eq "\n"){
            last;
        }
        chomp($_);
        $numbers{$_} = 0;
    }
}

sub file_entry {
    while (my $file = shift) {
        $numbers{$file} = 0;
    }
}

sub main {
    if (scalar @_) {
        file_entry @_;
    }else {
        manual_entry();
    }

    foreach my $key (keys %numbers) {
        my $number = $key;
        $number =~ s/\s/|/g;
        my $numbere = $key;

        $numbere =~ s/($number)/$equivalences{$1}/g;

        $numbere =~ s/\s\*/\*/g;
        $numbere =~ s/\s+/+/g;

        $numbers{$key} = eval $numbere;
    }

    foreach (sort {
        ($numbers{$b} <=> $numbers{$a})
    } keys %numbers)
    {
        print STDOUT "$_\n";
    }
}

main();

__END__