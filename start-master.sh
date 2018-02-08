#!/bin/bash
docker run \
--rm \
--name psrd-master \
-p 5432:5432 \
-v /tmp/psrd-master:/var/lib/postgresql/data \
-it postgres:9.6 \
-c 'wal_level=hot_standby' \
-c 'wal_keep_segments=8' \
-c 'max_wal_senders=3' \
-c 'wal_keep_segments=8' \
-c 'hot_standby=on'
