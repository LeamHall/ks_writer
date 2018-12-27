#!/usr/bin/env perl
#
# kvm_writer.pl
#
# Usage:
#   ./kvm_writer.pl -c data/ks_data.csv
#
# Notes: 
#   Edit the files in input/ to suit your environment.

use strict;
use warnings;
use 5.008_004;
use Getopt::Long;

my $version = '7';
my $config;
my $network;
my $host_ip;
my $gateway;
my $hostname;
my $ip;
my $gw;
my $input_dir = 'input';
my $output_dir = 'output';
my $kvm_file;

GetOptions(
  "config=s"  => \$config,
  );

open my $CONFIG,  '<', "$config" or die $!;
while (<$CONFIG>) {
  next if ( $_ =~ m/\#/);
  chomp;
  next unless ( $_ );
  my ( $version, $network, $host_ip, $gateway, $hostname, $disktype ) = split(':'); 
  next unless ( $disktype eq 'v' ); 
  open my $BASE_FILE, '<', "$input_dir/setup_new_virtual.sh" or die $!;
  my $kvm_string = do { local $/; <$BASE_FILE> };
  close $BASE_FILE;
 
  $kvm_file = "setup_" . $hostname . "_virtual.sh"; 
  open my $OUTPUT, '>', "$output_dir/$kvm_file" or die $!;
  select $OUTPUT;

  $ip = $network . '.' . $host_ip;
  $kvm_string =~ s/VERSION/$version/;
  $kvm_string =~ s/IP/$ip/;
  $kvm_string =~ s/HOSTNAME/$hostname/g;
  print $kvm_string;

  close $OUTPUT;
}
close $CONFIG;
