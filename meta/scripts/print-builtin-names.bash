#!/bin/bash
#
# Part of: MMUX Bash Pointers
# Contents: core library
# Date: Oct 12, 2024
#
# Abstract
#
#	Run this script to output a list of builtin names.
#
# Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU
# General Public  License as  published by  the Free Software  Foundation, either  version 3  of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that  it will be useful, but WITHOUT ANY WARRANTY; without
# even the  implied warranty of MERCHANTABILITY  or FITNESS FOR  A PARTICULAR PURPOSE.  See  the GNU
# General Public License for more details.
#
# You should  have received a copy  of the GNU General  Public License along with  this program.  If
# not, see <http://www.gnu.org/licenses/>.
#

declare -ra SIGNED_INTEGER_STEMS=(schar sshort sint slong sllong
				  sint8 sint16 sint32 sint64 ssize
				  sintmax sintptr ptrdiff off uid gid wchar time)
declare -ra UNSIGNED_INTEGER_STEMS=(uchar ushort uint ulong ullong
				    uint8 uint16 uint32 uint64 usize
				    uintmax uintptr mode pid wint socklen)
declare -ra INTEGER_STEMS=("${SIGNED_INTEGER_STEMS[@]}" "${UNSIGNED_INTEGER_STEMS[@]}")

declare -ra REAL_FLOAT_STEMS=(float double ldouble
			      float32 float64 float128
			      float32x float64x float128x
			      decimal32 decimal64 decimal128)
declare -ra COMPLEX_FLOAT_STEMS=(complexf complexd complexld
				 complexf32 complexf64 complexf128
				 complexf32x complexf64x complexf128x
				 complexd32 complexd64 complexd128)
declare -ra FLOAT_STEMS=("${REAL_FLOAT_STEMS[@]}" "${COMPLEX_FLOAT_STEMS[@]}")

declare -ga MMUX_BASH_POINTERS_REAL_STEMS=('pointer' "${INTEGER_STEMS[@]}" "${REAL_FLOAT_STEMS[@]}")
declare -ga MMUX_BASH_POINTERS_COMPLEX_STEMS=("${COMPLEX_FLOAT_STEMS[@]}")
declare -ga MMUX_BASH_POINTERS_STEMS=("${MMUX_BASH_POINTERS_REAL_STEMS[@]}" "${MMUX_BASH_POINTERS_COMPLEX_STEMS[@]}")

