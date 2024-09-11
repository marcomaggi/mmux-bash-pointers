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


m4_define([[[MMUX_BASH_POINTERS_DEFINE_SPRINT]]],[[[
int
mmux_bash_pointers_sprint_[[[]]]$1 (char * strptr, size_t len, $2 value)
{
#if ($4)
  snprintf(strptr, len, $3, value);
  return EXECUTION_SUCCESS;
#else
  fprintf(stderr, "MMUX Bash Pointers: error: printer \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return EXECUTION_FAILURE;
#endif
}
]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[pointer]]],		[[[void *]]],			[[["%p"]]],   [[[1]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[schar]]],		[[[signed char]]],		[[["%d"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[uchar]]],		[[[unsigned char]]],		[[["%u"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[sint]]],		[[[signed int]]],		[[["%d"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[uint]]],		[[[unsigned int]]],		[[["%u"]]],   [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[slong]]],		[[[signed long]]],		[[["%ld"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ulong]]],		[[[unsigned long]]],		[[["%lu"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[sllong]]],		[[[signed long long]]],		[[["%lld"]]], [[[HAVE_LONG_LONG_INT]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ullong]]],		[[[unsigned long long]]],	[[["%llu"]]], [[[HAVE_UNSIGNED_LONG_LONG_INT]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ssize]]],		[[[ssize_t]]],			[[["%ld"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[usize]]],		[[[size_t]]],			[[["%lu"]]],  [[[1]]])

MMUX_BASH_POINTERS_DEFINE_SPRINT([[[double]]],		[[[double]]],			[[["%lA"]]],  [[[1]]])
MMUX_BASH_POINTERS_DEFINE_SPRINT([[[ldouble]]],		[[[long double]]],		[[["%LA"]]],  [[[HAVE_LONG_DOUBLE]]])

int
mmux_bash_pointers_sprint_float (char * strptr, size_t len, float value)
{
  snprintf(strptr, len, "%A", (double)value);
  return EXECUTION_SUCCESS;
}
int
mmux_bash_pointers_sprint_complex (char * strptr, size_t len, double complex value)
{
  double	re = creal(value), im = cimag(value);

  snprintf(strptr, len, "(%lA)+i*(%lA)", re, im);
  return EXECUTION_SUCCESS;
}


/** --------------------------------------------------------------------
 ** Type string printers: int8.
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
 ** Type string printers: int16.
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
 ** Type string printers: int32.
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
 ** Type string printers: int64.
 ** ----------------------------------------------------------------- */

int
mmux_bash_pointers_sprint_sint64 (char * strptr, size_t len, int64_t value)
{
#if (HAVE_LONG_LONG_INT)
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
#if (HAVE_UNSIGNED_LONG_LONG_INT)
  return mmux_bash_pointers_sprint_ullong(strptr, len, (unsigned long long int)value);
#else
  fprintf(stderr, "MMUX Bash Pointers: error: printer \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return EXECUTION_FAILURE;
#endif
}

/* end of file */