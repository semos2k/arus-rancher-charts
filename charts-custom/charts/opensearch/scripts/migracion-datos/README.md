ELASTIC_HOST=elasticsearch.efk.svc.cluster.local
ELASTIC_PORT=9200
ELASTIC_URL="http://$ELASTIC_HOST:$ELASTIC_PORT"

GET /_cat/indices?pretty&s=i

GET /_snapshot/my_fs_backup

PUT /_snapshot/my_fs_backup
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/data/arus-snapshot"
  }
}


GET /_snapshot/my_fs_backup/_all

PUT /_snapshot/my_fs_backup/snapshot_fb_20210913?wait_for_completion=true
{
  "indices": "fluentbit-2021.11.09",
  "ignore_unavailable": true,
  "include_global_state": false 
}

GET /_snapshot/my_fs_backup/_status

POST /_snapshot/my_fs_backup/<name>/_restore


rm -R /data/arus-snapshot/*
rm -R utmp/*



usuarios:
------------------
admin:C)q6gvGpMYh6L?a6          hash:$2y$12$SjpkejKbGPbTLq61CV6F9OgDb9Mx2yJ2DES/dd2Md1I2lLmQtJ/hK
tareas:YRm9ZzaOQSry



PUT /_snapshot/my_fs_backup
{
  "type": "fs",
  "settings": {
    "location": "/usr/share/opensearch/data/arus-snapshot"
  }
}

PUT _cluster/settings
{
  "persistent": {
    "cluster": {
      "max_shards_per_node": 20000
    }
  }
}


OPENSEARCH_JAVA_OPTS -Xms6g -Xmx6g


DELETE _index_template/daily_logs

PUT _index_template/daily_logs
{
  "index_patterns": [
    "sso-logs-*",
    "fluentbit-*",
    "auditoria-*"
  ],
  "template": {
    "settings": {
      "number_of_shards": 5,
      "number_of_replicas": 0
    }
  }
}


PUT /auditoria-*/_settings
{
  "index" : {
    "number_of_replicas" : 0
  }
}

PUT /fluentbit-*/_settings
{
  "index" : {
    "number_of_replicas" : 0
  }
}

PUT /sso-logs-*/_settings
{
  "index" : {
    "number_of_replicas" : 0
  }
}
