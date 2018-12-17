#!/usr/bin/env perl
#
# write_kickstart.pl
#
use strict;
use warnings;
use 5.008_004;
use Getopt::Long;

my $version = '7';
my $config;
my $output;
my $network;
my $host_ip;
my $gateway;
my $hostname;
my $ip;
my $gw;
my $input_dir = 'input';
my $output_dir = 'output';
my $ks_file;

GetOptions(
  "config=s"  => \$config,
  );

open CONFIG,  '<', "$config" or die $!;
while (<CONFIG>) {
  next if ( $_ =~ m/\#/);
  chomp;
  my ($version, $network, $host_ip, $gateway, $hostname) = split(':'); 

  open INSTALL,  '<', "$input_dir/install_$version" or die $!;
  my $install  = do { local $/; <INSTALL>};
  close INSTALL;
  open PARTITIONS,      '<', "$input_dir/partitions_$version" or die $!;
  my $partitions = do { local $/; <PARTITIONS> };
  close PARTITIONS;
  open SERVICES,      '<', "$input_dir/services_$version" or die $!;
  my $services = do { local $/; <SERVICES> };
  close SERVICES;
  open NETWORK,      '<', "$input_dir/network_$version" or die $!;
  my $network_string = do { local $/; <NETWORK> };
  close NETWORK;

  $ks_file = $hostname . "_ks.cfg"; 
  open OUTPUT, '>', "$output_dir/$ks_file" or die $!;
  select OUTPUT;
  print $install;
  $ip = $network . '.' . $host_ip;
  $gw = $network . '.' . $gateway;
  $network_string =~ s/(.*)IP(.*)GATEWAY(.*)HOSTNAME(.*)/$1 $ip $2 $gw $3 $hostname $4/;
  print $network_string;
  print $services;
  print $partitions;
  close OUTPUT;
}
close CONFIG;
