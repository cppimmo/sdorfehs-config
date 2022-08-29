#!/usr/bin/perl
use strict;
use warnings;
use Readonly;

# TODO: try to implement a wlan interface status and connection SSID or local IP.
# NOTE: This file requires the Readonly package and brightnessctl.
# https://unix.stackexchange.com/questions/352031/how-to-find-status-of-wlan0
# Constants.
Readonly my $HOME => $ENV{HOME};
# For some reason this amount of spaces doesn't render.
Readonly my $PADDING_RIGHT => 20;
Readonly my $SEPARATOR => ' | ';
Readonly my $UPTIME_SINCE_STRING => `uptime -s`;
Readonly my $UPTIME_STRING => `date -d "$UPTIME_SINCE_STRING" '+UP:%d-%b-%Y %T' | tr a-z A-Z`;
Readonly my $FIFO_BAR_FILE => "$HOME/.config/sdorfehs/bar";
Readonly my $BATTERY_CAPACITY_FILE => "/sys/class/power_supply/BAT0/capacity";
# "Globals".
# my $barFile;
my $batteryFile;

sub Init {
	# open(my $barFile, '>', "$FIFO_BAR_FILE") or die "Error: $!";
	open($batteryFile, '<', "$BATTERY_CAPACITY_FILE") or die "Error: $!";
}

sub Quit {
	# close($barFile);
	close($batteryFile);
}

sub BatteryPercentage {
	seek($batteryFile, 0, 0);
	return <$batteryFile>;
}

sub BrightnessPercentage {
	my $brightnessActual = `brightnessctl get`;
	my $brightnessMax = `brightnessctl max`;
	return ($brightnessActual / $brightnessMax) * 100.0;
}

sub DateTimeNow {
	return `date +'T:%d-%b-%Y %T' | tr a-z A-Z`;
}

sub DoLoop {
	while (1) {
		my $statusString = '';

		$statusString = sprintf('BAT:%02.0f%%', BatteryPercentage()) . $SEPARATOR;
		$statusString = $statusString
			. sprintf("BRT:%02.0f%%", BrightnessPercentage())
			. $SEPARATOR;
		$statusString = $statusString . DateTimeNow() . $SEPARATOR;
		$statusString = $statusString . $UPTIME_STRING;
		
		# Remove newlines from string. Sdorfehs bar considers newlines as EOF.
		$statusString =~ s/[\n]//g;
		for (my $i = 0; $i < $PADDING_RIGHT; ++$i) {
			$statusString = $statusString . ' ';
		}

		# seek($barFile, 0, 0);
		# print $barFile $statusString;
		#print $statusString;
		my $result = system("echo '$statusString' > $FIFO_BAR_FILE");
		# truncate($barFile, tell($barFile));
		sleep(1);
	}
}

Init();
DoLoop();
Quit();
exit(0);

