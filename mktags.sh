#!/bin/bash
for tag in $(ls lazyfeed/tags)
do
cat > tag-$tag.html << HDR
<html>
<head>
    <title> Posts tagged $tag </title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>
    <h1> Posts tagged $tag </h1>
<table id="posts">
HDR
cat $(ls -r lazyfeed/tags/$tag/*.idx.html) >> tag-$tag.html
echo "</table></body></html>" >> tag-$tag.html
done
