/*
  Part of: MMUX Bash Pointers
  Contents: type functions
  Date: Sep 18, 2024

  Abstract

	This module implements type functions.

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
 ** Standard low-level type functions.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS]]],[[[
bool
mmux_bash_pointers_string_[[[]]]$1[[[]]]_p (char const * s_arg)
{
  mmux_libc_[[[]]]$1[[[]]]_t	value;

  if (EXECUTION_SUCCESS == mmux_bash_pointers_parse_[[[]]]$1[[[]]](&value, s_arg, NULL)) {
    return true;
  } else {
    return false;
  }
}
int
mmux_bash_pointers_sizeof_[[[]]]$1[[[]]] (void)
{
  return sizeof(mmux_libc_[[[]]]$1[[[]]]_t);
}
mmux_libc_[[[]]]$1[[[]]]_t
mmux_bash_pointers_maximum_[[[]]]$1[[[]]] (void)
{
  return $2;
}
mmux_libc_[[[]]]$1[[[]]]_t
mmux_bash_pointers_minimum_[[[]]]$1[[[]]] (void)
{
  return $3;
}
int
mmux_bash_pointers_sprint_maximum_[[[]]]$1[[[]]] (char * s, size_t l)
{
  return mmux_bash_pointers_sprint_[[[]]]$1[[[]]](s, l, $2);
}
int
mmux_bash_pointers_sprint_minimum_[[[]]]$1[[[]]](char * s, size_t l)
{
  return mmux_bash_pointers_sprint_[[[]]]$1[[[]]](s, l, $3);
}
]]])

MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(schar,	SCHAR_MAX,	SCHAR_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uchar,	UCHAR_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sshort,	SHRT_MAX,	SHRT_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(ushort,	USHRT_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sint,	INT_MAX,	INT_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uint,	UINT_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(slong,	LONG_MAX,	LONG_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(ulong,	ULONG_MAX,	0)
#if ((defined HAVE_LONG_LONG_INT) && (1 == HAVE_LONG_LONG_INT))
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sllong,	LLONG_MAX,	LLONG_MIN)
#endif
#if ((defined HAVE_UNSIGNED_LONG_LONG_INT) && (1 == HAVE_UNSIGNED_LONG_LONG_INT))
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(ullong,	ULLONG_MAX,	0)
#endif

MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(float,	FLT_MAX,	FLT_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(double,	DBL_MAX,	DBL_MIN)
#if ((defined HAVE_LONG_DOUBLE) && (1 == HAVE_LONG_DOUBLE))
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(ldouble,	LDBL_MAX,	LDBL_MIN)
#endif

MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sint8,	INT8_MAX,	INT8_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uint8,	UINT8_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sint16,	INT16_MAX,	INT16_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uint16,	UINT16_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sint32,	INT32_MAX,	INT32_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uint32,	UINT32_MAX,	0)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(sint64,	INT64_MAX,	INT64_MIN)
MMUX_BASH_POINTERS_DEFINE_STANDARD_LOW_LEVEL_TYPE_FUNCTIONS(uint64,	UINT64_MAX,	0)

/* ------------------------------------------------------------------ */

bool
mmux_bash_pointers_string_pointer_p (char const * s_arg)
{
  mmux_libc_pointer_t	value;

  if (EXECUTION_SUCCESS == mmux_bash_pointers_parse_pointer(&value, s_arg, NULL)) {
    return true;
  } else {
    return false;
  }
}
int
mmux_bash_pointers_sizeof_pointer (void)
{
  return sizeof(mmux_libc_pointer_t);
}
mmux_libc_pointer_t
mmux_bash_pointers_minimum_pointer (void)
{
  return (mmux_libc_pointer_t)mmux_bash_pointers_minimum_uintptr();
}
mmux_libc_pointer_t
mmux_bash_pointers_maximum_pointer (void)
{
  return (mmux_libc_pointer_t) mmux_bash_pointers_maximum_uintptr();
}
int
mmux_bash_pointers_sprint_maximum_pointer (char * s, size_t l)
{
  return mmux_bash_pointers_sprint_pointer(s, l, mmux_bash_pointers_maximum_pointer());
}
int
mmux_bash_pointers_sprint_minimum_pointer (char * s, size_t l)
{
  /* We want a proper number, not "(nul)" as the GNU C Library does. */
  size_t	to_be_written_chars;

  to_be_written_chars = snprintf(s, l, "%x", 0);
  if (l > to_be_written_chars) {
    return EXECUTION_SUCCESS;
  } else {
    return EXECUTION_FAILURE;
  }
}

