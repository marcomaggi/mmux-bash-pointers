/*
  Part of: MMUX Bash Pointers
  Contents: library functions
  Date: Sep  9, 2024

  Abstract

	This module implements library initialisation and version numbers inspection.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.

  You should have received  a copy of the GNU General Public  License along with this
  program.  If not, see <http://www.gnu.org/licenses/>.
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

mmux_bash_rv_t
mmux_bash_pointers_set_ERRNO (int errnum, char const * const who)
{
  return mmux_sint_bind_to_bash_variable("ERRNO", errnum, who);
}
mmux_bash_rv_t
mmux_bash_pointers_consume_errno (char const * const who)
{
  mmux_bash_pointers_set_ERRNO(errno, who);
  errno = 0;
  return MMUX_FAILURE;
}


m4_divert(-1)m4_dnl
m4_dnl --------------------------------------------------------------------
m4_dnl Helper macros for library initialisation.
m4_dnl --------------------------------------------------------------------

m4_define([[[MMUX_DEFINE_SIZEOF_VARIABLE]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
  if (0) { fprintf(stderr, "%s: sizeof %s\n", __func__, "$1"); }
  mmux_bash_create_global_sint_variable("mmux_[[[]]]MMUX_M4_TOLOWER([[[$1]]])[[[]]]_SIZEOF", mmux_$1_sizeof(),
                                        MMUX_BASH_BUILTIN_STRING_NAME);
]]])]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_MAXIMUM_VARIABLE]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[{
  mmux_$1_t value = mmux_$1_maximum();
  int requested_nbytes = mmux_$1_sprint_size(value);

  if (0 > requested_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	str[requested_nbytes];

    mmux_$1_sprint(str, requested_nbytes, value);
    mmux_bash_create_global_string_variable("mmux_[[[]]]MMUX_M4_TOLOWER([[[$1]]])[[[]]]_MAX", str, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}]]])]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_MINIMUM_VARIABLE]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[{
  mmux_$1_t value = mmux_$1_minimum();
  int requested_nbytes = mmux_$1_sprint_size(value);

  if (0 > requested_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	str[requested_nbytes];

    mmux_$1_sprint(str, requested_nbytes, value);
    mmux_bash_create_global_string_variable("mmux_[[[]]]MMUX_M4_TOLOWER([[[$1]]])[[[]]]_MIN", str, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}]]])]]])

/* ------------------------------------------------------------------ */

m4_define([[[MMUX_DEFINE_ERRNO_CONSTANT_VARIABLE]]],[[[#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  mmux_bash_create_global_sint_variable("mmux_libc_$1",	$1, MMUX_BASH_BUILTIN_STRING_NAME);
#endif
]]])

m4_define([[[MMUX_DEFINE_INT_CONSTANT_VARIABLE]]],[[[#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
  mmux_bash_create_global_sint_variable("mmux_libc_$1",	$1, MMUX_BASH_BUILTIN_STRING_NAME);
#endif
]]])