declare -ra LIBC_BUILTINS=(malloc realloc calloc free
			   memset memcpy memccpy memmove memcmp memchr memrchr
			   strerror errno_to_string
			   open openat close read write pread pwrite lseek dup dup2 fcntl ioctl pipe
			   fd_set_malloc fd_set_malloc_triplet FD_ZERO FD_SET FD_CLR FD_ISSET select
			   strlen strcpy strncpy strdup stpcpy strcat strncat strcmp strncmp strcoll strxfrm
			   strchr strrchr strstr strcasestr strspn strcspn strpbrk strtok
			   link linkat symlink readlink realpath unlink unlinkat remove rmdir rename renameat
			   mkdir mkdirat
			   chown fchown lchown fchownat umask getumask chmod fchmod fchmodat access faccessat
			   truncate ftruncate stat fstat lstat fstatat stat_malloc
			   st_mode_ref st_ino_ref st_dev_ref st_nlink_ref st_uid_ref st_gid_ref st_size_ref
			   st_atime_ref st_atime_nsec_ref st_mtime_ref st_mtime_nsec_ref st_ctime_ref st_ctime_nsec_ref
			   st_blocks_ref st_blksize_ref
			   S_ISDIR S_ISCHR S_ISBLK S_ISREG S_ISFIFO S_ISLNK S_ISSOCK S_TYPEISMQ S_TYPEISSEM S_TYPEISSHM
			   utimbuf_malloc utimbuf_actime_set utimbuf_actime_ref utimbuf_modtime_set utimbuf_modtime_ref
			   utime utimes futimes lutimes
			   getuid getgid geteuid getegid getgroups getgrouplist getlogin cuserid
			   getpwuid getpwnam setpwent getpwent endpwent pw_name pw_passwd pw_uid pw_gid pw_gecos pw_dir pw_shell
			   getgrgid getgrnam setgrent getgrent endgrent gr_name gr_gid gr_mem
			   timeval_malloc timeval_set timeval_ref timeval_seconds_set timeval_microseconds_set
			   timeval_seconds_ref timeval_microseconds_ref
			   timespec_malloc timespec_set timespec_ref timespec_seconds_set timespec_nanoseconds_set
			   timespec_seconds_ref timespec_nanoseconds_ref
			   tm_malloc tm_sec_set tm_sec_ref tm_min_set tm_min_ref tm_hour_set tm_hour_ref
			   tm_mday_set tm_mday_ref tm_mon_set tm_mon_ref tm_year_set tm_year_ref
			   tm_wday_set tm_wday_ref tm_yday_set tm_yday_ref tm_isdst_set tm_isdst_ref
			   tm_gmtoff_set tm_gmtoff_ref tm_reset
			   time localtime gmtime mktime timegm asctime ctime strftime strptime sleep nanosleep
			   islower isupper isalpha isdigit isalnum isxdigit ispunct isspace isblank isgraph isprint
			   iscntrl isascii tolower toupper
			   sa_family_ref
			   sockaddr_un_calloc sockaddr_un_sun_family_ref sockaddr_un_sun_path_ref
			   sockaddr_in_calloc
			   sin_family_ref sin_family_set sin_addr_ref sin_addr_set sin_addr_pointer_ref sin_port_ref sin_port_set
			   sockaddr_in6_calloc
			   sin6_family_ref sin6_family_set sin6_addr_pointer_ref sin6_flowinfo_ref sin6_flowinfo_set
			   sin6_scope_id_ref sin6_scope_id_set sin6_port_ref sin6_port_set
			   addrinfo_calloc ai_flags_ref ai_flags_set ai_family_ref ai_family_set ai_socktype_ref ai_socktype_set
			   ai_protocol_ref ai_protocol_set ai_addrlen_ref ai_addrlen_set ai_addr_ref ai_addr_set
			   ai_canonname_ref ai_canonname_set ai_next_ref ai_next_set
			   hostent_calloc h_name_ref h_aliases_ref h_addrtype_ref h_length_ref h_addr_list_ref h_addr_ref hostent_dump
			   sethostent gethostent endhostent
			   servent_calloc s_name_ref s_aliases_ref s_port_ref s_proto_ref servent_dump
			   setservent getservent endservent getservbyname getservbyport
			   protoent_calloc p_name_ref p_aliases_ref p_proto_ref protoent_dump
			   setprotoent getprotoent endprotoent getprotobyname getprotobynumber
			   netent_calloc n_name_ref n_aliases_ref n_addrtype_ref n_net_ref netent_dump
			   setnetent getnetent endnetent getnetbyname getnetbyaddr
			   htons ntohs htonl ntohl inet_aton inet_addr inet_ntoa inet_network inet_makeaddr
			   inet_lnaof inet_netof inet_pton inet_ntop
			   if_nametoindex if_indextoname if_nameindex_to_array
			   getaddrinfo freeaddrinfo getnameinfo
			   bind getsockname socket shutdown socketpair connect listen accept getpeername
			   send recv sendto recvfrom getsockopt setsockopt)

declare -ra MATH_REAL_BUILTINS=(sin cos tan asin acos atan atan2
				sinh cosh tanh asinh acosh atanh
				exp exp2 exp10 log log10 log2 logb
				pow sqrt cbrt hypot expm1 log1p
				erf erfc lgamma tgamma j0 j1 jn y0 y1 yn)

declare -ra MATH_COMPLEX_BUILTINS=(sin cos tan asin acos atan
				   sinh cosh tanh asinh acosh atanh
				   exp log log10 pow sqrt)

### ------------------------------------------------------------------------

declare -i IDX=

function print_builtin_name () {
    declare NAME=${1:?"missing parameter 1 name of bulitin in call to '$FUNCNAME'"}

    printf 'MMUX_BASH_POINTERS_PACKAGE[BUILTIN_%d]=%s\n' ${IDX:?} "${NAME:?}"
    let ++IDX
}

print_builtin_name 'mmux_bash_pointers_library_init'


declare -i IDX JDX
declare NAME ALIAS ITEM STEM

# Standard C Library stuff.
{
    for ITEM in "${LIBC_BUILTINS[@]}"
    do
	printf -v NAME 'mmux_libc_%s' "$ITEM"
	print_builtin_name "$NAME"
    done
}

# Conversions.
{
    for NAME in mmux_pointer_from_bash_string mmux_pointer_to_bash_string mmux_schar_from_string mmux_schar_to_string
    do print_builtin_name "$NAME"
    done
}

for STEM in "${MMUX_BASH_POINTERS_STEMS[@]}"
do
    printf -v NAME 'mmux_%s_pointer_set' "$STEM"
    print_builtin_name "$NAME"

    printf -v NAME 'mmux_%s_array_set'   "$STEM"
    print_builtin_name "$NAME"

    printf -v NAME 'mmux_%s_pointer_ref' "$STEM"
    print_builtin_name "$NAME"

    printf -v NAME 'mmux_%s_array_ref' "$STEM"
    print_builtin_name "$NAME"
