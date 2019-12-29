# zones

A [CoreDNS] play ground as demonstrated in [Learning CoreDNS].

[coredns]: https://github.com/coredns/coredns
[learning coredns]: https://www.oreilly.com/library/view/learning-coredns/9781492047957/

## Example

Run coredns with some sample configuration files,
e.g. [primary.conf], [secondary.conf], [forwarder.conf] and [services.conf].

[primary.conf]: conf/primary.conf
[secondary.conf]: conf/secondary.conf
[forwarder.conf]: conf/forwarder.conf
[services.conf]: conf/services.conf

```sh
$ git clone https://github.com/keithnoguchi/zones
$ cd zones
$ coredns -conf conf/primary.conf
```

Retrieve the [foo.example] zone info through the coredns running
on port 1053 as in the [primary.conf] configuration file:

[foo.example]: db.foo.example

```sh
$ dig ns1.foo.example @localhost -p 1053

; <<>> DiG 9.14.6 <<>> ns1.foo.example @localhost -p 1053
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7402
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 1
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: be4fc13bf13bbcae (echoed)
;; QUESTION SECTION:
;ns1.foo.example.               IN      A

;; ANSWER SECTION:
ns1.foo.example.        300     IN      A       192.168.1.53

;; AUTHORITY SECTION:
foo.example.            3600    IN      NS      ns1.foo.example.
foo.example.            3600    IN      NS      ns2.foo.example.

;; Query time: 0 msec
;; SERVER: ::1#1053(::1)
;; WHEN: Sat Dec 28 16:52:35 PST 2019
;; MSG SIZE  rcvd: 167
```

and the SRV record:

```sh
$ dig srv _https._tcp.www.foo.example @localhost -p 1053

; <<>> DiG 9.14.6 <<>> srv _https._tcp.www.foo.example @localhost -p 1053
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43947
;; flags: qr aa rd; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3
;; WARNING: recursion requested but not available

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; COOKIE: 671efeb4a6afb9e6 (echoed)
;; QUESTION SECTION:
;_https._tcp.www.foo.example.   IN      SRV

;; ANSWER SECTION:
_https._tcp.www.foo.example. 300 IN     SRV     0 0 443 foo.example.

;; AUTHORITY SECTION:
foo.example.            3600    IN      NS      ns1.foo.example.
foo.example.            3600    IN      NS      ns2.foo.example.

;; ADDITIONAL SECTION:
foo.example.            3600    IN      A       192.168.1.1
foo.example.            3600    IN      AAAA    2001:db8:42:1::1

;; Query time: 0 msec
;; SERVER: ::1#1053(::1)
;; WHEN: Sat Dec 28 16:56:49 PST 2019
;; MSG SIZE  rcvd: 272
```

## Test

`make test` will check all those three coredns servers, as in [Makefile]

[makefile]: Makefile

```sh
$ make test

primary-test

ns1.foo.example. root.foo.example. 2019122801 3600 900 604800 600
ns1.foo.example.
ns2.foo.example.
192.168.1.53
192.168.2.53
0 0 80 foo.example.
0 0 443 foo.example.

secondary-test

ns1.foo.example. root.foo.example. 2019122801 3600 900 604800 600
ns1.foo.example.
ns2.foo.example.
192.168.1.53
192.168.2.53
0 0 80 foo.example.
0 0 443 foo.example.

forwarder-test

ns1.foo.example. root.foo.example. 2019122801 3600 900 604800 600
ns1.foo.example.
ns2.foo.example.
192.168.1.53
192.168.2.53
0 0 80 foo.example.
0 0 443 foo.example.
216.58.194.174

etcd-test

/skydns/local/services/users
{"host": "192.0.2.10", "port": 20020, "priority": 10, "weight": 20}

services-test

192.0.2.10
10 100 20020 users.services.local.
```

Happy Hacking!
