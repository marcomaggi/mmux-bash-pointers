/*
  Part of: MMUX Bash Pointers
  Contents: type functions
  Date: Sep 18, 2024

  Abstract

	This module implements type functions.

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

m4_define([[[MMUX_FLOAT_ZERO]]],  [[[((mmux_$1_t)0.0)]]])
m4_define([[[MMUX_INTEGER_ZERO]]],[[[((mmux_$1_t)0)]]])


/** --------------------------------------------------------------------
 ** Some maximum/minimum values.
 ** ----------------------------------------------------------------- */

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT32]]],[[[
__extension__ static const _Float32   mmux_libc_maximum_float32=FLT32_MAX;
__extension__ static const _Float32   mmux_libc_minimum_float32=-(mmux_libc_maximum_float32);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT64]]],[[[
__extension__ static const _Float64   mmux_libc_maximum_float64=FLT64_MAX;
__extension__ static const _Float64   mmux_libc_minimum_float64=-(mmux_libc_maximum_float64);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT128]]],[[[
__extension__ static const _Float128 mmux_libc_maximum_float128=FLT128_MAX;
__extension__ static const _Float128 mmux_libc_minimum_float128=-(mmux_libc_maximum_float128);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT32X]]], [[[
__extension__ static const _Float32x  mmux_libc_maximum_float32x=FLT32X_MAX;
__extension__ static const _Float32x  mmux_libc_minimum_float32x=-(mmux_libc_maximum_float32x);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT64X]]], [[[
__extension__ static const _Float64x  mmux_libc_maximum_float64x=FLT64X_MAX;
__extension__ static const _Float64x  mmux_libc_minimum_float64x=-(mmux_libc_maximum_float64);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_FLOAT128X]]],[[[
__extension__ static const _Float128x mmux_libc_maximum_float128x=FLT128X_MAX;
__extension__ static const _Float128x mmux_libc_minimum_float128x=-(mmux_libc_maximum_float128x);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_DECIMAL32]]],[[[
/* Should we do something with "DEC32_MIN" defined by GCC? */
__extension__ static const _Decimal32   mmux_libc_maximum_decimal32=DEC32_MAX;
__extension__ static const _Decimal32   mmux_libc_minimum_decimal32=-(mmux_libc_maximum_decimal32);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_DECIMAL64]]],[[[
/* Should we do something with "DEC64_MIN" defined by GCC? */
__extension__ static const _Decimal64   mmux_libc_maximum_decimal64=DEC64_MAX;
__extension__ static const _Decimal64   mmux_libc_minimum_decimal64=-(mmux_libc_maximum_decimal64);
]]])

MMUX_BASH_CONDITIONAL_CODE([[[MMUX_HAVE_CC_TYPE_DECIMAL128]]],[[[
/* Should we do something with "DEC128_MIN" defined by GCC? */
__extension__ static const _Decimal128 mmux_libc_maximum_decimal128=DEC128_MAX;
__extension__ static const _Decimal128 mmux_libc_minimum_decimal128=-(mmux_libc_maximum_decimal128);
]]])


/** --------------------------------------------------------------------
 ** Some real number type functions: string_is, sizeof, minimum, maximum.
 ** ----------------------------------------------------------------- */

m4_dnl $1 - Stem of the type.
m4_dnl $2 - C language expression evaluating to the maximum value.
m4_dnl $3 - C language expression evaluating to the minimum value.
m4_dnl $4 - C preprocessor symbol used to exclude the code if the type is not supported.
m4_define([[[DEFINE_REAL_TYPE_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$4]]],[[[
bool
mmux_string_is_$1 (char const * s_value)
{
  mmux_$1_t	value;

  if (MMUX_SUCCESS == mmux_$1_parse(&value, s_value, NULL)) {
    return true;
  } else {
    return false;
  }
}
int
mmux_$1_sizeof (void)
{
  return sizeof(mmux_$1_t);
}
mmux_$1_t
mmux_$1_maximum (void)
{
  return $2;
}
mmux_$1_t
mmux_$1_minimum (void)
{
  return $3;
}
]]])]]])

