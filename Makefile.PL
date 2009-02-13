use inc::Module::Install;
include 'Module::AutoInstall';

name 'Error-Return';
all_from 'lib/Error/Return.pm';
perl_version '5.006';

requires 'Error';
requires 'Scope::Upper';

test_requires 'Test::More' => '0.70';
extra_tests;

auto_install;
auto_include;
WriteAll;
