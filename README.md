# ks_writer
Perl script to allow standardized semi-custom Kickstart files.

Input files are in ~/input, output files are in ~/output.  :)

```shell
    Usage: ./ks_writer.pl --config data/ks_data.csv

    -c/--config <CONFIG FILE>    

```

# kvm_writer
Perl script to generate standardized semi-custom KVM creation scripts.

Input file is input/setup_new_virtual.sh. Edit it to your needs, keeping
the UPPERCASE words as is.

```shell
  Usage: ./kvm_writer.pl --config data/ks_data.csv

    -c/--config <CONFIG FILE>    

```

