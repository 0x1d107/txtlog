cat <<HDR
<html>
	<head>
		<title> 
			txt.log
		</title>
		<link rel="stylesheet" href="style.css" />
        <link rel="alternate" type="application/rss+xml" href="feed.xml"/>
	</head>
<body>
<h1> txt.log </h1>
$(lowdown README)
<h2> Posts </h2>
<ul id="posts">
HDR
for md in  $@
do 
	html=${md%.md}.html
	title=$(lowdown -Xtitle $md)
	datetime=$(lowdown -Xdate $md)
	echo -e "$datetime\t$title\t$md\t$html"
done|sort -r|awk -F'\t' '{print "<li><a href="$4">"$2"</a> <time datetime="$1">"$1"</time></li>"}'
echo "</ul></body>"
