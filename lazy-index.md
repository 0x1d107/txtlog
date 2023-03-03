title: Lazy index generation for txt.log
date: 2023-03-03
tags: blog,projects

# Lazy index
Inspired by [lazyblog](http://alexey.shpakovsky.ru/en/lazyblog.html) and
[bashblog](https://github.com/cfenollosa/bashblog).
 Like in bashblog, the script still has to regenerate index page. But it regenerates it quickly
 simply by combining pre-generated index entries in files, sorted by name. That way we can order
 blog posts by `date` field in markdown file.
When each markdown file is processed, `lazyidx.sh` script generates file that contains appropriate `tr` table
row of index.html. At the end, all index entries are concatenated in the reverse order of file
names. These "row files" are named in the format `$date.$html.idx.html`, so we are effectively
sorting by date. 

`lazyidx.sh` also generates directories for each tag, where the script symlinks the "row file".
So generation of indices is a pretty simple task afterwards.

## Site generation speed
These measurements depend on the hardware you're running the script at 
(specifically the hard drive and cpu). Using a blog with 158 markdown files and a single parallel
job initial generation takes about 2 seconds.

```
anonyamous@localhost$ time make -j1

real	0m2.195s
user	0m1.718s
sys	    0m0.356s
```

Now if we add a new article, generation will take less than a second.

```
anonyamous@localhost$ vim article.md
anonyamous@localhost$ time make -j1
real	0m0.181s
user	0m0.095s
sys	    0m0.024s
```

And if we increase number of parallel jobs, full generation time is about 0.4 seconds.

```
anonyamous@localhost$ time make -j6
real	0m0.397s
user	0m1.781s
sys	    0m0.403s
```
