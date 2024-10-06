### mmux.m4 --
#
# Part of: MMUX Packages Infrastructure
# Contents: common GNU Autoconf macros
# Date: a long time ago
#
# Abstract
#
#       This  is a  collection of  GNU Autoconf  macros used,  by the  author, in  most of  the MMUX
#       packages.  To use it put the following in the "acinclude.m4" file:
#
#               m4_include(path/to/mmux.m4)
#
# Copyright (c) 2018, 2019, 2024 Marco Maggi <mrc.mgg@gmail.com>
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public  License as  published by  the Free Software  Foundation, either  version 3  of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# General Public License for more details.
#
# You should  have received a copy  of the GNU General  Public License along with  this program.  If
# not, see <http://www.gnu.org/licenses/>.
#


#### helpers

m4_define([mmux_is_yes],["x$[]$1" = "xyes"])
m4_define([mmux_is_no], ["x$[]$1" = "xno"])


# Synopsis
#
#       MMUX_PKG_VERSIONS([MAJOR_VERSION], [MINOR_VERSION], [PATCH_LEVEL], [PRERELEASE_TAG], [BUILD_METADATA])
#
# Description
#
#       Define the  appropriate m4 macros used  to set various package  semantic version components.
#       For the definition of semantic versioning see:
#
#                         <http://semver.org/>
#
#       This macro is meant to be used right before AC_INIT as:
#
#               MMUX_PKG_VERSIONS([MAJOR_VERSION],[MINOR_VERSION],[PATCH_LEVEL],[PRERELEASE_TAG],[BUILD_METADATA])
#               AC_INIT(..., MMUX_PACKAGE_VERSION, ...)
#
#        the arguments PRERELEASE_TAG and BUILD_METADATA are optional.  For example:
#
#               MMUX_PKG_VERSIONS([0],[1],[0],[devel.0],[x86_64])
#
#       The value of  PRERELEASE_TAG must be a  string like "devel.0", without a  leading dash.  The
#       value of BUILD_METADATA_TAG must be a string like "x86_64", without a leading plus.
#
#       This macro defines the following m4 macros:
#
#       MMUX_PACKAGE_MAJOR_VERSION: the major version number.
#
#       MMUX_PACKAGE_MINOR_VERSION: the minor version number.
#
#       MMUX_PACKAGE_PATCH_LEVEL: the patch level number.
#
#       MMUX_PACKAGE_PRERELEASE_TAG: the prerelease tag string as specified by semantic versioning.
#
#       MMUX_PACKAGE_BUILD_METADATA: the build metadata string as specified by semantic versioning.
#
#       MMUX_PACKAGE_VERSION: the package version string as required by AC_INIT; it includes neither
#       the prerelease tag nor the build metadata.
#
#       MMUX_PACKAGE_SEMANTIC_VERSION: the full semantic version string, with a leading "v".
#
#       MMUX_PACKAGE_PKG_CONFIG_VERSION:  the  version  number  to   use  in  the  module  file  for
#       "pkg-config".
#
m4_define([MMUX_PKG_VERSIONS],[
  m4_define([MMUX_PACKAGE_MAJOR_VERSION],  [$1])
  m4_define([MMUX_PACKAGE_MINOR_VERSION],  [$2])
  m4_define([MMUX_PACKAGE_PATCH_LEVEL],    [$3])
  m4_define([MMUX_PACKAGE_PRERELEASE_TAG], [$4])
  m4_define([MMUX_PACKAGE_BUILD_METADATA], [$5])

  # If a prerelease tag argument is present: define the associated component for the PACKAGE_VERSION
  # variable; otherwise define the component to the empty string.
  #
  # Note:  "m4_ifval" is  an Autoconf  macro,  see the  documentation  in the  node "Programming  in
  # M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG],
    m4_ifval(MMUX_PACKAGE_PRERELEASE_TAG,[-]MMUX_PACKAGE_PRERELEASE_TAG))

  # If a build metadata argument is present: define the associated component for the PACKAGE_VERSION
  # variable; otherwise define the component to the empty string.
  #
  # Note:  "m4_ifval" is  an Autoconf  macro,  see the  documentation  in the  node "Programming  in
  # M4sugar".
  m4_define([MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA],
    m4_ifval(MMUX_PACKAGE_BUILD_METADATA,[+]MMUX_PACKAGE_BUILD_METADATA))

  # Result variables.
  m4_define([MMUX_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG)
  m4_define([MMUX_PACKAGE_SEMANTIC_VERSION],[v]MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_VERSION__COMPONENT_PRERELEASE_TAG[]MMUX_PACKAGE_VERSION__COMPONENT_BUILD_METADATA)
  m4_define([MMUX_PACKAGE_PKG_CONFIG_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL)
])


# Synopsis
#
#       MMUX_INIT
#
# Description
#
#       Initialisation code for MMUX macros.
#
AC_DEFUN([MMUX_INIT],[
  AC_MSG_NOTICE([package major version:]  MMUX_PACKAGE_MAJOR_VERSION)
  AC_MSG_NOTICE([package minor version:]  MMUX_PACKAGE_MINOR_VERSION)
  AC_MSG_NOTICE([package patch level:]    MMUX_PACKAGE_PATCH_LEVEL)
  AC_MSG_NOTICE([package prerelease tag:] MMUX_PACKAGE_PRERELEASE_TAG)
  AC_MSG_NOTICE([package build metadata:] MMUX_PACKAGE_BUILD_METADATA)
  AC_MSG_NOTICE([package version:] MMUX_PACKAGE_VERSION)
  AC_MSG_NOTICE([package semantic version:] MMUX_PACKAGE_SEMANTIC_VERSION)
  AC_MSG_NOTICE([package pkg-config module version:] MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This is used to generate TAGS files for the C language.
  AS_VAR_SET([MMUX_DEPENDENCIES_INCLUDES])
])


# Synopsis
#
#       MMUX_OUTPUT
#
# Description
#
#       Define what is needed to end the MMUX  package preparations.  This macro is meant to be used
#       right before AC_output, as follows:
#
#               MMUX_OUTPUT
#               AC_OUTPUT
#
#       This macro defines the following substitutions:
#
#       MMUX_PKG_CONFIG_VERSION: the version string to be used in the module for pkg-config.
#
#       SLACKWARE_PACKAGE_VERSION: the version  string to be used when building  a Slackware package
#       file.
#
AC_DEFUN([MMUX_OUTPUT],[
  AC_SUBST([MMUX_PKG_MAJOR_VERSION],MMUX_PACKAGE_MAJOR_VERSION)
  AC_SUBST([MMUX_PKG_MINOR_VERSION],MMUX_PACKAGE_MINOR_VERSION)
  AC_SUBST([MMUX_PKG_PATCH_LEVEL],MMUX_PACKAGE_PATCH_LEVEL)
  AC_SUBST([MMUX_PKG_PRERELEASE_TAG],MMUX_PACKAGE_PRERELEASE_TAG)
  AC_SUBST([MMUX_PKG_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)
  AC_SUBST([MMUX_PKG_VERSION],MMUX_PACKAGE_VERSION)
  AC_SUBST([MMUX_PKG_SEMANTIC_VERSION],MMUX_PACKAGE_SEMANTIC_VERSION)

  # This is the version stored in the pkg-config data file.
  AC_SUBST([MMUX_PKG_CONFIG_VERSION],MMUX_PACKAGE_PKG_CONFIG_VERSION)

  # This  is the  version number  to be  used when  generating Slackware
  # packages.
  AC_SUBST([SLACKWARE_PACKAGE_VERSION],MMUX_PACKAGE_MAJOR_VERSION[.]MMUX_PACKAGE_MINOR_VERSION[.]MMUX_PACKAGE_PATCH_LEVEL[]MMUX_PACKAGE_PRERELEASE_TAG)

  # This  is  the build  metadata  string  to  be used  when  generating
  # Slackware  packages.   It  should  be  something  like  "noarch"  or
  # "x84_64".
  AC_SUBST([SLACKWARE_BUILD_METADATA],MMUX_PACKAGE_BUILD_METADATA)

  # This is used to generate TAGS files for the C language.
  AC_SUBST([MMUX_DEPENDENCIES_INCLUDES])
])


# Synopsis:
#
#       MMUX_CHECK_TARGET_OS
#
# Description:
#
#       Inspect  the value  of the  variable "target_os"  and defines  variables, substitutions  and
#       Automake conditionals according to it.
#
#       The following variables, substitutions and preprocessor macros are defined:
#
#       MMUX_ON_LINUX - set to 1 on a GNU+Linux system, otherwise set to 0.
#
#       MMUX_ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
#       MMUX_ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
#       MMUX_ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#
#       The following GNU Automake conditionals are defined:
#
#       ON_LINUX: set to 1 on a GNU+Linux system, otherwise set to 0.
#
#       ON_BSD: set to 1 on a BSD system, otherwise set to 0.
#
#       ON_CYGWIN: set to 1 on a CYGWIN system, otherwise set to 0.
#
#       ON_DARWIN: set to 1 on a Darwin system, otherwise set to 0.
#
AC_DEFUN([MMUX_CHECK_TARGET_OS],
  [AS_VAR_SET([MMUX_ON_LINUX], [0])
   AS_VAR_SET([MMUX_ON_BSD],   [0])
   AS_VAR_SET([MMUX_ON_CYGWIN],[0])
   AS_VAR_SET([MMUX_ON_DARWIN],[0])

   AS_CASE("$target_os",
     [*linux*],
     [AS_VAR_SET([MMUX_ON_LINUX],[1])
      AC_MSG_NOTICE([detected OS: linux])],
     [*bsd*],
     [AS_VAR_SET([MMUX_ON_BSD],[1])
      AC_MSG_NOTICE([detected OS: BSD])],
     [*cygwin*],
     [AS_VAR_SET([MMUX_ON_CYGWIN],[1])
      AC_MSG_NOTICE([detected OS: CYGWIN])],
     [*darwin*],
     [AS_VAR_SET([MMUX_ON_DARWIN],[1])
      AC_MSG_NOTICE([detected OS: DARWIN])])

   AM_CONDITIONAL([ON_LINUX], [test "x$MMUX_ON_LINUX"  = x1])
   AM_CONDITIONAL([ON_BSD],   [test "x$MMUX_ON_BSD"    = x1])
   AM_CONDITIONAL([ON_CYGWIN],[test "x$MMUX_ON_CYGWIN" = x1])
   AM_CONDITIONAL([ON_DARWIN],[test "x$MMUX_ON_DARWIN" = x1])

   AC_SUBST([MMUX_ON_LINUX], [$MMUX_ON_LINUX])
   AC_SUBST([MMUX_ON_BSD],   [$MMUX_ON_BSD])
   AC_SUBST([MMUX_ON_CYGWIN],[$MMUX_ON_CYGWIN])
   AC_SUBST([MMUX_ON_DARWIN],[$MMUX_ON_DARWIN])

   AC_DEFINE_UNQUOTED([MMUX_ON_LINUX], [$MMUX_ON_LINUX],  [True if the underlying platform is GNU+Linux])
   AC_DEFINE_UNQUOTED([MMUX_ON_BSD],   [$MMUX_ON_BSD],    [True if the underlying platform is BSD])
   AC_DEFINE_UNQUOTED([MMUX_ON_CYGWIN],[$MMUX_ON_CYGWIN], [True if the underlying platform is Cygwin])
   AC_DEFINE_UNQUOTED([MMUX_ON_DARWIN],[$MMUX_ON_DARWIN], [True if the underlying platform is Darwin])
   ])


# Synopsis:
#
#       MMUX_LIBTOOL_LIBRARY_VERSIONS(stem,current,revision,age)
#
# Parameters:
#
#       $1 - The library stem; if the library is "libspiffy.so", its stem is "spiffy"
#       $2 - The current version number.
#       $3 - The revision version number.
#       $4 - The age version number.
#
# Description:
#
#       Set version numbers for libraries built with GNU Libtool.  For details see the node "Libtool
#       versioning" in the GNU Libtool Info documentation.
#
AC_DEFUN([MMUX_LIBTOOL_LIBRARY_VERSIONS],
  [$1_VERSION_INTERFACE_CURRENT=$2
   $1_VERSION_INTERFACE_REVISION=$3
   $1_VERSION_INTERFACE_AGE=$4
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_CURRENT],
     [$$1_VERSION_INTERFACE_CURRENT],
     [current interface number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_REVISION],
     [$$1_VERSION_INTERFACE_REVISION],
     [current interface implementation number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_AGE],
     [$$1_VERSION_INTERFACE_AGE],
     [current interface age number])
   AC_DEFINE_UNQUOTED([$1_VERSION_INTERFACE_STRING],
     ["$$1_VERSION_INTERFACE_CURRENT.$$1_VERSION_INTERFACE_REVISION"],
     [library interface version])
   AC_SUBST([$1_VERSION_INTERFACE_CURRENT])
   AC_SUBST([$1_VERSION_INTERFACE_REVISION])
   AC_SUBST([$1_VERSION_INTERFACE_AGE])])


# Synopsis:
#
#       MMUX_AUTOCONF_ENABLE_OPTION(UPCASE_OPNAME, COMMAND_LINE_OPTION, DEFAULT, CHECKING_OPTION_MESSAGE, ENABLE_OPTION_MESSAGE)
#
# Parameters:
#
#       $1 - upper case option name
#       $2 - command line option name "--enable-$2"
#       $3 - default (yes, no)
#       $4 - text for the "checking option... " message
#       $5 - text for the "enable option... " message
#
# Description:
#
#       Wrapper  for  AC_ARG_ENABLE  which  adds  verbose messages  and  defines  a  shell  variable
#       "mmux_enable_$1" set to "yes" or "no".
#
# Usage example:
#
#               MMUX_AUTOCONF_ENABLE_OPTION([CC_TYPE_SLLONG], [mmux-cc-type-sllong], [yes],
#                 [whether to enable MMUX support for the C language type 'sllong'],
#                 [enables MMUX support for the C language type 'sllong'])
#
AC_DEFUN([MMUX_AUTOCONF_ENABLE_OPTION],
  [AS_VAR_SET(mmux_enable_$1,$3)
   AC_MSG_CHECKING([$4])
   AC_ARG_ENABLE([$2],
     [AS_HELP_STRING([--enable-$2],
        [$5 (default is $3)])],
     [AS_CASE([$enableval],
        [yes],[mmux_enable_$1=yes],
        [no], [mmux_enable_$1=no],
        [AC_MSG_ERROR([bad value $enableval for --enable-$2])])],
     [AS_VAR_SET(mmux_enable_$1,$3)])
   AC_MSG_RESULT([$mmux_enable_$1])])


# Synopsis:
#
#       MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([VARNAME],[BODY])
#
# Parameters:
#
#       $1 - The name of the variable to save.
#       $2 - The body to evaluate while the variable has been saved.
#
# Description:
#
#       Save the value of a shell variable while evaluating  a body of code.  Uses of this macro can
#       be nested, but not for the same variable.
#
#             MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([LIBS],
#               [AS_VAR_APPEND([LIBS],[" -lmylib"])
#                ...])
#
AC_DEFUN([MMUX_AUTOCONF_SAVE_SHELL_VARIABLE],[mmux_OLD_$1=$[]$1
$2
$1=$[]mmux_OLD_$1])


# Synopsis:
#
#       MMUX_CHECK_PKG_CONFIG_MACROS
#
# Description:
#
#       Test if  the macro PKG_CHECK_MODULES  is defined at  macro-expansion time.  This  test works
#       only if the file "configure.ac" also contains an actual expansion of PKG_CHECK_MODULES.
#
AC_DEFUN([MMUX_CHECK_PKG_CONFIG_MACROS],
  [AC_MSG_CHECKING([availability of pkg-config m4 macros])
   AS_IF([test m4_ifdef([PKG_CHECK_MODULES],[yes],[no]) == yes],
     [AC_MSG_RESULT([yes])],
     [AC_MSG_RESULT([no])
      AC_MSG_ERROR([pkg-config is required.  See pkg-config.freedesktop.org])])])


# Synopsis:
#
#       MMUX_LANG_C11
#
# Description:
#
#       Define the appropriate flags  to use the C11 standard language.  Such  flags are appended to
#       the current definition of the variable "CC".
#
#       This macro is meant to be used as:
#
#               AC_LANG([C])
#               MMUX_LANG_C11
#
#       If the variable "GCC" is set to "yes": select additional warning flags to be handed to the C
#       compiler.  Such flags are appended to the  variable MMUX_CFLAGS, which is also configured as
#       substitution  (and so  it becomes  a Makefile  variable).  We  should use  such variable  to
#       compile commands as follows, in "Makefile.am":
#
#               AM_CFLAGS = $(MMUX_CFLAGS)
#
AC_DEFUN([MMUX_LANG_C11],[
  AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
  AX_REQUIRE_DEFINED([AX_APPEND_COMPILE_FLAGS])
  AX_REQUIRE_DEFINED([AX_GCC_VERSION])
  AC_REQUIRE([AX_IS_RELEASE])

  AC_PROG_CC_C99
  AX_CHECK_COMPILE_FLAG([-std=c11],
    [AX_APPEND_FLAG([-std=c11], [CC])],
    [AC_MSG_ERROR([*** Compiler does not support -std=c11])],
    [-pedantic])

  AS_VAR_IF(GCC,'yes',
    [AX_GCC_VERSION])

  AC_SUBST([MMUX_CFLAGS])
  AC_DEFINE([_ISOC11_SOURCE],[1],[Enable the ISO C11 features.])

  # These flags are for every compiler.
  AS_VAR_IF(ax_is_release,'no',
    [AX_APPEND_COMPILE_FLAGS([-Wall -Wextra -pedantic], [MMUX_CFLAGS], [-Werror])])

  # These flags are for GCC only.
  AS_VAR_IF(ax_is_release,'no',
    [AS_VAR_IF(GCC,'yes',
      [AX_APPEND_COMPILE_FLAGS([-Wduplicated-cond -Wduplicated-branches -Wlogical-op -Wrestrict], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wnull-dereference -Wjump-misses-init -Wdouble-promotion -Wshadow], [MMUX_CFLAGS], [-Werror])
       AX_APPEND_COMPILE_FLAGS([-Wformat=2 -Wmisleading-indentation], [MMUX_CFLAGS], [-Werror])])])
  ])


