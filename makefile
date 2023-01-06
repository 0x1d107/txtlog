md=$(wildcard *.md)
pages=$(patsubst %.md,%.html,$(md))
all:index.html feed.xml $(pages)

index.html:mkindex.sh $(md)
	bash mkindex.sh $(md) > index.html
feed.xml:mkfeed.sh $(md)
	bash mkfeed.sh $(md) >feed.xml

%.html:%.md
	lowdown -s -mcss=style.css -thtml $^ > $@
