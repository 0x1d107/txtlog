md=$(wildcard *.md)
pages=$(patsubst %.md,%.html,$(md))
all:index.html feed.xml $(pages)

index.html:mkindex.sh README $(pages)
	bash mkindex.sh > index.html
	bash mktags.sh
feed.xml:mkfeed.sh $(pages)
	bash mkfeed.sh >feed.xml

%.html:%.md
	lowdown -s -mcss=style.css -thtml $< > $@
	bash lazyidx.sh $<
	bash lazyfeed.sh $<
publish: all
	rsync -avz --progress --rsh='ssh -i ~/.ssh/vultr_id_ed25519'  *.html *.xml *.css root@vultr:/var/www/html/
clean:
	rm -rvf index.html feed.xml $(pages) lazyfeed tag-*.html
.PHONY: clean publish