# Synopsis:
#
#     MMUX_CC_CHECK_COMMON_HEADERS
#
# Description:
#
#     Check  for all  the  common C  language  headers needed  when writing  a  GNU Bash  builtins
#     extension; and probably something more.  We should just use this macro somewhere like this:
#
#             AC_LANG([C])
#             ...
#             MMUX_CC_CHECK_COMMON_HEADERS
#
AC_DEFUN([MMUX_CC_CHECK_COMMON_HEADERS],
  [AC_HEADER_ASSERT
   AC_HEADER_STDBOOL
   AC_HEADER_SYS_WAIT
   AC_CHECK_HEADERS([complex.h ctype.h errno.h fcntl.h float.h limits.h math.h regex.h stddef.h wchar.h sys/ioctl.h])
   AC_CACHE_SAVE])


# Synopsis:
#
#       MMUX_CC_COMMON_INCLUDES_FOR_TESTS
#
# Description:
#
#       Expand into include  directives for all the  common C language headers.  We  should use this
#       macro as parameter for  all the GNU Autoconf macros that preprocess a  C language program in
#       tests.
#
#       According  to the  documentation of  GNU Autoconf  2.72: "AC_INCLUDES_DEFAULT"  used without
#       parameters should expand  to the include directives for:  "stdio.h", "stdlib.h", "string.h",
#       "inttypes.h", "stdint.h", "strings.h", "sys/types.h", "sys/stat.h", and "unistd.h".  It also
#       checks all those headers as a side effect of this macro use's expansion.
#
#       When used  with a parameter:  AC_INCLUDES_DEFAULT should expand to  its parameter; I  do not
#       know what value there  is in wrapptng the directives like this, but  let's do it.  Let's try
#       to keep the directives in alphabetical order.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_VALUEOF([SIZEOF_MY_TYPE], [sizeof(my_type_t)],
#                                 [MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
#
m4_define([MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[
AC_INCLUDES_DEFAULT
AC_INCLUDES_DEFAULT([
#ifdef HAVE_ARPA_INET_H
#  include <arpa/inet.h>
#endif

#ifdef HAVE_ASSERT_H
#  include <assert.h>
#endif

#ifdef HAVE_COMPLEX_H
#  include <complex.h>
#endif

#ifdef HAVE_CTYPE_H
#  include <ctype.h>
#endif

#ifdef HAVE_DIRENT_H
#  include <dirent.h>
#endif

#ifdef HAVE_ERRNO_H
#  include <errno.h>
#endif

#ifdef HAVE_FCNTL_H
#  include <fcntl.h>
#endif

#ifdef HAVE_FLOAT_H
#  include <float.h>
#endif

#ifdef HAVE_GRP_H
#  include <grp.h>
#endif

#ifdef HAVE_LIMITS_H
#  include <limits.h>
#endif

#ifdef HAVE_LINUX_FS_H
#  include <linux/fs.h>
#endif

#ifdef HAVE_MATH_H
#  include <math.h>
#endif

#ifdef HAVE_NETDB_H
#  include <netdb.h>
#endif

#ifdef HAVE_NETINET_IN_H
#  include <netinet/in.h>
#endif

#ifdef HAVE_PWD_H
#  include <pwd.h>
#endif

#ifdef HAVE_SIGNAL_H
#  include <signal.h>
#endif

#ifdef HAVE_STDBOOL_H
#  include <stdbool.h>
#endif

#ifdef HAVE_STDDEF_H
#  include <stddef.h>
#endif

#ifdef HAVE_SYS_AUXV_H
#  include <sys/auxv.h>
#endif

#ifdef HAVE_SYS_MMAN_H
#  include <sys/mman.h>
#endif

#ifdef HAVE_SYS_RESOURCE_H
#  include <sys/resource.h>
#endif

#ifdef HAVE_SYS_SELECT_H
#  include <sys/select.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#  include <sys/socket.h>
#endif

#ifdef HAVE_SYS_SYSCALL_H
#  include <sys/syscall.h>
#endif

#ifdef HAVE_SYS_TIME_H
#  include <sys/time.h>
#endif

#ifdef HAVE_SYS_UIO_H
#  include <sys/uio.h>
#endif

#ifdef HAVE_SYS_UN_H
#  include <sys/un.h>
#endif

#ifdef HAVE_TIME_H
#  include <time.h>
#endif

#ifdef HAVE_WAIT_H
#  include <wait.h>
#endif

#ifdef HAVE_WCHAR_H
#  include <wchar.h>
#endif
])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_VALUEOF(STEM, EXPRESSION, INCLUDES)
#
# Parameters:
#
#       $1 - Mandatory uppercase stem used to generate output variables and C preprocessor symbols.
#       $2 - Mandatory C language expression which, executed in a C program, returns the constant.
#       $3 - Optional  C language  preprocessor  directives to  include header  files; defaults  to
#            MMUX_CC_COMMON_INCLUDES_FOR_TESTS.
#
# Description:
#
#       Determine the value of a C language constant expression returning an exact integer.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_VALUEOF([EINVAL], [EINVAL], [#ifdef HAVE_ERRNO_H
#       #  include <errno.h>
#       #endif])
#
# to determine the existence and value of the "errno" constant "EINVAL"; results:
#
# mmux_cv_valueof_EINVAL
#
#     A shell variable used  to cache the result.  If the symbol "EINVAL"  exists: the shell value
#     is the value of the constant itself.  If the symbol "EINVAL" does not exist: the shell value
#     is the string "MMUX_META_VALUE_UNDEFINED".
#
# MMUX_HAVE_EINVAL
#
#     A C language  preprocessor symbol.  If the symbol "EINVAL"  exists: the preprocessor symbols
#     is defined to  be "1".  If the symbol  "EINVAL" does not exist: the  preprocessor symbols is
#     defined to be "0".
#
# MMUX_VALUEOF_EINVAL
#
#     A C language preprocessor symbol.  Its uses expand to the value of EINVAL itself.
#
# MMUX_VALUEOF_EINVAL
#
#     A GNU Autoconf substitution symbol.  Its uses expand to the value of EINVAL itself.
#
AC_DEFUN([MMUX_CC_DETERMINE_VALUEOF],
  [AC_CACHE_CHECK([the value of '$2'],
     [mmux_cv_valueof_$1],
     [AC_COMPUTE_INT([mmux_cv_valueof_$1],
        [$2],
        [m4_ifblank([$3],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[$3])],
        [AS_VAR_SET([mmux_cv_valueof_$1],[MMUX_META_VALUE_UNDEFINED])])])
    AS_IF([test "x$mmux_cv_valueof_$1" = xMMUX_META_VALUE_UNDEFINED],
          [AS_VAR_SET([MMUX_HAVE_$1],[0])],
          [AS_VAR_SET([MMUX_HAVE_$1],[1])])
    AC_DEFINE_UNQUOTED([MMUX_HAVE_$1],   [$MMUX_HAVE_$1],[The constant value $1 is defined.])
    AC_DEFINE_UNQUOTED([MMUX_VALUEOF_$1],[$mmux_cv_valueof_$1],[The constant value $1.])
    AC_SUBST([MMUX_VALUEOF_$1],[$mmux_cv_valueof_$1])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF, INCLUDES)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#       $3 - Optional  C language  preprocessor  directives to  include header files; defaults  to
#            MMUX_CC_COMMON_INCLUDES_FOR_TESTS.
#
# Description:
#
#       Determine the size in bytes of the C language type TYEPDEF, which can be either a standard C
#       language type or a custom type definition.
#
#       If an error occurs determining the type size: all the results will report a size of zero.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
#       Notice  that GNU  Autoconf already  defines "AC_CHECK_SIZEOF",  but sometimes  someone might
#       prefer this macros.
#
# Usage example:
#
#       MMUX_CC_DETERMINE_TYPE_SIZEOF(SSIZE, ssize_t)
#
#       determine the size  of the standard C  language type "ssize_t"; we  expect it to be  4 or 8.
#       Usage example results:
#
#       mmux_cv_cc_type_sizeof_ssize
#             Cached shell variable representing the result of the test: the size measured in bytes.
#             The stem "ssize" is the result of converting the parameter STEM to lower case.
#
#       MMUX_CC_TYPE_SIZEOF_SSIZE
#             C language preprocessor symbol  which will expand to the size  measured in bytes.  The
#             stem "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_SIZEOF_SSIZE
#             GNU Autoconf substitution symbol which will expand to the size measured in bytes.  The
#             stem "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_TYPE_SIZEOF],
  [AC_CACHE_CHECK([the size measured in bytes of the C language type '$2'],
     [mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
     [AC_COMPUTE_INT([mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
        [sizeof($2)],
        [m4_ifblank([$3],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS],[$3])],
        [AS_VAR_SET([mmux_cv_cc_type_sizeof_[]m4_tolower($1)],[0])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_SIZEOF_[]m4_toupper($1),
     [$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],
     [The size measured in bytes of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_SIZEOF_[]m4_toupper($1),[$mmux_cv_cc_type_sizeof_[]m4_tolower($1)])])


# Synopsis:
#
#       MMUX_CC_CHECK_STANDARD_TYPES
#
# Description:
#
#       Check the availability of all the supported C language types.
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPES],
  [MMUX_CC_CHECK_TYPE_SLLONG
   MMUX_CC_CHECK_TYPE_ULLONG
   MMUX_CC_CHECK_TYPE_LDOUBLE

   MMUX_CC_CHECK_TYPE_COMPLEXF
   MMUX_CC_CHECK_TYPE_COMPLEXD
   MMUX_CC_CHECK_TYPE_COMPLEXLD

   AC_TYPE_INT8_T
   AC_TYPE_INT16_T
   AC_TYPE_INT32_T
   AC_TYPE_INT64_T
   AC_TYPE_UINT8_T
   AC_TYPE_UINT16_T
   AC_TYPE_UINT32_T
   AC_TYPE_UINT64_T

   AC_TYPE_MODE_T
   AC_TYPE_OFF_T
   AC_TYPE_PID_T
   AC_TYPE_SIZE_T
   AC_TYPE_SSIZE_T
   AC_TYPE_INTMAX_T
   AC_TYPE_INTPTR_T

   # This defines both "uid_t" and "gid_t".
   AC_TYPE_UID_T])


# Synopsis:
#
#       MMUX_CC_INSPECT_STANDARD_TYPES
#
# Description:
#
#       Determine the size, measured  in bytes, of all the standard C language  types; only the core
#       types  are checked  (int, long,  int32_t, ...),  none of  the feature-specific  typedefs are
#       checked (size_t, pid_t, ...).
#
AC_DEFUN([MMUX_CC_INSPECT_STANDARD_TYPES],
  [AX_REQUIRE_DEFINED([MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_REQUIRE([MMUX_CC_CHECK_COMMON_HEADERS])
   AC_REQUIRE([AC_TYPE_INT8_T])
   AC_REQUIRE([AC_TYPE_INT16_T])
   AC_REQUIRE([AC_TYPE_INT32_T])
   AC_REQUIRE([AC_TYPE_INT64_T])
   AC_REQUIRE([AC_TYPE_UINT8_T])
   AC_REQUIRE([AC_TYPE_UINT16_T])
   AC_REQUIRE([AC_TYPE_UINT32_T])
   AC_REQUIRE([AC_TYPE_UINT64_T])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([POINTER],    [void *])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([SCHAR],      [signed char])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UCHAR],      [unsigned char])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SSHORT],     [signed short int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([USHORT],     [unsigned short int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT],       [signed int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT],       [unsigned int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SLONG],      [signed long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([ULONG],      [unsigned long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SLLONG],     [signed long long int])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([ULLONG],     [unsigned long long int])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([FLOAT],      [float])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([DOUBLE],     [double])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([LDOUBLE],    [long double])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([COMPLEX],    [double complex])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT8],      [int8_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT8],      [uint8_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT16],     [int16_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT16],     [uint16_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT32],     [int32_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT32],     [uint32_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINT64],     [int64_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINT64],     [uint64_t])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE(STEM, TYPEDEF)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#
# Description:
#
#       Determine the standard C  language type of which the exact signed  integer type "TYPEDEF" is
#       an alias; the standard  type is represented by one of the  stems: "schar", "sshort", "sint",
#       "slong", "sllong", "sint8", "sint16", "sint32", "sint64".
#
#       It is a fatal error if a standard stem alias is not found.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
# Prerequisites:
#
#       The expansion of this macro must be executed only after the expansion of the following macro
#       use has been executed:
#
#               MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF)
#
#       which will inspect the same type.
#
# Usage example:
#
#               MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SSIZE],[ssize_t])
#
#       determine the standard C  language type of which the exact signed  integer type "ssize_t" is
#       an alias; we expect the alias to be "sint" or "slong".  Usage example results:
#
#       mmux_cv_type_stem_alias_of_ssize
#               Cached shell variable  representing the result of  the test: the variable  is set to
#               the standard stem.  The stem "ssize" is  the result of converting the parameter STEM
#               to lower case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               C  language preprocessor  symbol which  expands into  the standard  stem.  The  stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               GNU Autoconf  substitution symbol which  expands into  the standard stem.   The stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE],
  [AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_CACHE_CHECK([the standard exact signed integer type alias of the custom exact signed integer '$2' (size=$mmux_cv_cc_type_sizeof_[]m4_tolower($1))],
     [mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [AS_CASE([$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],

        [$mmux_cv_cc_type_sizeof_schar],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[schar])],

        [$mmux_cv_cc_type_sizeof_sshort],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sshort])],

        [$mmux_cv_cc_type_sizeof_sint],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint])],

        [$mmux_cv_cc_type_sizeof_slong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[slong])],

        [$mmux_cv_cc_type_sizeof_sllong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sllong])],

        [$mmux_cv_cc_type_sizeof_sint8],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint8])],

        [$mmux_cv_cc_type_sizeof_sint16],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint16])],

        [$mmux_cv_cc_type_sizeof_sint32],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint32])],

        [$mmux_cv_cc_type_sizeof_sint64],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[sint64])],

        # There is no stadard alias.  This should not happen.
        [AC_MSG_ERROR([unable to determine exact signed integer standard C language type alias of '$2'])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),
     [$mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [Stem of C language standard type which is an alias of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),[$mmux_cv_type_stem_alias_of_[]m4_tolower($1)])])


