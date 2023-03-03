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
<table id="posts">
HDR
cat $(ls -r lazyfeed/*.idx.html)
echo "</table></body>"
