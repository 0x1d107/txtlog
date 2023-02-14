md=$(wildcard *.md)
pages=$(patsubst %.md,%.html,$(md))
all:index.html feed.xml $(pages)

index.html:mkindex.sh $(md) README
	bash mkindex.sh $(md) > index.html
feed.xml:mkfeed.sh $(md)
	bash mkfeed.sh $(md) >feed.xml

%.html:%.md
	lowdown -s -mcss=style.css -thtml $^ > $@
publish: all
	rsync -avz --progress --rsh='ssh -i ~/.ssh/vultr_id_ed25519'  *.html *.xml *.css root@vultr:/var/www/html/
clean:
	rm -vf index.html feed.xml $(pages)
.PHONY: clean publish
