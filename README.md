# zones

[Learning CoreDNS] example files

[learning coredns]: https://www.oreilly.com/library/view/learning-coredns/9781492047957/

## Example

Run coredns with the provided [coredns.conf] file:

[coredns.conf]: coredns.conf

```sh
git clone https://github.com/keithnoguchi/zones
cd zones
coredns -conf coredns.conf
```

Retrieve the [foo.example] zone info through the coredns
running on port 1053 ss in [coredns.conf]:

[foo.example]: db.foo.example

```sh
dig ns1.foo.example @localhost -p 1053

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

Happy Hacking!
