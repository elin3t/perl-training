#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';


package Figure;
use GD::Simple;
use DBI;
use Try::Tiny;
use Data::Dumper;

sub new{
    my $class = shift;
    my %args = @_;
    my $self = bless {}, $class;
    $self->{"figure_type"}=$args{figure_type}||"line";
    $self->{"color"}=$args{color}||"red";
    $self->{"points"}=[];

    return $self;
}

sub add_point{
    my $self = shift;
    my $point = shift;
    push $self->{points}, $point;
}

sub get_points{
    my $self = shift;
    return $self->{points};
}

sub get_type{
    my $self = shift;
    return $self->{figure_type};
}

sub set_color{
    my $self = shift;
    $self->{color} = shift;
}

sub get_color{
    my $self = shift;
    return $self->{color};
}

sub get_distance_two_points{
    my $self = shift;
    my $p1 = shift;
    my $p2 = shift;

    my @pointone = split(/,\s?/,$p1);
    my @pointtwo = split(/,\s?/,$p2);

    return sqrt(($pointone[0] - $pointtwo[0])**2 + ($pointone[1] - $pointtwo[1])**2 );
}

sub save_in_db{
    my $self = shift;
    try{
        my $dbh = DBI->connect('DBI:mysql:figures', 'root', '123'
        ) || die "Could not connect to database";
        my @points = $self->get_points();
        my $points_b;
        #la siguiente linea puede no funcionar porque guarda los puntos pegados
        $points_b = join (" ",@{$points[0]});
        $dbh->do(
            'INSERT INTO figure (figure_color, figure_type, figure_points) VALUES (?, ?, ?)',
            undef,
            $self->get_color(), $self->get_type(), $points_b
        );
        $dbh->disconnect;
    }catch{
        print STDERR "caught error: $_";
    }
}

1;

package Circle;
use Try::Tiny;
our @ISA = qw(Figure);
sub new{
    my $class = shift;
    my %args = @_;
    my $self = $class->SUPER::new(figure_type=>"circle", color=>"green");
    $self->{radio}=$args{radio}||0;
    $self->{center}=$args{center}||"0,0";
    return $self;
}

sub set_radio{
    my $self = shift;
    $self->{radio} = shift;
}

sub get_radio{
    my $self = shift;
    return $self->{radio};
}


sub set_center{
    my $self = shift;
    $self->{center} = shift;
}

sub get_center{
    my $self = shift;
    return $self->{center};
}

sub get_area{
    my $self = shift;
    my $area = 3.14159 * $self->{radio} * $self->{radio};
    return $area;
}

sub draw {
    my $self = shift;
    my $radio = int($self->get_radio());
    for my $r (0..$radio){
        print " " x ($radio-$r)**2 . "*" x (($r)**2) ."\n" ;
    }
    for my $r (0..$radio){
        print " " x ($r**2) . "*" x (($radio-$r)**2) ."\n" ;
    }

}

sub draw_in_file {
    my $self = shift;
    my $img = GD::Simple->new(200, 200);
    $img->bgcolor($self->get_color());
    $img->fgcolor($self->get_color());
    $img->moveTo(20, 20);
    $img->string("area is: " . $self->get_area());
    $img->moveTo(100,100);
    my $radio = $self->get_radio();
    $radio = $radio * 10 if $radio < 10;
    $img->ellipse($radio, $radio);

    open my $out, '>', 'circle.png' or die;
    binmode $out;
    print $out $img->png;

}

sub save_in_db{
    my $self = shift;
    try{
        my $dbh = DBI->connect('DBI:mysql:figures', 'root', '123'
        ) || die "Could not connect to database";

        $dbh->do(
            'INSERT INTO figure (figure_color, figure_type, figure_points, radio) VALUES (?, ?, ?, ?)',
            undef,
            $self->get_color(), $self->get_type(), $self->get_center(), $self->get_radio()
        );
        $dbh->disconnect;
    }catch{
        print STDERR "caught error: $_";
    }
}

1;

