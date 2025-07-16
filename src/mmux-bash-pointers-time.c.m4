/*
  Part of: MMUX Bash Pointers
  Contents: implementation of time and date builtins
  Date: Nov 15, 2024

  Abstract

	This module implements time and date builtins.

  Copyright (C) 2024, 2025 Marco Maggi <mrc.mgg@gmail.com>

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
 ** Struct timeval.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timeval_calloc]]])
{
  char const *	pointer_varname;
  mmux_time_t	seconds      = 0;
  mmux_slong_t	microseconds = 0;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pointer_varname,	1);
  if (4 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(seconds,		2);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG(microseconds,		3);
  }
  {
    mmux_libc_timeval_t *	timeval_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_calloc(&timeval_pointer, 1, sizeof(mmux_libc_timeval_t)));
    mmux_libc_timeval_set(timeval_pointer, seconds, microseconds);
    return mmux_pointer_bind_to_bash_variable_or_free(pointer_varname, timeval_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (4 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAL_POINTER_VAR [SECONDS MICROSECONDS]"]]])

/* ------------------------------------------------------------------ */

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_timeval_t]]],[[[tv_sec]]], [[[time]]], [[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_timeval_t]]],[[[tv_usec]]],[[[slong]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timeval_set]]])
{
  mmux_libc_timeval_t *	timeval_pointer;
  mmux_time_t		seconds;
  mmux_slong_t		microseconds;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timeval_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(seconds,			2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG(microseconds,		3);
  {
    mmux_libc_tv_sec_set(timeval_pointer, seconds);
    mmux_libc_tv_usec_set(timeval_pointer, microseconds);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAL_POINTER SLONG_SECONDS SLONG_MICROSECONDS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timeval_ref]]])
{
  char const *		seconds_varname;
  char const *		microseconds_varname;
  mmux_libc_timeval_t *	timeval_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(seconds_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(microseconds_varname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timeval_pointer,		3);
  {
    mmux_time_t		seconds;
    mmux_slong_t	microseconds;

    mmux_libc_tv_sec_ref (&seconds,      timeval_pointer);
    mmux_libc_tv_usec_ref(&microseconds, timeval_pointer);
    {
      mmux_bash_rv_t	brv = mmux_time_bind_to_bash_variable(seconds_varname, seconds, MMUX_BASH_BUILTIN_STRING_NAME);

      if (MMUX_SUCCESS != brv) { return brv; }
    }
    return mmux_slong_bind_to_bash_variable(microseconds_varname, microseconds, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SLONG_SECONDS_VAR SLONG_MICROSECONDS_VAR TIMEVAL_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timeval_dump]]])
{
  mmux_libc_timeval_t *	timeval_pointer;
  char const *		struct_name = "struct timeval";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timeval_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_file_descriptor_t		fd;

    mmux_libc_stdou(&fd);
    MMUX_LIBC_FUNCALL(mmux_libc_timeval_dump(fd, timeval_pointer, struct_name));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAL_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Struct timespec.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timespec_calloc]]])
{
  char const *	pointer_varname;
  mmux_time_t	seconds     = 0;
  mmux_slong_t	nanoseconds = 0;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pointer_varname,	1);
  if (4 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(seconds,		2);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG(nanoseconds,		3);
  }
  {
    mmux_libc_timespec_t *	timespec_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_calloc(&timespec_pointer, 1, sizeof(mmux_libc_timespec_t)));
    mmux_libc_timespec_set(timespec_pointer, seconds, nanoseconds);
    return mmux_pointer_bind_to_bash_variable_or_free(pointer_varname, timespec_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (4 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMESPEC_POINTER_VAR [SECONDS NANOSECONDS]"]]])

/* ------------------------------------------------------------------ */

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_timespec_t]]],[[[ts_sec]]], [[[time]]], [[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_timespec_t]]],[[[ts_nsec]]],[[[slong]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timespec_set]]])
{
  mmux_libc_timespec_t *	timespec_pointer;
  mmux_time_t		seconds;
  mmux_slong_t		nanoseconds;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timespec_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(seconds,			2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG(nanoseconds,		3);
  {
    mmux_libc_ts_sec_set(timespec_pointer, seconds);
    mmux_libc_ts_nsec_set(timespec_pointer, nanoseconds);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMESPEC_POINTER SLONG_SECONDS SLONG_NANOSECONDS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timespec_ref]]])
{
  char const *			seconds_varname;
  char const *			nanoseconds_varname;
  mmux_libc_timespec_t *	timespec_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(seconds_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(nanoseconds_varname,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timespec_pointer,	3);
  {
    mmux_time_t		seconds;
    mmux_slong_t	nanoseconds;

    mmux_libc_ts_sec_ref (&seconds,     timespec_pointer);
    mmux_libc_ts_nsec_ref(&nanoseconds, timespec_pointer);
    {
      mmux_bash_rv_t	brv = mmux_time_bind_to_bash_variable(seconds_varname, seconds, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { return brv; }
    }
    return mmux_slong_bind_to_bash_variable(nanoseconds_varname, nanoseconds, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SLONG_SECONDS_VAR SLONG_NANOSECONDS_VAR TIMESPEC_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timespec_dump]]])
{
  mmux_libc_timespec_t *	timespec_pointer;
  char const *		struct_name = "struct timespec";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timespec_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,		2);
  }
  {
    mmux_libc_file_descriptor_t		fd;

    mmux_libc_stdou(&fd);
    MMUX_LIBC_FUNCALL(mmux_libc_timespec_dump(fd, timespec_pointer, struct_name));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMESPEC_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Struct tm.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_tm_calloc]]])
{
  char const *	tm_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(tm_pointer_varname,	1);
  {
    mmux_time_t		T;
    mmux_libc_tm_t *	result_tm_pointer;
    mmux_libc_tm_t *	new_tm_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_time(&T));
    MMUX_LIBC_FUNCALL(mmux_libc_localtime(&result_tm_pointer, T));
    MMUX_LIBC_FUNCALL(mmux_libc_calloc(&new_tm_pointer, 1, sizeof(mmux_libc_tm_t)));
    return mmux_pointer_bind_to_bash_variable_or_free(tm_pointer_varname, new_tm_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TM_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_sec]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_min]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_hour]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_mday]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_mon]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_year]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_wday]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_yday]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_isdst]]],	[[[sint]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_tm_t]]],[[[tm_gmtoff]]],	[[[slong]]],	[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_tm_reset]]])
{
  mmux_libc_tm_t *	tm_p;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_p,	1);
  {
    mmux_libc_tm_reset(tm_p);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_tm_dump]]])
{
  mmux_libc_tm_t *	tm_pointer;
  char const *		struct_name = "struct tm";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_file_descriptor_t		fd;

    mmux_libc_stdou(&fd);
    MMUX_LIBC_FUNCALL(mmux_libc_tm_dump(fd, tm_pointer, struct_name));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TM_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Time builtins.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_time]]])
{
  char const *	time_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(time_varname,	1);
  {
    mmux_time_t		T;

    MMUX_LIBC_FUNCALL(mmux_libc_time(&T));
    return mmux_time_bind_to_bash_variable(time_varname, T, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_localtime]]])
{
  mmux_libc_tm_t *	tm_pointer;
  mmux_time_t		T;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(T,			2);
  {
    mmux_libc_tm_t *	result_tm_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_localtime(&result_tm_pointer, T));
    *tm_pointer = *result_tm_pointer;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TM_POINTER TIME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_gmtime]]])
{
  mmux_libc_tm_t *	tm_pointer;
  mmux_time_t		T;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(T,			2);
  {
    mmux_libc_tm_t *	result_tm_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_gmtime(&result_tm_pointer, T));
    *tm_pointer = *result_tm_pointer;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TM_POINTER TIME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_mktime]]])
{
  char const *		time_varname;
  mmux_libc_tm_t *	tm_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(time_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	2);
  {
    mmux_time_t		T;

    MMUX_LIBC_FUNCALL(mmux_libc_mktime(&T, tm_pointer));
    return mmux_time_bind_to_bash_variable(time_varname, T, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAR TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_timegm]]])
{
  char const *		time_varname;
  mmux_libc_tm_t *	tm_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(time_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	2);
  {
    mmux_time_t		T;

    MMUX_LIBC_FUNCALL(mmux_libc_timegm(&T, tm_pointer));
    return mmux_time_bind_to_bash_variable(time_varname, T, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER TIMEVAR TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_asctime]]])
{
  char const *		string_varname;
  mmux_libc_tm_t *	tm_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(string_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	2);
  {
    char const *	string;

    MMUX_LIBC_FUNCALL(mmux_libc_asctime(&string, tm_pointer));
    return mmux_string_bind_to_bash_variable(string_varname, string, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STRINGVAR TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_ctime]]])
{
  char const *	string_varname;
  mmux_time_t	T;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(string_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME(T,			2);
  {
    char const *	string;

    MMUX_LIBC_FUNCALL(mmux_libc_ctime(&string, T));
    return mmux_string_bind_to_bash_variable(string_varname, string, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STRINGVAR TIME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_strftime]]])
{
  char const *		string_varname;
  char const *		template;
  mmux_libc_tm_t *	tm_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(string_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(template,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	3);
  {
    mmux_usize_t	required_nbytes_including_nil;

    if (mmux_libc_strftime_required_nbytes_including_nil(&required_nbytes_including_nil, template, tm_pointer)) {
      return true;
    }

    {
      char		bufstr[required_nbytes_including_nil];
      mmux_usize_t	required_nbytes_without_zero;

      if (mmux_libc_strftime(&required_nbytes_without_zero, bufstr, required_nbytes_including_nil, template, tm_pointer)) {
	mmux_libc_dprintfer("%s: error converting broken-time to string\n", MMUX_BASH_BUILTIN_STRING_NAME);
	return MMUX_FAILURE;
      }
      return mmux_string_bind_to_bash_variable(string_varname, bufstr, MMUX_BASH_BUILTIN_STRING_NAME);
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STRINGVAR TEMPLATE TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_strptime]]])
{
  char const *		input_string;
  char const *		template;
  mmux_libc_tm_t *	tm_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(input_string,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(template,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(tm_pointer,	3);
  {
    char *	first_unprocessed_after_timestamp;

    if (mmux_libc_strptime(&first_unprocessed_after_timestamp, input_string, template, tm_pointer)) {
      mmux_libc_dprintfer("%s: error parsing time string: '%s'\n", MMUX_BASH_BUILTIN_STRING_NAME, input_string);
      return MMUX_FAILURE;
    }
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER INPUT_STRING TEMPLATE TM_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sleep]]])
{
  char const *		leftover_varname;
  mmux_uint_t		seconds;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(leftover_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT(seconds,			2);
  {
    mmux_uint_t		leftover;

    mmux_libc_sleep(&leftover, seconds);
    return mmux_uint_bind_to_bash_variable(leftover_varname, leftover, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER LEFTOVER_SECONDS_UINT_VAR UINT_SECONDS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_nanosleep]]])
{
  mmux_libc_timespec_t *	timespec_requested_time;
  mmux_libc_timespec_t *	timespec_remaining_time;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timespec_requested_time,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(timespec_remaining_time,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_nanosleep(timespec_requested_time, timespec_remaining_time));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER REQUESTED_TIME_TIMESPEC_POINTER REMAINING_TIME_TIMESPEC_POINTER"]]])


/** --------------------------------------------------------------------
 ** Module initialisation.
 ** ----------------------------------------------------------------- */

mmux_bash_rv_t
mmux_bash_pointers_init_time_module (void)
{
  mmux_bash_rv_t	rv;

  rv = mmux_bash_create_global_sint_variable("mmux_libc_timeval_SIZEOF",  sizeof(mmux_libc_timeval_t), NULL);
  if (MMUX_SUCCESS != rv) { return rv; }

  rv = mmux_bash_create_global_sint_variable("mmux_libc_timespec_SIZEOF", sizeof(mmux_libc_timespec_t), NULL);
  if (MMUX_SUCCESS != rv) { return rv; }

  rv = mmux_bash_create_global_sint_variable("mmux_libc_tm_SIZEOF",       sizeof(mmux_libc_tm_t), NULL);
  if (MMUX_SUCCESS != rv) { return rv; }

  return MMUX_SUCCESS;
}

/* end of file */
