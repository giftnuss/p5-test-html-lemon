
use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::HTML::Lemon',
    license             => 'perl',
    dist_abstract       => 'a HTML test module',
    dist_author         => q{Sebastian Knapp <sk@computer-leipzig.com>},
    dist_version_from   => 'lib/Test/HTML/Lemon.pm',
    build_requires => {
        'Test::More' => 0,
        'Test::Builder::Tester' => 0,
        'Module::Build' => '0.40'
    },
    requires => {
        'perl' => 5.008_001,
        'parent' => 0,
        'HTML::Parser' => 0,
        'Test::Builder' => 0
    },
    add_to_cleanup      => [ 'Test-HTML-Lemon-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
