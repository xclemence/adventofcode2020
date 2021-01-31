package BorderCheck;

use strict;
use warnings;

use Utils;

sub new {
   my ($class, $images, $provider) = @_;
   my $self = {};
   bless $self, $class;

   $self->{images} = $images;
   $self->{provider} = $provider;

   return $self;
}

sub is_valid {
   my ($self, $image) = @_;

   my @border = $self->{provider}($image);

   my @result = Utils::get_corresponding_images('', $self->{images}, @border);

   my $size_result = scalar @result;

   return $size_result == 0;
}

1;
