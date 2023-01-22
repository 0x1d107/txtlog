title: New blog, again
date: 2023-01-07

# New blog
Hi. This is my new blog. Again. Here I'll post some how-to's and description of my projects.
Probably. I hope won't abandon it again. 
## Microblog
If you want to read shorter chaotic twitter-like posts, you can also follow my rss-only feed:
<http://0x1d107.xyz/txtlog/0x1d107.xml>. Here I share the links to projects of my interest and other
stuff. warning: contains swearing and russian language.
## About the blog generator
The main part of the blog generator is just a makefile. Make tracks files that changed and generates
the repective html output. For markdown to html conversion I use
[lowdown](https://kristaps.bsd.lv/lowdown/) translator. As for the two "dynamic" files, `index.html`
and the rss feed, they are generated using shell scripts with here-docs as templates. I think it
works well enough for this case and it doesn't require a whole macro processor, like m4 or php.

Later, I'll add formula convertion from LaTeX to MathML at the generation stage. For now, something
like [Temml](https://temml.org/index.html) would do the job client-side.