m4_define([[[MMUX_DEFINE_ULONG_CONSTANT_VARIABLE]]],[[[#if ((defined MMUX_HAVE_$1) && (1 == MMUX_HAVE_$1))
{
  int requested_nbytes = mmux_ulong_sprint_size($1);

  if (0 > requested_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	str[requested_nbytes];

    mmux_ulong_sprint(str, requested_nbytes, $1);
    mmux_bash_create_global_string_variable("mmux_libc_$1", str, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
#endif
]]])

m4_divert(0)m4_dnl


/** --------------------------------------------------------------------
 ** Library initialisation.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_bash_pointers_library_init]]])
{
  if (mmux_cc_types_init_parsers_module()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising parsers module\n");
    return MMUX_FAILURE;
  }

  if (mmux_cc_types_init_sprint_module ()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising sprinters module\n");
    return MMUX_FAILURE;
  }

  if (MMUX_SUCCESS != mmux_bash_pointers_init_time_module()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising time module\n");
    return MMUX_FAILURE;
  }

  if (MMUX_SUCCESS != mmux_bash_pointers_init_file_descriptors_module()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising file descriptors module\n");
    return MMUX_FAILURE;
  }

  if (MMUX_SUCCESS != mmux_bash_pointers_init_file_system_module()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising file system module\n");
    return MMUX_FAILURE;
  }

  if (MMUX_SUCCESS != mmux_bash_pointers_init_sockets_module()) {
    fprintf(stderr, "MMUX Bash Pointers: internal error: initialising sockets module\n");
    return MMUX_FAILURE;
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
    MMUX_DEFINE_SIZEOF_VARIABLE([[[sllong]]],[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[ullong]]],[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[float]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[double]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[ldouble]]],[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[float32]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[float64]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[float128]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[float32x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[float64x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[float128x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal32]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal64]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[decimal128]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexld]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf32]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf64]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf128]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf32x]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf64x]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexf128x]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd32]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXD32]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd64]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXD64]]])
    MMUX_DEFINE_SIZEOF_VARIABLE([[[complexd128]]],[[[MMUX_HAVE_CC_TYPE_COMPLEXD128]]])

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
    MMUX_DEFINE_SIZEOF_VARIABLE([[[time]]]);
    MMUX_DEFINE_SIZEOF_VARIABLE([[[socklen]]]);
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
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[sllong]]],[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ullong]]],[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[double]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[ldouble]]],[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float32]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float64]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float128]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float32x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float64x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[float128x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

    MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal32]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal64]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[decimal128]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])


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
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[time]]]);
    MMUX_DEFINE_MAXIMUM_VARIABLE([[[socklen]]]);
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
    MMUX_DEFINE_MINIMUM_VARIABLE([[[sllong]]],[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[ullong]]],[[[MMUX_HAVE_CC_TYPE_ULLONG]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[double]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[ldouble]]],[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

    MMUX_DEFINE_MINIMUM_VARIABLE([[[float32]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float64]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float128]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

    MMUX_DEFINE_MINIMUM_VARIABLE([[[float32x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float64x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[float128x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

    MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal32]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal64]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
    MMUX_DEFINE_MINIMUM_VARIABLE([[[decimal128]]],[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

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
    MMUX_DEFINE_MINIMUM_VARIABLE([[[time]]]);
    MMUX_DEFINE_MINIMUM_VARIABLE([[[socklen]]]);
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

  {
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_EACCESS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_EMPTY_PATH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_FDCWD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_NOAUTOMOUNT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_REMOVEDIR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_SYMLINK_FOLLOW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AT_SYMLINK_NOFOLLOW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[EOF]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[FD_CLOEXEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_DUPFD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_GETFD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_GETFL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_GETLK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_GETOWN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_OK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_RDLCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_SETFD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_SETFL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_SETLK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_SETLKW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_SETOWN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_UNLCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[F_WRLCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MAXSYMLINKS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_ACCMODE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_APPEND]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_ASYNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_CLOEXEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_CREAT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_DIRECTORY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_DIRECT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_DSYNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_EXCL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_EXEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_EXLOCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_FSYNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_IGNORE_CTTY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_LARGEFILE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NDELAY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NOATIME]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NOCTTY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NOFOLLOW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NOLINK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NONBLOCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_NOTRANS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_PATH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_RDONLY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_RDWR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_READ]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_SHLOCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_SYNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_TMPFILE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_TRUNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_WRITE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[O_WRONLY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[R_OK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RENAME_EXCHANGE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RENAME_NOREPLACE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RENAME_WITHEOUT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SEEK_CUR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SEEK_DATA]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SEEK_END]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SEEK_HOLE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SEEK_SET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IRGRP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IROTH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IRUSR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IRWXG]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IRWXO]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IRWXU]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_ISGID]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_ISUID]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_ISVTX]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IWGRP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IWOTH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IWUSR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IXGRP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IXOTH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[S_IXUSR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[W_OK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[X_OK]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RWF_APPEND]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RWF_DSYNC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RWF_HIPRI]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RWF_NOWAIT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[RWF_SYNC]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_ALG]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_APPLETALK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_AX25]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_BLUETOOTH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_CAN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_DECnet]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_IB]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_INET6]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_INET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_IPX]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_KCM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_KEY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_LLC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_LOCAL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_MPLS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_NETLINK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_PACKET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_PPPOX]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_RDS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_TIPC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_UNIX]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_UNSPEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_VSOCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_X25]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AF_XDP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IFNAMSIZ]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_FILE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_INET6]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_INET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_LOCAL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_UNIX]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[PF_UNSPEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SHUT_RDWR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SHUT_RD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SHUT_WR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_CONFIRM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_DONTROUTE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_DONTWAIT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_EOR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_MORE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_NOSIGNAL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_OOB]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[MSG_PEEK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOL_SOCKET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_BROADCAST]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_DEBUG]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_DONTROUTE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_ERROR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_KEEPALIVE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_LINGER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_OOBINLINE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_RCVBUF]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_REUSEADDR]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_SNDBUF]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_STYLE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SO_TYPE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[INADDR_ANY]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_ADDRCONFIG]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_ALL]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_CANONIDN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_CANONNAME]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_IDN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_NUMERICSERV]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_PASSIVE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[AI_V4MAPPED]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_AH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_BEETPH]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_COMP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_DCCP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_EGP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_ENCAP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_ESP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_ETHERNET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_GRE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_ICMP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_IDP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_IGMP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_IP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_IPIP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_IPV6]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_MPLS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_MPTCP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_MTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_PIM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_PUP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_RAW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_RSVP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_SCTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_TCP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_TP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_UDP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPROTO_UDPLITE]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_DGRAM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_IDN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_NAMEREQD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_NOFQDN]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_NUMERICHOST]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[NI_NUMERICSERV]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_BIFFUDP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_CMDSERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_DAYTIME]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_DISCARD]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_ECHO]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_EFSSERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_EXECSERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_FINGER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_FTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_LOGINSERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_MTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_NAMESERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_NETSTAT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_RESERVED]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_RJE]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_ROUTESERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_SMTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_SUPDUP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_SYSTAT]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_TELNET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_TFTP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_TIMESERVER]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_TTYLINK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_USERRESERVED]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_WHOIS]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[IPPORT_WHOSERVER]]]);

    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_CLOEXEC]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_DCCP]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_DGRAM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_NONBLOCK]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_PACKET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_RAW]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_RDM]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_SEQPACKET]]]);
    MMUX_DEFINE_INT_CONSTANT_VARIABLE([[[SOCK_STREAM]]]);

    MMUX_DEFINE_ULONG_CONSTANT_VARIABLE([[[INADDR_BROADCAST]]]);
    MMUX_DEFINE_ULONG_CONSTANT_VARIABLE([[[INADDR_LOOPBACK]]]);
    MMUX_DEFINE_ULONG_CONSTANT_VARIABLE([[[INADDR_NONE]]]);
  }
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_bash_pointers_library_init]]],
    [[[(1 == argc)]]],
    [[["mmux_bash_pointers_library_init"]]],
    [[["Initialise the library MMUX Bash Pointers."]]])

/* end of file */
