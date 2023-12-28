use strict;
use warnings;
use ExtUtils::MakeMaker;

if (! -f '/usr/include/gpiod.h'){
    print "libgpiod-dev is not installed, exiting...\n";
#    exit;
}

WriteMakefile(
    NAME              => 'RPi::GPIOD',
    VERSION_FROM      => 'lib/RPi/GPIOD.pm',
    PREREQ_PM         => {},
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/RPi/GPIOD.pm',
       AUTHOR         => 'Adimarantis <adimarantis@gmail.com>') : ()
    ),
    META_MERGE => {
        'meta-spec' => { version => 1 },
        resources   => {
            bugtracker => {
                web => 'https://github.com/bublath/rpi-gpiod/issues',
            },
            repository => {
                type => 'git',
                url => 'https://github.com/bublath/rpi-gpiod.git',
                web => 'https://github.com/bublath/rpi-gpiod',
            },
        },
    },
    BUILD_REQUIRES => {
        'Test::More' => 1.302078,
    },
    LIBS              => ['-L/usr/lib/arm-linux-gnueabihf -lgpiod -lrt'],
    DEFINE            => '',
    INC               => '-I.',
);
