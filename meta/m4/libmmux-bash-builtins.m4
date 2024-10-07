m4_divert(-1)m4_dnl
m4_dnl
m4_dnl Part of: MMUX Bash Builtins Macros
m4_dnl Contents: macros to define builtins
m4_dnl Date: Sep  9, 2024
m4_dnl
m4_dnl Abstract
m4_dnl
m4_dnl		This library  defines macros to  automatically generate C language
m4_dnl		functions for GNU Bash builtings implementation.
m4_dnl
m4_dnl Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>
m4_dnl
m4_dnl This program is free  software: you can redistribute it and/or  modify it under the
m4_dnl terms  of  the  GNU General  Public  License  as  published  by the  Free  Software
m4_dnl Foundation, either version 3 of the License, or (at your option) any later version.
m4_dnl
m4_dnl This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
m4_dnl WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
m4_dnl PARTICULAR PURPOSE.  See the GNU General Public License for more details.
m4_dnl
m4_dnl You should have received  a copy of the GNU General Public  License along with this
m4_dnl program.  If not, see <http://www.gnu.org/licenses/>.
m4_dnl


m4_dnl preamble

m4_changequote(`[[[', `]]]')
m4_changecom([[[/*]]],[[[*/]]])


m4_dnl helpers

m4_define([[[mmux_toupper]]],[[[m4_translit([[[$1]]],[[[abcdefghijklmnopqrstuvwxyz]]],[[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]]])]]])
m4_define([[[mmux_tolower]]],[[[m4_translit([[[$1]]],[[[ABCDEFGHIJKLMNOPQRSTUVWXYZ]]],[[[abcdefghijklmnopqrstuvwxyz]]])]]])


m4_dnl function definitions

m4_dnl $1 - bulitin identifier
m4_dnl $2 - C language expression, between parentheses, about "argc": if true the number of argumets is correct
m4_define([[[MMUX_BASH_DEFINE_BUILTIN_FUNCTION_NO_OPTIONS]]],[[[m4_dnl
static bool
$1_validate_argc (int argc)
{
  return ($2)? true : false;
}
static int
$1_builtin (mmux_bash_word_list_t word_list)
{
  return (int) mmux_bash_builtin_implementation_function_no_options(word_list, $1_validate_argc, $1_main);
}
]]])

m4_dnl $1 - bulitin identifier
m4_dnl $2 - C language expression, between parentheses, about "argc": if true the number of argumets is correct
m4_define([[[MMUX_BASH_DEFINE_BUILTIN_FUNCTION]]],[[[m4_dnl
static bool
$1_validate_argc (int argc)
{
  return ($2)? true : false;
}
static int
$1_builtin (mmux_bash_word_list_t word_list)
{
  return (int) mmux_bash_builtin_implementation_function(word_list, $1_validate_argc, $1_main);
}
]]])


m4_dnl data structures

m4_dnl $1 - bulitin identifier
m4_dnl $2 - C language string representing the short documentation
m4_define([[[MMUX_BASH_DEFINE_BUILTIN_STRUCT]]],[[[m4_dnl
/* Bash will search for this struct  building the name "$1_struct" from the command
   line argument "$1" we have given to the "enable" builtin. */
mmux_bash_struct_builtin_t $1_struct = {
  .name		= "$1",				/* Builtin name */
  .function	= $1_builtin,			/* Function implementing the builtin */
  .flags	= MMUX_BASH_BUILTIN_ENABLED,	/* Initial flags for builtin */
  .long_doc	= $1_doc,			/* Array of long documentation strings. */
  .short_doc	= $2,				/* Usage synopsis; becomes short_doc */
  .reserved0	= NULL				/* Reserved for Bash. */
};
]]])

m4_dnl $1 - bulitin identifier
m4_dnl $2 - C language string representing a single-line long documentation
m4_define([[[MMUX_BASH_DEFINE_BUILTIN_LONG_DOC_SINGLE_LINE]]],[[[m4_dnl
/* A NULL-terminated array of ASCIIZ strings representing the lines of the
   builtin long documentation. */
static char * $1_doc[] = {
  $2,
  (char *)NULL
};
]]])


