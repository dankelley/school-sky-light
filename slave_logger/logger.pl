#!/usr/bin/perl
use strict;
use warnings;
use IO::Handle;
use Device::SerialPort;
my $dev = tie (*FH, 'Device::SerialPort', "/dev/tty.usbmodem3a21") || die "Can't tie: $!";
$dev->baudrate(9600);
$dev->databits(8);
$dev->parity("none");
$dev->stopbits(1);

open (my $log, '>>', 'slave_logger.log') || die "can't open: $!";
$log->autoflush(1);

print FH "3\n";
while (1) {
    my $val = <FH>;
    next unless $val;
    chomp $val;

    print $log time . ' ' . $val . "\n";
    print STDERR time . ' ' . $val . "\n";

    sleep 10;
    print FH "3\n";
}