package Triangle;
    our @ISA = qw(Figure);
    sub get_area{
        my $self = shift;
        my @points = $self->get_points();
        if (scalar @{$points[0]}==3)
        {
            my ($x1, $y1) =split(/,\s?/,$points[0][0]);
            my ($x2, $y2) =split(/,\s?/,$points[0][1]);
            my ($x3, $y3) =split(/,\s?/,$points[0][2]);
            return abs($x1*($y2-$y3)+$x2*($y3-$y1)+$x3*($y1-$y2))/2;
        }
        print STDERR "Asure you have 3 points in the triangle ";
        return -1;
    }


    sub draw {
        my $self = shift;
        my @points = $self->get_points();
        my $distance2 = $self->get_distance_two_points($points[0][1],$points[0][2]);

        foreach my $y (0..int $distance2 ){
            print " "x($distance2-$y) . "/";
            print "-" x ($y*2) . "\\\n";
        }
    }

    sub draw_in_file {
        my $self = shift;

        my @points = $self->get_points();
        my $img = GD::Simple->new(200, 100);
        $img->bgcolor($self->get_color());
        $img->fgcolor($self->get_color());

        my ($x1, $y1) =split(/,\s?/,$points[0][0]);
        my ($x2, $y2) =split(/,\s?/,$points[0][1]);
        my ($x3, $y3) =split(/,\s?/,$points[0][2]);

        $x1 = $x1*20 if $x1 < 10;
        $x2 = $x2*20 if $x2 < 10;
        $x3 = $x3*20 if $x3 < 10;


        $y1 = $y1*20 if $y1 < 10;
        $y2 = $y2*20 if $y2 < 10;
        $y3 = $y3*20 if $y3 < 10;


        $img->moveTo($x1,$y1);
        $img->lineTo($x2, $y2);
        $img->lineTo($x3, $y3);
        $img->lineTo($x1, $y1);

        $img->moveTo(10, 10);
        $img->string("Area is: " . $self->get_area());

        open my $out, '>', 'triangle.png' or die;
        binmode $out;
        print $out $img->png;
    }
1;

package Rectangle;

our @ISA = qw(Figure);
sub get_area{
    my $self = shift;
    my @points = $self->get_points();
    if (scalar @{$points[0]}==4)
    {

        my $distance1 = $self->get_distance_two_points($points[0][0],$points[0][1]);
        my $distance2 = $self->get_distance_two_points($points[0][1],$points[0][2]);
        my $distance3 = $self->get_distance_two_points($points[0][2],$points[0][3]);

        if ($distance1 == $distance2 && $distance1 != $distance3)
        {
            return $distance1 * $distance3;
        }
        if ($distance2 != $distance3)
        {
            return $distance3 * $distance2;
        }
        return $distance1 * $distance2;
    }
    print STDERR "Asure you have 4 points in the Rectangle ";
    return -1;
}

sub get_axis{
    my $self = shift;
    my @points = $self->get_points();
    my ($x1, $y1) =split(/,\s?/,$points[0][0]);
    my ($x2, $y2) =split(/,\s?/,$points[0][1]);
    my ($x3, $y3) =split(/,\s?/,$points[0][2]);

    my @axis;
    if ($x1 != $x2)
    {
        push @axis, $x1;
        push @axis, $x2;
    }else{
        push @axis, $x1;
        push @axis, $x3;
    }
    if ($y1 != $y2)
    {
        push @axis, $y1;
        push @axis, $y2;
    }else{
        push @axis, $y1;
        push @axis, $y3;
    }
    return @axis;
}

sub draw {
    my $self = shift;
    my @points = $self->get_points();
    my $distance1 = $self->get_distance_two_points($points[0][0],$points[0][1]);
    my $distance2 = $self->get_distance_two_points($points[0][1],$points[0][2]);
    if($distance1 == $distance2){
        $distance2 = $self->get_distance_two_points($points[0][2],$points[0][3]);
    }
    $distance1 = 10 if $distance1 > 10;

    foreach my $x (0..int $distance2){
        print "     |";
        print "-" x int($distance1) . "|\n";
    }
}

sub draw_in_file {
    my $self = shift;

    my @axis = $self->get_axis();
    my $img = GD::Simple->new(200, 100);
    $img->bgcolor($self->get_color());
    $img->fgcolor($self->get_color());

    $img->rectangle($axis[0] * 10 , $axis[2] * 10 + 30, $axis[1] * 10, $axis[3] *10 + 30);
    $img->moveTo(10, 25);
    $img->string("Area is: " . $self->get_area());

    open my $out, '>', 'rectangle.png' or die;
    binmode $out;
    print $out $img->png;
}

1;

package Square;

our @ISA = qw(Rectangle);
sub get_area{
    my $self = shift;
    my @points = $self->get_points();
    if (scalar @{$points[0]}==4)
    {

        my $distance1 = $self->get_distance_two_points($points[0][0],$points[0][1]);

        return $distance1 ** 2;
    }
    print STDERR "Are you sure you have 4 points in the Square\n you know it! ";
    return -1;
}

