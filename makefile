md=$(wildcard *.md)
pages=$(patsubst %.md,%.html,$(md))
all:index.html feed.xml $(pages)

index.html:mkindex.sh $(md)
	bash mkindex.sh $(md) > index.html
feed.xml:mkfeed.sh $(md)
	bash mkfeed.sh $(md) >feed.xml

%.html:%.md
	lowdown -s -mcss=style.css -thtml $^ > $@
publish: all
	cp -v *.html *.xml *.css 0x1d107.github.io/txtlog/
	cd  0x1d107.github.io/; git add *; git commit -m post; git push
clean:
	rm -vf index.html feed.xml $(pages)
.PHONY: clean publish
