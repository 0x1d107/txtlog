md=$(wildcard *.md)
pages=$(patsubst %.md,%.html,$(md))
all:index.html feed.xml $(pages)

index.html:mkindex.sh README $(pages)
	bash mkindex.sh > index.html
	bash mktags.sh
feed.xml:mkfeed.sh $(pages)
	bash mkfeed.sh >feed.xml

%.html:%.md
	lowdown -s --parse-math -mcss=style.css -thtml $< | python postproc.py > $@
	bash lazyidx.sh $<
	bash lazyfeed.sh $<
publish: all
	git add *.md
	git commit -am 'edit articles'
	git push
	rsync -avz --delete --progress --rsh='ssh -i ~/.ssh/vultr_id_ed25519' *.ico *.html *.xml *.xsl *.css vendor root@vultr:/var/www/html/
clean:
	rm -rvf index.html feed.xml $(pages) lazyfeed tag-*.html
.PHONY: clean publish
