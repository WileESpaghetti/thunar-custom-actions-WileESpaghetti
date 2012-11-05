#!/bin/sh
# TODO add support for XINE
# TODO trap so no temp files are left behind
MPLAYER_DIR=${MPLAYER_DIR:-~/.mplayer}
MPLAYER_CONFIG=${MPLAYER_CONFIG:-"$MPLAYER_DIR/config"}
DVD_DEVICE=${1:-/dev/dvd}
TMP=`mktemp`

# create a MPlayer config if it does not exist
# XXX assumes that you have a simple config with only a default profile
# XXX if you have multiple profiles using dskchng can have unexpected results
function makeMPlayerConfig()
{
	# make the config directory if needed
	if [ ! -d $MPLAYER_DIR ]
	then
		mkdir $MPLAYER_DIR
	fi

	# add the dvd-device line or create config file if needed
	if [ ! -f $MPLAYER_CONFIG ] || ( ! grep -q 'dvd-device=' $MPLAYER_CONFIG )
	then
		echo dvd-device=/dev/dvd >> $MPLAYER_CONFIG
	fi
}

# change the dvd-device section in $MPLAYER_CONFIG
function chdsk()
{
	awk -v dev=$1 'BEGIN{OFS=FS="="} /dvd-device/{$2=dev}{print}' $MPLAYER_CONFIG > $TMP
	mv $TMP $MPLAYER_CONFIG
} 

makeMPlayerConfig
chdsk $DVD_DEVICE
