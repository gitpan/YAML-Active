package YAML::Active::Plugin::Hash;

# $Id: Hash.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active qw/assert_hashref hash_activate yaml_NULL/;


our $VERSION = '1.05';


use base 'YAML::Active::Plugin';


# Differentiate between normal plugin args, args prefixed with a single
# underscore, and args prefixed with a double underscore. Double underscore
# args are for the YAML::Active mechanism itself - things like '__phase'.
# Single underscore args can be used by specific plugins as they wish.

# We need to prefix all members with __ so they're not confused with the
# actual args used in the YAML.

YAML::Active::Plugin::Hash->mk_hash_accessors(qw(__hash));


sub run_plugin {
    my $self = shift;
    assert_hashref($self);
    $self->__hash(
        hash_activate(scalar($self->get_args($self)), $self->__phase)
    );
    yaml_NULL();
}


sub get_args {
    my ($self, $hash) = @_;

    # Get the actual args used in the YAML file; don't just copy %self,
    # because we don't want the properties of this object to be confused with
    # the YAML data, which would lead to endless recursion

    my %args;
    while (my ($key, $value) = each %$hash) {
        next if substr($key, 0, 2) eq '__';
        $args{$key} = $value;
    }

    wantarray ? %args : \%args;
}


1;
