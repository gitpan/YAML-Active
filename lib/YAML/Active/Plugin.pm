package YAML::Active::Plugin;

# $Id: Plugin.pm 9177 2005-06-14 12:33:38Z gr $

use warnings;
use strict;
use YAML::Active 'yaml_NULL';


our $VERSION = '1.02';


use Class::MethodMaker
    [ scalar => '__phase',
    ];


sub yaml_activate {
    my ($self, $phase) = @_;
    $self->__phase($phase);
    $self->run_plugin;
}


sub run_plugin {
    my $self = shift;
    yaml_NULL();
}


1;
