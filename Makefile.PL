use inc::Module::Install;
include 'Module::AutoInstall';

name 'YAML-Active';
all_from 'lib/YAML/Active.pm';
perl_version '5.006';

requires 'YAML::XS';
requires 'Class::Accessor';
requires 'Class::Accessor::Complex';

recommends 'Test::Pod';
recommends 'Test::Pod::Coverage';

test_requires 'Test::More' => '0.70';
test_requires 'Test::Compile';

auto_install;
auto_include;
WriteAll;
