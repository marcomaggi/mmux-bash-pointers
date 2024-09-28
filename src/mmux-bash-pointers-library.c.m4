/*
  Part of: MMUX Bash Pointers
  Contents: library functions
  Date: Sep  9, 2024

  Abstract

	This module implements library initialisation and version numbers inspection.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms of the  GNU Lesser General Public  License as published by  the Free Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with
  this program.  If not, see <http://www.gnu.org/licenses/>.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "mmux-bash-pointers-internals.h"


/** --------------------------------------------------------------------
 ** Version functions.
 ** ----------------------------------------------------------------- */

char const *
mmux_bash_pointers_version_string (void)
{
  return mmux_bash_pointers_VERSION_INTERFACE_STRING;
}
int
mmux_bash_pointers_version_interface_current (void)
{
  return mmux_bash_pointers_VERSION_INTERFACE_CURRENT;
}
int
mmux_bash_pointers_version_interface_revision (void)
{
  return mmux_bash_pointers_VERSION_INTERFACE_REVISION;
}
int
mmux_bash_pointers_version_interface_age (void)
{
  return mmux_bash_pointers_VERSION_INTERFACE_AGE;
}


/** --------------------------------------------------------------------
 ** Error handling.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_set_ERRNO (int errnum, char const * const caller_name)
{
  return mmux_bash_store_sint_in_variable("ERRNO", errnum, caller_name);
}


m4_divert(-1)m4_dnl
m4_dnl --------------------------------------------------------------------
m4_dnl Helper macros for library initialisation.
m4_dnl --------------------------------------------------------------------

m4_define([[[MMUX_DEFINE_SIZEOF_VARIABLE]]],[[[
  mmux_bash_create_global_sint_variable("mmux_libc_SIZEOF_[[[]]]mmux_toupper([[[$1]]])", mmux_bash_pointers_sizeof_$1(),
                                        MMUX_BUILTIN_NAME);
]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_MAXIMUM_VARIABLE]]],[[[{
  mmux_libc_$1_t value = mmux_bash_pointers_maximum_$1();
  int requested_nbytes = mmux_bash_pointers_sprint_size_$1(value);

  if (0 > requested_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	str[requested_nbytes];

    mmux_bash_pointers_sprint_$1(str, requested_nbytes, value);
    if (0) { fprintf(stderr, "%s: maximum $1: %s=%s\n", __func__, "mmux_libc_MAX_[[[]]]mmux_toupper([[[$1]]])", str); }
    mmux_bash_create_global_string_variable("mmux_libc_MAX_[[[]]]mmux_toupper([[[$1]]])", str, MMUX_BUILTIN_NAME);
  }
}]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_MINIMUM_VARIABLE]]],[[[{
  mmux_libc_$1_t value = mmux_bash_pointers_minimum_$1();
  int requested_nbytes = mmux_bash_pointers_sprint_size_$1(value);

  if (0 > requested_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	str[requested_nbytes];

    mmux_bash_pointers_sprint_$1(str, requested_nbytes, value);
    mmux_bash_create_global_string_variable("mmux_libc_MIN_[[[]]]mmux_toupper([[[$1]]])", str, MMUX_BUILTIN_NAME);
  }
}]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE]]],[[[#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  mmux_bash_create_global_sint_variable("mmux_libc_$1",	$1, MMUX_BUILTIN_NAME);
#endif
]]])

m4_divert(0)m4_dnl


/** --------------------------------------------------------------------
 ** Library initialisation.
 ** ----------------------------------------------------------------- */

