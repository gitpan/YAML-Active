#!/usr/bin/perl

use warnings;
use strict;

use 5.006001;
use Module::Build;

Module::Build->new(
        module_name  => 'YAML::Active',
        license      => 'perl',
        requires     => {
            'perl' => '5.6.1',
            'YAML' => 0.35,
        },
    )->create_build_script;
