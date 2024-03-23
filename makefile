#! make -f
#
# makefile - start
#


# option
#

# directory
#

# source file directory
SRCDIR			=	sources

# include file directory
INCDIR			=	sources

# object file directory
OBJDIR			=	objects

# binary file directory
BINDIR			=	bin

# output file directory
OUTDIR			=	rom

# tool directory
TOOLDIR			=	tools

# vpath search directories
VPATH			=	$(SRCDIR):$(INCDIR):$(OBJDIR):$(BINDIR)

# assembler
#

# assembler command
AS				=	sdasz80

# assembler flags
ASFLAGS			=	-ls -I$(INCDIR) -I.

# c compiler
#

# c compiler command
CC				=	sdcc

# c compiler flags
CFLAGS			=	-mz80 --opt-code-speed -I$(INCDIR) -I.

# linker
#

# linker command
LD				=	sdcc

# linker flags
LDFLAGS			=	-mz80 --no-std-crt0 --nostdinc --nostdlib --code-loc 0x4020 --data-loc 0xc000

# suffix rules
#
.SUFFIXES:			.s .c .rel

# assembler source suffix
.s.rel:
	$(AS) $(ASFLAGS) -o $(OBJDIR)/$@ $<

# c source suffix
.c.rel:
	$(CC) $(CFLAGS) -o $(OBJDIR)/$@ -c $<

# project files
#

# target name
TARGET			=	DICE

# assembler source files
ASSRCS			=	crt0.s \
					main.s System.s \
					Math.s Sound.s \
					App.s \
					Title.s \
					Game.s Town.s Dungeon.s \
					Player.s Enemy.s Dice.s Maze.s Menu.s Camp.s Battle.s \
					pattern.s sprite.s \
					logo.s \
					monster_1.s monster_2.s monster_3.s monster_4.s monster_5.s monster_6.s monster_7.s

# c source files
CSRCS			=	

# object files
OBJS			=	$(ASSRCS:.s=.rel) $(CSRCS:.c=.rel)


# build project target
#
$(TARGET).com:		$(OBJS)
	$(LD) $(LDFLAGS) -o $(BINDIR)/$(TARGET).ihx $(foreach file,$(OBJS),$(OBJDIR)/$(file))
	$(TOOLDIR)/ihx2rom32k -o $(OUTDIR)/$(TARGET).ROM $(BINDIR)/$(TARGET).ihx

# clean project
#
clean:
	@rm -f $(OBJDIR)/*
	@rm -f $(BINDIR)/*
##	@rm -f makefile.depend

# build depend file
#
depend:
##	ifneq ($(strip $(CSRCS)),)
##		$(CC) $(CFLAGS) -MM $(foreach file,$(CSRCS),$(SRCDIR)/$(file)) > makefile.depend
##	endif

# build resource file
#
resource:
	@$(TOOLDIR)/image2pattern -n patternTable -o sources/pattern.s resources/picture/pattern.png
	@$(TOOLDIR)/image2sprite16 -n spriteTable -o sources/sprite.s resources/picture/sprite.png
	@$(TOOLDIR)/image2pattern -n logoTable -o sources/logo.s resources/picture/logo.png
	@$(TOOLDIR)/image2pattern -n monsterTable_1 -o sources/monster_1.s resources/picture/monster_1.png
	@$(TOOLDIR)/image2pattern -n monsterTable_2 -o sources/monster_2.s resources/picture/monster_2.png
	@$(TOOLDIR)/image2pattern -n monsterTable_3 -o sources/monster_3.s resources/picture/monster_3.png
	@$(TOOLDIR)/image2pattern -n monsterTable_4 -o sources/monster_4.s resources/picture/monster_4.png
	@$(TOOLDIR)/image2pattern -n monsterTable_5 -o sources/monster_5.s resources/picture/monster_5.png
	@$(TOOLDIR)/image2pattern -n monsterTable_6 -o sources/monster_6.s resources/picture/monster_6.png
	@$(TOOLDIR)/image2pattern -n monsterTable_7 -o sources/monster_7.s resources/picture/monster_7.png

# build tools
#
tool:
	@gcc -o $(TOOLDIR)/bin2s $(TOOLDIR)/bin2s.cpp
	@gcc -o $(TOOLDIR)/ihx2bload $(TOOLDIR)/ihx2bload.cpp
	@gcc -o $(TOOLDIR)/ihx2rom32k $(TOOLDIR)/ihx2rom32k.cpp
	@g++ -o $(TOOLDIR)/image2pattern `sdl2-config --cflags --libs` -lSDL2_image $(TOOLDIR)/image2pattern.cpp
	@g++ -o $(TOOLDIR)/image2screen1 `sdl2-config --cflags --libs` -lSDL2_image $(TOOLDIR)/image2screen1.cpp
	@g++ -o $(TOOLDIR)/image2sprite16 `sdl2-config --cflags --libs` -lSDL2_image $(TOOLDIR)/image2sprite16.cpp
	@g++ -o $(TOOLDIR)/chr2png -lpng $(TOOLDIR)/chr2png.cpp

# phony targets
#
.PHONY:				clean depend

# include depend file
#
-include makefile.depend


# makefile - end
