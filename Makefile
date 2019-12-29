# SPDX-License-Identifier: GPL-2.0
.PHONY: all test watch clean
all: clean primary secondary test
%:
	@-mkdir -p log
	@coredns -conf conf/$*.conf > log/$*.log &
test: primary-test secondary-test
%-test:
	@printf "\n%s\n\n" $@ && dig -f tests/$@.dig
watch:
	@tail -f log/*
clean:
	@-killall coredns
	@-$(RM) log/*.log
