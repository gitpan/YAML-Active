use inc::Module::Install;
name 'YAML-Active';
all_from 'lib/YAML/Active.pm';
perl_version '5.006';

requires 'YAML';
requires 'Class::Accessor';
requires 'Class::Accessor::Complex';

build_requires 'Test::More' => '0.70';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