DEFINE_REAL_TYPE_FUNCTIONS([[[pointer]]],
			   [[[(mmux_pointer_t)mmux_uintptr_maximum()]]],
			   [[[(mmux_pointer_t)mmux_uintptr_minimum()]]])

DEFINE_REAL_TYPE_FUNCTIONS(schar,	SCHAR_MAX,	SCHAR_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uchar,	UCHAR_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sshort,	SHRT_MAX,	SHRT_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(ushort,	USHRT_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sint,	INT_MAX,	INT_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uint,	UINT_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(slong,	LONG_MAX,	LONG_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(ulong,	ULONG_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sllong,	LLONG_MAX,	LLONG_MIN,	[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
DEFINE_REAL_TYPE_FUNCTIONS(ullong,	ULLONG_MAX,	0,		[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

/* FIXME Should we do something to make available the "_MIN" constants defined by the
   C language standard?  (Marco Maggi; Sep 18, 2024) */
DEFINE_REAL_TYPE_FUNCTIONS(float,	FLT_MAX,	-FLT_MAX)
DEFINE_REAL_TYPE_FUNCTIONS(double,	DBL_MAX,	-DBL_MAX)
DEFINE_REAL_TYPE_FUNCTIONS(ldouble,	LDBL_MAX,	-LDBL_MAX,	[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_REAL_TYPE_FUNCTIONS(float32, mmux_libc_maximum_float32, mmux_libc_minimum_float32, [[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_REAL_TYPE_FUNCTIONS(float64, mmux_libc_maximum_float64, mmux_libc_minimum_float64, [[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_REAL_TYPE_FUNCTIONS(float128,mmux_libc_maximum_float128, mmux_libc_minimum_float128, [[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_REAL_TYPE_FUNCTIONS(float32x, mmux_libc_maximum_float32x, mmux_libc_minimum_float32x, [[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_REAL_TYPE_FUNCTIONS(float64x, mmux_libc_maximum_float64x, mmux_libc_minimum_float64x, [[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_REAL_TYPE_FUNCTIONS(float128x,mmux_libc_maximum_float128x, mmux_libc_minimum_float128x, [[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

DEFINE_REAL_TYPE_FUNCTIONS(decimal32, mmux_libc_maximum_decimal32, mmux_libc_minimum_decimal32, [[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
DEFINE_REAL_TYPE_FUNCTIONS(decimal64, mmux_libc_maximum_decimal64, mmux_libc_minimum_decimal64, [[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
DEFINE_REAL_TYPE_FUNCTIONS(decimal128,mmux_libc_maximum_decimal128, mmux_libc_minimum_decimal128, [[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

DEFINE_REAL_TYPE_FUNCTIONS(sint8,	INT8_MAX,	INT8_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uint8,	UINT8_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sint16,	INT16_MAX,	INT16_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uint16,	UINT16_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sint32,	INT32_MAX,	INT32_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uint32,	UINT32_MAX,	0)
DEFINE_REAL_TYPE_FUNCTIONS(sint64,	INT64_MAX,	INT64_MIN)
DEFINE_REAL_TYPE_FUNCTIONS(uint64,	UINT64_MAX,	0)

/* ------------------------------------------------------------------ */

m4_dnl $1 - CUSTOM_STEM
m4_dnl $2 - STANDARD_STEM
m4_define([[[DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS]]],[[[
bool
mmux_string_is_$1 (char const * s_value)
{
  return mmux_string_is_$2(s_value);
}
int
mmux_$1_sizeof (void)
{
  return sizeof(mmux_$1_t);
}
mmux_$1_t
mmux_$1_maximum (void)
{
  return mmux_$2_maximum ();
}
mmux_$1_t
mmux_$1_minimum (void)
{
  return mmux_$2_minimum ();
}
]]])

DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(ssize,	MMUX_BASH_POINTERS_STEM_ALIAS_SSIZE)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(usize,	MMUX_BASH_POINTERS_STEM_ALIAS_USIZE)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(sintmax,	MMUX_BASH_POINTERS_STEM_ALIAS_SINTMAX)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(uintmax,	MMUX_BASH_POINTERS_STEM_ALIAS_UINTMAX)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(sintptr,	MMUX_BASH_POINTERS_STEM_ALIAS_SINTPTR)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(uintptr,	MMUX_BASH_POINTERS_STEM_ALIAS_UINTPTR)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(mode,	MMUX_BASH_POINTERS_STEM_ALIAS_MODE)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(off,		MMUX_BASH_POINTERS_STEM_ALIAS_OFF)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(pid,		MMUX_BASH_POINTERS_STEM_ALIAS_PID)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(uid,		MMUX_BASH_POINTERS_STEM_ALIAS_UID)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(gid,		MMUX_BASH_POINTERS_STEM_ALIAS_GID)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(ptrdiff,	MMUX_BASH_POINTERS_STEM_ALIAS_PTRDIFF)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(wchar,	MMUX_BASH_POINTERS_STEM_ALIAS_WCHAR)
DEFINE_REAL_TYPEDEF_TYPE_FUNCTIONS(wint,	MMUX_BASH_POINTERS_STEM_ALIAS_WINT)


/** --------------------------------------------------------------------
 ** Some complex number type functions: string_is, sizeof, make_rectangular, real part, imag part, abs, arg, conj.
 ** ----------------------------------------------------------------- */

m4_dnl $1 - type stem
m4_dnl $2 - real part function
m4_dnl $3 - imag part function
m4_dnl $4 - make rectangular function
m4_dnl $5 - magnitude function
m4_dnl $6 - argument function
m4_dnl $7 - conjugate function
m4_dnl $8 - atan2 function
m4_dnl $9 - C preprocessor symbol used to exclude the code if the type is not supported.
m4_define([[[DEFINE_COMPLEX_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$9]]],[[[
bool
mmux_string_is_$1 (char const * s_value)
{
  mmux_$1_t	value;

  if (MMUX_SUCCESS == mmux_$1_parse(&value, s_value, NULL)) {
    return true;
  } else {
    return false;
  }
}
int
mmux_$1_sizeof (void)
{
  return sizeof(mmux_$1_t);
}
mmux_$1_t
mmux_$1_make_rectangular (mmux_$1_part_t re, mmux_$1_part_t im)
{
  return $4(re, im);
}
mmux_$1_part_t
mmux_$1_real_part (mmux_$1_t Z)
{
  return $2(Z);
}
mmux_$1_part_t
mmux_$1_imag_part (mmux_$1_t Z)
{
  return $3(Z);
}
inline mmux_$1_part_t
mmux_$1_abs (mmux_$1_t Z)
{
  return sqrt($2(Z) * $2(Z) + $3(Z) * $3(Z));
}
inline mmux_$1_part_t
mmux_$1_arg (mmux_$1_t Z)
{
  return $8($3(Z), $2(Z));
}
inline mmux_$1_t
mmux_$1_conj (mmux_$1_t Z)
{
  return mmux_$1_make_rectangular($2(Z), - $3(Z));
}
]]])]]])

/* ------------------------------------------------------------------ */

DEFINE_COMPLEX_FUNCTIONS([[[complexf]]],  [[[crealf]]], [[[cimagf]]], [[[CMPLXF]]],
			 [[[cabsf]]],     [[[cargf]]],  [[[conjf]]],  [[[atan2f]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexd]]],  [[[creal]]],  [[[cimag]]],  [[[CMPLX]]],
			 [[[cabs]]],      [[[carg]]],   [[[conj]]],   [[[atan2]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexld]]], [[[creall]]], [[[cimagl]]], [[[CMPLXL]]],
			 [[[cabsl]]],     [[[cargl]]],  [[[conjl]]],  [[[atan2l]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

/* ------------------------------------------------------------------ */

DEFINE_COMPLEX_FUNCTIONS([[[complexf32]]],  [[[crealf32]]], [[[cimagf32]]], [[[CMPLXF32]]],
			 [[[cabsf32]]],     [[[cargf32]]],  [[[conjf32]]],  [[[atan2f32]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexf64]]],  [[[crealf64]]], [[[cimagf64]]], [[[CMPLXF64]]],
			 [[[cabsf64]]],     [[[cargf64]]],  [[[conjf64]]],  [[[atan2f64]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexf128]]], [[[crealf128]]],[[[cimagf128]]],[[[CMPLXF128]]],
			 [[[cabsf128]]],    [[[cargf128]]], [[[conjf128]]], [[[atan2f128]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

/* ------------------------------------------------------------------ */

DEFINE_COMPLEX_FUNCTIONS([[[complexf32x]]],  [[[crealf32x]]], [[[cimagf32x]]], [[[CMPLXF32X]]],
			 [[[cabsf32x]]],     [[[cargf32x]]],  [[[conjf32x]]],  [[[atan2f32x]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexf64x]]],  [[[crealf64x]]], [[[cimagf64x]]], [[[CMPLXF64X]]],
			 [[[cabsf64x]]],     [[[cargf64x]]],  [[[conjf64x]]],  [[[atan2f64x]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])

DEFINE_COMPLEX_FUNCTIONS([[[complexf128x]]], [[[crealf128x]]],[[[cimagf128x]]],[[[CMPLXF128X]]],
			 [[[cabsf128x]]],    [[[cargf128x]]], [[[conjf128x]]], [[[atan2f128x]]],
			 [[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])


/** --------------------------------------------------------------------
 ** Complex decimal basic functions.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_COMPLEX_DECIMAL_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$5]]],[[[
bool
mmux_string_is_$1 (char const * s_value)
{
  mmux_$1_t	value;

  if (MMUX_SUCCESS == mmux_$1_parse(&value, s_value, NULL)) {
    return true;
  } else {
    return false;
  }
}
]]])]]])

DEFINE_COMPLEX_DECIMAL_FUNCTIONS([[[complexd32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD32]]])
DEFINE_COMPLEX_DECIMAL_FUNCTIONS([[[complexd64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD64]]])
DEFINE_COMPLEX_DECIMAL_FUNCTIONS([[[complexd128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD128]]])


/** --------------------------------------------------------------------
 ** Store result value in result variable.
 ** ----------------------------------------------------------------- */

m4_define([[[MMUX_BASH_DEFINE_VALUE_STORER]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
int
mmux_$1_bind_to_variable (char const * variable_name, mmux_$1_t value, char const * caller_name)
{
  int		rv, required_nbytes;

  required_nbytes = mmux_$1_sprint_size(value);
  if (0 > required_nbytes) {
    return MMUX_FAILURE;
  } else {
    char	s_value[required_nbytes];

    rv = mmux_$1_sprint(s_value, required_nbytes, value);
    if (MMUX_SUCCESS == rv) {
      return mmux_bash_store_string_in_variable(variable_name, s_value, caller_name);
    } else {
      return rv;
    }
  }
}
]]])]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[pointer]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[schar]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uchar]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sshort]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ushort]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sint]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uint]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[slong]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ulong]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sllong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ullong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[sint8]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uint8]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sint16]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uint16]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sint32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uint32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sint64]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uint64]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[float]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[double]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ldouble]]],		[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[float32]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[float64]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[float128]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[float32x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[float64x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[float128x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[decimal32]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[decimal64]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL64]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[decimal128]]],		[[[MMUX_HAVE_CC_TYPE_DECIMAL128]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[complexf]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexd]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexld]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[complexf32]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexf64]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexf128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[complexf32x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexf64x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexf128x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[complexd32]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXD32]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexd64]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXD64]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[complexd128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXD128]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[usize]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ssize]]])

MMUX_BASH_DEFINE_VALUE_STORER([[[sintmax]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uintmax]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[sintptr]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uintptr]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[ptrdiff]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[mode]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[off]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[pid]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[uid]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[gid]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[wchar]]])
MMUX_BASH_DEFINE_VALUE_STORER([[[wint]]])


/** --------------------------------------------------------------------
 ** Core C language predicate: signed integer numbers.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_SIGNED_INTEGER_PREDICATES]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
bool
mmux_$1_is_zero (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) == X)? true : false;
}
bool
mmux_$1_is_positive (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) < X)? true : false;
}
bool
mmux_$1_is_negative (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) > X)? true : false;
}
bool
mmux_$1_is_non_positive (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) >= X)? true : false;
}
bool
mmux_$1_is_non_negative (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) <= X)? true : false;
}
bool
mmux_$1_is_nan (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return false;
}
bool
mmux_$1_is_infinite (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return false;
}
]]])]]])

DEFINE_SIGNED_INTEGER_PREDICATES([[[schar]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sshort]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sint]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[slong]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sllong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])

DEFINE_SIGNED_INTEGER_PREDICATES([[[sint8]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sint16]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sint32]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sint64]]])

DEFINE_SIGNED_INTEGER_PREDICATES([[[ssize]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sintmax]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[sintptr]]])

DEFINE_SIGNED_INTEGER_PREDICATES([[[ptrdiff]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[off]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[pid]]])
DEFINE_SIGNED_INTEGER_PREDICATES([[[wchar]]])


/** --------------------------------------------------------------------
 ** Core C language predicate: unsigned integer numbers.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_UNSIGNED_INTEGER_PREDICATES]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
bool
mmux_$1_is_zero (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) == X)? true : false;
}
bool
mmux_$1_is_positive (mmux_$1_t X)
{
  return (MMUX_INTEGER_ZERO($1) < X)? true : false;
}
bool
mmux_$1_is_negative (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return false;
}
bool
mmux_$1_is_non_positive (mmux_$1_t X)
{
  return mmux_$1_is_zero(X);
}
bool
mmux_$1_is_non_negative (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return true;
}
bool
mmux_$1_is_nan (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return false;
}
bool
mmux_$1_is_infinite (mmux_$1_t X MMUX_BASH_POINTERS_UNUSED)
{
  return false;
}
]]])]]])

DEFINE_UNSIGNED_INTEGER_PREDICATES([[[pointer]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uchar]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[ushort]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uint]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[ulong]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[ullong]]],	[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uint8]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uint16]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uint32]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uint64]]])

DEFINE_UNSIGNED_INTEGER_PREDICATES([[[usize]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uintmax]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uintptr]]])

DEFINE_UNSIGNED_INTEGER_PREDICATES([[[mode]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[uid]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[gid]]])
DEFINE_UNSIGNED_INTEGER_PREDICATES([[[wint]]])


/** --------------------------------------------------------------------
 ** Core C language predicates: floating-point real numbers.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_REAL_FLOAT_NUMBER_PREDICATES]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
bool
mmux_$1_is_zero (mmux_$1_t X)
{
  return (FP_ZERO == (fpclassify(X)))? true : false;
}
bool
mmux_$1_is_nan (mmux_$1_t X)
{
  return (FP_NAN == (fpclassify(X)))? true : false;
}
bool
mmux_$1_is_infinite (mmux_$1_t X)
{
  return (FP_INFINITE == (fpclassify(X)))? true : false;
}
bool
mmux_$1_is_positive (mmux_$1_t X)
{
  if (mmux_$1_is_nan(X)) {
    return false;
  } else if (mmux_$1_is_zero(X)) {
    if (signbit(X)) {
      return false;
    } else {
      return true;
    }
  } else {
    return (MMUX_FLOAT_ZERO($1) < X)? true : false;
  }
}
bool
mmux_$1_is_negative (mmux_$1_t X)
{
  if (mmux_$1_is_nan(X)) {
    return false;
  } else if (mmux_$1_is_zero(X)) {
    if (signbit(X)) {
      return true;
    } else {
      return false;
    }
  } else {
    return (MMUX_FLOAT_ZERO($1) > X)? true : false;
  }
}
bool
mmux_$1_is_non_positive (mmux_$1_t X)
{
  if (mmux_$1_is_nan(X)) {
    return false;
  } else if (mmux_$1_is_zero(X)) {
    return true;
  } else {
    return (MMUX_FLOAT_ZERO($1) > X)? true : false;
  }
}
bool
mmux_$1_is_non_negative (mmux_$1_t X)
{
  if (mmux_$1_is_nan(X)) {
    return false;
  } else if (mmux_$1_is_zero(X)) {
    return true;
  } else {
    return (MMUX_FLOAT_ZERO($1) < X)? true : false;
  }
}
]]])]]])

DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[double]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[ldouble]]],	[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float32]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float64]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float128]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float32x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float64x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_REAL_FLOAT_NUMBER_PREDICATES([[[float128x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])


/** --------------------------------------------------------------------
 ** Core C language predicates: floating-point complex numbers.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_COMPLEX_NUMBER_PREDICATES]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$3]]],[[[
bool
mmux_$1_is_zero (mmux_$1_t Z)
{
  mmux_$1_part_t	re = mmux_$1_real_part(Z), im = mmux_$1_imag_part(Z);

  return (mmux_$2_is_zero(re) && mmux_$2_is_zero(im))? true : false;
}
bool
mmux_$1_is_nan (mmux_$1_t Z)
{
  mmux_$1_part_t	re = mmux_$1_real_part(Z), im = mmux_$1_imag_part(Z);

  return (mmux_$2_is_nan(re) || mmux_$2_is_nan(im))? true : false;
}
bool
mmux_$1_is_infinite (mmux_$1_t Z)
{
  mmux_$1_part_t	re = mmux_$1_real_part(Z), im = mmux_$1_imag_part(Z);

  return (mmux_$2_is_infinite(re) || mmux_$2_is_infinite(im))? true : false;
}
]]])]]])

DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf]]],	[[[float]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexd]]],	[[[double]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexld]]],	[[[ldouble]]],		[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf32]]],	[[[float32]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf64]]],	[[[float64]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf128]]],	[[[float128]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf32x]]],	[[[float32x]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf64x]]],	[[[float64x]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
DEFINE_COMPLEX_NUMBER_PREDICATES([[[complexf128x]]],	[[[float128x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])


/** --------------------------------------------------------------------
 ** Comparison core functions.
 ** ----------------------------------------------------------------- */

#undef  DECL
#define DECL		__attribute__((__const__))

m4_define([[[DEFINE_COMPARISON_EQUAL_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
DECL bool mmux_$1_equal         (mmux_$1_t op1, mmux_$1_t op2) { return (op1 == op2)? true : false; }
]]])]]])

m4_define([[[DEFINE_COMPARISON_INTEGER_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[$1]]],[[[$2]]])
DECL bool mmux_$1_greater       (mmux_$1_t op1, mmux_$1_t op2) { return (op1 >  op2)? true : false; }
DECL bool mmux_$1_lesser        (mmux_$1_t op1, mmux_$1_t op2) { return (op1 <  op2)? true : false; }
DECL bool mmux_$1_greater_equal (mmux_$1_t op1, mmux_$1_t op2) { return (op1 >= op2)? true : false; }
DECL bool mmux_$1_lesser_equal  (mmux_$1_t op1, mmux_$1_t op2) { return (op1 <= op2)? true : false; }
]]])]]])

