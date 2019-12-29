# SPDX-License-Identifier: GPL-2.0
.PHONY: all test watch service etcd clean
all: clean primary secondary forwarder services test
%:
	@coredns -conf conf/$*.conf > log/$*.log &
services: etcd
	@coredns -conf conf/$@.conf > log/$@.log &
etcd:
	@go install github.com/etcd-io/etcd
	@go install github.com/etcd-io/etcd/etcdctl
	@-killall etcd
	@etcd 2> log/etcd.log &
	@ETCDCTL_API=3 etcdctl put /skydns/local/services/users \
		'{"host": "192.0.2.10", "port": 20020, "priority": 10, "weight": 20}'
test: primary-test secondary-test forwarder-test etcd-test services-test
%-test:
	@printf "\n%s\n\n" $@ && dig +short @localhost -f tests/$@.dig
%-test-verbose:
	@printf "\n%s\n\n" $@ && dig @localhost -f tests/$*-test.dig
etcd-test:
	@printf "\n%s\n\n" $@ && ETCDCTL_API=3 etcdctl get /skydns/local/services/users
watch:
	@tail -f log/*
clean:
	@-killall coredns
	@-killall etcd
	@-$(RM) log/*.log
	@-mkdir -p log
