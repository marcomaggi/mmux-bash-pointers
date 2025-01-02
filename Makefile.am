## Process this file with automake to produce Makefile.in

ACLOCAL_AMFLAGS		= -I meta/autotools
AUTOMAKE_OPTIONS	= foreign
EXTRA_DIST		= INSTALL
dist_doc_DATA		= README COPYING
AM_CFLAGS		= $(MMUX_CFLAGS)
AM_CPPFLAGS		= -I$(srcdir)/src/ -I$(builddir)/src/
CLEANFILES		=
DISTCLEANFILES		=
BUILT_SOURCES		=

## --------------------------------------------------------------------

nodist_pkgconfig_DATA	= meta/scripts/mmux-bash-pointers.pc

## ------------------------------------------------------------------------

MBFLPP_PROG_FLAGS	= --bash-program="$(BASH_PROGRAM)" --define=__MBFL_LIBDIR__=$(MBFL_LIBDIR)
MBFLPP_PROG_FLAGS	+= --define=__LIBMBFL_LINKER__=$(MBFL_LIBMBFL_LINKER) --add-bash
MBFLPP_PROG_ENV		= MBFL_LIBRARY_PATH=$(builddir)/src/share/mbfl; export MBFL_LIBRARY_PATH;
MBFLPP_PROG_RUN		= $(MBFLPP_PROG_ENV) $(MBFLPP) $(MBFLPP_PROG_FLAGS) $(MBFLPP_FLAGS)


#### GNU m4 macros

EXTRA_DIST		+= \
	$(top_srcdir)/src/m4/macros-for-cc.m4	\
	$(top_srcdir)/src/m4/macros-for-bash.m4	\
	$(top_srcdir)/src/m4/mmux-bash-pointers-config.m4.in

MMUX_M4_FLAGS		=  $(M4FLAGS) --prefix-builtins --include=$(srcdir)/src/m4/
MMUX_M4_FLAGS		+= --include=$(builddir)/src/ --include=$(builddir)/src/m4

# These  are  used  to  preprocess C  language  files  with  extension
# ".c.m4".  Do not change the order of inclusion!!!
#
MMUX_M4_CC_MACROS	= \
	$(top_srcdir)/src/m4/macros-for-cc.m4

# These  are  used  to  preprocess   GNU  Bash  files  with  extension
# ".bash.m4".  Do not change the order of inclusion!!!
#
MMUX_M4_BASH_MACROS	= \
	$(top_srcdir)/src/m4/macros-for-bash.m4	\
	$(builddir)/src/m4/mmux-bash-pointers-config.m4


#### Automake dirstamp files

MMUX_AM_DIRSTAMP_FILES	= \
	src/m4/$(am__dirstamp)	\
	tests/$(am__dirstamp)

BUILT_SOURCES		+= $(MMUX_AM_DIRSTAMP_FILES)
DISTCLEANFILES		+= $(MMUX_AM_DIRSTAMP_FILES)

src/m4/$(am__dirstamp):
	@$(MKDIR_P) src/m4/
	@: > $(@)

tests/$(am__dirstamp):
	@$(MKDIR_P) tests/
	@: > $(@)


#### support for GNU Emacs

if WANT_EMACS
sharelispdir		= $(datadir)/emacs/site-lisp
dist_sharelisp_LISP	= src/emacs/mmux-bash-packages.el src/emacs/mmux-bash-pointers.el
endif


#### documentation

AM_MAKEINFOFLAGS	= --no-split
AM_MAKEINFOHTMLFLAGS	= --split=node -c WORDS_IN_PAGE=0 --css-ref=mmux-bash-pointers.css \
	-c PRE_BODY_CLOSE="<p>This document describes version <tt>$(PACKAGE_VERSION)</tt> of <em>$(PACKAGE_NAME)</em>.</p>"

info_TEXINFOS		= doc/mmux-bash-pointers.texi

EXTRA_DIST		+= doc/mmux-bash-pointers.style.css
CLEANFILES		+= doc/mmux-bash-pointers.css

doc_mmux_bash_pointers_TEXINFOS	= \
	doc/macros.texi			\
	doc/overview-linking.texi	\
	doc/mmux-version.texi		\
	doc/gpl-3.0.texi		\
	doc/fdl-1.3.texi