m4_dnl usages

m4_dnl $1 - bulitin identifier
m4_dnl $2 - C language expression about "argc": if true the number of argumets is wrong
m4_dnl $3 - C language string representing the short documentation
m4_dnl $4 - C language string representing the long documentation, a single-line
m4_define([[[MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION]]],[[[m4_dnl
m4_dnl Here we do not use the NO_OPTION  version of the implementation function: with that
m4_dnl version an argument  like "-1.2" is interpreted  as an option, and  an error raised
m4_dnl because there  are no  options allowed.   Here we  want such  arguments to  just go
m4_dnl through any validation and come to us as they are.
MMUX_BASH_DEFINE_BUILTIN_FUNCTION([[[$1]]],[[[$2]]])
MMUX_BASH_DEFINE_BUILTIN_LONG_DOC_SINGLE_LINE([[[$1]]],[[[$4]]])
MMUX_BASH_DEFINE_BUILTIN_STRUCT([[[$1]]],[[[$3]]])
]]])

m4_dnl m4_dnlif 0
m4_dnl /* Called when  the builtin is  enabled and loaded from  the shared object.   If this
m4_dnl    function returns 0, the load fails. */
m4_dnl int
m4_dnl add_builtin_load (char *name MMUX_BASH_POINTERS_UNUSED)
m4_dnl {
m4_dnl   return (1);
m4_dnl }
m4_dnl /* Called when `add' is disabled. */
m4_dnl void
m4_dnl add_builtin_unload (char *name)
m4_dnl {
m4_dnl }
m4_dnl #endif


m4_dnl helpers

m4_dnl $1 - Preprocessor symbol: if defined, include the body of code; otherwise include the alternative body.
m4_dnl $2 - The body of code.
m4_dnl $3 - The alternative of code.
m4_define([[[MMUX_BASH_CONDITIONAL_CODE]]],[[[m4_ifelse([[[$1]]],,[[[$2]]],[[[m4_dnl
#if ((defined $1) && (1 == $1))
$2
m4_ifelse([[[$3]]],,,[[[m4_dnl
#else
$3
]]])
#endif
]]])]]])


#### parsing arguments

