# MongoDB Cluster

This project sets up a [MongoDB](http://www.mongodb.org/) cluster of servers with examples of
sharding, replication, and user management through Chef Solo.

The servers are currently configured to run on Ubuntu 12.04 boxes. The following nodes exist, in the order
they are expected to be `vagrant up`'d:

```sh
c0    # Config Server
c1    # Config Server
c2    # Config Server
d0    # Mongod instance
d1    # Mongod instance
d2    # Mongod instance
s0    # Mongos instance
```

From scratch, `vagrant up`ing normally produces the `d2` server as the primary of the replicaset.

## Setup

To run the API in a vagrant box , you must have [Vagrant](http://www.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/) installed on your machine. Windows users may
also need Chef and Berkshelf; easily installed via [ChefDK](https://downloads.getchef.com/chef-dk/).

```sh
git clone https://github.com/ceejh/mongodb-cluster.git
cd mongodb-cluster

# Vagrant plugins to manage the network
# Download cookbooks and install chef
vagrant plugin install vagrant-auto_network
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-triggers
vagrant plugin install vagrant-omnibus

vagrant up
```

## Replication and sharding

This repository is only meant to serve an example of configuring a MongoDB cluster with the MongoDB
cookbook. It will set up sharding on keys that are only placeholders. In `vagrant_boxes/mongos.json`,
the configured collections to be sharded is simply:

```javascript
"sharded_collections": {
  "foo.bar": "baz"
},
```

### Checking node status

To ensure all the nodes came up properly, there are a few commands you can run on each node to see
how it is configured.

On **config servers** you can run the mongo shell with `mongo admin -u admin -p admin --port 20179`. Once inside, running the commands
`use config` and `db.shards.find()` should print out: `{ "_id" : "rs_default", "host" : "rs_default/d0:27017,d1:27017,d2:27017" }`.

On **mongod** instances, logging into the mongo shell with `mongo admin -u admin -p admin` and running the command
`rs.status()` should give a response of all three mongod instances in the replicaset.

For the **mongos** instance, run the mongo shell again with `mongo admin -u admin -p admin` and check the shard
status with the command `sh.status()`, which should print out the list of databases that are sharded and the
collections they are sharded on.
