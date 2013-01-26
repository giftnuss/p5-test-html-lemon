
use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::HTML::Clear',
    license             => 'perl',
    dist_author         => q{Sebastian Knapp <sk@computer-leipzig.com>},
    dist_version_from   => 'lib/Test/HTML/Clear.pm',
    build_requires => {
        'Test::More' => 0,
        'Module::Build' => '0.40'
    },
    requires => {
        'perl' => 5.008_001
    },
    add_to_cleanup      => [ 'Test-HTML-Clear-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();