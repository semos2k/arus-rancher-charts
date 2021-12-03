#!/bin/bash

# docker image:
#   yauritux/busybox-curl

#ELASTIC_HOST=${ELASTIC_NAME:=elasticsearch.efk.svc.cluster.local}
ELASTIC_HOST=10.42.7.125
ELASTIC_PORT=9200
ELASTIC_URL="http://$ELASTIC_HOST:$ELASTIC_PORT"
TMP_FILE=indices.txt
SNAPSHOT_DIR=/data/arus-snapshot/

if [ ! -f $TMP_FILE ]; then
   curl -v --silent "$ELASTIC_URL/_cat/indices" 2>&1 > $TMP_FILE
fi

cat $TMP_FILE | awk '{ print $3" "$7 }' | sort | grep -v .kibana | while read line; do
    INDEX=$(echo $line | awk '{print $1}')
    CANT=$(echo $line | awk '{print $2}')

    echo "$INDEX,$CANT"

    if [ ! -f $INDEX.tar.gz ]; then

        curl -X PUT "$ELASTIC_URL/_snapshot/my_fs_backup/snapshot_$INDEX?wait_for_completion=false" \
            -H "Content-Type: application/json" \
            --data-binary @- << EOF
            {
                "indices": "$INDEX",
                "ignore_unavailable": true,
                "include_global_state": false 
            }
EOF

        # GET /_snapshot/my_fs_backup/_status
        #    grep STARTED
        while true; do
            BK_STATUS=$(curl "$ELASTIC_URL/_snapshot/my_fs_backup/_status" 2>&1 | grep state) 

            echo "waiting finish state"
            
            #if [[ "$BK_STATUS" == *"STARTED"* ]]; then
            #    echo "finish!"
            #    break
            #fi

            if [[ "$BK_STATUS" == "" ]]; then
                echo "status finish!"
                break
            fi

            sleep 1
        done

        tar -zcvf $INDEX.tar.gz $SNAPSHOT_DIR*

        if [[ "$SNAPSHOT_DIR" == "" ]]; then
            echo "danger command, exit !!!"
            exit 1
        else
            rm -R $SNAPSHOT_DIR*
        fi
    else
        echo "el archivo $INDEX.tar.gz ya existe !!!"
    fi
done
