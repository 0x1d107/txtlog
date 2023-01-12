#!/bin/bash
HOST="https://0x1d107.xyz/txtlog"
TITLE="Blog feed"
cat << HDR
<rss version="2.0">
<channel>
	<title>${TITLE}</title>
	<link>${HOST}/feed.xml</link>
	<description>${TITLE}</description>
HDR
for md in $@
do
	html=${md%.md}.html
	pubdate=$(date --date=$(lowdown -Xdate $md) -R)
	cat << ITM
	<item>
		<title>$(lowdown -Xtitle $md)</title>
		<link>${HOST}/${html}</link>
		<description><![CDATA[$(lowdown $md)]]></description>
		<pubDate>${pubdate}</pubDate>
		<guid>${HOST}/${html}</guid>
	</item>
ITM
done
cat <<FTR
</channel>
</rss>
FTR
