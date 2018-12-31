#!/usr/bin/env perl
#
# write_kickstart.pl
#
# Usage:
#   ./ks_writer.pl -c data/ks_data.csv
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
my $ks_file;

GetOptions(
  "config=s"  => \$config,
  );

open CONFIG,  '<', "$config" or die $!;
while (<CONFIG>) {
  next if ( $_ =~ m/\#/);
  chomp;
  next unless ( $_);
  my ($version, $network, $host_ip, $gateway, $hostname, $disktype, $diskletter) = split(':'); 
  $diskletter = 'a' unless $diskletter;
  
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
  open PACKAGES,      '<', "$input_dir/packages_$version" or die $!;
  my $packages = do { local $/; <PACKAGES> };
  close PACKAGES;
  open PRE,      '<', "$input_dir/pre_$version" or die $!;
  my $pre = do { local $/; <PRE> };
  close PRE;
  open POST,      '<', "$input_dir/post_$version" or die $!;
  my $post = do { local $/; <POST> };
  close POST;
  
  $ks_file = $hostname . "_ks.cfg"; 
  open OUTPUT, '>', "$output_dir/$ks_file" or die $!;
  select OUTPUT;

  print $install;
  $ip = $network . '.' . $host_ip;
  $gw = $network . '.' . $gateway;
  $network_string =~ s/GATEWAY/$gw/;
  $network_string =~ s/IP/$ip/;
  $network_string =~ s/HOSTNAME/$hostname/;
  print $network_string;

  $services       =~ s/DISKTYPE/$disktype/g;
  print $services;
  
  $partitions     =~ s/DISKTYPE/$disktype/g;
  $partitions     =~ s/DISKLETTER/$diskletter/g;
  print $partitions;
  print $packages;
  print $pre;
  print $post;

  close OUTPUT;
}
close CONFIG;
