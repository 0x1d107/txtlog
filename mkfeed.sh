#!/bin/bash
HOST="https://0x1d107.xyz"
TITLE="Blog feed"
cat << HDR
<rss version="2.0">
<channel>
	<title>${TITLE}</title>
	<link>${HOST}/feed.xml</link>
	<description>${TITLE}</description>
HDR
cat $(ls -r lazyfeed/*.xml)
cat <<FTR
</channel>
</rss>
FTR
