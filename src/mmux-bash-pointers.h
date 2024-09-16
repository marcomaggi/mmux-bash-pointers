/*
  Part of: MMUX Bash Pointers
  Contents: public header file
  Date: Sep  9, 2024

  Abstract

	This is the public  header file of the library, defining  the public API.  It
	must be included in all the code that uses the library.

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

#ifndef MMUX_BASH_POINTERS_H
#define MMUX_BASH_POINTERS_H 1


/** --------------------------------------------------------------------
 ** Preliminary definitions.
 ** ----------------------------------------------------------------- */

#ifdef __cplusplus
extern "C" {
#endif

/* The  macro  MMUX_BASH_POINTERS_UNUSED  indicates   that  a  function,  function
   argument or variable may potentially be unused. Usage examples:

   static int unused_function (char arg) MMUX_BASH_POINTERS_UNUSED;
   int foo (char unused_argument MMUX_BASH_POINTERS_UNUSED);
   int unused_variable MMUX_BASH_POINTERS_UNUSED;
*/
#ifdef __GNUC__
#  define MMUX_BASH_POINTERS_UNUSED		__attribute__((__unused__))
#else
#  define MMUX_BASH_POINTERS_UNUSED		/* empty */
#endif

#ifndef __GNUC__
#  define __attribute__(...)	/* empty */
#endif

#ifndef __GNUC__
#  define __builtin_expect(...)	/* empty */
#endif

#if defined _WIN32 || defined __CYGWIN__
#  ifdef BUILDING_DLL
#    ifdef __GNUC__
#      define mmux_bash_pointers_decl		__attribute__((__dllexport__)) extern
#    else
#      define mmux_bash_pointers_decl		__declspec(dllexport) extern
#    endif
#  else
#    ifdef __GNUC__
#      define mmux_bash_pointers_decl		__attribute__((__dllimport__)) extern
#    else
#      define mmux_bash_pointers_decl		__declspec(dllimport) extern
#    endif
#  endif
#  define mmux_bash_pointers_private_decl	extern
#else
#  if __GNUC__ >= 4
#    define mmux_bash_pointers_decl		__attribute__((__visibility__("default"))) extern
#    define mmux_bash_pointers_private_decl	__attribute__((__visibility__("hidden")))  extern
#  else
#    define mmux_bash_pointers_decl		extern
#    define mmux_bash_pointers_private_decl	extern
#  endif
#endif


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include <stdint.h>
#include <inttypes.h>
#include <complex.h>


/** --------------------------------------------------------------------
 ** Constants and preprocessor macros.
 ** ----------------------------------------------------------------- */



/** --------------------------------------------------------------------
 ** Version functions.
 ** ----------------------------------------------------------------- */

mmux_bash_pointers_decl char const *	mmux_bash_pointers_version_string		(void);
mmux_bash_pointers_decl int		mmux_bash_pointers_version_interface_current	(void);
mmux_bash_pointers_decl int		mmux_bash_pointers_version_interface_revision	(void);
mmux_bash_pointers_decl int		mmux_bash_pointers_version_interface_age	(void);


/** --------------------------------------------------------------------
 ** Type definitions.
 ** ----------------------------------------------------------------- */

/* These definitions can be useful when expanding macros. */
typedef void *				mmux_libc_pointer_t;
typedef signed char			mmux_libc_schar_t;
typedef unsigned char			mmux_libc_uchar_t;
typedef signed short int		mmux_libc_sshort_t;
typedef unsigned short int		mmux_libc_ushort_t;
typedef signed int			mmux_libc_sint_t;
typedef unsigned int			mmux_libc_uint_t;
typedef signed long			mmux_libc_slong_t;
typedef unsigned long			mmux_libc_ulong_t;

#if ((defined HAVE_LONG_LONG_INT) && (1 == HAVE_LONG_LONG_INT))
typedef signed long long		mmux_libc_sllong_t;
#endif
#if ((defined HAVE_UNSIGNED_LONG_LONG) && (1 == HAVE_UNSIGNED_LONG_LONG))
typedef unsigned long long		mmux_libc_ullong_t;
#endif

typedef int8_t				mmux_libc_sint8_t;
typedef uint8_t				mmux_libc_uint8_t;
typedef int16_t				mmux_libc_sint16_t;
typedef uint16_t			mmux_libc_uint16_t;
typedef int32_t				mmux_libc_sint32_t;
typedef uint32_t			mmux_libc_uint32_t;
typedef int64_t				mmux_libc_sint64_t;
typedef uint64_t			mmux_libc_uint64_t;

typedef float				mmux_libc_float_t;
typedef double				mmux_libc_double_t;
#if ((defined HAVE_LONG_DOUBLE) && (1 == HAVE_LONG_DOUBLE))
typedef long double			mmux_libc_ldouble_t;
#endif
typedef double complex			mmux_libc_complex_t;

typedef ssize_t				mmux_libc_ssize_t;
typedef size_t				mmux_libc_usize_t;
typedef intmax_t			mmux_libc_sintmax_t;
typedef uintmax_t			mmux_libc_uintmax_t;
typedef intptr_t			mmux_libc_sintptr_t;
typedef uintptr_t			mmux_libc_uintptr_t;

typedef ptrdiff_t			mmux_libc_ptrdiff_t;
typedef mode_t				mmux_libc_mode_t;
typedef off_t				mmux_libc_off_t;
typedef pid_t				mmux_libc_pid_t;
typedef uid_t				mmux_libc_uid_t;
typedef gid_t				mmux_libc_gid_t;


/** --------------------------------------------------------------------
 ** Type string parsers.
 ** ----------------------------------------------------------------- */

#undef  mmux_bash_pointers_parse_offset
#define mmux_bash_pointers_parse_offset(P_DATA,S_ARG,CALLER_NAME) \
  mmux_bash_pointers_parse_usize(P_DATA,S_ARG,CALLER_NAME)

mmux_bash_pointers_decl int mmux_bash_pointers_parse_pointer (void **  p_data, char const * s_arg, char const * caller_name);

mmux_bash_pointers_decl int mmux_bash_pointers_parse_schar   (signed   char * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uchar   (unsigned char * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sshort  (signed   short int  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ushort  (unsigned short int  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sint    (signed   int  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uint    (unsigned int  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_slong   (signed   long * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ulong   (unsigned long * p, char const * s, char const * caller_name);
#if ((defined HAVE_LONG_LONG_INT) && (1 == HAVE_LONG_LONG_INT))
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sllong  (signed   long long * p, char const * s, char const * caller_name);
#endif
#if ((defined HAVE_UNSIGNED_LONG_LONG_INT) && (1 == HAVE_UNSIGNED_LONG_LONG_INT))
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ullong  (unsigned long long * p, char const * s, char const * caller_name);
#endif
mmux_bash_pointers_decl int mmux_bash_pointers_parse_float   (float   * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_double  (double  * p, char const * s, char const * caller_name);
#if ((defined HAVE_LONG_DOUBLE) && (1 == HAVE_LONG_DOUBLE))
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ldouble (long double * p, char const * s, char const * caller_name);
#endif
mmux_bash_pointers_decl int mmux_bash_pointers_parse_complex (double complex * p, const char * s, char const * caller_name);

mmux_bash_pointers_decl int mmux_bash_pointers_parse_sint8   (int8_t   * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uint8   (uint8_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sint16  (int16_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uint16  (uint16_t * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sint32  (int32_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uint32  (uint32_t * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sint64  (int64_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uint64  (uint64_t * p, char const * s, char const * caller_name);

mmux_bash_pointers_decl int mmux_bash_pointers_parse_usize   (size_t   * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ssize   (ssize_t  * p, char const * s, char const * caller_name);

mmux_bash_pointers_decl int mmux_bash_pointers_parse_sintmax(intmax_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uintmax(uintmax_t * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_sintptr(intptr_t  * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uintptr(uintptr_t * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_ptrdiff(ptrdiff_t * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_mode    (mode_t   * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_off     (off_t    * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_pid     (pid_t    * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_uid     (uid_t    * p, char const * s, char const * caller_name);
mmux_bash_pointers_decl int mmux_bash_pointers_parse_gid     (gid_t    * p, char const * s, char const * caller_name);


/** --------------------------------------------------------------------
 ** Type string printers.
 ** ----------------------------------------------------------------- */

#undef  mmux_bash_pointers_sprint_offset
#define mmux_bash_pointers_sprint_offset(STRPTR,LEN,VALUE) \
  mmux_bash_pointers_sprint_usize(STRPTR,LEN,VALUE)

mmux_bash_pointers_decl int mmux_bash_pointers_sprint_pointer (char * strptr, size_t len, void * value);

mmux_bash_pointers_decl int mmux_bash_pointers_sprint_schar   (char * strptr, size_t len, signed   char value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uchar   (char * strptr, size_t len, unsigned char value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sshort  (char * strptr, size_t len, signed   short value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ushort  (char * strptr, size_t len, unsigned short value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sint    (char * strptr, size_t len, signed   int  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uint    (char * strptr, size_t len, unsigned int  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_slong   (char * strptr, size_t len, signed   long value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ulong   (char * strptr, size_t len, unsigned long value);
#if ((defined HAVE_LONG_LONG_INT) && (1 == HAVE_LONG_LONG_INT))
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sllong  (char * strptr, size_t len, signed   long long value);
#endif
#if ((defined HAVE_UNSIGNED_LONG_LONG_INT) && (1 == HAVE_UNSIGNED_LONG_LONG_INT))
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ullong  (char * strptr, size_t len, unsigned long long value);
#endif
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_float   (char * strptr, size_t len, float   value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_double  (char * strptr, size_t len, double  value);
#if ((defined HAVE_LONG_DOUBLE) && (1 == HAVE_LONG_DOUBLE))
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ldouble (char * strptr, size_t len, long double value);
#endif
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_complex (char * strptr, size_t len, double complex value);

mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sint8   (char * strptr, size_t len, int8_t   value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uint8   (char * strptr, size_t len, uint8_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sint16  (char * strptr, size_t len, int16_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uint16  (char * strptr, size_t len, uint16_t value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sint32  (char * strptr, size_t len, int32_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uint32  (char * strptr, size_t len, uint32_t value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sint64  (char * strptr, size_t len, int64_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uint64  (char * strptr, size_t len, uint64_t value);

mmux_bash_pointers_decl int mmux_bash_pointers_sprint_usize   (char * strptr, size_t len, size_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ssize   (char * strptr, size_t len, ssize_t value);

mmux_bash_pointers_decl int mmux_bash_pointers_sprint_sintmax (char * strptr, size_t len, intmax_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uintmax (char * strptr, size_t len, uintmax_t value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_intptr  (char * strptr, size_t len, intptr_t  value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uintptr (char * strptr, size_t len, uintptr_t value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_ptrdiff (char * strptr, size_t len, ptrdiff_t value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_mode    (char * strptr, size_t len, mode_t   value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_off     (char * strptr, size_t len, off_t    value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_pid     (char * strptr, size_t len, pid_t    value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_uid     (char * strptr, size_t len, uid_t    value);
mmux_bash_pointers_decl int mmux_bash_pointers_sprint_gid     (char * strptr, size_t len, gid_t    value);


/** --------------------------------------------------------------------
 ** Type stdout printers.
 ** ----------------------------------------------------------------- */

mmux_bash_pointers_decl int mmux_bash_pointers_print_pointer (void * data);
mmux_bash_pointers_decl int mmux_bash_pointers_print_usize   (size_t data);
mmux_bash_pointers_decl int mmux_bash_pointers_print_complex (double complex data);


/** --------------------------------------------------------------------
 ** Error handling functions.
 ** ----------------------------------------------------------------- */

mmux_bash_pointers_decl int mmux_bash_pointers_set_ERRNO (int errnum);


/** --------------------------------------------------------------------
 ** Done.
 ** ----------------------------------------------------------------- */

#ifdef __cplusplus
} // extern "C"
#endif

#endif /* MMUX_BASH_POINTERS_H */

/* end of file */
