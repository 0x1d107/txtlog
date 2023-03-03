#!/bin/bash

md=$1
html=${md%.md}.html
rm -f $md $html lazyfeed/*.$html.idx.html lazyfeed/*.$html.item.xml
find lazyfeed/tags -xtype l -delete
find lazyfeed/tags -type d -empty -delete
rm -f tag-*.html
touch mkindex.sh
make