m4_define([[[DEFINE_COMPARISON_FLOAT_FUNCTIONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[$1]]],[[[$2]]])
DECL bool mmux_$1_greater       (mmux_$1_t op1, mmux_$1_t op2) { return (     isgreater(op1,op2))? true : false; }
DECL bool mmux_$1_lesser        (mmux_$1_t op1, mmux_$1_t op2) { return (        isless(op1,op2))? true : false; }
DECL bool mmux_$1_greater_equal (mmux_$1_t op1, mmux_$1_t op2) { return (isgreaterequal(op1,op2))? true : false; }
DECL bool mmux_$1_lesser_equal  (mmux_$1_t op1, mmux_$1_t op2) { return (   islessequal(op1,op2))? true : false; }
]]])]]])

DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[pointer]]])

DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[schar]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uchar]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sshort]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[ushort]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sint]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uint]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[slong]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[ulong]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sllong]]],		[[[MMUX_HAVE_CC_TYPE_SLLONG]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[ullong]]],		[[[MMUX_HAVE_CC_TYPE_ULLONG]]])

DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[double]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[ldouble]]],		[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float32]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float64]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float128]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float32x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float64x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_COMPARISON_FLOAT_FUNCTIONS([[[float128x]]],		[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexd]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexld]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf32]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf64]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf128]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf32x]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf64x]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
DEFINE_COMPARISON_EQUAL_FUNCTIONS([[[complexf128x]]],		[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sint8]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uint8]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sint16]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uint16]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sint32]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uint32]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sint64]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uint64]]])

DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[usize]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[ssize]]])

DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sintmax]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uintmax]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[sintptr]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uintptr]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[ptrdiff]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[mode]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[off]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[pid]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[uid]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[gid]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[wchar]]])
DEFINE_COMPARISON_INTEGER_FUNCTIONS([[[wint]]])


/** --------------------------------------------------------------------
 ** More type functions.
 ** ----------------------------------------------------------------- */

m4_define([[[DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$5]]],[[[
inline mmux_$1_t mmux_$1_abs (mmux_$1_t X)                   { return $2(X); }
inline mmux_$1_t mmux_$1_max (mmux_$1_t X, mmux_$1_t Y) { return $3(X, Y); }
inline mmux_$1_t mmux_$1_min (mmux_$1_t X, mmux_$1_t Y) { return $4(X, Y); }
]]])]]])

DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float]]],	[[[fabsf]]],    [[[fmaxf]]],     [[[fminf]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[double]]],	[[[fabs]]],     [[[fmax]]],      [[[fmin]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[ldouble]]],	[[[fabsl]]],    [[[fmaxl]]],     [[[fminl]]],    [[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float32]]],	[[[fabsf32]]],  [[[fmaxf32]]],   [[[fminf32]]],  [[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float64]]],	[[[fabsf64]]],  [[[fmaxf64]]],   [[[fminf64]]],  [[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float128]]],	[[[fabsf128]]], [[[fmaxf128]]],  [[[fminf128]]], [[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float32x]]],	[[[fabsf32x]]], [[[fmaxf32x]]],  [[[fminf32x]]], [[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float64x]]],	[[[fabsf64x]]], [[[fmaxf64x]]],  [[[fminf64x]]], [[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_TYPE_FUNCTIONS_COMPARISON_MORE([[[float128x]]],	[[[fabsf128x]]],[[[fmaxf128x]]], [[[fminf128x]]],[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])


/** --------------------------------------------------------------------
 ** Approximate comparison functions for floating-point numbers.
 ** ----------------------------------------------------------------- */

m4_dnl $1 - complex type stem
m4_dnl $2 - preprocessor symbol for conditional definition
m4_define([[[DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$2]]],[[[
bool
mmux_$1_equal_absmargin (mmux_$1_t op1, mmux_$1_t op2, mmux_$1_t margin)
{
  if (0) { fprintf(stderr, "%s: op1=%Lf op2=%Lf margin=%Lf\n", __func__, (long double)op1, (long double)op2, (long double)margin); }
  return (mmux_$1_abs(op1 - op2) <= mmux_$1_abs(margin))? true : false;
}
bool
mmux_$1_equal_relepsilon (mmux_$1_t op1, mmux_$1_t op2, mmux_$1_t epsilon)
{
  return (mmux_$1_abs(op1 - op2) <= (epsilon * mmux_$1_max(mmux_$1_abs(op1), mmux_$1_abs(op2))))? true : false;
}
]]])]]])

