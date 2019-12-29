# SPDX-License-Identifier: GPL-2.0
LOG	:= coredns.log
TESTS	:= foo.example.test.dig
.PHONY: all run test
all: clean run test
run:
	@coredns -conf coredns.conf > $(LOG) &
test:
	@for t in $(TESTS); do printf "\n%s\n\n" $${t} && dig -f $${t}; done
watch:
	@tail -f $(LOG)
clean:
	@-killall coredns
	@-$(RM) $(LOG)
