/*
  Part of: MMUX Bash Pointers
  Contents: functions to print values to string
  Date: Sep 11, 2024

  Abstract

	This module implements functions to print values to string.

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
 ** Type string printers: raw C standard types, no typedefs.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_POINTERS_DEFINE_SPRINT]]],[[[int
mmux_bash_pointers_sprint_[[[$1]]] (char * strptr, size_t len, mmux_libc_[[[$1]]]_t value)
{
#if ($3)
  size_t	to_be_written_chars;

  to_be_written_chars = snprintf(strptr, len, $2, value);
  if (len > to_be_written_chars) {
    return EXECUTION_SUCCESS;
  } else {
    return EXECUTION_FAILURE;
  }
#else
  fprintf(stderr, "MMUX Bash Pointers: error: printer \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return EXECUTION_FAILURE;
#endif
}]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[schar]]],		[[["%hhd"]]], [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[uchar]]],		[[["%hhu"]]], [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[sshort]]],		[[["%hd"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ushort]]],		[[["%hu"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[sint]]],		[[["%d"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[uint]]],		[[["%u"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[slong]]],		[[["%ld"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ulong]]],		[[["%lu"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[sllong]]],		[[["%lld"]]], [[[HAVE_LONG_LONG_INT]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ullong]]],		[[["%llu"]]], [[[HAVE_UNSIGNED_LONG_LONG_INT]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[double]]],		[[["%lA"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ldouble]]],		[[["%LA"]]],  [[[HAVE_LONG_DOUBLE]]])

/* ------------------------------------------------------------------ */

int
mmux_bash_pointers_sprint_pointer (char * strptr, size_t len, mmux_libc_pointer_t value)
/* This exists because the GNU C Library  prints "(nil)" when the pointer is NULL and
   the template is "%p"; we want a proper number representation. */
{
  size_t	to_be_written_chars;

  if (value) {
    to_be_written_chars = snprintf(strptr, len, "%p", value);
  } else {
    to_be_written_chars = snprintf(strptr, len, "0x0");
  }
  if (len > to_be_written_chars) {
    return EXECUTION_SUCCESS;
  } else {
    return EXECUTION_FAILURE;
  }
}
int
mmux_bash_pointers_sprint_float (char * strptr, size_t len, float value)
/* This exists  because of the  explicit cast to "double";  without it: GCC  raises a
   warning. */
{
  size_t	to_be_written_chars;

  to_be_written_chars = snprintf(strptr, len, "%A", (double)value);
  if (len > to_be_written_chars) {
    return EXECUTION_SUCCESS;
  } else {
    return EXECUTION_FAILURE;
  }
}
int
mmux_bash_pointers_sprint_complex (char * strptr, size_t len, double complex value)
{
  double	re = creal(value), im = cimag(value);
  size_t	to_be_written_chars;

  to_be_written_chars = snprintf(strptr, len, "(%lA)+i*(%lA)", re, im);
  if (len > to_be_written_chars) {
    return EXECUTION_SUCCESS;
  } else {
    return EXECUTION_FAILURE;
  }
}


/** --------------------------------------------------------------------
 ** Type string printers: C standard type int8.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_sprint_sint8 (char * strptr, size_t len, int8_t value)
{
  return mmux_bash_pointers_sprint_sint(strptr, len, (signed int)value);
}
int
mmux_bash_pointers_sprint_uint8 (char * strptr, size_t len, uint8_t value)
{
  return mmux_bash_pointers_sprint_uint(strptr, len, (unsigned int)value);
}


/** --------------------------------------------------------------------
 ** Type string printers: C standard type int16.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_sprint_sint16 (char * strptr, size_t len, int16_t value)
{
  return mmux_bash_pointers_sprint_sint(strptr, len, (signed int)value);
}
int
mmux_bash_pointers_sprint_uint16 (char * strptr, size_t len, uint16_t value)
{
  return mmux_bash_pointers_sprint_uint(strptr, len, (unsigned int)value);
}


/** --------------------------------------------------------------------
 ** Type string printers: C standard type int32.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_sprint_sint32 (char * strptr, size_t len, int32_t value)
{
  return mmux_bash_pointers_sprint_slong(strptr, len, (signed long int)value);
}
int
mmux_bash_pointers_sprint_uint32 (char * strptr, size_t len, uint32_t value)
{
  return mmux_bash_pointers_sprint_ulong(strptr, len, (unsigned long int)value);
}


/** --------------------------------------------------------------------
 ** Type string printers: C standard type int64.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_sprint_sint64 (char * strptr, size_t len, int64_t value)
{
#if ((defined HAVE_LONG_LONG_INT) && (1 == HAVE_LONG_LONG_INT))
  return mmux_bash_pointers_sprint_sllong(strptr, len, (signed long long int)value);
#else
  fprintf(stderr, "MMUX Bash Pointers: error: printer \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return EXECUTION_FAILURE;
#endif
}
int
mmux_bash_pointers_sprint_uint64 (char * strptr, size_t len, uint64_t value)
{
#if ((defined HAVE_UNSIGNED_LONG_LONG_INT) && (1 == HAVE_UNSIGNED_LONG_LONG_INT))
  return mmux_bash_pointers_sprint_ullong(strptr, len, (unsigned long long int)value);
#else
  fprintf(stderr, "MMUX Bash Pointers: error: printer \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return EXECUTION_FAILURE;
#endif
}


/** --------------------------------------------------------------------
 ** Other C language and Unix type string printers.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER]]],[[[
int
mmux_bash_pointers_sprint_$1 (char * strptr, size_t len, mmux_libc_[[[$1]]]_t value)
{
  return mmux_bash_pointers_sprint_[[[]]]$2[[[]]](strptr, len, value);
}
]]])

MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[ssize]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_SSIZE]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[usize]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_USIZE]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[sintmax]]],	[[[MMUX_BASH_POINTERS_STEM_ALIAS_SINTMAX]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[uintmax]]],	[[[MMUX_BASH_POINTERS_STEM_ALIAS_UINTMAX]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[sintptr]]],	[[[MMUX_BASH_POINTERS_STEM_ALIAS_SINTPTR]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[uintptr]]],	[[[MMUX_BASH_POINTERS_STEM_ALIAS_UINTPTR]]])

MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[ptrdiff]]],	[[[MMUX_BASH_POINTERS_STEM_ALIAS_PTRDIFF]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[mode]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_MODE]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[off]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_OFF]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[pid]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_PID]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[uid]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_UID]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[gid]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_GID]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[wchar]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_WCHAR]]])
MMUX_BASH_POINTERS_DEFINE_SUBTYPE_SPRINTER([[[wint]]],		[[[MMUX_BASH_POINTERS_STEM_ALIAS_WINT]]])

/* end of file */