sub draw {
    my $self = shift;
    my @points = $self->get_points();
    my $distance1 = $self->get_distance_two_points($points[0][0],$points[0][1]);
    $distance1 = 10 if $distance1 > 10;

    foreach my $x (0..int $distance1){
        print "     |";
        print "-" x int($distance1 * 2) . "|\n";
    }
}

sub draw_in_file {
    my $self = shift;

    my @axis = $self->get_axis();
    my $img = GD::Simple->new(200, 100);
    $img->bgcolor($self->get_color());
    $img->fgcolor($self->get_color());

    $img->rectangle($axis[0] * 10 , $axis[2] * 10 + 30, $axis[1] * 10, $axis[3] *10 + 30);
    $img->moveTo(10, 25);
    $img->string("Area is: " . $self->get_area());

    open my $out, '>', 'square.png' or die;
    binmode $out;
    print $out $img->png;
}


1;


package main;

use Data::Dumper;
use Term::ANSIColor;
use GD::Simple;


sub ask_point{
    my $point1 = <STDIN>;
    chomp($point1);
    my @tmp = split(/,\s?/,$point1);

    if (scalar @tmp == 2 && $tmp[0] =~ /\d+/ &&$tmp[1] =~ /\d+/ )
    {

        return $point1;
    }
    print STDERR "wrong data input\n";
    return ask_point();
}

    my $command;
    my $fig;
    my $file;
    ($command, $fig, $file)=@ARGV;
    $command = lc $command;
    $fig = lc $fig;
    if ($fig eq "rectangle" && $command eq "create")
    {
        print STDOUT "Enter the 4 coordinate points, one each line and axis comma separared\n";

        my $rectangle = Rectangle->new(figure_type=>"rectangle", color=>"black");
        while(scalar @{$rectangle->get_points()} < 4){
            $rectangle->add_point(ask_point());
        }
        print color($rectangle->get_color());
        print STDOUT "The reactangle area is: " . $rectangle->get_area() . "\n";
        $rectangle->draw();
        print "drawing rectangle in file ... \n";
        $rectangle->draw_in_file();
        print "draw is done in file: rectangle.png\n";
        $rectangle->save_in_db();
        print color('reset');
    }
    elsif($fig eq "triangle" && $command eq "create"){
        print STDOUT "Enter the 3 coordinate points, one each line and axis comma separared\n";

        my $triangle = Triangle->new(figure_type=>"triangle", color=>"blue");
        while(scalar @{$triangle->get_points()} < 3){
            $triangle->add_point(ask_point());
        }

        print color($triangle->get_color());
        print STDOUT "The triangle's area is: " . $triangle->get_area() . "\n";
        $triangle->draw();
        print "drawing triangle in file ... \n";
        $triangle->draw_in_file();
        print "draw is done in file: triangle.png\n";
        $triangle->save_in_db();
        print color('reset');
    }
    elsif($fig eq "circle" && $command eq "create"){
        print STDOUT "Plase enter the center of the circle: \n ";
        my $center = <STDIN>;
        chomp($center);
        print STDOUT "Please enter the radious: \n";
        my $radious = <STDIN>;
        chomp($radious);
        my $circle = Circle->new(radio=>$radious,center=>$center);
        $circle->set_color('green');
        print color($circle->get_color());
        print STDOUT "The circle's area is: " . $circle->get_area() . "\n";
        $circle->draw();
        print "drawing circle in file ... \n";
        $circle->draw_in_file();
        print "draw is done in file: circle.png\n";
        $circle->save_in_db();
        print color('reset');
    }
    elsif($fig eq "square" && $command eq "create"){
        print STDOUT "Enter the 4 coordinate points, one each line and axis comma separared\n";

        my $square = Square->new(figure_type=>"square", color=>"cyan");
        while(scalar @{$square->get_points()} < 4){
            $square->add_point(ask_point());
        }
        print color($square->get_color());
        print STDOUT "The square's area is: " . $square->get_area() . "\n";
        $square->draw();
        print "drawing square in file ... \n";
        $square->draw_in_file();
        print "draw is done in file: square.png\n";
        $square->save_in_db();
        print color('reset');
    }
    else{
        print "$command $fig";
    }

print STDOUT "\n";
1;
__END__

my $circle = Circle->new(radio=>3, center=>"0,0");
print $circle->get_area() . "\n";
$circle->set_color("yellow");
print $circle->get_color() . "\n";
my $triangle = Triangle->new(figure_type=>"triangle", color=>"blue");
$triangle->add_point("15,15");
$triangle->add_point("23,30");
$triangle->add_point("50,25");
print $triangle->get_area() . "\n";