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
