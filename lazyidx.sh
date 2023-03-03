md=$1
html=${md%.md}.html
title=$(lowdown -Xtitle $md)
datetime=$(lowdown -Xdate $md)
entry="<tr><td>$datetime</td><td><a href=\"$html\">$title</a></td></tr>"
mkdir -p lazyfeed
echo $entry > lazyfeed/$datetime.$html.idx.html
#[ -e index.html ] && [ -z "$(grep $html index.html)" ] && sed -i '/id="posts"/a '"$entry" index.html

