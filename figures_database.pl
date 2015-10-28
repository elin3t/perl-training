#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use DBI;
use Term::ANSIColor;



my $dbh = DBI->connect('DBI:mysql:figures', 'root', '123'
) || die "Could not connect to database";

print "Enter the type of figure you want to list \n(circle, rectangle, triangle or square)\nor enter to exit:\n";
while(my $t = <STDIN>){
    if($t eq "\n" || $t eq ""){
        last;
    }
    chomp($t);
    $t = lc $t;
    if (index $t, ['circle', 'rectangle', 'triangle', 'square'])
    {
        my $sql = 'SELECT figure_color, figure_type, figure_points, radio FROM figure WHERE figure_type = ?';
        my $sth = $dbh->prepare($sql);
        $sth->execute($t);
        print "start of records..\n";
        print color('blue');
        while (my @row = $sth->fetchrow_array) {
            if ($t eq "circle")
            {
                print "color: $row[1]\t|| type: $row[2]\t|| center: $row[3]\t||radio: $row[4]\n" ;
            }else{
                print "color: $row[1]\t|| type: $row[2]\t|| points: $row[3]\n" ;
            }

        }
        print color('reset');
        print "end of records\n";
    }else{
        print color('yellow');
        print  "The option you enter is wrong!!\n and you know it!\n";
        print color('reset');
    }
    print "Enter the type of figure you want to list \n(circle, rectangle, triangle or square)\nor enter to exit:\n";

}





$dbh->disconnect();

__END__
