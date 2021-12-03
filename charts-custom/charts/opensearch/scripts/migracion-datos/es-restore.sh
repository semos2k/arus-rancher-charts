#!/bin/bash

# docker image:
#   yauritux/busybox-curl

#ELASTIC_HOST=${ELASTIC_NAME:=elasticsearch.efk.svc.cluster.local}
ELASTIC_HOST=10.42.7.107
ELASTIC_PORT=9200
ELASTIC_URL="http://admin:admin@$ELASTIC_HOST:$ELASTIC_PORT"
TMP_FILE=indices.txt
SNAPSHOT_DIR=/data/arus-snapshot/
TMP_DECOMPRESS=utmp/

#if [ ! -f $TMP_DECOMPRESS ]; then
#    mkdir $TMP_DECOMPRESS
#fi

cat $TMP_FILE | grep -v red | grep -v kibana | awk '{ print $3" "$7 }' | sort | while read line; do
    INDEX=$(echo $line | awk '{print $1}')
    CANT=$(echo $line | awk '{print $2}')

    if [ ! -f $INDEX.log ]; then
        echo " $INDEX decompress ..."
        tar -xvf $INDEX.tar.gz -C $TMP_DECOMPRESS > /dev/null

        cp -R ${TMP_DECOMPRESS}${SNAPSHOT_DIR}* ${SNAPSHOT_DIR}

        sleep 7

        # echo curl -X POST "$ELASTIC_URL/_snapshot/my_fs_backup/snapshot_$INDEX/_restore"
        curl -X POST "$ELASTIC_URL/_snapshot/my_fs_backup/snapshot_$INDEX/_restore" \
            -H "Content-Type: application/json" \
            --data-binary @- << EOF
            {
                "indices": "$INDEX",
                "ignore_unavailable": true,
                "include_global_state": false,
                "include_aliases": false,
                "partial": false
            }
EOF

        # GET /_snapshot/my_fs_backup/_status
        #    grep STARTED
        while true; do
            RESTORE_STATUS=$(curl --silent "$ELASTIC_URL/_cat/indices/$INDEX?pretty&s=i" 2>&1 | awk '{ print $3" "$7 }') 
            RESTORE_CANT=$(echo $RESTORE_STATUS | awk '{print $2}')

            echo " $INDEX waiting total items: $RESTORE_CANT of $CANT"
            
            if [[ "$RESTORE_CANT" == "$CANT" ]]; then
                echo "status finish!"
                break
            fi

            sleep 1        
        done

        echo "finish" > $INDEX.log

        if [[ "$TMP_DECOMPRESS" == "" ]]; then
            echo "danger command, exit !!!"
            exit 1        
        fi

        if [[ "$SNAPSHOT_DIR" == "" ]]; then
            echo "danger command, exit !!!"
            exit 1        
        fi

        rm -R $TMP_DECOMPRESS*
        rm -R $SNAPSHOT_DIR*
    else
        echo " the $INDEX has already processed "
    fi
done
