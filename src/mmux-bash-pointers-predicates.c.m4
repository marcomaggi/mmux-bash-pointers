/*
  Part of: MMUX Bash Pointers
  Contents: functions to validate the string representation of C language types
  Date: Sep 18, 2024

  Abstract

	This module  functions to  validate the string  representation of  C language
	types.

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
 ** Type predicate builtins.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE]]],[[[static int
mmux_$1_is_string_main (int argc MMUX_BASH_POINTERS_UNUSED,  char const * const argv[])
#undef  MMUX_BUILTIN_NAME
#define MMUX_BUILTIN_NAME	"mmux_$1_is_string"
{
MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
  mmux_libc_$1_t	data;

  return mmux_bash_pointers_parse_$1(&data, argv[1], MMUX_BUILTIN_NAME);
]]],[[[
  fprintf(stderr, "MMUX Bash Pointers: error: predicate \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return MMUX_FAILURE;
]]])
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_$1_is_string]]],
    [[[(2 == argc)]]],
    [[["mmux_$1_is_string STRING_REP"]]],
    [[["Return true if STRING_REP is a valid string representation for the C language type."]]])
]]])

MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[pointer]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[schar]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uchar]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sshort]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ushort]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sint]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uint]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[slong]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ulong]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sllong]]],	[[[MMUX_HAVE_TYPE_SLLONG]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ullong]]],	[[[MMUX_HAVE_TYPE_ULLONG]]])

MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[float]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[double]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ldouble]]],	[[[MMUX_HAVE_TYPE_LDOUBLE]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[complexf]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[complexd]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[complexld]]],	[[[MMUX_HAVE_TYPE_LDOUBLE]]])

MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sint8]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uint8]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sint16]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uint16]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sint32]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uint32]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sint64]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uint64]]])

MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ssize]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[usize]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sintmax]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uintmax]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[sintptr]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uintptr]]])

MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[ptrdiff]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[mode]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[off]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[pid]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[uid]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[gid]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[wchar]]])
MMUX_BASH_POINTERS_DEFINE_TYPE_STRING_REP_PREDICATE([[[wint]]])


/** --------------------------------------------------------------------
 ** Arithmetic predicate builtins: zero, positive, negative, non-positive, non-negative, nan, infinite.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE]]],[[[
static int
mmux_$1_is_$3_main (int argc MMUX_BASH_POINTERS_UNUSED,  char const * const argv[])
#undef  MMUX_BUILTIN_NAME
#define MMUX_BUILTIN_NAME	"mmux_$1_is_$3"
{
MMUX_BASH_CONDITIONAL_CODE([[[$4]]],[[[
  mmux_libc_$1_t	value;
  int			rv;

  rv = mmux_bash_pointers_parse_$1(&value, argv[1], MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != rv) { mmux_bash_pointers_set_ERRNO(EINVAL, MMUX_BUILTIN_NAME); return rv; }

  if (mmux_$1_is_$3(value)) {
    return MMUX_SUCCESS;
  } else {
    return MMUX_FAILURE;
  }
]]],[[[
  fprintf(stderr, "MMUX Bash Pointers: error: predicate \"%s\" not implemented because underlying C language type not available.\n",
	  __func__);
  return MMUX_FAILURE;
]]])
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_$1_is_$3]]],
    [[[(2 == argc)]]],
    [[["mmux_$1_is_$3 OP"]]],
    [[["Return true if OP is a valid representation of a $2 value for the C language type \"$1\"."]]])
]]])

m4_define([[[MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES]]],[[[
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[zero]]],		[[[zero]]],	      [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[positive]]],		[[[positive]]],	      [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[negative]]],		[[[negative]]],	      [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[non-positive]]],	[[[non_positive]]],   [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[non-negative]]],	[[[non_negative]]],   [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[nan]]],		[[[nan]]],	      [[[$2]]])
MMUX_BASH_POINTERS_DEFINE_ARITHMETIC_PREDICATE([[[$1]]],	[[[infinite]]],		[[[infinite]]],	      [[[$2]]])
]]])

MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[pointer]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[schar]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uchar]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sshort]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ushort]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sint]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uint]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[slong]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ulong]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sllong]]],	[[[MMUX_HAVE_TYPE_SLLONG]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ullong]]],	[[[MMUX_HAVE_TYPE_ULLONG]]])

MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[float]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[double]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ldouble]]],	[[[MMUX_HAVE_TYPE_LDOUBLE]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[complexf]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[complexd]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[complexld]]],	[[[MMUX_HAVE_TYPE_LDOUBLE]]])

MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sint8]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uint8]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sint16]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uint16]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sint32]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uint32]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sint64]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uint64]]])

MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ssize]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[usize]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sintmax]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uintmax]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[sintptr]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uintptr]]])

MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[ptrdiff]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[mode]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[off]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[pid]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[uid]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[gid]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[wchar]]])
MMUX_BASH_POINTERS_DEFINE_ALL_ARITHMETIC_PREDICATES([[[wint]]])

/* end of file */
