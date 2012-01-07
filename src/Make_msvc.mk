#
# for debug:
#	$ nmake /F Make_msvc.mk
#
# for release:
#	$ nmake /F Make_msvc.mk NODEBUG=1

LUAEXE_NAME = lua52.exe
LUACEXE_NAME = luac52.exe
LUADLL_NAME = lua52.dll
LUALIB_NAME = lua52.lib

SRC_CORE =	\
	lapi.c lcode.c lctype.c ldebug.c ldo.c ldump.c lfunc.c lgc.c llex.c \
	lmem.c lobject.c lopcodes.c lparser.c lstate.c lstring.c ltable.c \
	ltm.c lundump.c lvm.c lzio.c
SRC_LIB =	\
	lauxlib.c lbaselib.c lbitlib.c lcorolib.c ldblib.c liolib.c \
	lmathlib.c loslib.c lstrlib.c ltablib.c loadlib.c linit.c
SRC_LUA =	lua.c
SRC_LUAC =	luac.c lopcodes.c
DEF_LUADLL =	lua.def

OBJ_CORE = $(SRC_CORE:.c=.obj)
OBJ_LIB = $(SRC_LIB:.c=.obj)
OBJ_LUA = $(SRC_LUA:.c=.obj)
OBJ_LUAC = $(SRC_LUAC:.c=.obj)
OBJ_ALL = $(OBJ_CORE) $(OBJ_LIB) $(OBJ_LUA) $(OBJ_LUAC)

DEFINES =	/D_CRT_SECURE_NO_WARNINGS=1 \
		/D_BIND_TO_CURRENT_VCLIBS_VERSION=1 \
		/DLUA_COMPAT_MODULE=1
CCFLAGS = $(DEFINES)
LDFLAGS =

############################################################################
### BUILD FRAMEWORK.

APPVER =	5.0
TARGETOS =	WINNT
TARGETLANG =	LANG_JAPANESE
_WIN32_IE = 0x0600
!INCLUDE <Win32.Mak>

build : $(LUAEXE_NAME) $(LUACEXE_NAME)

$(LUAEXE_NAME) : $(OBJ_LUA) $(LUALIB_NAME)
	$(link) /NOLOGO $(ldebug) $(conlflags) $(conlibsdll) $(LDFLAGS) \
		/OUT:$@ $(OBJ_LUA) $(LUALIB_NAME)
	IF EXIST $@.manifest \
	    mt -nologo -manifest $@.manifest -outputresource:$@;1

$(LUACEXE_NAME) : $(OBJ_LUAC) $(LUALIB_NAME)
	$(link) /NOLOGO $(ldebug) $(conlflags) $(conlibsdll) $(LDFLAGS) \
		/OUT:$@ $(OBJ_LUAC) $(LUALIB_NAME)
	IF EXIST $@.manifest \
	    mt -nologo -manifest $@.manifest -outputresource:$@;1

$(LUADLL_NAME) : $(DEF_LUADLL) $(OBJ_CORE) $(OBJ_LIB)
	$(link) /NOLOGO $(ldebug) $(dlllflags) $(conlibsdll) $(LDFLAGS) \
		/OUT:$@ /DEF:$(DEF_LUADLL) $(OBJ_CORE) $(OBJ_LIB)
	IF EXIST $@.manifest \
	    mt -nologo -manifest $@.manifest -outputresource:$@;2

$(LUALIB_NAME) : $(LUADLL_NAME)

.c.obj ::
	$(CC) $(cdebug) $(cflags) $(cvarsdll) $(CCFLAGS) /c $<

clean :
	del /F $(OBJ_ALL)
	del /F $(LUAEXE_NAME) $(LUAEXE_NAME).manifest
	del /F $(LUACEXE_NAME) $(LUACEXE_NAME).manifest
	del /F $(LUADLL_NAME) $(LUADLL_NAME).manifest
	del /F $(LUALIB_NAME)
	del /F *.pdb
	del /F *.exp
	del /F tags

tags: *.c *.h
	ctags -R *.c *.h

rebuild : clean tags build

.PHONY : build clean rebuild

############################################################################
### Dependencies.

lapi.obj: lapi.c lua.h luaconf.h lapi.h llimits.h lstate.h lobject.h ltm.h \
 lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lstring.h ltable.h lundump.h \
 lvm.h
lauxlib.obj: lauxlib.c lua.h luaconf.h lauxlib.h
lbaselib.obj: lbaselib.c lua.h luaconf.h lauxlib.h lualib.h
lbitlib.obj: lbitlib.c lua.h luaconf.h lauxlib.h lualib.h
lcode.obj: lcode.c lua.h luaconf.h lcode.h llex.h lobject.h llimits.h \
 lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h ldo.h lgc.h \
 lstring.h ltable.h lvm.h
