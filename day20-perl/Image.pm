use FindBin 1.51 qw( $RealBin );
package Image;

use strict;
use warnings;
use Data::Dumper qw(Dumper);
use experimental 'smartmatch';

use ImageTransform;
use Utils;

sub read_file {
   my ($file) = @_;

   # Read file
   open my $handle, '<', $file;
   chomp(my @lines = <$handle>);
   close $handle;

   #analyse file
   my $current_title = 0;
   my @images = ();
   my @current_data = ();

   foreach my $line (@lines) {
       if ($line eq '') {
           next;
       }
       if(rindex ($line, 'T', 0) == 0) {

           if($current_title != 0) {
               push(@images, Image->new($current_title, @current_data));
           }

           $line =~ /(?<title_number>\d+)/;
           $current_title =  $+{title_number};
           @current_data = ()
       } else {
           push @current_data, [split //, $line];
       }
   }
   push @images, Image->new($current_title, @current_data);

   return @images;
}

sub new {
   my ($class, $title, @data) = @_;
   my $self = {};
   bless $self, $class;

   $self->{title} = $title;
   $self->{data} = \@data;

   return $self;
}

sub top_border {
   my ($self) = @_;
   return Utils::top_border(@{$self->{data}});
}

sub bottom_border {
   my ($self) = @_;
   return Utils::bottom_border(@{$self->{data}});
}

sub left_border() {
   my ($self) = @_;
   return Utils::left_border(@{$self->{data}});
}

sub right_border() {
   my ($self) = @_;
   return Utils::right_border(@{$self->{data}});
}

sub top_condidate {
   my ($self) = @_;
   my @top = $self->top_border();
   return [[@top], [reverse @top]];
}

sub bottom_condidate {
   my ($self) = @_;
   my @bottom = $self->bottom_border();
   return [[@bottom], [reverse @bottom]];
}

sub right_condidate {
   my ($self) = @_;
   my @right = $self->right_border();
   return [[@right], [reverse @right]];
}

sub left_condidate {
   my ($self) = @_;
   my @left = $self->left_border();
   return [[@left], [reverse @left]];
}

sub _has_neighbour {
   my ($values, @condidate) = @_;

   foreach (@{$values}) {
      my $current = $_;
      my @found = grep{ @{$_} ~~ @{$current} } @condidate;
      my $found_size = scalar @found;
      if ($found_size ne 0) {
         return 1
      }
   }

   return 0;
}

sub neighbour_number {
   my ($self, @others) = @_;
   my $neighbour = 0;

   my @tops = map { [$_->top_border()] } @others;
   my @bottoms = map { [$_->bottom_border()] } @others;
   my @lefts = map { [$_->left_border()] } @others;
   my @rights = map { [$_->right_border()] } @others;

   my @other_all_border = (@tops, @bottoms, @lefts, @rights);

   if(_has_neighbour($self->top_condidate(),  @other_all_border)) {
      $neighbour += 1;
   }

   if(_has_neighbour($self->bottom_condidate(), @other_all_border)) {
      $neighbour += 1;
   }

   if(_has_neighbour($self->left_condidate(), @other_all_border)) {
      $neighbour += 1;
   }

   if(_has_neighbour($self->right_condidate(), @other_all_border)) {
      $neighbour += 1;
   }

   return $neighbour;
}

sub get_real_image {
   my ($self) = @_;

   my @lines = @{$self->{data}};
   my $lines_size = scalar @lines;

   my $max_index = $lines_size - 2;

   my @good_lines = @{$self->{data}}[1..$max_index];

   @good_lines = map { [@{$_}[1..$max_index]]} @good_lines;

   return @good_lines;
}

sub get_image_tranforms {
   my ($self) = @_;

   my @result = ();
   push @result, ImageTransform->new('L', 0,  $self->{data}, \&Utils::left_border, $self->{title});
   push @result, ImageTransform->new('L', 1,  $self->{data}, \&Utils::left_border, $self->{title});

   push @result, ImageTransform->new('R', 0, $self->{data}, \&Utils::right_border, $self->{title});
   push @result, ImageTransform->new('R', 1, $self->{data}, \&Utils::right_border, $self->{title});

   push @result, ImageTransform->new('T', 0, $self->{data}, \&Utils::top_border, $self->{title});
   push @result, ImageTransform->new('T', 1, $self->{data}, \&Utils::top_border, $self->{title});

   push @result, ImageTransform->new('B', 0, $self->{data}, \&Utils::bottom_border, $self->{title});
   push @result, ImageTransform->new('B', 1, $self->{data}, \&Utils::bottom_border, $self->{title});

   return @result;
}

1;