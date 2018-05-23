# CoreDNS

### How to use

```
$ docker-compose -f ./etcd-compose.yaml up -d
$ docker-compose -f ./rdns-compose.yaml up -d
```

### Add test records

```
$ etcdctl rm /rdns/local/rancher/test/zhibo/x1 '{"host":"1.1.1.1"}'
{"host":"1.1.1.1"}
$etcdctl set /rdns/local/rancher/test/zhibo/x2 '{"host":"2.2.2.2"}'
{"host":"2.2.2.2"}
```

Use dig for test:

```
dig @<coredns-address> zhibo.test.rancher.local A

; <<>> DiG 9.8.3-P1 <<>> @172.22.100.5 zhibo.test.rancher.local A
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7723
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;zhibo.test.rancher.local.	IN	A

;; ANSWER SECTION:
zhibo.test.rancher.local. 160	IN	A	2.2.2.2
zhibo.test.rancher.local. 160	IN	A	1.1.1.1
```

### Add ns records

For DNS to work properly SkyDNS needs to tell its parents its nameservers.

```
etcdctl set /rdns/cloud/rancher/lb/dns/ns/ns1 '{"host":"ip1"}'
etcdctl set /rdns/cloud/rancher/lb/dns/ns/ns2 '{"host":"ip2"}'
```

## Air-gap setup

Modify `rdns.base_url` field of configmap.yaml in kube-rdns,such as `http://servic_ip:9333/v1`

Default Settings

| Name | Value |
| ----- | ---- |
| &lt;port&gt; | 9333 |
| &lt;version&gt; | v1 |

## Backup and Restore

### Dependencies

* etcdctl installed.

* AWS S3 bucket.

* AWS access and secret key with write permissions for this bucket.

* Copy etcd-backup into /usr/local/bin
```
cp etcd-backup /usr/local/bin/etcd-backup
```

### Backup data to S3

1. Modify fields in `backup_etcd_s3.sh`, such as `s3-bucket`, `s3-region`, etc.

2. Reference script `backup_etcd_s3.sh`, and use crontab to perform, such as copy to `/etc/cron.daily/`.
```
mv backup_etcd_s3.sh /etc/cron.daily/backup_etcd_s3
```

### Restore data from S3

1. Make public the backup files.

2. In `restore_etcd.sh` script file,change the `BACKUP_V2_SUFFIX` and `BACKUP_V3_SUFFIX` fields according to the file you want to restore.

3. Execute `restore_etcd.sh` script file.