/* ------------------------------------------------------------------ */

bool
mmux_bash_pointers_string_complex_p (char const * s_arg)
{
  double complex	value;

  if (EXECUTION_SUCCESS == mmux_bash_pointers_parse_complex(&value, s_arg, NULL)) {
    return true;
  } else {
    return false;
  }
}
int
mmux_bash_pointers_sizeof_complex (void)
{
  return sizeof(mmux_libc_complex_t);
}


/** --------------------------------------------------------------------
 ** Standard high-level type functions.
 ** ----------------------------------------------------------------- */

m4_dnl $1 - CUSTOM_STEM
m4_dnl $2 - STANDARD_STEM
m4_define([[[MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS]]],[[[
bool
mmux_bash_pointers_string_[[[]]]$1[[[]]]_p (char const * s_arg)
{
  mmux_libc_[[[]]]$1[[[]]]_t	value;

  if (EXECUTION_SUCCESS == mmux_bash_pointers_parse_[[[]]]$1[[[]]](&value, s_arg, NULL)) {
    return true;
  } else {
    return false;
  }
}
  int
  mmux_bash_pointers_sizeof_[[[]]]$1[[[]]] (void)
  {
    return sizeof(mmux_libc_[[[]]]$1[[[]]]_t);
  }
  mmux_libc_[[[]]]$1[[[]]]_t
  mmux_bash_pointers_maximum_[[[]]]$1[[[]]] (void)
  {
    return mmux_bash_pointers_maximum_[[[]]]$2[[[]]] ();
  }
  mmux_libc_[[[]]]$1[[[]]]_t
  mmux_bash_pointers_minimum_[[[]]]$1[[[]]] (void)
  {
    return mmux_bash_pointers_minimum_[[[]]]$2[[[]]] ();
  }
  int
  mmux_bash_pointers_sprint_maximum_[[[]]]$1[[[]]] (char * s, size_t l)
  {
    return mmux_bash_pointers_sprint_maximum_[[[]]]$2[[[]]] (s,l);
  }
  int
  mmux_bash_pointers_sprint_minimum_[[[]]]$1[[[]]] (char * s, size_t l)
  {
    return mmux_bash_pointers_sprint_minimum_[[[]]]$2[[[]]] (s,l);
  }
]]])

MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(ssize,	MMUX_BASH_POINTERS_STEM_ALIAS_SSIZE)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(usize,	MMUX_BASH_POINTERS_STEM_ALIAS_USIZE)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(sintmax,	MMUX_BASH_POINTERS_STEM_ALIAS_SINTMAX)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(uintmax,	MMUX_BASH_POINTERS_STEM_ALIAS_UINTMAX)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(sintptr,	MMUX_BASH_POINTERS_STEM_ALIAS_SINTPTR)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(uintptr,	MMUX_BASH_POINTERS_STEM_ALIAS_UINTPTR)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(mode,	MMUX_BASH_POINTERS_STEM_ALIAS_MODE)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(off,	MMUX_BASH_POINTERS_STEM_ALIAS_OFF)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(pid,	MMUX_BASH_POINTERS_STEM_ALIAS_PID)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(uid,	MMUX_BASH_POINTERS_STEM_ALIAS_UID)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(gid,	MMUX_BASH_POINTERS_STEM_ALIAS_GID)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(ptrdiff,	MMUX_BASH_POINTERS_STEM_ALIAS_PTRDIFF)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(wchar,	MMUX_BASH_POINTERS_STEM_ALIAS_WCHAR)
MMUX_BASH_POINTERS_DEFINE_STANDARD_HIGH_LEVEL_TYPE_FUNCTIONS(wint,	MMUX_BASH_POINTERS_STEM_ALIAS_WINT)

/* end of file */