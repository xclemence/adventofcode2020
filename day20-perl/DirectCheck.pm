package DirectCheck;

use strict;
use warnings;
use experimental 'smartmatch';

sub new {
   my ($class, $provider, $border) = @_;
   my $self = {};
   bless $self, $class;

   $self->{provider} = $provider;
   $self->{border} = $border;

   return $self;
}

sub is_valid {
   my ($self, $image) = @_;
   my @candidate_border = $self->{provider}($image);
   return @candidate_border ~~ @{$self->{border}};
}

1;
