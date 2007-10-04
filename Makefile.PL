use inc::Module::Install;
name 'YAML-Active';
all_from 'lib/YAML/Active.pm';

requires 'YAML';

build_requires 'Test::More';

use_standard_tests(without => 'pod_coverage');
auto_include;
WriteAll;