## --------------------------------------------------------------------

doc/mmux-bash-pointers.html/$(am__dirstamp): doc/$(am__dirstamp)
	@$(MKDIR_P) doc/mmux-bash-pointers.html/
	@: > doc/mmux-bash-pointers.html/$(am__dirstamp)

doc/mmux-bash-pointers.html/mmux-bash-pointers.css: \
	doc/mmux-bash-pointers.style.css doc/mmux-bash-pointers.html/$(am__dirstamp)
	$(INSTALL) -m 0444 "$(top_srcdir)/doc/mmux-bash-pointers.style.css" "$(builddir)/doc/mmux-bash-pointers.html/mmux-bash-pointers.css"

## --------------------------------------------------------------------

html-local: doc/mmux-bash-pointers.html/mmux-bash-pointers.css

install-html-local:
	$(MKDIR_P) "$(DESTDIR)$(htmldir)/mmux-bash-pointers.html/"
	$(INSTALL) -m 0444 $(builddir)/doc/mmux-bash-pointers.html/mmux-bash-pointers.css "$(DESTDIR)$(htmldir)/mmux-bash-pointers.html/"


#### shell libraries

EXTRA_DIST		+= \
	src/libmmux-bash-packages.bash.m4			\
	src/libmmux-bash-pointers.bash.m4			\
	$(top_srcdir)/meta/scripts/print-builtin-names.bash

MMUX_SHELL_LIBFILES	 = \
	src/libmmux-bash-packages.bash		\
	src/libmmux-bash-pointers.bash

BUILT_SOURCES		+= src/mmux-bash-pointers-builtin-definitions.bash
CLEANFILES		+= $(MMUX_SHELL_LIBFILES) src/mmux-bash-pointers-builtin-definitions.bash
mmuxbashlib_DATA	=  $(MMUX_SHELL_LIBFILES)
mmuxbashlibdir		=  $(datadir)/bash

src/mmux-bash-pointers-builtin-definitions.bash: $(top_srcdir)/meta/scripts/print-builtin-names.bash
	export CONFIG_H_FILE=$(builddir)/config.h; $(BASH_PROGRAM) $< >$@

src/libmmux-bash-pointers.bash: src/mmux-bash-pointers-builtin-definitions.bash

src/libmmux-bash-%.bash: src/libmmux-bash-%.bash.m4 $(MMUX_M4_BASH_MACROS)
	$(M4_PROGRAM) $(MMUX_M4_FLAGS) $(MMUX_M4_BASH_MACROS) $< >$@


#### libraries

EXTRA_DIST	+= \
	src/mmux-bash-pointers.h.m4			\
	src/mmux-bash-pointers-internals.h.m4		\
	src/mmux-bash-pointers-accessors.c.m4		\
	src/mmux-bash-pointers-arithmetics.c.m4		\
	src/mmux-bash-pointers-bash.c.m4		\
	src/mmux-bash-pointers-bind-functions.c.m4	\
	src/mmux-bash-pointers-bitwise.c.m4		\
	src/mmux-bash-pointers-characters.c.m4		\
	src/mmux-bash-pointers-comparison.c.m4		\
	src/mmux-bash-pointers-errors.c.m4		\
	src/mmux-bash-pointers-file-descriptors.c.m4	\
	src/mmux-bash-pointers-file-system.c.m4		\
	src/mmux-bash-pointers-library.c.m4		\
	src/mmux-bash-pointers-mathematics.c.m4		\
	src/mmux-bash-pointers-memory.c.m4		\
	src/mmux-bash-pointers-misc-builtins.c.m4	\
	src/mmux-bash-pointers-mutators.c.m4		\
	src/mmux-bash-pointers-persona.c.m4		\
	src/mmux-bash-pointers-predicates.c.m4		\
	src/mmux-bash-pointers-processes.c.m4		\
	src/mmux-bash-pointers-sockets.c.m4		\
	src/mmux-bash-pointers-strings.c.m4		\
	src/mmux-bash-pointers-system.c.m4		\
	src/mmux-bash-pointers-time.c.m4

