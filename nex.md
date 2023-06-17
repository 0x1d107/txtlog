title: Bash Nex Protocol Client
date: 2023-06-17
tags: projects

# Bare-bones Nex Protocol Client written in Bash
> [Nex](https://nex.nightfall.city/nex.txt) is a simple internet protocol designed for distributed
document retrieval. It's inspired by gopher and gemini.
 
Nex is like a cross between gemini and gopher. To get a content of a nex page user sends a selector
through a TCP socket. The directories are in plaintext with rocket links like in
[gemtext](https://gemini.circumlunar.space/docs/gemtext.gmi). Unlike in gemini, in nex there's no
TLS encryption between server and the client. Reading a page is as simple as using netcat/ 

```
echo '/' | nc nex.nightfall.city 1900
```

With the protocol as simple as this, there aren't many clients for it. So, I've hacked together a
bare-bones browser in bash, called [nexus.sh](scripts/nexus.sh). User can follow links by typing their number in the
`select` prompt.

```
=> nex://nex.nightfall.city/ <=
          .        
                    *
    .        +                       .
        N i g h t f a l l
       E  X  P  R  E  S  S      .
 *            .
                                  *
        .            '
                                        ,
Welcome to Nightfall City's Express Transportation System --
Nex! Nex is the best way to enjoy the city's landmarks and
scenic views. The shuttles are operated by Nightfall City's
Rail Company and boast modern design and comfort for its
users.
   .                         '
	[ Information ]                      *

Nex is a little internet protocol inspired by Gopher and
Gemini.
                                  +
=> nex.txt Read More
=> browsers.txt
=> servers.txt

	[ Stops ]

Want your own stop? Get space by sending me an email at
m15o at posteo dot net

=> m15o/

	[ Stations ]

=> nex://futurist.city/~jr/
1) .			     5) servers.txt
2) ..			     6) m15o/
3) nex.txt		     7) nex://futurist.city/~jr/
4) browsers.txt
#? 
```