static int
mmux_bash_pointers_library_init_main (int argc MMUX_BASH_POINTERS_UNUSED,  char const * const argv[] MMUX_BASH_POINTERS_UNUSED)
#undef  MMUX_BUILTIN_NAME
#define MMUX_BUILTIN_NAME	"mmux_bash_pointers_library_init"
{
  /* Compile the POSIX regular expression required to parse the string representation
   * of complex numbers.
   *
   * We expect complex numbers represented as:
   *
   *   (+1.2)+i*(-3.4)
   *
   * with the real and imaginary parts  always enclosed in parentheses.  Whatever the
   * sign, whatever the format of the double number: it should always work.
   *
   * FIXME  The compiled  regular expression  is never  released; it  stays allocated
   * forever.  Ideally it  should be released if this library  is unloaded, which, it
   * is my understanding, is actually possible.  (Marco Maggi; Sep  4, 2024)
   */
  {
    int	rv = regcomp(&mmux_bash_pointers_complex_rex, "^(\\([^)]\\+\\))+i\\*(\\([^)]\\+\\))$", 0);
    if (rv) {
      fprintf(stderr, "MMUX Bash Pointers: internal error: compiling regular expression\n");
      return MMUX_FAILURE;
    }
  }

  /* These constants are defined by the Standard C Library; we make them available as
     global shell variables. */
  {
    MMUX_DEFINE_SIZEOF_VARIABLE([[[pointer]]]);

    MMUX_DEFINE_SIZEOF_VARIABLE([[[schar]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uchar]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sshort]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[ushort]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sint]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uint]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[slong]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[ulong]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_SLLONG]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[sllong]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_ULLONG]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[ullong]]]);]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[float]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[double]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_LDOUBLE]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[ldouble]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float128]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32X]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float32x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64X]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float64x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128X]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[float128x]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL32]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL64]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL128]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal128]]]);]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_LDOUBLE]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexld]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF32]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF64]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF128]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf128]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF32X]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf32x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF64X]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf64x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXF128X]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf128x]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXD32]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXD64]]], [[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_COMPLEXD128]]],[[[MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd128]]]);]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[sint8]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uint8]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sint16]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uint16]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sint32]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uint32]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sint64]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uint64]]]);

    MMUX_DEFINE_SIZEOF_VARIABLE([[[ssize]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[usize]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sintmax]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uintmax]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sintptr]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uintptr]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[ptrdiff]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[mode]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[off]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[pid]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[uid]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[gid]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[wchar]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[wint]]]);
  }
  {
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[pointer]]]);

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[schar]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uchar]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sshort]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ushort]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sint]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uint]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[slong]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ulong]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_SLLONG]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[sllong]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_ULLONG]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[ullong]]]);]]])

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[double]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_LDOUBLE]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[ldouble]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float128]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32X]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float32x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64X]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float64x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128X]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[float128x]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL32]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL64]]], [[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL128]]],[[[MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal128]]]);]]])


    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sint8]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uint8]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sint16]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uint16]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sint32]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uint32]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sint64]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uint64]]]);

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ssize]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[usize]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sintmax]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uintmax]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sintptr]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uintptr]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ptrdiff]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[mode]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[off]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[pid]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[uid]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[gid]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[wchar]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[wint]]]);
  }
  {
    MMUX_DEFINE_MINIMUM_VARIABLE([[[pointer]]]);

    MMUX_DEFINE_MINIMUM_VARIABLE([[[schar]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uchar]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sshort]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[ushort]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sint]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uint]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[slong]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[ulong]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_SLLONG]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[sllong]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_ULLONG]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[ullong]]]);]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[double]]]);
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_LDOUBLE]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[ldouble]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float128]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT32X]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float32x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT64X]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float64x]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_FLOAT128X]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[float128x]]]);]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL32]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal32]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL64]]], [[[MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal64]]]);]]])
MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_TYPE_DECIMAL128]]],[[[MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal128]]]);]]])

    MMUX_DEFINE_MINIMUM_VARIABLE([[[sint8]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uint8]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sint16]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uint16]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sint32]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uint32]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sint64]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uint64]]]);

    MMUX_DEFINE_MINIMUM_VARIABLE([[[ssize]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[usize]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sintmax]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uintmax]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sintptr]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uintptr]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[ptrdiff]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[mode]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[off]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[pid]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[uid]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[gid]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[wchar]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[wint]]]);
  }
  {
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPERM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOENT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESRCH]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EINTR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EIO]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENXIO]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[E2BIG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOEXEC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADF]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECHILD]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EAGAIN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOMEM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EACCES]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EFAULT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTBLK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBUSY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EEXIST]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EXDEV]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENODEV]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTDIR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EISDIR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EINVAL]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENFILE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EMFILE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTTY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ETXTBSY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EFBIG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOSPC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESPIPE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EROFS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EMLINK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPIPE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDOM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ERANGE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDEADLK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENAMETOOLONG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOLCK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOSYS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTEMPTY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELOOP]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EWOULDBLOCK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOMSG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EIDRM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECHRNG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EL2NSYNC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EL3HLT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EL3RST]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELNRNG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EUNATCH]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOCSI]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EL2HLT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EXFULL]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOANO]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADRQC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADSLT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDEADLOCK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBFONT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOSTR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENODATA]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ETIME]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOSR]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENONET]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOPKG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EREMOTE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOLINK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EADV]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESRMNT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECOMM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPROTO]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EMULTIHOP]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDOTDOT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADMSG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EOVERFLOW]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTUNIQ]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EBADFD]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EREMCHG]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELIBACC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELIBBAD]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELIBSCN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELIBMAX]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ELIBEXEC]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EILSEQ]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ERESTART]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESTRPIPE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EUSERS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTSOCK]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDESTADDRREQ]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EMSGSIZE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPROTOTYPE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOPROTOOPT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPROTONOSUPPORT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESOCKTNOSUPPORT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EOPNOTSUPP]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EPFNOSUPPORT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EAFNOSUPPORT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EADDRINUSE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EADDRNOTAVAIL]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENETDOWN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENETUNREACH]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENETRESET]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECONNABORTED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECONNRESET]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOBUFS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EISCONN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTCONN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESHUTDOWN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ETOOMANYREFS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ETIMEDOUT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECONNREFUSED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EHOSTDOWN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EHOSTUNREACH]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EALREADY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EINPROGRESS]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ESTALE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EUCLEAN]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTNAM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENAVAIL]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EISNAM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EREMOTEIO]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EDQUOT]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOMEDIUM]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EMEDIUMTYPE]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ECANCELED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOKEY]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EKEYEXPIRED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EKEYREVOKED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EKEYREJECTED]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[EOWNERDEAD]]]);
    MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE([[[ENOTRECOVERABLE]]]);
  }
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_bash_pointers_library_init]]],
    [[[(1 == argc)]]],
    [[["mmux_bash_pointers_library_init"]]],
    [[["Initialise the library MMUX Bash Pointers."]]])

/* end of file */
