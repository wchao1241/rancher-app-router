#!/bin/bash

# https://github.com/giantswarm/etcd-backup

export ETCDBACKUP_AWS_ACCESS_KEY=XXX
export ETCDBACKUP_AWS_SECRET_KEY=YYY
#export ETCDBACKUP_PASSPHRASE=ZZZ

/usr/local/bin/etcd-backup -aws-s3-bucket rdns-etcd-backup \
            -aws-s3-region us-west-1 \
            -prefix rdnsdb \
            -etcd-v2-datadir /mnt/data/etcd

docker run --rm \
    -e ETCDBACKUP_AWS_ACCESS_KEY=XXX \
    -e ETCDBACKUP_AWS_SECRET_KEY=YYY \
    -v /mnt/data/etcd:/mnt/data/etcd \
    wchao241/etcd-backup:v1.0 \
    -aws-s3-bucket rdns-etcd-backup \
    -aws-s3-region us-west-1 \
    -prefix rdnsdb \
    -etcd-v3-endpoints http://172.17.0.1:2379 \
    -etcd-v2-datadir /mnt/data/etcd


#######################################################


export ETCDBACKUP_AWS_ACCESS_KEY=XXX
export ETCDBACKUP_AWS_SECRET_KEY=YYY


/usr/local/bin/etcd-backup -aws-s3-bucket rdns-etcd-bp \
            -aws-s3-region us-east-2 \
            -prefix rdnsdb \
            -etcd-v2-datadir /mnt/data/etcd


docker run --rm \
    -e ETCDBACKUP_AWS_ACCESS_KEY=XXX \
    -e ETCDBACKUP_AWS_SECRET_KEY=YYY \
    -v /mnt/data/etcd:/mnt/data/etcd \
    wchao241/etcd-backup:v1.0 \
    -aws-s3-bucket rdns-etcd-bp \
    -aws-s3-region us-east-2 \
    -prefix rdnsdb \
    -etcd-v3-endpoints http://172.17.0.1:2379 \
    -etcd-v2-datadir /mnt/data/etcd
