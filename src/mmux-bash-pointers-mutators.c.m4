/*
  Part of: MMUX Bash Pointers
  Contents: implementation of memory mutator builtins
  Date: Sep  9, 2024

  Abstract

	This module implements raw memory mutator builtins.

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


m4_define([[[MMUX_BASH_POINTERS_DEFINE_MUTATOR]]],[[[
static int
mmuxpointerspointerset[[[]]]$1[[[]]]_main (int argc MMUX_BASH_POINTERS_UNUSED, char * argv[])
#undef  MMUX_BUILTIN_NAME
#define MMUX_BUILTIN_NAME	"pointer-set-$1"
{
#if ($3)
  void *	ptr;
  uint8_t *	ptr_byte;
  $2 *		ptr_value;
  size_t	offset;
  $2		value;
  int		rv;

  rv = mmux_bash_pointers_parse_pointer(&ptr, argv[1], MMUX_BUILTIN_NAME);
  if (EXECUTION_SUCCESS != rv) { return rv; }

  rv = mmux_bash_pointers_parse_offset(&offset, argv[2], MMUX_BUILTIN_NAME);
  if (EXECUTION_SUCCESS != rv) { return rv; }

  rv = mmux_bash_pointers_parse_$1(&value, argv[3], MMUX_BUILTIN_NAME);
  if (EXECUTION_SUCCESS != rv) { return rv; }

  ptr_byte  = ptr;
  ptr_byte += offset;
  ptr_value = ($2 *)ptr_byte;

  *ptr_value = value;
  return EXECUTION_SUCCESS;
#else
  fprintf(stderr, "MMUX Bash Pointers: error: mutator \"%s\" not implemented because underlying C language type not available.\n",
	  MMUX_BUILTIN_NAME);
  return EXECUTION_FAILURE;
#endif
}
MMUX_BASH_POINTERS_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmuxpointerspointerset$1]]],[[[(4 != argc)]]],
    [[["pointer-set-$1 POINTER OFFSET VALUE"]]],
    [[["Store VALUE at OFFSET from POINTER, VALUE must fit a C language type \"$2\"."]]])
]]])

MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[pointer]]],	[[[void *]]],			[[[1]]])

MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[schar]]],		[[[signed   char]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uchar]]],		[[[unsigned char]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sint]]],		[[[signed   int]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uint]]],		[[[unsigned int]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[slong]]],		[[[signed   long]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[ulong]]],		[[[unsigned long]]],		[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sllong]]],		[[[signed   long long]]],	[[[HAVE_LONG_LONG_INT]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[ullong]]],		[[[unsigned long long]]],	[[[HAVE_UNSIGNED_LONG_LONG_INT]]])

MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[float]]],		[[[float]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[double]]],		[[[double]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[ldouble]]],	[[[long double]]],		[[[HAVE_LONG_DOUBLE]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[complex]]],	[[[double complex]]],		[[[HAVE_LONG_DOUBLE]]])

MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sint8]]],		[[[int8_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uint8]]],		[[[uint8_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sint16]]],		[[[int16_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uint16]]],		[[[uint16_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sint32]]],		[[[int32_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uint32]]],		[[[uint32_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[sint64]]],		[[[int64_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[uint64]]],		[[[uint64_t]]],			[[[1]]])

MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[usize]]],		[[[size_t]]],			[[[1]]])
MMUX_BASH_POINTERS_DEFINE_MUTATOR([[[ssize]]],		[[[ssize_t]]],			[[[1]]])

/* end of file */
