#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Paths::Graph;
use Data::Dumper;

my %tree;
my $start;
my $goal;

sub has_key{
    my %hash = %{shift()};
    my $key = shift;
    if (exists $hash{$key}) {
        return 1;
    }
    foreach my $x (keys %hash) {
        if (ref $hash{$x} eq ref {} ) {
            my %tpmh = %{$hash{$x}};
            return has_key(\%tpmh, $key);
        }
    }
    return 0;
}

sub set_value_for_key{
    my %hash = %{shift()};
    my $key = shift;
    my $value = shift;
    my @path = (keys %hash)[0];
    if (exists $hash{$key}) {
        $hash{$key}{$value}={};
    }
    foreach my $x (keys %hash) {
        if (ref $hash{$x} eq ref {} ) {
            my %tpmh = %{$hash{$x}};
            %hash = (%hash, set_value_for_key(\%tpmh, $key, $value));
        }
    }
    return %hash;
}

print STDOUT "Enter the start and final node:\n";
my $input = <STDIN>;
chomp($input);
($start, $goal) = split(/\s/,$input);
print STDOUT "Enter the nodes: one coneion per line, space separated \n";
while(my $t = <STDIN>){
    if($t eq "\n" || $t eq ""){
        last;
    }
    my $tmpr;
    my $tmpl;
    ($tmpr, $tmpl) = split(/\s/,$t);
    if (has_key(\%tree, $tmpr)) {
        %tree = set_value_for_key(\%tree, $tmpr, $tmpl);
    }else{
        $tree{$tmpr}={};
        $tree{$tmpr}{$tmpl}={};
    }

}

my $obj = Paths::Graph->new(-origin=>$start,-destiny=>$goal,-graph=>\%tree);

my @way = $obj->shortest_path();
my $path = scalar @{$way[0]};
$path = $path -1;

print STDOUT "$path\n";