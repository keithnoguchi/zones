# SPDX-License-Identifier: GPL-2.0
.PHONY: all test watch clean
all: clean primary secondary forwarder test
%:
	@coredns -conf conf/$*.conf > log/$*.log &
test: primary-test secondary-test forwarder-test
%-test:
	@printf "\n%s\n\n" $@ && dig -f tests/$@.dig
watch:
	@tail -f log/*
clean:
	@-killall coredns
	@-$(RM) log/*.log
	@-mkdir -p log
