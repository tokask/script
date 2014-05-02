#!/bin/bash
# This script will clone the root partition of your gentoo system to a selected
# partition and create the appropriate fstab file for the cloned partition

#################################################################################

# Change these variables according to your prefs, for CLONE_DIR always use a path
# like /dir1/dir2, never something like /dir or /dir1/dir2/dir3...
# CLONE_DIR either have to be defined in /etc/fstab, or mounted...
# BIND_DIR is a directory to mount - bind your root partition (it is needed for your
# gentoo system which uses devfs - otherwise /dev will not be correctly copied...
# If you do not want to change the fstab file for your cloned partition, set
# FSTAB_FLAG to 0...

BIND_DIR=/mnt/oldroot
CLONE_DIR=/mnt/clone
FSTAB_FLAG=1

#################################################################################
# Do not change these:
SOURCE_DIR=/   
CREATE_BIND_DIR=0
MOUNT_CLONE_DIR=0

###################### Subroutines ##############################################
#_____________________________________________________________________________
Check_params()

# Checks whether your destination partition is mounted or exist in /etc/fstab
# and checks for the need to create mount points
{
   SOURCE_PART=`grep "$SOURCE_DIR\ " /etc/mtab | awk  '{ print $1 }'`
   grep "$CLONE_DIR\ " /etc/mtab &> /dev/null
   if [ $? -ne 0 ]
      then
         grep "^[\ \t]*.*$CLONE_DIR\ " /etc/fstab &> /dev/null
         if [ $? -ne 0 ]
         then
            echo
            echo $CLONE_DIR is not listed in /etc/fstab as a valid mount point. Please either
            echo list it in your fstab, so it can be automatically mounted, or mount a partition
            echo on it !
            echo
            Usage
            exit 1
         else
            CLONED_PART=`grep "^[\ \t]*.*$CLONE_DIR" /etc/fstab | awk  '{ print $1 }'`
            if [ ! -d $CLONE_DIR ]
               then
                  mkdir $CLONE_DIR
            fi   
            MOUNT_CLONE_DIR=1
         fi
      else CLONED_PART=`grep "$CLONE_DIR" /etc/mtab | awk  '{ print $1 }'`
   fi
   if [ ! -d $BIND_DIR ]
      then
         CREATE_BIND_DIR=1
   fi   
}
#_____________________________________________________________________________
Usage() # Prints some help
{
   echo
   echo "############## gent-clone help #####################"
   echo
   echo "This script will clone your gentoo root partition to "
   echo "another partition. Usage:"
   echo
   echo "gent-clone mode [destination mount point]"
   echo
   echo 'where mode = "-c"  Clones current root partition to a destination partition'
   echo '           = "-p"  Prentend cloning; useful to see what would happen without any changes'
   echo '           = "-h"  Prints this message...'
   echo 
   echo 'Destination mount point should be given as /dir1/dir2 or /dir format, if it is not supplied, '
   echo 'then the program uses internal defaults (can be changed at the beginning of the script).'
   echo 'A partition should be attached to the destination directory or the mount point  listed in'
   echo '/etc/fstab before using the script! '
   echo
   echo 'Normally, the /etc/fstab file on your root partition will be edited by the script:'
   echo 'A new adjusted /etc/fstab is created and copied over - this contains your destination'
   echo 'partition mounted as root. If you do not want this behavior, set the FSTAB_FLAG variable'
   echo 'from 1 to 0 by editing the first part of this script.'
   echo
   echo
   echo 'examples: gent-clone -c /mnt/clone - clone you root partititon to the partition mounted on /mnt/clone '
   echo '        : gent-clone -c            - clone your current root partition to your predefinied'
   echo '                                     partition (set this up by editing the first part of the script)'
   echo '        : gent-clone -p            - Pretend mode: Prints out what will happen when you issue a -c argument'
}

