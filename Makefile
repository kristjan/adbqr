BATS ?= bats

.PHONY: test

test:
	$(BATS) tests