done

# Arithmetics builtins.
{
    print_builtin_name 'mmux_pointer_add'
    print_builtin_name 'mmux_pointer_diff'

    for STEM in "${INTEGER_STEMS[@]}"
    do
	for ITEM in add sub mul div mod neg inv incr decr abs
	do
	    printf -v NAME  'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in add sub mul div neg inv abs
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${COMPLEX_FLOAT_STEMS[@]}"
    do
	for ITEM in add sub mul div neg inv abs make_rectangular real_part imag_part arg conj
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

# Bitwise builtins.
{
    for STEM in 'pointer' "${INTEGER_STEMS[@]}"
    do
	for ITEM in and or xor not shl shr
	do
	    printf -v NAME 'mmux_%s_bitwise_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

# Predicates builtins.
{
    for STEM in "${MMUX_BASH_POINTERS_STEMS[@]}"
    do
	printf -v NAME 'mmux_string_is_%s' "$STEM"
	print_builtin_name "$NAME"
    done

    for STEM in 'pointer' "${INTEGER_STEMS[@]}" "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in zero positive negative non_positive non_negative nan infinite
	do
	    printf -v NAME  'mmux_%s_is_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${COMPLEX_FLOAT_STEMS[@]}"
    do
	for ITEM in zero nan infinite
	do
	    printf -v NAME 'mmux_%s_is_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

# Comparison builtins.
{
    for STEM in 'pointer' "${INTEGER_STEMS[@]}"
    do
	for ITEM in equal greater less greater_equal less_equal min max
	do
	    printf -v NAME  'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in equal greater less greater_equal less_equal equal_absmargin equal_relepsilon min max
	do
	    printf -v NAME  'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${COMPLEX_FLOAT_STEMS[@]}"
    do
	for ITEM in equal equal_absmargin equal_relepsilon
	do
	    printf -v NAME  'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

# Output format selection.
{
    for STEM in "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in set_format ref_format reformat
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${COMPLEX_FLOAT_STEMS[@]}"
    do
	for ITEM in reformat
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

# Mathematics builtins.
{
    for STEM in "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in "${MATH_REAL_BUILTINS[@]}"
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${COMPLEX_FLOAT_STEMS[@]}"
    do
	for ITEM in "${MATH_COMPLEX_BUILTINS[@]}"
	do
	    printf -v NAME 'mmux_%s_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done

    for STEM in "${REAL_FLOAT_STEMS[@]}"
    do
	for ITEM in E LOG2E LOG10E LN2 LN10 PI PI_2 PI_4 1_PI 2_PI 2_SQRTPI SQRT2 SQRT1_2
	do
	    printf -v NAME 'mmux_%s_constant_%s' "$STEM" "$ITEM"
	    print_builtin_name "$NAME"
	done
    done
}

### ------------------------------------------------------------------------

# The environment variable "CONFIG_H_FILE" is exported by the makefile.
#
function have_cfunc () {
    declare -r CFUNCNAME=${1:?}
    declare -r UPCASE_CFUNCNAME=${CFUNCNAME^^}
    declare -r SYMBOL_TEMPLATE='HAVE_%s'
    declare -r RESULT_TEMPLATE='#define HAVE_%s 1'
    declare SYMBOL RESULT LINE

    printf -v SYMBOL "$SYMBOL_TEMPLATE" "${UPCASE_CFUNCNAME}"
    printf -v RESULT "$RESULT_TEMPLATE" "${UPCASE_CFUNCNAME}"

    LINE=$(grep "$SYMBOL" "$CONFIG_H_FILE" )
    if test "$LINE" = "$RESULT"
    then return 0
    else return 1
    fi
}

# Builtin wrapping C language functions that may not be available.
{
    for ITEM in mempcpy strnlen strndup stpncpy strcasecmp strncasecmp strverscmp \
			rawmemchr memmem strchrnul basename dirname canonicalize_file_name \
			renameat2 group_member dup3 accept4
    do
	if have_cfunc "$ITEM"
	then
	    printf '%s: present: %s\n' "$0" "$ITEM" >&2
	    printf -v NAME 'mmux_libc_%s' "$ITEM"
	    print_builtin_name "$NAME"
	else printf '%s: missing: %s\n' "$0" "$ITEM" >&2
	fi
    done
}

### end of file
# Local Variables:
# mode: sh
# End:
