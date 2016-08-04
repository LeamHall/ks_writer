#!/bin/bash

# ks_writer.sh
# version: 0.2
# ks_writer.sh allows you to build a semi-custom kickstart file.

RELEASE=
SUFFIX=
INPUTDIR="./input"
OUTPUTDIR="./output"

if [ -f 'default' ]
then
  . default
fi

HELP="Usage: $0 [-o OUTFILE] [-s SUFFIX] [-r RELEASE]
  -o            # Output file name
  -h            # This help note
  -s SUFFIX     # Will look for files with that suffix
  -r RELEASE    # Will look for files with that relase number

    $0 will reference a file named 'default' for default settings.
    Command line arguments supercede the defaults.

    Sample usage:
    $0 -r 6 -s webserver -o www.ks.cfg 

    Will source the default file, override $RELEASE to '6', 
    $SUFFIX to 'webserver', and write to file 'www.ks.cfg'.
"

while getopts "ho:r:s:" opt
do
  case $opt in 
    r)
       RELEASE=$OPTARG
       ;;
    s)
       SUFFIX=$OPTARG
       ;;
    o)
       FILE=`basename ${OPTARG}`
       OUTFILE="${OUTPUTDIR}/${OPTARG}"
       ;;
    h)
       echo "$HELP"
       exit
       ;;
     *)
       echo "Sorry, I don't understand $OPTARG."
       exit
       ;; 
    esac
done

if [ -z $RELEASE  ]
then
  echo "Please provide a release number."
  exit
fi

if [ -f "$OUTFILE" ]
then
  > $OUTFILE
fi

for file in install network services partitions packages pre post
do
  if [ -f "${INPUTDIR}/${file}.${RELEASE}.${SUFFIX}" ]
    then
    if [ -z $OUTFILE ]
    then
      cat ${INPUTDIR}/${file}.${RELEASE}.${SUFFIX}
    else
      cat ${INPUTDIR}/${file}.${RELEASE}.${SUFFIX} >> $OUTFILE
    fi
  elif [ -f "${INPUTDIR}/${file}.${SUFFIX}" ]
    then
    if [ -z $OUTFILE ]
    then
      cat ${INPUTDIR}/${file}.${SUFFIX}
    else
      cat ${INPUTDIR}/${file}.${SUFFIX} >> $OUTFILE
    fi
  elif [ -f "${INPUTDIR}/${file}.${RELEASE}" ]
    then
    if [ -z $OUTFILE ]
    then
      cat ${INPUTDIR}/${file}.${RELEASE}
    else
      cat ${INPUTDIR}/${file}.${RELEASE} >> $OUTFILE
    fi
  else
    if [ -z $OUTFILE ]
    then
      cat ${INPUTDIR}/${file}
    else
      cat ${INPUTDIR}/${file} >> ./$OUTFILE
    fi
  fi
done
