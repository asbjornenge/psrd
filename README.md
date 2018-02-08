# PostgreSQL Streaming Replication with Docker

This repo provides a basic streaming replication setup for PostgreSQL using docker.

We'll setup a single `master` and two `standby` nodes.

First, let's make a tmp dir for the postgres data, start the node and let it create the database filestructure. 
When the database is ready, we can create the `replicator` user and copy `pg_hba.conf` to the data dir (it gives the `replicator` user permission to replicate).

```
mkdir /tmp/psrd-master
./start-master.sh

# Wait for it to create database etc.

psql -U postgres -h localhost -p 5432
  CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'thepassword'

cp pg_hba.conf /tmp/psrd-master/
> ctrl-c
```

We can now restart the node (having updated the `pg_bha.conf`). Then we can do a `basebackup` that will serve as the database filestructure for the standbys.

```
./start-master.sh
docker exec -it psrd-master sh -c 'pg_basebackup -h localhost -D /var/lib/postgresql/data/standby -U replicator -P -v -x'
```

Now we need to copy the `basebackup` to the standby nodes data dir path.
Next we need to copy `recovery.conf` to both these dirs, and start up the standby nodes.

```
mv /tmp/psrd-master/standby/ /tmp/psrd-standby1
cp -R /tmp/psrd-standby1 /tmp/psrd-standby2
cp recovery.conf /tmp/psrd-standby1/
cp recovery.conf /tmp/psrd-standby2/
./start-standby1.sh
./start-standby2.sh
```

