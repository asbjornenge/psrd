# PosgreSQL Streaming Replication with Docker

This repo provides a basic streaming replication setup for docker.

```
mkdir /tmp/psrd-master
./start-master.sh
# Wait for it to create database.
> ctrl-c

cp pg_hba.conf /tmp/psrd-master/

psql -U postgres -h localhost -p 5432
  CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'thepassword'

docker exec -it psrd-master sh -c 'pg_basebackup -h localhost -D /var/lib/postgresql/data/standby -U replicator -P -v -x'

mv /tmp/psrd-master/standby/ /tmp/psrd-standby1
cp recovery.conf /tmp/psrd-standby1/
./start-standby1.sh
```

