#!/bin/sh

RSYNC_ARGS="-vrtW --delay-updates --timeout=5 rsync://$RSYNC_HOST$RSYNC_PATH /data"

# log the contents of /data on startup (helpful for debugging)
find /data

# if we're in sync-once mode just replace with the rsync command
if [[ "$1" == "once" ]]; then
	echo "once: rsync $RSYNC_ARGS"
	exec rsync $RSYNC_ARGS
fi

# exit if we get SIGTERM or SIGINT
trap "echo Exiting...; exit $?" INT TERM

# otherwise loop (sleep first)
echo "starting periodic rsync (sleeping first)"
while sleep 30; do
	# sleep a random amount of extra time to help distribute
	while [[ `expr $RANDOM % 2` -eq 0 ]]; do
		sleep 5;
	done
	# sync but don't care if it fails
	echo "periodic: rsync $RSYNC_ARGS"
	rsync $RSYNC_ARGS
	echo "rsync completed with code $?"
done
