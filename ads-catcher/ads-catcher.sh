#!/bin/sh
##############################################################################
# PEB
# 2019.03.24
##############################################################################
# Copyright (C) 2019 
# This file is copyright under the latest version of the EUPL.
# Please see LICENSE file for your rights under this license.
##############################################################################

ADSC_INSTALL_PATH="/opt/tools/ads-catcher/"

# Log and temporary files
ADSC_TMPFILE=/tmp/ads-catcher.tmp
PIHOLE_LOGFILE=/var/log/pihole.log
PIHOLE_BLACKLIST_FILE=/etc/pihole/blacklist.txt

# Blacklist files
ADSC_BLACKLIST_FOLDER=$ADSC_INSTALL_PATH/blacklist/
ADSC_HISTORY_FOLDER=$ADSC_INSTALL_PATH/history/
YOUTUBE_BLACKLIST=$ADSC_BLACKLIST_FOLDER/youtube-blacklist.txt


##############################################################################
# @brief : function to add path of ads-catcher blacklist files
##############################################################################
addBlacklistFilesToPihole () {
  
  # Content of the pihole blacklist file
  PIHOLE_BLACKLIST_CONTENT="`cat $PIHOLE_BLACKLIST_FILE`"

  # List of ads-catcher files
  ADSC_BLACKLIST_FILES="`ls -d $ADSC_BLACKLIST_FOLDER/*`"

  # Save result into the blacklsit file
  echo "$PIHOLE_BLACKLIST_CONTENT\n$ADSC_BLACKLIST_FILES" | awk 'NF' | sort -u > $PIHOLE_BLACKLIST_FILE
}


##############################################################################
# @brief : function to know if we need to update pihole after calling a catcher
# @param $1 : file that contains list of addresses to block
# @return 1 if we need to update pihole, otherwise 0
##############################################################################
isPiholeUpdateNeeded () {

  # Argument check
  if [ $# -lt 1 ]; then
    echo "[isPiholeUpdateNeeded] ERROR, missing argument"
    return 0
  fi

  # Parameters
  BLACKLIST_FILE=$1

  # Extract service name
  SERVICE_NAME=`echo $BLACKLIST_FILE | sed 's/\-blacklist.txt'//`
  SERVICE_NAME=`basename $SERVICE_NAME`

  # Compute number of entries
  NB_ENTRIES=`wc -l $BLACKLIST_FILE | cut -d\  -f1`

  # Just for history, do a backup of this file
  BACKUP_NAME="$SERVICE_NAME-$NB_ENTRIES.txt"
  cp $BLACKLIST_FILE $ADSC_HISTORY_FOLDER/$BACKUP_NAME

  # Extract previous number of entries
  PREVIOUS_NB_ENTRIES=`cat $ADSC_TMPFILE | grep $SERVICE_NAME | cut -d= -f2`

  # Update pihole with new entries
  if [ "$NB_ENTRIES" != "$PREVIOUS_NB_ENTRIES" ]; then
    RETVAL=1
  else
    RETVAL=0
  fi

  # Save state of this update
  echo "$SERVICE_NAME=$NB_ENTRIES" > $ADSC_TMPFILE

  return $RETVAL
}


##############################################################################
# @brief : function to update blacklist file with clean feature
# @param $1 : blacklist file that contains list of addresses to block
# @param $2 : list of addresses to add
##############################################################################
updateBlacklistFile() {

  # Argument check
  if [ $# -lt 2 ]; then
    echo "[updateBlacklistFile] ERROR, missing argument :"
    return
  fi

  # Parameters
  BLACKLIST_FILE=$1
  Y1=$2

  # Get previous blacklisted addresses
  Y2=`cat $BLACKLIST_FILE`

  # Save result into the blacklist file
  echo "$Y1\n$Y2" | awk 'NF' | sort -u > $BLACKLIST_FILE
}


##############################################################################
# @brief : function to catch youtube ads
# @return 1 if we need to update pihole, otherwise 0
##############################################################################
catcherYoutube () {

  # be sure that the blacklist file exist
  touch $YOUTUBE_BLACKLIST
  
  # Extract dns request from the pihole logfiles
  Y1A=`cat "$PIHOLE_LOGFILE" | grep query | grep googlevideo.com | sed 's/.*query\[A*]\ //' | sed 's/from\ [a-Az-Z0-9.:]*//' | sort -u`
  Y1B=`cat "$PIHOLE_LOGFILE.1" | grep query | grep googlevideo.com | sed 's/.*query\[A*]\ //' | sed 's/from\ [a-Az-Z0-9.:]*//' | sort -u`
  Y2="$Y1A\n$Y1B"

  # Remove whitelist addresses
  Y2=`echo $Y2 | sed '/redirector.googlevideo.com/d'`

  # Update blacklist file
  updateBlacklistFile "$YOUTUBE_BLACKLIST" "$Y2"

  # Check treatments result
  isPiholeUpdateNeeded "$YOUTUBE_BLACKLIST"

  return $?
}


##############################################################################
### MAIN ###
##############################################################################
# Create blacklist folder and tmp files to be sure
touch $ADSC_TMPFILE
mkdir -p $ADSC_BLACKLIST_FOLDER
mkdir -p $ADSC_HISTORY_FOLDER

# Call different catchers
catcherYoutube
RETVAL_YOUTUBE=$?

if [ $RETVAL_YOUTUBE -eq 1 ]; then
  
  # Refresh list of blacklist files
  addBlacklistFilesToPihole

  # Update pihole with new entries
  /usr/local/bin/pihole -g
fi