/* ------------------------------------------------------------------ */

m4_dnl $1 - complex type stem
m4_dnl $2 - real part type stem
m4_dnl $3 - preprocessor symbol for conditional definition
m4_define([[[DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS]]],[[[MMUX_BASH_CONDITIONAL_CODE([[[$3]]],[[[
bool
mmux_$1_equal_absmargin (mmux_$1_t op1, mmux_$1_t op2, mmux_$1_t margin)
{
  mmux_$1_part_t	re1 = mmux_$1_real_part(op1);
  mmux_$1_part_t	im1 = mmux_$1_imag_part(op1);
  mmux_$1_part_t	re2 = mmux_$1_real_part(op2);
  mmux_$1_part_t	im2 = mmux_$1_imag_part(op2);
  mmux_$1_part_t	ret = mmux_$1_real_part(margin);
  mmux_$1_part_t	imt = mmux_$1_imag_part(margin);

  if (0) { fprintf(stderr, "%s: re1=%Lf re1=%Lf ret=%Lf\n", __func__, (long double)re1, (long double)re2, (long double)ret); }
  if (0) { fprintf(stderr, "%s: im1=%Lf im2=%Lf imt=%Lf\n", __func__, (long double)im1, (long double)im2, (long double)imt); }
  return (mmux_$2_equal_absmargin(re1, re2, ret) && mmux_$2_equal_absmargin(im1, im2, imt))? true : false;
}
bool
mmux_$1_equal_relepsilon (mmux_$1_t op1, mmux_$1_t op2, mmux_$1_t epsilon)
{
  mmux_$1_part_t	re1 = mmux_$1_real_part(op1);
  mmux_$1_part_t	im1 = mmux_$1_imag_part(op1);
  mmux_$1_part_t	re2 = mmux_$1_real_part(op2);
  mmux_$1_part_t	im2 = mmux_$1_imag_part(op2);
  mmux_$1_part_t	ret = mmux_$1_real_part(epsilon);
  mmux_$1_part_t	imt = mmux_$1_imag_part(epsilon);

  return (mmux_$2_equal_relepsilon(re1, re2, ret) && mmux_$2_equal_relepsilon(im1, im2, imt))? true : false;
}
]]])]]])

/* ------------------------------------------------------------------ */

DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[double]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[ldouble]]],	[[[MMUX_HAVE_CC_TYPE_LDOUBLE]]])

DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float32]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT32]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float64]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT64]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float128]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT128]]])

DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float32x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT32X]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float64x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT64X]]])
DEFINE_TYPE_FUNCTIONS_REAL_FLOAT_APPROX_COMPARISONS([[[float128x]]],	[[[MMUX_HAVE_CC_TYPE_FLOAT128X]]])

/* ------------------------------------------------------------------ */

DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf]]],    [[[float]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexd]]],    [[[double]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexld]]],   [[[ldouble]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXLD]]])

DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf32]]],  [[[float32]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf64]]],  [[[float64]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf128]]], [[[float128]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128]]])

DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf32x]]], [[[float32x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF32X]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf64x]]], [[[float64x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF64X]]])
DEFINE_TYPE_FUNCTIONS_COMPLEX_FLOAT_APPROX_COMPARISONS([[[complexf128x]]],[[[float128x]]],	[[[MMUX_HAVE_CC_TYPE_COMPLEXF128X]]])

/* end of file */
