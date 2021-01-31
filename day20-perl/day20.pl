use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

use strict;
use warnings;
use Data::Dumper qw(Dumper);
use experimental 'smartmatch';

use Image;
use ImageTransform;
use Algorithm;
use DirectCheck;
use Display;

my @images = Image::read_file('data/data0');

print "------------------------\n";
my $size = scalar @images;
print " $size\n";
print "------------------------\n";


# Step 1
print "------------------------\n";
print "----------Step 1--------\n";
print "------------------------\n";


my @corners = Algorithm::get_corners(@images);
my @corners_titles = map {$_->{title}} @corners;
print join '|', @corners_titles;
my $total = eval join '*', @corners_titles;
print " total : $total \n";
print "------------------------\n";


# Step 2
print "------------------------\n";
print "----------Step 2--------\n";
print "------------------------\n";


my @result = Algorithm::order_image_v2(@images);
my @real_image = Algorithm::generate_full_image(@result);

Display::display_title_image(@result);
print "------------------------\n";

my @monster = Utils::read_monster('data/monster');

my $test = Algorithm::identify_monster(\@real_image, @monster);

Display::display_data(\@real_image);

my $sum_values = Algorithm::rough_number(\@real_image);

print "final result = $sum_values\n"
