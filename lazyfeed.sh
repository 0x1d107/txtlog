HOST="https://0x1d107.xyz"
TITLE="Blog feed"
md=$1
html=${md%.md}.html
xdate=$(lowdown -Xdate $md)
pubdate=$(date --date=$xdate -R)
mkdir -p lazyfeed

cat > "lazyfeed/${xdate}.${html}.item.xml" << ITM 
	<item>
		<title>$(lowdown -Xtitle $md)</title>
		<link>${HOST}/${html}</link>
		<description><![CDATA[$(lowdown $md)]]></description>
		<pubDate>${pubdate}</pubDate>
		<guid>${HOST}/${html}</guid>
	</item>
ITM