MMUX_BASH_POINTERS_BUILT_SOURCES	= \
	src/mmux-bash-pointers.h			\
	src/mmux-bash-pointers-internals.h		\
	src/mmux-bash-pointers-accessors.c		\
	src/mmux-bash-pointers-arithmetics.c		\
	src/mmux-bash-pointers-bash.c			\
	src/mmux-bash-pointers-bind-functions.c		\
	src/mmux-bash-pointers-bitwise.c		\
	src/mmux-bash-pointers-characters.c		\
	src/mmux-bash-pointers-comparison.c		\
	src/mmux-bash-pointers-errors.c			\
	src/mmux-bash-pointers-file-descriptors.c	\
	src/mmux-bash-pointers-file-system.c		\
	src/mmux-bash-pointers-library.c		\
	src/mmux-bash-pointers-mathematics.c		\
	src/mmux-bash-pointers-memory.c			\
	src/mmux-bash-pointers-misc-builtins.c		\
	src/mmux-bash-pointers-mutators.c		\
	src/mmux-bash-pointers-persona.c		\
	src/mmux-bash-pointers-processes.c		\
	src/mmux-bash-pointers-predicates.c		\
	src/mmux-bash-pointers-sockets.c		\
	src/mmux-bash-pointers-strings.c		\
	src/mmux-bash-pointers-system.c			\
	src/mmux-bash-pointers-time.c

BUILT_SOURCES	+= $(MMUX_BASH_POINTERS_BUILT_SOURCES)
CLEANFILES	+= $(MMUX_BASH_POINTERS_BUILT_SOURCES)
DISTCLEANFILES	+= $(MMUX_BASH_POINTERS_BUILT_SOURCES)

mmux_bash_pointers_CURRENT	= @mmux_bash_pointers_VERSION_INTERFACE_CURRENT@
mmux_bash_pointers_REVISION	= @mmux_bash_pointers_VERSION_INTERFACE_REVISION@
mmux_bash_pointers_AGE		= @mmux_bash_pointers_VERSION_INTERFACE_AGE@
mmux_bash_pointers_LINKER_VERSION= -version-info $(mmux_bash_pointers_CURRENT):$(mmux_bash_pointers_REVISION):$(mmux_bash_pointers_AGE)

include_HEADERS				= \
	src/mmux-bash-pointers.h			\
	src/mmux-bash-pointers-config.h

lib_LTLIBRARIES				= libmmux-bash-pointers.la
libmmux_bash_pointers_la_CPPFLAGS	= $(AM_CPPFLAGS) -I$(builddir)/src
libmmux_bash_pointers_la_CFLAGS		= $(AM_CFLAGS) $(BASH_CFLAGS) $(MMUX_CC_TYPES_CFLAGS) $(MMUX_CC_LIBC_CFLAGS)
libmmux_bash_pointers_la_LDFLAGS	= $(mmux_bash_pointers_LINKER_VERSION) $(AM_LDFLAGS)
libmmux_bash_pointers_la_LIBADD		=  $(MMUX_CC_TYPES_LIBS) $(MMUX_CC_LIBC_LIBS)
libmmux_bash_pointers_la_SOURCES	= \
	src/mmux-bash-pointers.h			\
	src/mmux-bash-pointers-config.h			\
	src/mmux-bash-pointers-accessors.c		\
	src/mmux-bash-pointers-arithmetics.c		\
	src/mmux-bash-pointers-bash.c			\
	src/mmux-bash-pointers-bind-functions.c		\
	src/mmux-bash-pointers-bitwise.c		\
	src/mmux-bash-pointers-characters.c		\
	src/mmux-bash-pointers-comparison.c		\
	src/mmux-bash-pointers-errors.c			\
	src/mmux-bash-pointers-file-descriptors.c	\
	src/mmux-bash-pointers-file-system.c		\
	src/mmux-bash-pointers-internals.h		\
	src/mmux-bash-pointers-library.c		\
	src/mmux-bash-pointers-mathematics.c		\
	src/mmux-bash-pointers-memory.c			\
	src/mmux-bash-pointers-misc-builtins.c		\
	src/mmux-bash-pointers-mutators.c		\
	src/mmux-bash-pointers-persona.c		\
	src/mmux-bash-pointers-predicates.c		\
	src/mmux-bash-pointers-processes.c		\
	src/mmux-bash-pointers-sockets.c		\
	src/mmux-bash-pointers-strings.c		\
	src/mmux-bash-pointers-system.c			\
	src/mmux-bash-pointers-time.c