lcorolib.obj: lcorolib.c lua.h luaconf.h lauxlib.h lualib.h
lctype.obj: lctype.c lctype.h lua.h luaconf.h llimits.h
ldblib.obj: ldblib.c lua.h luaconf.h lauxlib.h lualib.h
ldebug.obj: ldebug.c lua.h luaconf.h lapi.h llimits.h lstate.h lobject.h \
 ltm.h lzio.h lmem.h lcode.h llex.h lopcodes.h lparser.h ldebug.h ldo.h \
 lfunc.h lstring.h lgc.h ltable.h lvm.h
ldo.obj: ldo.c lua.h luaconf.h lapi.h llimits.h lstate.h lobject.h ltm.h \
 lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h lopcodes.h lparser.h \
 lstring.h ltable.h lundump.h lvm.h
ldump.obj: ldump.c lua.h luaconf.h lobject.h llimits.h lstate.h ltm.h \
 lzio.h lmem.h lundump.h
lfunc.obj: lfunc.c lua.h luaconf.h lfunc.h lobject.h llimits.h lgc.h \
 lstate.h ltm.h lzio.h lmem.h
lgc.obj: lgc.c lua.h luaconf.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
 lzio.h lmem.h ldo.h lfunc.h lgc.h lstring.h ltable.h
linit.obj: linit.c lua.h luaconf.h lualib.h lauxlib.h
liolib.obj: liolib.c lua.h luaconf.h lauxlib.h lualib.h
llex.obj: llex.c lua.h luaconf.h lctype.h llimits.h ldo.h lobject.h \
 lstate.h ltm.h lzio.h lmem.h llex.h lparser.h lstring.h lgc.h ltable.h
lmathlib.obj: lmathlib.c lua.h luaconf.h lauxlib.h lualib.h
lmem.obj: lmem.c lua.h luaconf.h ldebug.h lstate.h lobject.h llimits.h \
 ltm.h lzio.h lmem.h ldo.h lgc.h
loadlib.obj: loadlib.c lua.h luaconf.h lauxlib.h lualib.h
lobject.obj: lobject.c lua.h luaconf.h lctype.h llimits.h ldebug.h lstate.h \
 lobject.h ltm.h lzio.h lmem.h ldo.h lstring.h lgc.h lvm.h
lopcodes.obj: lopcodes.c lopcodes.h llimits.h lua.h luaconf.h
loslib.obj: loslib.c lua.h luaconf.h lauxlib.h lualib.h
lparser.obj: lparser.c lua.h luaconf.h lcode.h llex.h lobject.h llimits.h \
 lzio.h lmem.h lopcodes.h lparser.h ldebug.h lstate.h ltm.h ldo.h lfunc.h \
 lstring.h lgc.h ltable.h
lstate.obj: lstate.c lua.h luaconf.h lapi.h llimits.h lstate.h lobject.h \
 ltm.h lzio.h lmem.h ldebug.h ldo.h lfunc.h lgc.h llex.h lstring.h \
 ltable.h
lstring.obj: lstring.c lua.h luaconf.h lmem.h llimits.h lobject.h lstate.h \
 ltm.h lzio.h lstring.h lgc.h
lstrlib.obj: lstrlib.c lua.h luaconf.h lauxlib.h lualib.h
ltable.obj: ltable.c lua.h luaconf.h ldebug.h lstate.h lobject.h llimits.h \
 ltm.h lzio.h lmem.h ldo.h lgc.h lstring.h ltable.h lvm.h
ltablib.obj: ltablib.c lua.h luaconf.h lauxlib.h lualib.h
ltm.obj: ltm.c lua.h luaconf.h lobject.h llimits.h lstate.h ltm.h lzio.h \
 lmem.h lstring.h lgc.h ltable.h
lua.obj: lua.c lua.h luaconf.h lauxlib.h lualib.h
luac.obj: luac.c lua.h luaconf.h lauxlib.h lobject.h llimits.h lstate.h \
 ltm.h lzio.h lmem.h lundump.h ldebug.h lopcodes.h
lundump.obj: lundump.c lua.h luaconf.h ldebug.h lstate.h lobject.h \
 llimits.h ltm.h lzio.h lmem.h ldo.h lfunc.h lstring.h lgc.h lundump.h
lvm.obj: lvm.c lua.h luaconf.h ldebug.h lstate.h lobject.h llimits.h ltm.h \
 lzio.h lmem.h ldo.h lfunc.h lgc.h lopcodes.h lstring.h ltable.h lvm.h
lzio.obj: lzio.c lua.h luaconf.h llimits.h lmem.h lstate.h lobject.h ltm.h \
 lzio.h