# Synopsis:
#
#       MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE(STEM, TYPEDEF)
#
# Parameters:
#
#       $1 - The custom type stem, used to define output names.
#       $2 - The custom type name, usually a C language "typedef".
#
# Description:
#
#       Determine the standard C language type of which the exact unsigned integer type "TYPEDEF" is
#       an alias; the standard  type is represented by one of the  stems: "uchar", "ushort", "uint",
#       "ulong", "ullong", "uint8", "uint16", "uint32", "uint64".
#
#       It is a fatal error if a standard stem alias is not found.
#
#       The parameter STEM is conerted to upper case or  lower case as needed, so it does not matter
#       if tha parameter itself is upper case or lower case.
#
# Prerequisites:
#
#       The expansion of this macro must be executed only after the expansion of the following macro
#       use has been executed:
#
#               MMUX_CC_DETERMINE_TYPE_SIZEOF(STEM, TYPEDEF)
#
#       which will inspect the same type.
#
# Usage example:
#
#               MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([USIZE],[size_t])
#
#       determine the standard C language type of  which the exact unsigned integer type "size_t" is
#       an alias; we expect the alias to be "uint" or "ulong".  Usage example results:
#
#       mmux_cv_type_stem_alias_of_usize
#               Cached shell variable  representing the result of  the test: the variable  is set to
#               the standard stem.  The stem "usize" is  the result of converting the parameter STEM
#               to lower case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               C  language preprocessor  symbol which  expands into  the standard  stem.  The  stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
#       MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_SSIZE
#               GNU Autoconf  substitution symbol which  expands into  the standard stem.   The stem
#               "SSIZE" is the result of converting the parameter STEM to upper case.
#
AC_DEFUN([MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE],
  [AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_CACHE_CHECK([the standard exact unsigned integer type alias of the custom exact unsigned integer '$2' (size=$mmux_cv_cc_type_sizeof_[]m4_tolower($1))],
     [mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [AS_CASE([$mmux_cv_cc_type_sizeof_[]m4_tolower($1)],

        [$mmux_cv_cc_type_sizeof_uchar],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uchar])],

        [$mmux_cv_cc_type_sizeof_ushort],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ushort])],

        [$mmux_cv_cc_type_sizeof_uint],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint])],

        [$mmux_cv_cc_type_sizeof_ulong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ulong])],

        [$mmux_cv_cc_type_sizeof_ullong],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[ullong])],

        [$mmux_cv_cc_type_sizeof_uint8],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint8])],

        [$mmux_cv_cc_type_sizeof_uint16],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint16])],

        [$mmux_cv_cc_type_sizeof_uint32],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint32])],

        [$mmux_cv_cc_type_sizeof_uint64],
        [AS_VAR_SET([mmux_cv_type_stem_alias_of_[]m4_tolower($1)],[uint64])],

        # There is no stadard alias.  This should not happen.
        [AC_MSG_ERROR([unable to determine exact unsigned integer standard C language type alias of '$2'])])])
   AC_DEFINE_UNQUOTED(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),
     [$mmux_cv_type_stem_alias_of_[]m4_tolower($1)],
     [Stem of C language standard type which is an alias of '$2'.])
   AC_SUBST(MMUX_CC_TYPE_STANDARD_STEM_ALIAS_OF_[]m4_toupper($1),[$mmux_cv_type_stem_alias_of_[]m4_tolower($1)])])