.PHONY: library

library: libmmux-bash-pointers.la

src/%.h: src/%.h.m4 $(MMUX_M4_CC_MACROS)
	$(M4_PROGRAM) $(MMUX_M4_FLAGS) $(MMUX_M4_CC_MACROS) $< >$@

src/%.c: src/%.c.m4 $(MMUX_M4_CC_MACROS)
	$(M4_PROGRAM) $(MMUX_M4_FLAGS) $(MMUX_M4_CC_MACROS) $< >$@

src/%.$(OBJEXT): \
	src/mmux-bash-pointers.h		\
	src/mmux-bash-pointers-internals.h	\
	src/mmux-bash-pointers-config.h


#### tests

EXTRA_DIST		+= \
	tests/test-arithmetics.bash.m4		\
	tests/test-arrays.bash.m4		\
	tests/test-bitwise.bash.m4		\
	tests/test-characters.bash.m4		\
	tests/test-comparison.bash.m4		\
	tests/test-complex.bash.m4		\
	tests/test-conversion.bash.m4		\
	tests/test-errors.bash.m4		\
	tests/test-file-descriptors.bash.m4	\
	tests/test-file-system.bash.m4		\
	tests/test-mathematics.bash.m4		\
	tests/test-memory.bash.m4		\
	tests/test-output-formats.bash.m4	\
	tests/test-packages.bash.m4		\
	tests/test-persona.bash.m4		\
	tests/test-pointers.bash.m4		\
	tests/test-predicates.bash.m4		\
	tests/test-processes.bash.m4		\
	tests/test-sockets.bash.m4		\
	tests/test-strings.bash.m4		\
	tests/test-structs.bash.m4		\
	tests/test-system-configuration.bash.m4	\
	tests/test-time.bash.m4			\
	tests/test-types.bash.m4		\
	tests/test-version.bash.m4

# For some reason  GNU Automake does not want  "TEST_EXTENSIONS" to be
# inside a conditional; so we put it here.
TEST_EXTENSIONS		= .bash

if WANT_MBFL_TESTING_ENABLED

MMUX_CHECK_BUILT_TESTS	= \
	tests/test-arithmetics.bash		\
	tests/test-arrays.bash			\
	tests/test-bitwise.bash			\
	tests/test-characters.bash		\
	tests/test-comparison.bash		\
	tests/test-complex.bash			\
	tests/test-conversion.bash		\
	tests/test-errors.bash			\
	tests/test-file-descriptors.bash	\
	tests/test-file-system.bash		\
	tests/test-mathematics.bash		\
	tests/test-memory.bash			\
	tests/test-output-formats.bash		\
	tests/test-packages.bash		\
	tests/test-persona.bash			\
	tests/test-pointers.bash		\
	tests/test-predicates.bash		\
	tests/test-processes.bash		\
	tests/test-sockets.bash			\
	tests/test-strings.bash			\
	tests/test-structs.bash			\
	tests/test-system-configuration.bash	\
	tests/test-time.bash			\
	tests/test-types.bash			\
	tests/test-version.bash

TESTS			= $(MMUX_CHECK_BUILT_TESTS)
check_SCRIPTS		= $(MMUX_CHECK_BUILT_TESTS)
CLEANFILES		+= $(MMUX_CHECK_BUILT_TESTS)

## --------------------------------------------------------------------

