.DEFAULT_GOAL := install
export SHELLOPTS:=pipefail:errexit

ifeq ($(PREFIX),)
  PREFIX := /lib/
endif

ifeq ($(DESTDIR),)
  DESTDIR := $(HOME)
endif

install:
	gem install ltb tsp
	install -d $(DESTDIR)$(PREFIX)
	install -m 644 common.sh $(DESTDIR)$(PREFIX)
