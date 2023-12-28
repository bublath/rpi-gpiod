package RPi::GPIOD;
use strict;
use warnings;

use Carp qw(croak);

our $VERSION = '1.0';

my $chipID;

require XSLoader;
XSLoader::load('RPi::GPIOD', $VERSION);

sub new {
    my ($class, $chip, $debug) = @_;

	$chip=0 if !defined $chip;
	
	$chipID=$chip;

    my $self = bless {}, $class;

    my $ret=c_openChip($chip);

    $debug=0 unless defined $debug;

    return $self;
}

sub openGPIO {
    my ($self, $gpio) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_openGPIO($gpio);
}

sub set {
    my ($self, $gpio, $val) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_setGPIO($gpio,$val);
}

sub output {
    my ($self, $gpio) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_setOutput($gpio);
}

sub input {
    my ($self, $gpio) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_setOutput($gpio);
}

sub get {
    my ($self, $gpio) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_getGPIO($gpio);
}

sub closeGPIO {
    my ($self, $gpio) = @_;
	croak "You must supply a gpio number\n" if ! defined $gpio;
	return c_closeGPIO($gpio);
}

sub DESTROY {
    my $self = shift;
    my $ret=c_closeChip();
}
1;
__END__

=head1 NAME

RPi::GPIOD - Work with Raspberry Pi GPIOs via libgpio/gpiod

=head1 SYNOPSIS

use RPi::GPIOD;
 
my $chip = 0;
my $gpio = 21;
my $state;

my $env = RPi::GPIOD->new($chip,1);

$env->openGPIO($gpio);
$env->output($gpio);
$state=$env->get($gpio);
print "1: $state \n";
$env->set($gpio,1);
$state=$env->get($gpio);
print "2: $state \n";
sleep(1);
$env->set($gpio,0);
$state=$env->get($gpio);
print "3: $state \n";
$env->closeGPIO($gpio);
$env=undef;

=head1 DESCRIPTION

This module provides a Perl interface to Raspberry Pi GPIOs via libgpio

=head1 METHODS

=head2 new($chip, $debug)

Initalizes the object for usage.

Parameters:

    $chip

Typically 0

    $debug

Optional: Bool. True, C<1> to enable debug output, False, C<0> to disable.


=head1 AUTHOR

Adimarantis (adimarantis@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright 2023 Adimarantis

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.