# This environment  setting is used  both to compile  ".bash.m4" files
# and to run ".bash" files.
#
MBFL_TESTS_ENV		= export MBFL_LIBRARY_PATH=$(builddir)/src:$(MBFL_LIBRARY_PATH);
# We  set TMPDIR  because  if the  "/tmp" directory  is  mounted on  a
# separate partition with "noexec"  attribute: tests for executability
# of files  will fail if  the temporary  test files are  created under
# "/tmp".
MBFL_TESTS_ENV		+= TMPDIR=$(PWD)/tmp; export TMPDIR;
MBFL_TESTS_ENV		+= testsdir=$(builddir)/tests; export testsdir;
MBFL_TESTS_ENV		+= TESTMATCH=$(TESTMATCH); export TESTMATCH;
MBFL_TESTS_ENV		+= export LD_LIBRARY_PATH=$(builddir)/.libs/:$(LD_LIBRARY_PATH);
MBFL_TESTS_COMPILE	= $(MBFL_TESTS_ENV) $(MBFLPP_PROG_RUN)
MBFL_TESTS_FLAGS	= $(MBFLPP_GENERAL_FLAGS)

MBFL_TESTS_PREREQUISITES= \
	libmmux-bash-pointers.la			\
	$(builddir)/src/libmmux-bash-packages.bash	\
	$(builddir)/src/libmmux-bash-pointers.bash

tests/test-%.bash: tests/test-%.bash.m4 $(MBFL_TESTS_PREREQUISITES)
	$(MBFL_TESTS_COMPILE) $(MBFL_TESTS_FLAGS) --output=$@ $<

## ------------------------------------------------------------------------

MBFL_TESTS_RUN_VERBENV	= TESTSUCCESS=yes; export TESTSUCCESS; TESTSTART=yes; export TESTSTART;
MBFL_TESTS_RUN_ENV	= $(MBFL_TESTS_ENV)
# Read "Parallel Test Harness" in the documentation of GNU Automake to
# understand how to use this interface for "make check".
#
# We must make sure that this ends with a semicolon!!!
AM_TESTS_ENVIRONMENT	= $(MBFL_TESTS_RUN_VERBENV) $(MBFL_TESTS_RUN_ENV)
# This variable name is  composed with the template "%s_LOG_COMPILER",
# where "%s" must be the test file extension.
BASH_LOG_COMPILER	= $(BASH_PROGRAM)
AM_TEST_LOG_FLAGS	= $(MBFLFLAGS)

## --------------------------------------------------------------------

endif


#### interface to "make installcheck"

if WANT_MBFL_TESTING_ENABLED

# This  thing with  the PATH  environment  variable is  needed to  run
# distcheck successfully.   We need  to remember  that, for  some sick
# reason, the  Bash built-in "source"  will search for the  file under
# PATH's directories.
#
MBFL_ICHECK_ENV	 = PATH=$(DESTDIR)$(bindir):$$PATH; export PATH;
MBFL_ICHECK_ENV	+= TMPDIR=$(PWD)/tmp; export TMPDIR;
MBFL_ICHECK_ENV	+= testsdir=$(builddir)/tests; export testsdir;
MBFL_ICHECK_ENV	+= export MBFL_LIBRARY_PATH=$(DESTDIR)$(mmuxbashlibdir):$(MBFL_LIBRARY_PATH);
MBFL_ICHECK_ENV	+= export LD_LIBRARY_PATH=$(DESTDIR)$(libdir):$(LD_LIBRARY_PATH);
MBFL_ICHECK_RUN	 = $(BASH_PROGRAM) $(MBFL_ICHECK_FLAGS)

# If a  test script executes no  test functions: its exit  code is 77,
# which signals  GNU Automake's  test harness that  the test  has been
# skipped.  This is fine when running  "make check", but will cause an
# error when  running "make installcheck";  so we intercept  that exit
# code and normalise it to 0.
#
# We  want  to support  the  case  of  a  ".test" script  being  under
# "$(srcdir)" rather than under "$(builddir)"; so we look for the file
# in both directories.
#
installcheck-local: $(TESTS)
	$(MBFL_ICHECK_ENV) RV=0					;\
	for FILE in $(TESTS)					;\
	do  echo "running: '$(builddir)/$$FILE'"		;\
	    if ! $(MBFL_ICHECK_RUN) "$(builddir)/$$FILE"	;\
	    then RV=$$?; break					;\
	    fi							;\
	done							;\
	if test "$$RV" = 77; then exit 0; else exit $$RV; fi	;

endif


#### common rules

include $(top_srcdir)/meta/automake/mmux-makefile-rules

### end of file
