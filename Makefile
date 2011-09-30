#
# Makefile for rogue
# @(#)Makefile	4.13 (Berkeley) 1/23/82
#
# Rogue: Exploring the Dungeons of Doom
# Copyright (C) 1980, 1981, 1982 Michael Toy, Ken Arnold and Glenn Wichman
# All rights reserved.
#
# See the file LICENSE.TXT for full copyright and licensing information.
#

DISTNAME=rogue5.2.2

HDRS=	rogue.h extern.h
DOBJS=	vers.o extern.o armor.o chase.o command.o daemon.o daemons.o \
	fight.o init.o io.o list.o main.o misc.o monsters.o move.o \
	new_level.o options.o pack.o passages.o potions.o rings.o rip.o \
	rooms.o save.o scrolls.o state.o sticks.o things.o weapons.o wizard.o\
        xcrypt.o mdport.o
OBJS=	$(DOBJS) mach_dep.o
CFILES=	vers.c extern.c armor.c chase.c command.c daemon.c daemons.c \
	fight.c init.c io.c list.c main.c misc.c monsters.c move.c \
	new_level.c options.c pack.c passages.c potions.c rings.c rip.c \
	rooms.c save.c scrolls.c state.c sticks.c things.c weapons.c wizard.c \
	mach_dep.c xcrypt.c mdport.c
MISC=	Makefile LICENSE.TXT rogue.6 rogue.me

CC    = gcc
CFLAGS= -O3
CRLIB = -lcurses
RM    = rm -f
TAR   = tar

SCOREFILE=
SF=-DSCOREFILE=\"rogue52.scr\" -DLOCKFILE=\"rogue52.lck\"
NAMELIST=
NL=
#MACHDEP=	-DMAXLOAD=40 -DLOADAV -DCHECKTIME=4
MACHDEP=

.c.o:
	@echo $(CC) -c $(CFLAGS) $*.c
	@$(CC) -c $(CFLAGS) $*.c -o $*.o
#	@cpp -P $(CFLAGS) $*.c | ./xstr -v -c -
#	@cc -c $(CFLAGS) x.c
#	@mv x.o $*.o

rogue: $(HDRS) $(OBJS) # xs.o
#	@rm -f x.c
#	$(CC) $(LDFLAGS) xs.o $(OBJS) $(CRLIB) 
	$(CC) $(LDFLAGS) $(OBJS) $(CRLIB) -o $@

vers.o:
	$(CC) -c $(CFLAGS) vers.c

mach_dep.o: mach_dep.c
	$(CC) -c $(CFLAGS) $(SF) $(NL) $(MACHDEP) mach_dep.c

xs.o: strings
	./xstr
	$(CC) -c $(CFLAGS) xs.c

xstr: xstr.c
	$(CC) -s -O -o xstr xstr.c

findpw: findpw.c xcrypt.c
	$(CC) -s -o findpw findpw.c xcrypt.c

prob: prob.o extern.o xs.o
	$(CC) -O -o prob prob.o extern.o xs.o

prob.o: prob.c rogue.h
	$(CC) -O -c prob.c

clean:
	rm -f $(POBJS) $(OBJS) core a.out p.out rogue strings make.out rogue.tar vgrind.* x.c x.o xs.c xs.o linterrs findpw distmod.o xs.po xstr rogue rogue.exe rogue.tar.gz rogue.cat rogue.doc xstr.exe

dist.src:
	make clean
	tar cf $(DISTNAME)-src.tar $(CFILES) $(HDRS) $(MISC)
	gzip -f $(DISTNAME)-src.tar

debug.irix:
	make clean
	make CC=cc CFLAGS="-woff 1116 -g -DWIZARD" rogue
dist.irix:
	make clean
	make CC=cc CFLAGS="-woff 1116 -O3" rogue
	tbl rogue.me | nroff -me | colcrt - > rogue.doc
	nroff -man rogue.6 | colcrt - > rogue.cat
	tar cf $(DISTNAME)-irix.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-irix.tar

debug.aix:
	make clean
	make CC=xlc CFLAGS="-qmaxmem=16768 -g -qstrict -DWIZARD" rogue
dist.aix:
	make clean
	make CC=xlc CFLAGS="-qmaxmem=16768 -O3 -qstrict" rogue
	tbl rogue.me | nroff -me | colcrt - > rogue.doc
	nroff -man rogue.6 | colcrt - > rogue.cat
	tar cf $(DISTNAME)-aix.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-aix.tar

debug.linux:
	make clean
	make CFLAGS="-g3 -DWIZARD" rogue
dist.linux:
	make clean
	make rogue
	groff -P-c -t -me -Tascii rogue.me | sed -e 's/.\x08//g' > rogue.doc
	groff -man rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	tar cf $(DISTNAME)-linux.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-linux.tar
	
debug.interix:
	make clean
	make CFLAGS="-g3 -DWIZARD" rogue
dist.interix: 
	make clean
	make rogue
	groff -P-b -P-u -t -me -Tascii rogue.me > rogue.doc
	groff -P-b -P-u -man -Tascii rogue.6 > rogue.cat
	tar cf $(DISTNAME)-interix.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-interix.tar
	
debug.cygwin:
	make clean
	make CFLAGS="-g3 -DWIZARD" rogue
dist.cygwin:
	make clean
	make rogue
	groff -P-c -t -me -Tascii rogue.me | sed -e 's/.\x08//g' > rogue.doc
	groff -P-c -man -Tascii rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	tar cf $(DISTNAME)-cygwin.tar rogue.exe LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-cygwin.tar
	
debug.djgpp:
	make clean
	make CFLAGS="-g3 -DWIZARD" LDFLAGS="-L$(DJDIR)/LIB" CRLIB="-lpdcurses" rogue
dist.djgpp: 
	make clean
	make CFLAGS="-O3" LDFLAGS="-L$(DJDIR)/LIB" CRLIB="-lpdcurses" rogue
	groff -t -me -Tascii rogue.me | sed -e 's/.\x08//g' > rogue.doc
	groff -man -Tascii rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	rm -f $(DISTNAME)-djgpp.zip
	zip $(DISTNAME)-djgpp.zip rogue.exe LICENSE.TXT rogue.cat rogue.doc