#_______________________________________________________________________
Config() # Create /etc/fstab for cloned partition
{
cp /etc/fstab /etc/fstab.cloned

SLICE_CLONED=`echo $CLONED_PART | cut -d "/" -f3`   
SLICE_SOURCE=`echo $SOURCE_PART | cut -d "/" -f3`   

SED_FROM='^[\ \t]*\/dev\/'$SLICE_CLONED
SED_TO='\/dev\/clonepart'
cat /etc/fstab.cloned | sed -e "s/$SED_FROM/$SED_TO/" > /etc/fstab.cloned

SED_FROM='^[\ \t]*\/dev\/'$SLICE_SOURCE
SED_TO='\/dev\/rootpart'
cat /etc/fstab.cloned | sed -e "s/$SED_FROM/$SED_TO/" > /etc/fstab.cloned

SED_FROM='^\/dev\/clonepart'
SED_TO='\/dev\/'$SLICE_SOURCE
cat /etc/fstab.cloned | sed -e "s/$SED_FROM/$SED_TO/" > /etc/fstab.cloned 

SED_FROM='^\/dev\/rootpart'
SED_TO='\/dev\/'$SLICE_CLONED
cat /etc/fstab.cloned | sed -e "s/$SED_FROM/$SED_TO/" > /etc/fstab.cloned
cp /etc/fstab.cloned $CLONE_DIR/etc/fstab

}
#_________________________________________________________________________
Clone() # Copies $SOURCE_PART to CLONED_PART
{
      if [ $CREATE_BIND_DIR -eq "1" ]
      then
         mkdir $BIND_DIR
      fi
      if [ $MOUNT_CLONE_DIR -eq "1" ]
      then
         mount $CLONE_DIR
      fi
      mount --bind $SOURCE_DIR $BIND_DIR
      rm -rf $CLONE_DIR/*
      cd $BIND_DIR
      find -mount -print | cpio -pdm $CLONE_DIR
      if [ $FSTAB_FLAG -eq "1" ]
      then
         Config
      fi
      echo
      echo "All done. Partition $SOURCE_PART was cloned to partition $CLONED_PART."
}
#____________________________________________________
Report() # What will happen; Used in pretend mode...
{
      echo

      if [ $CREATE_BIND_DIR -eq "1" ]
      then
         echo Creating $BIND_DIR...
      fi

      if [ $MOUNT_CLONE_DIR -eq "1" ]
      then
         echo Mounting $CLONED_PART on $CLONE_DIR...
      fi

      echo 'Mounting '$SOURCE_DIR' ('$SOURCE_PART') with -bind on '$BIND_DIR'...'
      echo 'Deleting all files in '$CLONE_DIR' ('$CLONED_PART')...'
      echo 'Changing dir to '$BIND_DIR'...'
      echo 'Copying everything in '$BIND_DIR' ('$SOURCE_PART') to '$CLONE_DIR' ('$CLONED_PART')...'
      echo

      if [ $FSTAB_FLAG -eq "1" ]
      then
         echo "Creating and copying a modified fstab, where $CLONED_PART is mounted as / ..."
      fi
}

######################### Main Program Module ##################################

case "$#" in
0)   
   Usage
   exit 1
   ;;
1)
   case "$1" in
   -p)
      Check_params
      Report
      exit 0
      ;;
   -c)
      Check_params
      Clone
      exit 0
      ;;
   -h)
      Usage
      exit 0
      ;;
   *)
      echo
      echo "Unknown parameter..."
      echo
      Usage
      exit 1
      ;;
   esac
   ;;
2)
   case "$1" in
   -p)
      CLONE_DIR=$2
      Check_params
      Report
      exit 0
      ;;
   -c)
      CLONE_DIR=$2
      Check_params
      Clone
      exit 0
      ;;
   -h)
      echo
      echo 'The "-h" parameter cannot be used with additional arguments...'
      echo
      Usage
      exit 1
      ;;
   *)
      echo
      echo "Unknown parameter..."
      echo
      Usage
      exit 1
      ;;
   esac
   ;;
*)
   echo
   echo 'This 2 is the maximum number of params!'
   echo
   Usage
   exit 1
   ;;
esac

############### End ##################################### 