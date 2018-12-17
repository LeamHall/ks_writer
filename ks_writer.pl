#!/usr/bin/env perl
#
# write_kickstart.pl
#
use strict;
use warnings;
use 5.008_004;
use Getopt::Long;


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
my $string = "server IP GATEWAY connects as HOSTNAME\n";
my $new_string;

GetOptions(
  "config=s"  => \$config,
  );

open HEADER,  '<', "$input_dir/header.txt" or die $!;
my $header  = do { local $/; <HEADER>};
close HEADER;

open FS,      '<', "$input_dir/fs.txt" or die $!;
my $fs = do { local $/; <FS> };
close FS;

open CONFIG,  '<', "$config" or die $!;
while (<CONFIG>) {
  next if ( $_ =~ m/\#/);
  chomp;
  $new_string = $string;
  ($network, $host_ip, $gateway, $hostname) = split(':'); 
  $ks_file = $hostname . "_ks.cfg"; 
  open OUTPUT, '>', "$output_dir/$ks_file" or die $!;
  select OUTPUT;
  print $header;
  print $fs;
  $ip = $network . '.' . $host_ip;
  $gw = $network . '.' . $gateway;
  $new_string =~ s/(.*)IP(.*)GATEWAY(.*)HOSTNAME(.*)/$1 $ip $2 $gw $3 $hostname $4/;
  print $new_string;
  close OUTPUT;
}
close CONFIG;
