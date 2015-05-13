package com.tripadvisor.postgres.pg_kv_daemon;

import org.skife.jdbi.v2.DBI;
import org.skife.jdbi.v2.Handle;
import org.skife.jdbi.v2.util.IntegerMapper;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Replicationd
{
    public static void main(String[] args) throws ClassNotFoundException
    {
        //Bootstrap the postgres driver
        Class.forName("org.postgresql.Driver");

        //TODO Make configurable / or an argument
        DBI dbi = new DBI("jdbc:postgresql://localhost/kv_catalog");
        Handle h = dbi.open();


        ExecutorService executor = Executors.newCachedThreadPool();
        List<Future<Object>> jobFutures = new ArrayList<>();


        h.createQuery(
                "SELECT shard_name, id, hostname, port, source_id, source_hostname, source_port FROM replication_topology"
        ).forEach(row -> {
            DBI shardDBI = new DBI(String.format("jdbc:postgresql://%s:%s/%s",
                    row.get("hostname"), row.get("port"), row.get("shard_name")));

            ReplicationTask task = new ReplicationTask(
                    shardDBI,
                    (Integer) row.get("source_id"),
                    (String)  row.get("source_hostname"),
                    (Integer) row.get("source_port")
            );
            jobFutures.add(executor.submit(task));
        });

        executor.shutdown();





    }

}
