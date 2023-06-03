md=$(wildcard *.md)
pages=$(patsubst %.md,html/%.html,$(md))
styles=$(wildcard *.css)
misc=$(wildcard *.xml) $(wildcard *.xsl) $(wildcard *.js) robots.txt favicon.ico vendor/ radIO.m3u
all:html/index.html html/feed.xml $(pages)

html/index.html:mkindex.sh README $(pages) $(styles) $(misc)
	bash mkindex.sh > $@
	bash mktags.sh
	cp -r $(styles) $(misc) html/
html/feed.xml:mkfeed.sh $(pages)
	bash mkfeed.sh > $@

html/%.html:%.md
	mkdir -p html
	lowdown -s --parse-math -mcss=style.css -thtml $< | python postproc.py > $@
	bash lazyidx.sh $<
	bash lazyfeed.sh $<
publish: all
	#git add *.md
	#git commit -am 'edit articles'
	#git push
	rsync -avz --delete --progress --rsh='ssh -i ~/.ssh/vultr_id_ed25519' html/ root@vultr:/var/www/html/
clean:
	rm -rvf html lazyfeed
.PHONY: clean publish
