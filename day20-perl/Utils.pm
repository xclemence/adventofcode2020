use FindBin 1.51 qw( $RealBin );
package Utils;
use experimental 'smartmatch';
use List::MoreUtils qw(first_index);

use Image;

sub get_corresponding_images {
    my ($target, $images, @border) = @_;

    my @images = @{$images};

    my @image_result = ();

    for (@images) {
        my @transform = $_->get_image_tranforms();
        my @found = grep{ $_->check_border(@border) } @transform;

        my $found_size = scalar @found;
        if ($found_size ne 0) {
            if ($target eq '') {
                push @image_result, $_;
            }
            else {
               my $new_image = Image->new($_->{title}, $found[0]->transform_data($target, \@border));
               push @image_result, $new_image;
            }
        }
    }

    return @image_result;
}

sub get_corresponding_images_with_check {
   my ($target, $images, $border, @addintional_check) = @_;

   my @local_border = @{$border};

   my @images_candidates = get_corresponding_images($target, $images, @local_border);

   my $number = scalar @images_candidates;

   for (@images_candidates) {
      if (satisfy_checks($_, @addintional_check)) {
         return $_;
      }
   }

   return undef;
}

sub satisfy_checks {
   my ($image, @addintional_checks) = @_;

   for (@addintional_checks) {
      if(!$_->is_valid($image)) {
         return false;
      }
   }
   return true;

}

sub rotate_data {
   my ($data, $anti_horaire) = @_;

   my @image_data = @{$data};

   my $max_index = (scalar @image_data) - 1;

   my @result = ();

   for my $current_column (0..$max_index) {
      my $column_index = $anti_horaire ? $max_index - $current_column : $current_column;

      my @new_line = ();

      for my $current_line (0..$max_index) {
         my $line_index = $anti_horaire ? $current_line : $max_index - $current_line;

         push @new_line, $image_data[$line_index][$column_index];
      }

      push @result, [@new_line];
   }

   return @result;
}


sub top_border {
   my (@data) = @_;
   my @top = @{ $data[0] };

   return @top;
}

sub bottom_border {
   my (@data) = @_;

   my $size = scalar @data;
   my $bottom = $data[$size - 1];

   return @{$bottom};
}

sub left_border {
   my (@data) = @_;

   my @left = map { @{$_}[0]} @data;

   return @left;
}

sub right_border {
   my (@data) = @_;

   my $line = $data[0];
   my $size = scalar @{$line};

   my @right = map { @{$_}[$size - 1]} @data;

   return @right;
}

sub get_transform_from_position {
   my ($position) = @_;

   my %reference = (
                      'T' => \&top_border,
                      'L' => \&left_border,
                      'B' => \&bottom_border,
                      'R' => \&right_border,
                    );

   return $reference{$position}
}

sub get_rotate_order {
   my ($position, $target) = @_;

   my @postion_order = qw(L B R T);

   my $postion_index = first_index { $_ eq $position } @postion_order;
   my $target_index = first_index { $_ eq $target } @postion_order;

   my $rotate_order = $target_index - $postion_index;

   $rotate_order = $rotate_order - 4 if($rotate_order > 1);
   $rotate_order = $rotate_order + 4 if($rotate_order < -1);

   return $rotate_order > 0;
}

sub read_monster {
   my ($file) = @_;

   # Read file
   open my $handle, '<', $file;
   chomp(my @lines = <$handle>);
   close $handle;

   #analyse file
   my $line_index = 0;
   my $column_index = 0;
   my @monster = ();

   foreach my $line (@lines) {
      $column_index = index ($line, '#', 0);
       while($column_index != -1) {
         push @monster, [$line_index, $column_index];
         $column_index = index ($line, '#', $column_index + 1);
       }
      $line_index += 1;
   }

   return @monster;
}
 

1;
