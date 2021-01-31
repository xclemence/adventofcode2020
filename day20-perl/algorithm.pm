use FindBin 1.51 qw( $RealBin );
package Algorithm;
use Data::Dumper qw(Dumper);
use experimental 'smartmatch';

use Image;
use Utils;
use BorderCheck;

sub compute_right_order {
    my ($images, $first_item) = @_;
    
    my @new_line = ();
    push @new_line, $first_item;

    my ($found_imge, $ordered_image) = (undef, $first_item);

    do {
        my $size = scalar @{$images};
        ($found_image, $ordered_image) = get_corresponding_image('L', $images, $ordered_image->right_border());

        if($ordered_image) {
            @{$images} = grep{ $_->{title} ne $ordered_image->{title} } @{$images};
            push @new_line, $ordered_image;
        }
    } while ($ordered_image);

    return @new_line;
}

sub get_corners {
    my (@images) = @_;
    my @corners = ();

    foreach (@images) {
        my $current = $_;

        my @others = grep{ $_->{title} ne $current->{title} } @images;
        my $neighbour = $current->neighbour_number(@others);

        if ($neighbour eq 2) {
            push @corners, $_;
        }
    }

    return @corners;
}

sub get_border_positions {
    my ($border_image, $images) = @_;

    my @position = ();
    my @neighbour = Utils::get_corresponding_images('', $images, $border_image->left_border());
    push @position, 'L' if (scalar(@neighbour) == 0);

    @neighbour = Utils::get_corresponding_images('', $images, $border_image->bottom_border());
    push @position, 'B' if (scalar(@neighbour) == 0);

    @neighbour = Utils::get_corresponding_images('', $images, $border_image->right_border());
    push @position, 'R' if (scalar(@neighbour) == 0);

    @neighbour = Utils::get_corresponding_images('', $images, $border_image->top_border());
    push @position, 'T' if (scalar(@neighbour) == 0);
    
    return @position;
}

sub oriente_corner_image {
    my ($border_image, @border_positions) = @_;

    my %reference = (
                      'T' => 0,
                      'L' => 1,
                      'B' => 2,
                      'R' => 3,
                    );

    my $last_index = $reference{$border_positions[1]};

    my $delta = $reference{$border_positions[1]} - $reference{$border_positions[0]};

    if ($delta > 0) {
        $last_index = $reference{$border_positions[1]};
    }

    if ($delta < 0) {
        $last_index = $reference{$border_positions[0]};
    }

    if ($delta > 1) {
        $last_index = $reference{$border_positions[0]};
    }

    if ($delta < 1) {
        $last_index = $reference{$border_positions[1]};
    }

    my @data = @{$border_image->{data}};
    while ($last_index != 1) {
        @data = Utils::rotate_data(\@data, 1);
        $last_index++;
        $last_index %= 4;
    }

    return Image->new($border_image->{title}, @data);
}

sub order_image_v2 {
    my (@images) = @_;

    my @corners = get_corners(@images);

    my $use_corner = $corners[0];

    @images = grep{ $_->{title} ne $use_corner->{title} } @images;

    my @border_positions = get_border_positions($use_corner, \@images);

    $use_corner = oriente_corner_image($use_corner, @border_positions);

    my @ordered_images = ();
    my @current_line = ();

    my $top_check = BorderCheck->new(\@images, \&Image::top_border);

    # right part
    my $oriented_image = $use_corner;

    push @current_line, $oriented_image;

    do {
        @border = $oriented_image->right_border();
        $oriented_image = Utils::get_corresponding_images_with_check(
                                                        'L', 
                                                        \@images,
                                                        \@border,
                                                        ($top_check));
        if($oriented_image) {
            @images = grep{ $_->{title} ne $oriented_image->{title} } @images;
            push @current_line, $oriented_image;
        }
    } while ($oriented_image);

    while (@current_line) {
        push @ordered_images, [@current_line];
        @current_line = get_ordered_line(\@images, @current_line);
    }

    return @ordered_images;
}

sub get_ordered_line {
    my ($images, @previous_line) = @_;

    my @current_line = ();
    foreach (@previous_line) {
        my @border = $_->bottom_border();
        my $oriented_image = Utils::get_corresponding_images_with_check('T', $images, \@border, ());

        if($oriented_image) {
            @{$images} = grep{ $_->{title} ne $oriented_image->{title} } @{$images};
            push @current_line, $oriented_image;
        }
        else {
            return ();
        }
    }

    return @current_line;
}

sub generate_full_image_lines {
    my (@images) = @_;

    my @lines = ();

    my @real_image =  map { [$_->get_real_image()] } @images;

    my $image_max_index = scalar @{$real_image[0]} - 1;

    for my $i (0..$image_max_index) {
        my @items = flatten(map { @{$_}[$i] } @real_image);

        my $size_test  = scalar @items;

        push @lines, [@items];
    }

    return @lines;
}

sub flatten {
  return map { ref $_ ? flatten(@{$_}) : $_ } @_;
}

sub generate_full_image {
    my (@images) = @_;

    my @lines = ();

    for (@images) {
        my @line_images = @{$_};
        push @lines, generate_full_image_lines(@line_images);
    }

    return @lines;
}

sub identify_monster_on_area {
    my ($image, $start_line, $start_column, @moster) = @_;

    my @image_data = @{$image};

    for (@moster) {
        my @position = @{$_};
        my $line_index = $position[0] + $start_line;
        my $column_index = $position[1] + $start_column;

        if($image_data[$line_index][$column_index] ne '#') {
            return 0;
        }
    }

    for (@moster) {
        my @position = @{$_};
        my $line_index = $position[0] + $start_line;
        my $column_index = $position[1] + $start_column;

        $image_data[$line_index][$column_index] = 'O';
    }

    return 1;
}

sub identify_monster {
    my ($image, @moster) = @_;

    my @image_data = @{$image};

    my $motif_line_size = 3;
    my $motif_column_size = 20;

    my $line_max_index = scalar @image_data - $motif_line_size - 1;
    my $column_max_index = scalar @{$image_data[0]} - $motif_column_size - 1;

    for my $i (0..$line_max_index) {
        for my $j (0..$line_max_index) {
            identify_monster_on_area($image, $i, $j, @moster);
        }
    }

    return 1;
}

sub rough_number {
    my ($image) = @_;

    my (@image_data) = @{$image};
    my $sum_values = 0;

    for (@image_data) {
        my @line = @{$_};
        $sum_values += grep { $_ eq '#' } @line;
    }

    return $sum_values;
}

1;