# Put this at the end of a function that uses the parser macros.
#
# static int
# my_builtin_main (int argc, char const * char argv[])
# {
#   void *	arg;
#
#   MMUX_BASH_PARSE_BUILTIN_ARG_MPF_PTR([[[arg]]], [[[argv[1]]]]);
#   ...
#   return MMUX_SUCCESS;
#   MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
# }
#
m4_define([[[MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH]]],[[[
 mmux_error_parsing_builtin_argument:
  mmux_bash_pointers_set_ERRNO(EINVAL, MMUX_BUILTIN_NAME);
  return MMUX_FAILURE;
]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_POINTER]]],[[[{
  int  mmux_retval = mmux_pointer_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_ASCIIZ_PTR]]],[[[{
  $1 = $2;
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SCHAR]]],[[[{
  int  mmux_retval = mmux_schar_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UCHAR]]],[[[{
  int  mmux_retval = mmux_uchar_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SSHORT]]],[[[{
  int  mmux_retval = mmux_sshort_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_USHORT]]],[[[{
  int  mmux_retval = mmux_ushort_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINT]]],[[[{
  int  mmux_retval = mmux_sint_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINT]]],[[[{
  int  mmux_retval = mmux_uint_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SLONG]]],[[[{
  int  mmux_retval = mmux_slong_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_ULONG]]],[[[{
  int  mmux_retval = mmux_ulong_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SLLONG]]],[[[{
  int  mmux_retval = mmux_sllong_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_ULLONG]]],[[[{
  int  mmux_retval = mmux_ullong_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINT8]]],[[[{
  int  mmux_retval = mmux_sint8_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINT8]]],[[[{
  int  mmux_retval = mmux_uint8_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINT16]]],[[[{
  int  mmux_retval = mmux_sint16_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINT16]]],[[[{
  int  mmux_retval = mmux_uint16_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINT32]]],[[[{
  int  mmux_retval = mmux_sint32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINT32]]],[[[{
  int  mmux_retval = mmux_uint32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINT64]]],[[[{
  int  mmux_retval = mmux_sint64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINT64]]],[[[{
  int  mmux_retval = mmux_uint64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT]]],[[[{
  int  mmux_retval = mmux_float_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_DOUBLE]]],[[[{
  int  mmux_retval = mmux_double_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_LDOUBLE]]],[[[{
  int  mmux_retval = mmux_ldouble_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT32]]],[[[{
  int  mmux_retval = mmux_float32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT64]]],[[[{
  int  mmux_retval = mmux_float64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT128]]],[[[{
  int  mmux_retval = mmux_float128_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT32X]]],[[[{
  int  mmux_retval = mmux_float32x_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT64X]]],[[[{
  int  mmux_retval = mmux_float64x_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_FLOAT128X]]],[[[{
  int  mmux_retval = mmux_float128x_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_DECIMAL32]]],[[[{
  int  mmux_retval = mmux_decimal32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_DECIMAL64]]],[[[{
  int  mmux_retval = mmux_decimal64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_DECIMAL128]]],[[[{
  int  mmux_retval = mmux_decimal128_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXF]]],[[[{
  int  mmux_retval = mmux_complexf_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXD]]],[[[{
  int  mmux_retval = mmux_complexd_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXLD]]],[[[{
  int  mmux_retval = mmux_complexld_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXF32]]],[[[{
  int  mmux_retval = mmux_complexf32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])
# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXF64]]],[[[{
  int  mmux_retval = mmux_complexf64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXF128]]],[[[{
  int  mmux_retval = mmux_complexf128_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXD32]]],[[[{
  int  mmux_retval = mmux_complexd32_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXD64]]],[[[{
  int  mmux_retval = mmux_complexd64_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_COMPLEXD128]]],[[[{
  int  mmux_retval = mmux_complexd128_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_MODE]]],[[[{
  int  mmux_retval = mmux_mode_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SSIZE]]],[[[{
  int  mmux_retval = mmux_ssize_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_USIZE]]],[[[{
  int  mmux_retval = mmux_usize_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINTMAX]]],[[[{
  int  mmux_retval = mmux_sintmax_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINTMAX]]],[[[{
  int  mmux_retval = mmux_uintmax_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_SINTPTR]]],[[[{
  int  mmux_retval = mmux_sintptr_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UINTPTR]]],[[[{
  int  mmux_retval = mmux_uintptr_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# --------------------------------------------------------------------

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_PTRDIFF]]],[[[{
  int  mmux_retval = mmux_ptrdiff_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_OFF]]],[[[{
  int  mmux_retval = mmux_off_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_PID]]],[[[{
  int  mmux_retval = mmux_pid_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_UID]]],[[[{
  int  mmux_retval = mmux_uid_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_GID]]],[[[{
  int  mmux_retval = mmux_gid_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_WCHAR]]],[[[{
  int  mmux_retval = mmux_wchar_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])

# $1 - name of the target variable
# $2 - expression evaluating to the string to parse
m4_define([[[MMUX_BASH_PARSE_BUILTIN_ARG_WINT]]],[[[{
  int  mmux_retval = mmux_wint_parse(&$1, $2, MMUX_BUILTIN_NAME);
  if (MMUX_SUCCESS != mmux_retval) { goto mmux_error_parsing_builtin_argument; }
}]]])


m4_dnl let's go

m4_dnl end of file
m4_dnl Local Variables:
m4_dnl mode: m4
m4_dnl End:
m4_divert(0)m4_dnl
