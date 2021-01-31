package Display;

sub display_data {
    my ($data) = @_;

    for (@{$data}) {
        my $line  = join('', @{$_});
        print "$line\n"
    }
}

sub display_title_image {
   my (@images) = @_;

   for (@images) {
      display_line_title(@{$_});
      print "\n";
   }
  
}

sub display_line_title {
   my (@images) = @_;
   for (@images) {
      print $_->{title}." ";
   }
   print "\n";
}

sub display_full_image {
   my (@images) = @_;

   for (@images) {
      display_line_image(@{$_});
      print "\n";
   }
}

sub display_line_image {
   my (@images) = @_;

   my $size = @{$images[0]->{data}} - 1;

   for my $i (0..$size) {
      for (@images) {
         my @data = @{$_->{data}};
         display_list(@{$data[$i]});
      }
      print "\n";
   }
}

sub display_list {
   my (@line_data) = @_;
   
   my $line  = join('', @line_data);
   print "$line ";
}

1;