# Synopsis:
#
#     MMUX_CC_INSPECT_STANDARD_FEATURE_TYPES
#
# Description:
#
#     Determine the  size, measured  in bytes,  of all the  supported standard,  feature-specific, C
#     language  types   (size_t,  pid_t,  ...).   It   also  determines  aliases  that   match  each
#     feature-specific type with  the raw type; for example:  we expect "size_t" to be  an alias for
#     "unsigned long" or something like that.
#
AC_DEFUN([MMUX_CC_INSPECT_STANDARD_FEATURE_TYPES],
  [AX_REQUIRE_DEFINED([MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_REQUIRE([MMUX_CC_CHECK_COMMON_HEADERS])
   AC_REQUIRE([MMUX_CC_INSPECT_STANDARD_TYPES])
   AC_REQUIRE([AC_TYPE_MODE_T])
   AC_REQUIRE([AC_TYPE_OFF_T])
   AC_REQUIRE([AC_TYPE_PID_T])
   AC_REQUIRE([AC_TYPE_SIZE_T])
   AC_REQUIRE([AC_TYPE_SSIZE_T])
   AC_REQUIRE([AC_TYPE_INTMAX_T])
   AC_REQUIRE([AC_TYPE_INTPTR_T])
   AC_REQUIRE([AC_TYPE_UID_T])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([SSIZE],      [ssize_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([USIZE],      [size_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINTMAX],    [intmax_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINTMAX],    [uintmax_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([SINTPTR],    [intptr_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UINTPTR],    [uintptr_t])

   MMUX_CC_DETERMINE_TYPE_SIZEOF([PTRDIFF],    [ptrdiff_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([MODE],       [mode_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([OFF],        [off_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([UID],        [uid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([PID],        [pid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([GID],        [gid_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([WCHAR],      [wchar_t])
   MMUX_CC_DETERMINE_TYPE_SIZEOF([WINT],       [wint_t])

   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SSIZE],        [ssize_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SINTMAX],      [intmax_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([SINTPTR],      [intptr_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([OFF],          [off_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([PID],          [pid_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([PTRDIFF],      [ptrdiff_t])
   MMUX_CC_DETERMINE_SIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([WCHAR],        [wchar_t])

   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([USIZE],      [size_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UINTMAX],    [uintmax_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UINTPTR],    [uintptr_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([MODE],       [mode_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([UID],        [uid_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([GID],        [gid_t])
   MMUX_CC_DETERMINE_UNSIGNED_INTEGER_ALIAS_FOR_CUSTOM_TYPE([WINT],       [wint_t])])


# Synopsis:
#
#     MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_FLOAT
#
# Description:
#
#     Check  the availability  of all  the supported  C language  types "_FloatN"  and "_FloatNx".
#     These types should not require an external library.
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_FLOAT],
  [MMUX_CC_CHECK_TYPE_FLOAT32
   MMUX_CC_CHECK_TYPE_FLOAT64
   MMUX_CC_CHECK_TYPE_FLOAT128
   MMUX_CC_CHECK_TYPE_FLOAT32X
   MMUX_CC_CHECK_TYPE_FLOAT64X
   MMUX_CC_CHECK_TYPE_FLOAT128X

   MMUX_CC_CHECK_TYPE_COMPLEXF32
   MMUX_CC_CHECK_TYPE_COMPLEXF64
   MMUX_CC_CHECK_TYPE_COMPLEXF128
   MMUX_CC_CHECK_TYPE_COMPLEXF32X
   MMUX_CC_CHECK_TYPE_COMPLEXF64X
   MMUX_CC_CHECK_TYPE_COMPLEXF128X

   AC_CACHE_SAVE])


# Synopsis:
#
#     MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_DECIMAL_FLOAT
#
# Description:
#
#     Check the availability of all the supported C language types "_DecimalN".
#
#     At the  time of  this writing (Oct  2, 2024)  support for these  types probably  requires an
#     external library, so the macro:
#
#             MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY
#
#     should be  used to search  for such library.   All the macros used  to check for  a specific
#     "_DecimalN" type should "AC_REQUIRE" such macro, so we do not do it here.
#
AC_DEFUN([MMUX_CC_CHECK_STANDARD_TYPE_EXTENSION_DECIMAL_FLOAT],
  [MMUX_CC_CHECK_TYPE_DECIMAL32
   MMUX_CC_CHECK_TYPE_DECIMAL64
   MMUX_CC_CHECK_TYPE_DECIMAL128])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_SLLONG
#
# Description:
#
#     Check if  the underlying platform  supports the standard C  language type "signed  long long
#     int".  If it does: define the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_SLLONG" to "1".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_SLLONG],
  [AS_VAR_SET([MMUX_HAVE_CC_TYPE_SLLONG],[0])
   MMUX_AUTOCONF_ENABLE_OPTION([CC_TYPE_SLLONG], [mmux-cc-type-sllong], [yes],
     [whether to enable MMUX support for the C language type 'sllong'],
     [enables MMUX support for the C language type 'sllong'])
   AS_IF([test mmux_is_yes([mmux_enable_CC_TYPE_SLLONG])],
     [AC_TYPE_LONG_LONG_INT
      AC_MSG_CHECKING([for MMUX supporting 'signed long long int'])
      AS_IF([test mmux_is_yes([ac_cv_type_long_long_int])],
            [AS_VAR_SET([MMUX_HAVE_CC_TYPE_SLLONG],[1])
             AC_MSG_RESULT([yes])],
            [AC_MSG_RESULT([no])])])
   AC_SUBST([MMUX_HAVE_CC_TYPE_SLLONG])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_ULLONG
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "unsigned long long
#     int".  If it does: define the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_ULLONG" to "1".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_ULLONG],
  [AC_TYPE_UNSIGNED_LONG_LONG_INT
   AC_MSG_CHECKING([for MMUX supporting 'unsigned long long int'])
   AS_IF([test mmux_is_yes([ac_cv_type_unsigned_long_long_int])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_ULLONG],[1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_ULLONG],[0])
          AC_MSG_RESULT([no])])
   AC_SUBST([MMUX_HAVE_CC_TYPE_ULLONG])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_LDOUBLE
#
# Description:
#
#     Check if the underlying  platform supports the standard C language type  "long double".  If it
#     does:
#
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_LDOUBLE".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_LDOUBLE],
  [AC_TYPE_LONG_DOUBLE
   AC_MSG_CHECKING([for MMUX supporting 'long double'])
   AS_IF([test mmux_is_yes([ac_cv_type_long_double])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_LDOUBLE],  [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_LDOUBLE],  [0])
          AC_MSG_RESULT([no])])
   AC_SUBST([MMUX_HAVE_CC_TYPE_LDOUBLE])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT32
#
# Description:
#
#     Check if the  underlying platform supports the  standard C language type  "_Float32".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT32";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT32";
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT32],
  [AC_CHECK_TYPE([_Float32])
   AC_CHECK_FUNC([strtof32])
   AC_CHECK_FUNC([strfromf32])
   AC_CHECK_FUNC([fabsf32])
   AC_CHECK_FUNC([fmaxf32])
   AC_CHECK_FUNC([fminf32])
   AC_CHECK_FUNC([crealf32])
   AC_CHECK_FUNC([cimagf32])
   AC_MSG_CHECKING([for MMUX supporting '_Float32'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float32])       \
            -a mmux_is_yes([ac_cv_func_strtof32])       \
            -a mmux_is_yes([ac_cv_func_strfromf32])     \
            -a mmux_is_yes([ac_cv_func_fabsf32])        \
            -a mmux_is_yes([ac_cv_func_fmaxf32])        \
            -a mmux_is_yes([ac_cv_func_fminf32])        \
            -a mmux_is_yes([ac_cv_func_crealf32])       \
            -a mmux_is_yes([ac_cv_func_cimagf32])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT32],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT32],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT32],   [$MMUX_HAVE_CC_TYPE_FLOAT32],    [Defined to 1 if the platform supports _Float32.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT32])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT64
#
# Description:
#
#     Check if the  underlying platform supports the  standard C language type  "_Float64".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT64";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT64".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT64],
  [AC_CHECK_TYPE([_Float64])
   AC_CHECK_FUNC([strtof64])
   AC_CHECK_FUNC([strfromf64])
   AC_CHECK_FUNC([fabsf64])
   AC_CHECK_FUNC([fmaxf64])
   AC_CHECK_FUNC([fminf64])
   AC_CHECK_FUNC([crealf64])
   AC_CHECK_FUNC([cimagf64])
   AC_MSG_CHECKING([for MMUX supporting '_Float64'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float64])       \
            -a mmux_is_yes([ac_cv_func_strtof64])       \
            -a mmux_is_yes([ac_cv_func_strfromf64])     \
            -a mmux_is_yes([ac_cv_func_fabsf64])        \
            -a mmux_is_yes([ac_cv_func_fmaxf64])        \
            -a mmux_is_yes([ac_cv_func_fminf64])        \
            -a mmux_is_yes([ac_cv_func_crealf64])       \
            -a mmux_is_yes([ac_cv_func_cimagf64])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT64],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT64],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT64],   [$MMUX_HAVE_CC_TYPE_FLOAT64],    [Defined to 1 if the platform supports _Float64.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT64])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT128
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "_Float128".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT128";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT128".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT128],
  [AC_CHECK_TYPE([_Float128])
   AC_CHECK_FUNC([strtof128])
   AC_CHECK_FUNC([strfromf128])
   AC_CHECK_FUNC([fabsf128])
   AC_CHECK_FUNC([fmaxf128])
   AC_CHECK_FUNC([fminf128])
   AC_CHECK_FUNC([crealf128])
   AC_CHECK_FUNC([cimagf128])
   AC_MSG_CHECKING([for MMUX supporting '_Float128'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float128])      \
            -a mmux_is_yes([ac_cv_func_strtof128])      \
            -a mmux_is_yes([ac_cv_func_strfromf128])    \
            -a mmux_is_yes([ac_cv_func_fabsf128])       \
            -a mmux_is_yes([ac_cv_func_fmaxf128])       \
            -a mmux_is_yes([ac_cv_func_fminf128])       \
            -a mmux_is_yes([ac_cv_func_crealf128])      \
            -a mmux_is_yes([ac_cv_func_cimagf128])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT128],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT128],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT128],   [$MMUX_HAVE_CC_TYPE_FLOAT128],    [Defined to 1 if the platform supports _Float128.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT128])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT32X
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "_Float32x".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT32X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT32X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT32X],
  [AC_CHECK_TYPE([_Float32x])
   AC_CHECK_FUNC([strtof32x])
   AC_CHECK_FUNC([strfromf32x])
   AC_CHECK_FUNC([fabsf32x])
   AC_CHECK_FUNC([fmaxf32x])
   AC_CHECK_FUNC([fminf32x])
   AC_CHECK_FUNC([crealf32x])
   AC_CHECK_FUNC([cimagf32x])
   AC_MSG_CHECKING([for MMUX supporting '_Float32x'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float32x])      \
            -a mmux_is_yes([ac_cv_func_strtof32x])      \
            -a mmux_is_yes([ac_cv_func_strfromf32x])    \
            -a mmux_is_yes([ac_cv_func_fabsf32x])       \
            -a mmux_is_yes([ac_cv_func_fmaxf32x])       \
            -a mmux_is_yes([ac_cv_func_fminf32x])       \
            -a mmux_is_yes([ac_cv_func_crealf32x])      \
            -a mmux_is_yes([ac_cv_func_cimagf32x])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT32X],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT32X],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT32X],   [$MMUX_HAVE_CC_TYPE_FLOAT32X],    [Defined to 1 if the platform supports _Float32x.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT32X])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT64X
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "_Float64x".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT64X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT64X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT64X],
  [AC_CHECK_TYPE([_Float64x])
   AC_CHECK_FUNC([strtof64x])
   AC_CHECK_FUNC([strfromf64x])
   AC_CHECK_FUNC([fabsf64x])
   AC_CHECK_FUNC([fmaxf64x])
   AC_CHECK_FUNC([fminf64x])
   AC_CHECK_FUNC([crealf64x])
   AC_CHECK_FUNC([cimagf64x])
   AC_MSG_CHECKING([for MMUX supporting '_Float64x'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float64x])      \
            -a mmux_is_yes([ac_cv_func_strtof64x])      \
            -a mmux_is_yes([ac_cv_func_strfromf64x])    \
            -a mmux_is_yes([ac_cv_func_fabsf64x])       \
            -a mmux_is_yes([ac_cv_func_fmaxf64x])       \
            -a mmux_is_yes([ac_cv_func_fminf64x])       \
            -a mmux_is_yes([ac_cv_func_crealf64x])      \
            -a mmux_is_yes([ac_cv_func_cimagf64x])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT64X],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT64X],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT64X],   [$MMUX_HAVE_CC_TYPE_FLOAT64X],    [Defined to 1 if the platform supports _Float64x.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT64X])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_FLOAT128X
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "_Float128x".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_FLOAT128X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_FLOAT128X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_FLOAT128X],
  [AC_CHECK_TYPE([_Float128x])
   AC_CHECK_FUNC([strtof128x])
   AC_CHECK_FUNC([strfromf128x])
   AC_CHECK_FUNC([fabsf128x])
   AC_CHECK_FUNC([fmaxf128x])
   AC_CHECK_FUNC([fminf128x])
   AC_CHECK_FUNC([crealf128x])
   AC_CHECK_FUNC([cimagf128x])
   AC_MSG_CHECKING([for MMUX supporting '_Float128x'])
   AS_IF([test mmux_is_yes([ac_cv_type__Float128x])     \
            -a mmux_is_yes([ac_cv_func_strtof128x])     \
            -a mmux_is_yes([ac_cv_func_strfromf128x])   \
            -a mmux_is_yes([ac_cv_func_fabsf128x])      \
            -a mmux_is_yes([ac_cv_func_fmaxf128x])      \
            -a mmux_is_yes([ac_cv_func_fminf128x])      \
            -a mmux_is_yes([ac_cv_func_crealf128x])     \
            -a mmux_is_yes([ac_cv_func_cimagf128x])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT128X],    [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_FLOAT128X],    [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_FLOAT128X],   [$MMUX_HAVE_CC_TYPE_FLOAT128X],    [Defined to 1 if the platform supports _Float128x.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_FLOAT128X])])


# Synopsis:
#
#     MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY
#
# Description:
#
#     Check  the  availability of  a  Decimal  Floating Point  C  Library  implementing the  usual
#     functions for the decimal floating-point  number types: _Decimal32, _Decimal64, _Decimal128.
#     If the library is found:
#
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF128X".
#
#     * set  the variable "MMUX_DECIMAL_FLOATING_POINT_LIBRARY_LIBS"  to the list of  linker flags
#     required to link with the library;
#
#     *  set the  variable "MMUX_DECIMAL_FLOATING_POINT_LIBRARY_CFLAGS"  to the  list of  compiler
#     flags required to compile with the library.
#
AC_DEFUN([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY],
  [PKG_CHECK_MODULES([LIBDFP],[libdfp],,[AC_MSG_WARN([package libdfp not found])])
# AC_CHECK_LIB([dfp],[strtod32])
   AS_IF([test -n "$pkg_cv_LIBDFP_LIBS"],
         [AS_VAR_SET([MMUX_HAVE_DECIMAL_FLOATING_POINT_C_LIBRARY],[1])],
         [AS_VAR_SET([MMUX_HAVE_DECIMAL_FLOATING_POINT_C_LIBRARY],[0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_DECIMAL_FLOATING_POINT_C_LIBRARY],[$MMUX_HAVE_DECIMAL_FLOATING_POINT_C_LIBRARY],
                      [Defined to 1 if a Decimal Floating Point C Library is available.])
   AC_SUBST([MMUX_HAVE_DECIMAL_FLOATING_POINT_C_LIBRARY])
   AS_VAR_SET([MMUX_DECIMAL_FLOATING_POINT_LIBRARY_LIBS],[$LIBDFP_LIBS])
   AS_VAR_SET([MMUX_DECIMAL_FLOATING_POINT_LIBRARY_CFLAGS],[$LIBDFP_CFLAGS])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL32
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "_Decimal32".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_DECIMAL32";
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXD32";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_DECIMAL32";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXD32".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL32],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY])
   AC_CHECK_TYPE([_Decimal32])
   MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([CFLAGS],
     [AS_VAR_APPEND([CFLAGS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_CFLAGS"])
      MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([LIBS],
        [AS_VAR_APPEND([LIBS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_LIBS"])
         AC_CHECK_FUNC([strtod32])
         AC_CHECK_FUNC([strfromd32])
         AC_CHECK_FUNC([fabsd32])
         AC_CHECK_FUNC([fmaxd32])
         AC_CHECK_FUNC([fmind32])])])
   AC_MSG_CHECKING([for MMUX supporting '_Decimal32'])
   AS_IF([test mmux_is_yes([ac_cv_type__Decimal32])  \
            -a mmux_is_yes([ac_cv_func_strtod32])  \
            -a mmux_is_yes([ac_cv_func_strfromd32])  \
            -a mmux_is_yes([ac_cv_func_fabsd32])  \
            -a mmux_is_yes([ac_cv_func_fmaxd32])  \
            -a mmux_is_yes([ac_cv_func_fmind32])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL32],  [1])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD32], [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL32],  [0])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD32], [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_DECIMAL32],  [$MMUX_HAVE_CC_TYPE_DECIMAL32],
     [Defined to 1 if the platform supports _Decimal32.])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXD32], [$MMUX_HAVE_CC_TYPE_COMPLEXD32],
     [Defined to 1 if the platform supports _Decimal32 complex.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_DECIMAL32])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXD32])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL64
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "_Decimal64".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_DECIMAL64";
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXD64";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_DECIMAL64";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXD64".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL64],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY])
   AC_CHECK_TYPE([_Decimal64])
   MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([CFLAGS],
     [AS_VAR_APPEND([CFLAGS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_CFLAGS"])
      MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([LIBS],
        [AS_VAR_APPEND([LIBS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_LIBS"])
         AC_CHECK_FUNC([strtod64])
         AC_CHECK_FUNC([strfromd64])
         AC_CHECK_FUNC([fabsd64])
         AC_CHECK_FUNC([fmaxd64])
         AC_CHECK_FUNC([fmind64])])])
   AC_MSG_CHECKING([for MMUX supporting '_Decimal64'])
   AS_IF([test mmux_is_yes([ac_cv_type__Decimal64])  \
            -a mmux_is_yes([ac_cv_func_strtod64])  \
            -a mmux_is_yes([ac_cv_func_strfromd64])  \
            -a mmux_is_yes([ac_cv_func_fabsd64])  \
            -a mmux_is_yes([ac_cv_func_fmaxd64])  \
            -a mmux_is_yes([ac_cv_func_fmind64])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL64],  [1])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD64], [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL64],  [0])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD64], [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_DECIMAL64],  [$MMUX_HAVE_CC_TYPE_DECIMAL64],
     [Defined to 1 if the platform supports _Decimal64.])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXD64], [$MMUX_HAVE_CC_TYPE_COMPLEXD64],
     [Defined to 1 if the platform supports _Decimal64 complex.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_DECIMAL64])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXD64])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_DECIMAL128
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "_Decimal128".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_DECIMAL128";
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXD128";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_DECIMAL128";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXD128".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_DECIMAL128],
  [AC_REQUIRE([MMUX_CC_CHECK_DECIMAL_FLOATING_POINT_LIBRARY])
   AC_CHECK_TYPE([_Decimal128])
   MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([CFLAGS],
     [AS_VAR_APPEND([CFLAGS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_CFLAGS"])
      MMUX_AUTOCONF_SAVE_SHELL_VARIABLE([LIBS],
        [AS_VAR_APPEND([LIBS],[" $MMUX_DECIMAL_FLOATING_POINT_LIBRARY_LIBS"])
         AC_CHECK_FUNC([strtod128])
         AC_CHECK_FUNC([strfromd128])
         AC_CHECK_FUNC([fabsd128])
         AC_CHECK_FUNC([fmaxd128])
         AC_CHECK_FUNC([fmind128])])])
   AC_MSG_CHECKING([for MMUX supporting '_Decimal128'])
   AS_IF([test mmux_is_yes([ac_cv_type__Decimal128])  \
            -a mmux_is_yes([ac_cv_func_strtod128])  \
            -a mmux_is_yes([ac_cv_func_strfromd128])  \
            -a mmux_is_yes([ac_cv_func_fabsd128])  \
            -a mmux_is_yes([ac_cv_func_fmaxd128])  \
            -a mmux_is_yes([ac_cv_func_fmind128])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL128],  [1])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD128], [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_DECIMAL128],  [0])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD128], [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_DECIMAL128],  [$MMUX_HAVE_CC_TYPE_DECIMAL128],
     [Defined to 1 if the platform supports _Decimal128.])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXD128], [$MMUX_HAVE_CC_TYPE_COMPLEXD128],
     [Defined to 1 if the platform supports _Decimal128 complex.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_DECIMAL128])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXD128])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "float complex".  If it
