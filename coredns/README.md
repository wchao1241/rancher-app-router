# CoreDNS

## How to use

```
$ docker-compose -f ./etcd-compose.yaml up -d
$ docker-compose -f ./rdns-compose.yaml up -d
```

### Before running

If you want to use other root domain, you can update the `corefile`. This demo uses `lb.rancher.cloud`.

According to the root domain, create the corresponding path in etcd:

```
$ etcdctl mkdir /rdns/lb/rancher/cloud
```

### Add test records

```
$ etcdctl set /rdns/lb/rancher/cloud/zhibo/x1 '{"host":"1.1.1.1"}'
{"host":"1.1.1.1"}
$etcdctl set /rdns/lb/rancher/cloud/zhibo/x2 '{"host":"2.2.2.2"}'
{"host":"2.2.2.2"}
```

Use dig for test:

```
dig @<coredns-address> zhibo.lb.rancher.cloud A

; <<>> DiG 9.8.3-P1 <<>> @172.22.100.5 zhibo.lb.rancher.cloud A
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7723
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;zhibo.lb.rancher.cloud.	IN	A

;; ANSWER SECTION:
zhibo.lb.rancher.cloud. 160	IN	A	2.2.2.2
zhibo.lb.rancher.cloud. 160	IN	A	1.1.1.1
```

### Add ns records

For DNS to work properly SkyDNS needs to tell its parents its nameservers.

```
etcdctl set /rdns/cloud/rancher/lb/dns/ns/ns1 '{"host":"ip1"}'
etcdctl set /rdns/cloud/rancher/lb/dns/ns/ns2 '{"host":"ip2"}'
```

### Add cname record for API

We should use `api.lb.rancher.cloud` as default API domain, add a CNAME record for ELB domain.

```
etcdctl set /rdns/cloud/rancher/lb/api '{"host":"rdns-server-lb-1538981444.us-west-1.elb.amazonaws.com"}'
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
