# @configure_input@
#

AC_PREREQ([2.72])
MMUX_PKG_VERSIONS([0],[1],[0],[devel.1])
AC_INIT([MMUX Bash Pointers],[MMUX_PACKAGE_VERSION],
  [mrc.mgg@gmail.com],
  [mmux-bash-pointers],[https://github.com/marcomaggi/mmux-bash-pointers])
MMUX_INIT
MMUX_LIBTOOL_LIBRARY_VERSIONS([mmux_bash_pointers],0,0,0)
AC_REVISION([0.1])
AC_COPYRIGHT([Copyright (c) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

This program is free software: you  can redistribute it and/or modify it
under  the  terms of  the GNU  General Public  License as  published  by
the Free  Software Foundation, either version  3 of the License,  or (at
your option) any later version.

This program  is distributed  in the  hope that it  will be  useful, but
WITHOUT   ANY   WARRANTY;  without   even   the   implied  warranty   of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
])

AC_CONFIG_SRCDIR([src/])
AC_CONFIG_MACRO_DIR([meta/autotools])
AC_CONFIG_AUX_DIR([meta/autotools])
AC_USE_SYSTEM_EXTENSIONS
AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([1.17 foreign subdir-objects])
AM_MAINTAINER_MODE

AM_PROG_AR
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P

LT_PREREQ([2.4.7])
LT_INIT([disable-static])


#### basic system inspection

MMUX_CHECK_TARGET_OS
AX_IS_RELEASE([git-directory])

AC_LANG([C])
MMUX_LANG_C11

AM_PROG_AS
AM_PROG_CC_C_O
AC_PATH_PROG([M4_PROGRAM],[m4])
AC_PATH_PROG([BASH_PROGRAM],[/bin/bash],[/bin/bash],[:])

AC_CACHE_SAVE


#### external libraries

PKG_PREREQ([0.29])
PKG_INSTALLDIR
MMUX_CHECK_PKG_CONFIG_MACROS
PKG_CHECK_MODULES([BASH],[bash],,[AC_MSG_WARN([package GNU Bash not found])])

AC_SEARCH_LIBS(cos, m,, [AC_MSG_ERROR([Cannot find libm])])
PKG_CHECK_MODULES([MMUX_CC_TYPES],[mmux-cc-types >= 0.1.0])
PKG_CHECK_MODULES([MMUX_CC_LIBC], [mmux-cc-libc  >= 0.1.0])
MBFL_SETUP_FOR_TESTING([v3.0.0])

AC_CACHE_SAVE


#### inspect GNU Bash header files

m4_define([MMUX_BASH_INCLUDE_FILES],[
#ifdef HAVE_BASHTYPES_H
#  include <bashtypes.h>
#endif

#ifdef HAVE_BASHJMP_H
#  include <bashjmp.h>
#endif

#ifdef HAVE_BUILTINS_H
#  include <builtins.h>
#endif

#ifdef HAVE_SHELL_H
#  include <shell.h>
#endif

#ifdef HAVE_COMMON_H
#  include <common.h>
#endif
])

AC_DEFUN([MMUX_BASH_CONSTANT_TEST],[MMUX_CC_DETERMINE_VALUEOF([$1],[$1],[MMUX_BASH_INCLUDE_FILES])])
AC_DEFUN([MMUX_BASH_CONSTANT_TESTS],[m4_map_args_w($1,[MMUX_BASH_CONSTANT_TEST(],[)])])

MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([CFLAGS],[" $BASH_CFLAGS"],
  [MMUX_AUTOCONF_SAVE_SHELL_VARIABLE_WHILE_APPENDING([LIBS],[" $BASH_LIBS"],
     [AC_CHECK_HEADERS([bashtypes.h bashjmp.h builtins.h shell.h common.h],,
        [AC_MSG_ERROR([unable to find all the GNU Bash header files])],
        [MMUX_BASH_INCLUDE_FILES])
      MMUX_BASH_CONSTANT_TESTS([BUILTIN_ENABLED EXECUTION_SUCCESS EXECUTION_FAILURE EX_USAGE])])])

AC_CACHE_SAVE


#### external packages

AC_ARG_WITH([emacs],
  AS_HELP_STRING([--with-emacs],[enable installation of GNU Emacs module]),
  [true],[with_emacs=no])
AC_MSG_CHECKING([whether GNU Emacs module will be installed])
AS_VAR_IF(with_emacs,'yes',
  [AC_MSG_RESULT([yes])],
  [AC_MSG_RESULT([no])])
AM_CONDITIONAL([WANT_EMACS],[test x$with_emacs = xyes])
AS_VAR_IF(with_emacs,'yes',
  [AM_PATH_LISPDIR])


#### finish

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile]
  [src/mmux-bash-pointers-config.h]
  [src/m4/mmux-bash-pointers-config.m4]
  [doc/mmux-version.texi]
  [meta/scripts/mmux-bash-pointers.pc]
  [meta/slackware/slack-desc])
MMUX_OUTPUT
AC_OUTPUT

### end of file
