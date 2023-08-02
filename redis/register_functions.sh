#! /bin/sh

REDIS_ARGS=""
OWN_PATH=$(dirname -- "$( readlink -f -- "$0"; )")

for script in $OWN_PATH/*.lua; do
    redis-cli $REDIS_ARGS -x FUNCTION LOAD REPLACE < ${script}
done

if [ "$1" = "--watch" ]; then 
    inotifywait -m -e close_write $OWN_PATH/*.lua | 
        while read file_path file_event file_name; do 
            redis-cli $REDIS_ARGS -x FUNCTION LOAD REPLACE < ${file_path}${file_name}
        done
fi
