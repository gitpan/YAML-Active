package YAML::Active::Plugin::Array;

# $Id: Array.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active qw/assert_arrayref array_activate yaml_NULL/;

use base 'YAML::Active::Plugin';


our $VERSION = '1.02';


use Class::MethodMaker
    [ array => '__array',
    ];


sub run_plugin {
    my $self = shift;
    assert_arrayref($self);
    $self->__array(array_activate($self, $self->__phase));

    yaml_NULL();
}


1;
