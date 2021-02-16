package ImageTransform;

use strict;
use warnings;
use Data::Dumper qw(Dumper);
use experimental 'smartmatch';
use List::MoreUtils qw(first_index);

sub new {
   my ($class, $position, $is_reverse, $image_data, $provider, $title) = @_;
   my $self = {};
   bless $self, $class;

   $self->{position} = $position;
   $self->{is_reverse} = $is_reverse;
   $self->{image_data} = $image_data;
   $self->{provider} = $provider;
   $self->{title} = $title;

   return $self;
}

sub get_corresponing_position {
   my ($class, $position) = @_;

   if($position eq 'L') {
      return 'R';
   }

   if($position eq 'R') {
      return 'L';
   }

   if($position eq 'T') {
      return 'B';
   }

   if($position eq 'B') {
      return 'T';
   }

   return '';
}

sub is_mirror_position {
   my ($self, $target) = @_;

   return $self->{position} eq $self->get_corresponing_position($target);
}

sub is_same_position {
   my ($self, $position) = @_;

   return $self->{position} eq $position;
}

sub get_image_data_ref {
   my ($self) = @_;

   return $self->{image_data};
}

sub get_border {
   my ($self) = @_;
   my @border =  $self->{provider}(@{$self->{image_data}});

   if ($self->{is_reverse}) {
      return reverse @border;
   }

   return @border;
}

sub check_border {
   my ($self, @border_candidate) = @_;
   my @border = $self->get_border();

   return @border ~~ @border_candidate;
}

sub get_rotate_parameter {
   my ($self, $target) = @_;

   my @position_order = qw(L B R T);
   my @image_data = @{$self->get_image_data_ref()};

   my $position_index = first_index { $_ eq $self->{position} } @position_order;
   my $target_index = first_index { $_ eq $target } @position_order;

   my $rotate_order = $target_index - $position_index;

   my $test =  $self->{position};

   $rotate_order = $position_index - 4 if($rotate_order > 1);
   $rotate_order = $position_index + 4 if($rotate_order < -1);

   return $rotate_order > 1;
}

sub reverse_data {
   my ($data, $mirror_line, $mirror_column) = @_;

   my @result = @{$data};

   if($mirror_line) {
      @result = reverse @result;
   }

   if($mirror_column) {
      @result = map { [reverse @{$_}] } @result;
   }

   return @result;
}

sub reverse_image_data {
   my ($self, $mirror) = @_;

   return reverse_data(
      $self->get_image_data_ref(),
      $self->{position} eq 'T' || $self->{position} eq 'B' || $mirror,
      $self->{position} eq 'L' || $self->{position} eq 'R' || $mirror
   );
}

sub get_data_or_mirror{
   my ($self, $data, $mirror) = @_;

   # if (! $mirror) {
   #    return @{$data};
   # }

   return reverse_data(
      $data,
      $self->{position} eq 'L' || $self->{position} eq 'R',
      $self->{position} eq 'T' || $self->{position} eq 'B'
   );
}

sub transform_data {
   my ($self, $target_position, $target_border) = @_;

   # print $self->{title}." ";
   my $is_reverse = $self->{is_reverse};
   my $position = $self->{position};

   my @data = @{$self->get_image_data_ref()};

   if($is_reverse) {
      # print "reverse";
      @data =  reverse_data(
         \@data,
         $position eq 'L' || $position eq 'R',
         $position eq 'T' || $position eq 'B'
      );
   }

   if ($self->is_same_position($target_position)) {
      # print "same $position $target_position $is_reverse\n";
      return @data;
   }

   if ($self->is_mirror_position($target_position)) {
      # print "mirror  $position $target_position $is_reverse\n";
      return  reverse_data(
         \@data,
         $position eq 'T' || $position eq 'B',
         $position eq 'L' || $position eq 'R'
      );
   }

   my $rotate_direction = Utils::get_rotate_order($position, $target_position);
   my @rotate = Utils::rotate_data(\@data, $rotate_direction);

   my $border_provider = Utils::get_transform_from_position($target_position);
   my @new_border = $border_provider->(@rotate);
   
   if (@{$target_border} ~~ @new_border) {
      # print "rotate $position $target_position $is_reverse\n";
      return @rotate;
   }

   my $param = $self->get_rotate_parameter($target_position);

   # print "rotate $position $target_position $is_reverse".join('', @new_border)."->".join('', @{$target_border})."\n";

   return  reverse_data(
      \@rotate,
      $target_position eq 'L' || $target_position eq 'R',
      $target_position eq 'T' || $target_position eq 'B'
   );
}

1;