#     does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF],
  [AC_CHECK_HEADER([complex.h])
   AC_CHECK_TYPE([float complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_CHECK_DECL([CMPLXF],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_CHECK_FUNC([crealf])
   AC_CHECK_FUNC([cimagf])
   AC_CHECK_FUNC([cabsf])
   AC_CHECK_FUNC([cargf])
   AC_CHECK_FUNC([conjf])
   AC_CHECK_FUNC([atan2f])
   AC_MSG_CHECKING([for MMUX supporting 'float complex'])
   AS_IF([test mmux_is_yes([ac_cv_type_float_complex])          \
            -a mmux_is_yes([ac_cv_have_decl_CMPLXF])            \
            -a mmux_is_yes([ac_cv_func_crealf])                 \
            -a mmux_is_yes([ac_cv_func_cimagf])                 \
            -a mmux_is_yes([ac_cv_func_cabsf])                  \
            -a mmux_is_yes([ac_cv_func_cargf])                  \
            -a mmux_is_yes([ac_cv_func_conjf])                  \
            -a mmux_is_yes([ac_cv_func_atan2f])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF], [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF], [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF],[$MMUX_HAVE_CC_TYPE_COMPLEXF], [Defined to 1 if the platform supports _Float complex.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXD
#
# Description:
#
#     Check if the underlying  platform supports the standard C language  type "double complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXD";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXD".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXD],
  [AC_CHECK_HEADER([complex.h])
   AC_CHECK_TYPE([double complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_CHECK_DECL([CMPLX],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
   AC_CHECK_FUNC([creal])
   AC_CHECK_FUNC([cimag])
   AC_CHECK_FUNC([cabs])
   AC_CHECK_FUNC([carg])
   AC_CHECK_FUNC([conj])
   AC_CHECK_FUNC([atan2])
   AC_MSG_CHECKING([for MMUX supporting 'double complex'])
   AS_IF([test mmux_is_yes([ac_cv_type_double_complex])         \
            -a mmux_is_yes([ac_cv_have_decl_CMPLX])             \
            -a mmux_is_yes([ac_cv_func_creal])                  \
            -a mmux_is_yes([ac_cv_func_cimag])                  \
            -a mmux_is_yes([ac_cv_func_cabs])                   \
            -a mmux_is_yes([ac_cv_func_carg])                   \
            -a mmux_is_yes([ac_cv_func_conj])                   \
            -a mmux_is_yes([ac_cv_func_atan2])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD], [1])
          AC_MSG_RESULT([yes])],
         [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXD], [0])
          AC_MSG_RESULT([no])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXD],[$MMUX_HAVE_CC_TYPE_COMPLEXD], [Defined to 1 if the platform supports 'double complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXD])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXLD
#
# Description:
#
#     Check if the underlying platform supports the  standard C language type "long double complex".
#     If it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXLD";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXLD".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXLD],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_LDOUBLE])
   AS_IF([test mmux_is_yes([ac_cv_type_long_double])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([long double complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXL],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([creall])
          AC_CHECK_FUNC([cimagl])
          AC_CHECK_FUNC([cabsl])
          AC_CHECK_FUNC([cargl])
          AC_CHECK_FUNC([conjl])
          AC_CHECK_FUNC([atan2l])
          AC_MSG_CHECKING([for MMUX supporting 'long double complex'])
          AS_IF([test mmux_is_yes([ac_cv_type_long_double_complex])     \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXL])             \
                   -a mmux_is_yes([ac_cv_func_creall])                  \
                   -a mmux_is_yes([ac_cv_func_cimagl])                  \
                   -a mmux_is_yes([ac_cv_func_cabsl])                   \
                   -a mmux_is_yes([ac_cv_func_cargl])                   \
                   -a mmux_is_yes([ac_cv_func_conjl])                   \
                   -a mmux_is_yes([ac_cv_func_atan2l])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXLD], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXLD], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for double complex complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXLD], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXLD],[$MMUX_HAVE_CC_TYPE_COMPLEXLD],
     [Defined to 1 if the platform supports 'long double complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXLD])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF32
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float32 complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF32";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF32".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF32],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT32])
   AS_IF([test mmux_is_yes([ac_cv_type__Float32])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float32 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF32],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf32])
          AC_CHECK_FUNC([cimagf32])
          AC_CHECK_FUNC([cabsf32])
          AC_CHECK_FUNC([cargf32])
          AC_CHECK_FUNC([conjf32])
          AC_CHECK_FUNC([atan2f32])
          AC_MSG_CHECKING([for MMUX supporting '_Float32 complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float32_complex])        \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF32])           \
                   -a mmux_is_yes([ac_cv_func_crealf32])                \
                   -a mmux_is_yes([ac_cv_func_cimagf32])                \
                   -a mmux_is_yes([ac_cv_func_cabsf32])                 \
                   -a mmux_is_yes([ac_cv_func_cargf32])                 \
                   -a mmux_is_yes([ac_cv_func_conjf32])                 \
                   -a mmux_is_yes([ac_cv_func_atan2f32])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float32 complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF32],[$MMUX_HAVE_CC_TYPE_COMPLEXF32],
     [Defined to 1 if the platform supports '_Float32 complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF32])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF64
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64 complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF64";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF64".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF64],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT64])
   AS_IF([test mmux_is_yes([ac_cv_type__Float64])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float64 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF64],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf64])
          AC_CHECK_FUNC([cimagf64])
          AC_CHECK_FUNC([cabsf64])
          AC_CHECK_FUNC([cargf64])
          AC_CHECK_FUNC([conjf64])
          AC_CHECK_FUNC([atan2f64])
          AC_MSG_CHECKING([for MMUX supporting '_Float64 complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float64_complex])        \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF64])           \
                   -a mmux_is_yes([ac_cv_func_crealf64])                \
                   -a mmux_is_yes([ac_cv_func_cimagf64])                \
                   -a mmux_is_yes([ac_cv_func_cabsf64])                 \
                   -a mmux_is_yes([ac_cv_func_cargf64])                 \
                   -a mmux_is_yes([ac_cv_func_conjf64])                 \
                   -a mmux_is_yes([ac_cv_func_atan2f64])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float64 complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF64],[$MMUX_HAVE_CC_TYPE_COMPLEXF64],
     [Defined to 1 if the platform supports '_Float64 complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF64])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF128
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float128 complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF128";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF128".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF128],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT128])
   AS_IF([test mmux_is_yes([ac_cv_type__Float128])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float128 complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF128],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf128])
          AC_CHECK_FUNC([cimagf128])
          AC_CHECK_FUNC([cabsf128])
          AC_CHECK_FUNC([cargf128])
          AC_CHECK_FUNC([conjf128])
          AC_CHECK_FUNC([atan2f128])
          AC_MSG_CHECKING([for MMUX supporting '_Float128 complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float128_complex])       \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF128])          \
                   -a mmux_is_yes([ac_cv_func_crealf128])               \
                   -a mmux_is_yes([ac_cv_func_cimagf128])               \
                   -a mmux_is_yes([ac_cv_func_cabsf128])                \
                   -a mmux_is_yes([ac_cv_func_cargf128])                \
                   -a mmux_is_yes([ac_cv_func_conjf128])                \
                   -a mmux_is_yes([ac_cv_func_atan2f128])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float128 complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF128],[$MMUX_HAVE_CC_TYPE_COMPLEXF128],
     [Defined to 1 if the platform supports '_Float128 complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF128])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF32X
#
# Description:
#
#     Check if  the underlying platform supports  the standard C language  type "_Float32x complex".
#     If it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF32X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF32X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF32X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT32X])
   AS_IF([test mmux_is_yes([ac_cv_type__Float32x])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float32x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF32X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf32x])
          AC_CHECK_FUNC([cimagf32x])
          AC_CHECK_FUNC([cabsf32x])
          AC_CHECK_FUNC([cargf32x])
          AC_CHECK_FUNC([conjf32x])
          AC_CHECK_FUNC([atan2f32x])
          AC_MSG_CHECKING([for MMUX supporting '_Float32x complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float32x_complex])       \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF32X])          \
                   -a mmux_is_yes([ac_cv_func_crealf32x])               \
                   -a mmux_is_yes([ac_cv_func_cimagf32x])               \
                   -a mmux_is_yes([ac_cv_func_cabsf32x])                \
                   -a mmux_is_yes([ac_cv_func_cargf32x])                \
                   -a mmux_is_yes([ac_cv_func_conjf32x])                \
                   -a mmux_is_yes([ac_cv_func_atan2f32x])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32X], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32X], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float32x complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF32X], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF32X],[$MMUX_HAVE_CC_TYPE_COMPLEXF32X],
     [Defined to 1 if the platform supports '_Float32x complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF32X])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF64X
#
# Description:
#
#     Check if the underlying platform supports the standard C language type "_Float64x complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF64X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF64X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF64X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT64X])
   AS_IF([test mmux_is_yes([ac_cv_type__Float64x])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float64x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF64X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf64x])
          AC_CHECK_FUNC([cimagf64x])
          AC_CHECK_FUNC([cabsf64x])
          AC_CHECK_FUNC([cargf64x])
          AC_CHECK_FUNC([conjf64x])
          AC_CHECK_FUNC([atan2f64x])
          AC_MSG_CHECKING([for MMUX supporting '_Float64x complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float64x_complex])       \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF64X])          \
                   -a mmux_is_yes([ac_cv_func_crealf64x])               \
                   -a mmux_is_yes([ac_cv_func_cimagf64x])               \
                   -a mmux_is_yes([ac_cv_func_cabsf64x])                \
                   -a mmux_is_yes([ac_cv_func_cargf64x])                \
                   -a mmux_is_yes([ac_cv_func_conjf64x])                \
                   -a mmux_is_yes([ac_cv_func_atan2f64x])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64X], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64X], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float64x complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF64X], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF64X],[$MMUX_HAVE_CC_TYPE_COMPLEXF64X],
     [Defined to 1 if the platform supports '_Float64x complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF64X])])


# Synopsis:
#
#     MMUX_CC_CHECK_TYPE_COMPLEXF128X
#
# DESCRIPTION:
#
#     Check if the underlying platform supports the standard C language type "_Float128x complex".  If
#     it does:
#
#     * define to "1" the C language preprocessor symbol "MMUX_HAVE_CC_TYPE_COMPLEXF128X";
#     * define to "1" the GNU Autoconf substitution symbol "MMUX_HAVE_CC_TYPE_COMPLEXF128X".
#
AC_DEFUN([MMUX_CC_CHECK_TYPE_COMPLEXF128X],
  [AC_REQUIRE([MMUX_CC_CHECK_TYPE_FLOAT128X])
   AS_IF([test mmux_is_yes([ac_cv_type__Float128x])],
         [AC_CHECK_HEADER([complex.h])
          AC_CHECK_TYPE([_Float128x complex],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_DECL([CMPLXF128X],[],[],[MMUX_CC_COMMON_INCLUDES_FOR_TESTS])
          AC_CHECK_FUNC([crealf128x])
          AC_CHECK_FUNC([cimagf128x])
          AC_CHECK_FUNC([cabsf128x])
          AC_CHECK_FUNC([cargf128x])
          AC_CHECK_FUNC([conjf128x])
          AC_CHECK_FUNC([atan2f128x])
          AC_MSG_CHECKING([for MMUX supporting '_Float128x complex'])
          AS_IF([test mmux_is_yes([ac_cv_type__Float128x_complex])      \
                   -a mmux_is_yes([ac_cv_have_decl_CMPLXF128X])         \
                   -a mmux_is_yes([ac_cv_func_crealf128x])              \
                   -a mmux_is_yes([ac_cv_func_cimagf128x])              \
                   -a mmux_is_yes([ac_cv_func_cabsf128x])               \
                   -a mmux_is_yes([ac_cv_func_cargf128x])               \
                   -a mmux_is_yes([ac_cv_func_conjf128x])               \
                   -a mmux_is_yes([ac_cv_func_atan2f128x])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128X], [1])
                 AC_MSG_RESULT([yes])],
                [AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128X], [0])
                 AC_MSG_RESULT([no])])],
         [AC_MSG_CHECKING([for _Float128x complex])
          AC_MSG_RESULT([no])
          AS_VAR_SET([MMUX_HAVE_CC_TYPE_COMPLEXF128X], [0])])
   AC_DEFINE_UNQUOTED([MMUX_HAVE_CC_TYPE_COMPLEXF128X],[$MMUX_HAVE_CC_TYPE_COMPLEXF128X],
     [Defined to 1 if the platform supports '_Float128x complex'.])
   AC_SUBST([MMUX_HAVE_CC_TYPE_COMPLEXF128X])])


#### let's go

### end of file
# Local Variables:
# mode: autoconf
# fill-column: 100
# End:
