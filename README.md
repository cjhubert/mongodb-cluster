# MongoDB Cluster

This project sets up a [MongoDB](http://www.mongodb.org/) cluster with examples of
sharding and replication through Chef Solo.

## Setup

```sh
git clone https://github.com/ceejh/mongodb-cluster.git
cd mongodb-cluster

# Vagrant plugins to manage the network
vagrant plugin install vagrant-auto_network
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-triggers
vagrant plugin install vagrant-omnibus

vagrant up
```
