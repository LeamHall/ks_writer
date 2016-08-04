# ks_writer
Bash script to allow standardized semi-custom Kickstart files.

Input files are in ~/input, and the output files are in ~/output as you might imagine.  :)

```shell
    Usage: ./ks_writer.sh [-o OUTFILE] [-s SUFFIX] [-r RELEASE]

    -o            # Output file name

    -h            # This help note

    -s SUFFIX     # Will look for files with that suffix

    -r RELEASE    # Will look for files with that relase number

    ./ks_writer.sh will reference a file named 'default' for default settings.
    Command line arguments supercede the defaults.

    Sample usage:
    ./ks_writer.sh -r 6 -s webserver -o www.ks.cfg 

    Will source the default file, override 6 to '6', 
    local to 'webserver', and write to file 'www.ks.cfg'.
```
