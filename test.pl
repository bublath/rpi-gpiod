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
#$env->closeGPIO($gpio);
$env=undef;
