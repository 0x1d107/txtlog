md=$1
html=${md%.md}.html
title=$(lowdown -Xtitle $md)
datetime=$(lowdown -Xdate $md)
tags="$(lowdown -mtags='' -Xtags $md|tr '[:upper:]' '[:lower:]')"
mkdir -p lazyfeed/tags
idx=$datetime.$html.idx.html
tag_links=""
for tag in ${tags//,/ }
do
    tag_links="$tag_links <a href=\"tag-$tag.html\">$tag</a>"
    mkdir -p lazyfeed/tags/$tag/
    ln -f -s ../../$idx lazyfeed/tags/$tag/
done
cat > lazyfeed/$idx << ENTRY
    <tr><td>$datetime</td><td><a href="$html">$title</a></td><td>$tag_links</td></tr>
ENTRY

