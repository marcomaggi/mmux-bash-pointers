#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for socketa builtins
#!# Date: Nov 18, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/sockets.test ; less tests/sockets.log
#!#
#!#	that will select these tests.
#!#
#!# Copyright (c) 2024 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# This program is free  software: you can redistribute it and/or modify it  under the terms of the
#!# GNU General Public License as published by the Free Software Foundation, either version 3 of the
#!# License, or (at your option) any later version.
#!#
#!# This program  is distributed  in the  hope that  it will  be useful,  but WITHOUT  ANY WARRANTY;
#!# without even the implied  warranty of MERCHANTABILITY or FITNESS FOR  A PARTICULAR PURPOSE.  See
#!# the GNU General Public License for more details.
#!#
#!# You should have received  a copy of the GNU General Public License  along with this program.  If
#!# not, see <http://www.gnu.org/licenses/>.
#!#


#### macros

MBFL_DEFINE_SPECIAL_MACROS


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)
mbfl_linker_source_library_by_stem(mmux-bash-packages)
mbfl_linker_source_library_by_stem(mmux-bash-pointers)


#### if_nameindex

function sockets-if_nameindex-1.1 () {
    mbfl_location_enter
    {
	declare -a ARRY

	dotest-unset-debug
	mbfl_location_leave_when_failure( mmux_libc_if_nameindex_to_array ARRY )
	mbfl_array_dump ARRY
	true
    }
    mbfl_location_leave
}


#### if_nametoindex

function sockets-if_nametoindex-1.1 () {
    mbfl_location_enter
    {
	declare INDEX

	dotest-unset-debug

	mbfl_location_leave_when_failure( mmux_libc_if_nametoindex INDEX 'lo' )
	dotest-equal 1 RR(INDEX)
    }
    mbfl_location_leave
}


#### if_indextoname

function sockets-if_indextoname-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NAME

	mbfl_location_leave_when_failure( mmux_libc_if_indextoname NAME '1' )
	dotest-debug NAME=WW(NAME)
	dotest-equal 'lo' WW(NAME)
    }
    mbfl_location_leave
}


#### htons

function sockets-htons-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri INPUT=16#1234
	declare -ri EXPECTED_OUPUT=16#3412
	declare OUPUT

	mbfl_location_leave_when_failure( mmux_libc_htons OUPUT RR(INPUT) )
	dotest-debug INPUT=WW(INPUT) OUPUT=WW(OUPUT)
	dotest-equal WW(EXPECTED_OUPUT) WW(OUPUT)
    }
    mbfl_location_leave
}


#### ntohs

function sockets-ntohs-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri INPUT=16#1234
	declare -ri EXPECTED_OUPUT=16#3412
	declare OUPUT

	mbfl_location_leave_when_failure( mmux_libc_ntohs OUPUT RR(INPUT) )
	dotest-debug INPUT=WW(INPUT) OUPUT=WW(OUPUT)
	dotest-equal WW(EXPECTED_OUPUT) WW(OUPUT)
    }
    mbfl_location_leave
}


#### htonl

function sockets-htonl-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri INPUT=16#12345678
	declare -ri EXPECTED_OUPUT=16#78563412
	declare OUPUT

	mbfl_location_leave_when_failure( mmux_libc_htonl OUPUT RR(INPUT) )
	dotest-debug INPUT=WW(INPUT) OUPUT=WW(OUPUT)
	dotest-equal WW(EXPECTED_OUPUT) WW(OUPUT)
    }
    mbfl_location_leave
}


#### ntohl

function sockets-ntohl-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri INPUT=16#12345678
	declare -ri EXPECTED_OUPUT=16#78563412
	declare OUPUT

	mbfl_location_leave_when_failure( mmux_libc_ntohl OUPUT RR(INPUT) )
	dotest-debug INPUT=WW(INPUT) OUPUT=WW(OUPUT)
	dotest-equal WW(EXPECTED_OUPUT) WW(OUPUT)
    }
    mbfl_location_leave
}


#### struct sockaddr_un

function sockets-struct-sockaddr_un-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r FAMILY=RR(mmux_libc_AF_LOCAL) PATHNAME='/tmp/sock.ext'
	declare SOCKADDR_UN SOCKADDR_UN_LENGTH SUN_FAMILY SUN_PATH

	mbfl_location_compensate( mmux_libc_sockaddr_un_calloc SOCKADDR_UN SOCKADDR_UN_LENGTH RR(FAMILY) WW(PATHNAME),
				  mmux_libc_free RR(SOCKADDR_UN) )
	mbfl_location_leave_when_failure( mmux_libc_sun_family_ref SUN_FAMILY RR(SOCKADDR_UN) )
	mbfl_location_leave_when_failure( mmux_libc_sun_path_ref   SUN_PATH   RR(SOCKADDR_UN) )

	dotest-debug SOCKADDR_UN_LENGTH=RR(SOCKADDR_UN_LENGTH)
	dotest-debug ,WW(SUN_FAMILY),WW(SUN_PATH), ${#SUN_PATH} ${#PATHNAME}

	mbfl_location_leave_when_failure( mmux_libc_sockaddr_un_dump RR(SOCKADDR_UN) )

	dotest-equal RR(FAMILY) WW(SUN_FAMILY) &&
	    dotest-equal WW(PATHNAME) WW(SUN_PATH)
    }
    mbfl_location_leave
}
function sockets-struct-sockaddr_un-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r FAMILY=RR(mmux_libc_AF_LOCAL) PATHNAME='/tmp/sock.ext'
	declare SOCKADDR_UN SOCKADDR_UN_LENGTH SUN_FAMILY SUN_PATH
	declare SA_FAMILY

	mbfl_location_compensate( mmux_libc_sockaddr_un_calloc SOCKADDR_UN SOCKADDR_UN_LENGTH RR(FAMILY) WW(PATHNAME),
				  mmux_libc_free RR(SOCKADDR_UN) )
	mbfl_location_leave_when_failure( mmux_libc_sun_family_ref SUN_FAMILY RR(SOCKADDR_UN) )
	mbfl_location_leave_when_failure( mmux_libc_sun_path_ref   SUN_PATH   RR(SOCKADDR_UN) )
	mbfl_location_leave_when_failure( mmux_libc_sa_family_ref  SA_FAMILY  RR(SOCKADDR_UN) )

	dotest-debug ,WW(SUN_FAMILY),WW(SUN_PATH), ${#SUN_PATH} ${#PATHNAME}

	dotest-equal RR(FAMILY) WW(SA_FAMILY) &&
	dotest-equal RR(FAMILY) WW(SUN_FAMILY) &&
	    dotest-equal WW(PATHNAME) WW(SUN_PATH)
    }
    mbfl_location_leave
}


#### struct sockaddr_in

function sockets-struct-sockaddr_in-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_SIN_ADDR='1.2.3.4'

	declare SOCKADDR_IN_POINTER
	declare -r INPUT_SIN_FAMILY=RR(mmux_libc_AF_INET)
	declare SIN_ADDR_POINTER
	declare -r INPUT_HOST_BYTEORDER_SIN_PORT=8080

	declare OUTPUT_SIN_FAMILY
	declare OUTPUT_HOST_BYTEORDER_SIN_ADDR
	declare OUTPUT_HOST_BYTEORDER_SIN_PORT
	declare OUTPUT_ASCII_SIN_ADDR

	dotest-debug INPUT_SIN_FAMILY=WW(INPUT_SIN_FAMILY)
	dotest-debug INPUT_HOST_BYTEORDER_SIN_PORT=WW(INPUT_HOST_BYTEORDER_SIN_PORT)

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN_POINTER \
							       RR(INPUT_SIN_FAMILY) \
							       IN_ADDR_POINTER \
							       RR(INPUT_HOST_BYTEORDER_SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(INPUT_ASCII_SIN_ADDR) RR(IN_ADDR_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_sin_family_ref OUTPUT_SIN_FAMILY              RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_addr_ref   OUTPUT_HOST_BYTEORDER_SIN_ADDR RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_port_ref   OUTPUT_HOST_BYTEORDER_SIN_PORT RR(SOCKADDR_IN_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_inet_ntop RR(mmux_libc_AF_INET) WW(IN_ADDR_POINTER) OUTPUT_ASCII_SIN_ADDR )

	dotest-debug OUTPUT_SIN_FAMILY=WW(OUTPUT_SIN_FAMILY)
	dotest-debug OUTPUT_ASCII_SIN_ADDR=WW(OUTPUT_ASCII_SIN_ADDR)
	dotest-debug OUTPUT_HOST_BYTEORDER_SIN_PORT=WW(OUTPUT_HOST_BYTEORDER_SIN_PORT)

	mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN_POINTER) >&2 )

	dotest-equal RR(INPUT_SIN_FAMILY) WW(OUTPUT_SIN_FAMILY) &&
	    dotest-equal RR(INPUT_ASCII_SIN_ADDR) RR(OUTPUT_ASCII_SIN_ADDR) &&
	    dotest-equal RR(INPUT_HOST_BYTEORDER_SIN_PORT) RR(OUTPUT_HOST_BYTEORDER_SIN_PORT)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_in-sin_family-1.1 () {
    declare SOCKADDR_IN_POINTER
    declare -r INPUT_SIN_FAMILY=RR(mmux_libc_AF_INET)
    declare    OUPUT_SIN_FAMILY

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_IN_POINTER 1 RR(mmux_libc_sockaddr_in_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_family_set RR(SOCKADDR_IN_POINTER) RR(INPUT_SIN_FAMILY) )
	mbfl_location_leave_when_failure( mmux_libc_sin_family_ref OUPUT_SIN_FAMILY        RR(SOCKADDR_IN_POINTER) )
	dotest-equal RR(INPUT_SIN_FAMILY) RR(OUPUT_SIN_FAMILY)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_in-sin_addr-1.1 () {
    declare SOCKADDR_IN_POINTER
    declare -r INPUT_SIN_ADDR=RR(mmux_libc_INADDR_LOOPBACK)
    declare    OUPUT_SIN_ADDR

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_IN_POINTER 1 RR(mmux_libc_sockaddr_in_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_addr_set RR(SOCKADDR_IN_POINTER) RR(INPUT_SIN_ADDR) )
	mbfl_location_leave_when_failure( mmux_libc_sin_addr_ref OUPUT_SIN_ADDR RR(SOCKADDR_IN_POINTER) )
	dotest-equal RR(INPUT_SIN_ADDR) RR(OUPUT_SIN_ADDR)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_in-sin_addr-pointer-1.1 () {
    declare SOCKADDR_IN_POINTER SIN_ADDR_POINTER
    declare -r INPUT_SIN_ADDR=RR(mmux_libc_INADDR_LOOPBACK)
    declare    OUPUT_SIN_ADDR

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_IN_POINTER 1 RR(mmux_libc_sockaddr_in_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_addr_pointer_ref SIN_ADDR_POINTER RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_uint32_pointer_set RR(SIN_ADDR_POINTER) 0 RR(INPUT_SIN_ADDR) )
	mbfl_location_leave_when_failure( mmux_uint32_pointer_ref OUPUT_SIN_ADDR RR(SIN_ADDR_POINTER) 0 )
	dotest-equal RR(INPUT_SIN_ADDR) RR(OUPUT_SIN_ADDR)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_in-sin_port-1.1 () {
    declare SOCKADDR_IN_POINTER
    declare -r INPUT_SIN_PORT=8080
    declare    OUPUT_SIN_PORT

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_IN_POINTER 1 RR(mmux_libc_sockaddr_in_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_IN_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sin_port_set RR(SOCKADDR_IN_POINTER) RR(INPUT_SIN_PORT) )
	mbfl_location_leave_when_failure( mmux_libc_sin_port_ref OUPUT_SIN_PORT        RR(SOCKADDR_IN_POINTER) )
	dotest-equal RR(INPUT_SIN_PORT) RR(OUPUT_SIN_PORT)
    }
    mbfl_location_leave
}


#### struct sockaddr_insix

function sockets-struct-sockaddr_insix-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_SINSIX_ADDR='1:2:3:4:5:6:7:8'

	declare SOCKADDR_INSIX

	declare -r INPUT_SINSIX_FAMILY=RR(mmux_libc_AF_INET6)
	declare SINSIX_ADDR_POINTER
	declare -r INPUT_HOST_BYTEORDER_SINSIX_FLOWINFO=0
	declare -r INPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID=0
	declare -r INPUT_HOST_BYTEORDER_SINSIX_PORT=8080

	declare OUTPUT_SINSIX_FAMILY
	declare OUTPUT_HOST_BYTEORDER_SINSIX_FLOWINFO
	declare OUTPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID
	declare OUTPUT_HOST_BYTEORDER_SINSIX_PORT

	dotest-debug INPUT_SINSIX_FAMILY=WW(INPUT_SINSIX_FAMILY)
	dotest-debug INPUT_HOST_BYTEORDER_SINSIX_FLOWINFO=WW(INPUT_HOST_BYTEORDER_SINSIX_FLOWINFO)
	dotest-debug INPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID=WW(INPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID)
	dotest-debug INPUT_HOST_BYTEORDER_SINSIX_PORT=WW(INPUT_HOST_BYTEORDER_SINSIX_PORT)

	mbfl_location_compensate( mmux_libc_sockaddr_insix_calloc SOCKADDR_INSIX \
								RR(INPUT_SINSIX_FAMILY) \
								SINSIX_ADDR_POINTER \
								RR(INPUT_HOST_BYTEORDER_SINSIX_FLOWINFO) \
								RR(INPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID) \
								RR(INPUT_HOST_BYTEORDER_SINSIX_PORT),
				  mmux_libc_free RR(SOCKADDR_INSIX) )
	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(INPUT_SINSIX_FAMILY) WW(INPUT_ASCII_SINSIX_ADDR) RR(SINSIX_ADDR_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_sinsix_family_ref   OUTPUT_SINSIX_FAMILY                  RR(SOCKADDR_INSIX) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntop         RR(INPUT_SINSIX_FAMILY) RR(SOCKADDR_INSIX) OUTPUT_ASCII_ADDR )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_flowinfo_ref OUTPUT_HOST_BYTEORDER_SINSIX_FLOWINFO RR(SOCKADDR_INSIX) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_scope_id_ref OUTPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID RR(SOCKADDR_INSIX) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_port_ref     OUTPUT_HOST_BYTEORDER_SINSIX_PORT     RR(SOCKADDR_INSIX) )

	mbfl_location_leave_when_failure( mmux_libc_sockaddr_insix_dump RR(SOCKADDR_INSIX) >&2 )

	dotest-debug OUTPUT_SINSIX_FAMILY=WW(OUTPUT_SINSIX_FAMILY)
	dotest-debug OUTPUT_ASCII_ADDR=WW(OUTPUT_ASCII_ADDR)
	dotest-debug OUTPUT_HOST_BYTEORDER_SINSIX_FLOWINFO=WW(OUTPUT_HOST_BYTEORDER_SINSIX_FLOWINFO)
	dotest-debug OUTPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID=WW(OUTPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID)
	dotest-debug OUTPUT_HOST_BYTEORDER_SINSIX_PORT=WW(OUTPUT_HOST_BYTEORDER_SINSIX_PORT)

	dotest-equal RR(INPUT_SINSIX_FAMILY) WW(OUTPUT_SINSIX_FAMILY) &&
	    dotest-equal RR(INPUT_HOST_BYTEORDER_SINSIX_FLOWINFO) RR(OUTPUT_HOST_BYTEORDER_SINSIX_FLOWINFO) &&
	    dotest-equal RR(INPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID) RR(OUTPUT_HOST_BYTEORDER_SINSIX_SCOPE_ID) &&
	    dotest-equal RR(INPUT_HOST_BYTEORDER_SINSIX_PORT) RR(OUTPUT_HOST_BYTEORDER_SINSIX_PORT)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_insix-sinsix_family-1.1 () {
    declare SOCKADDR_INSIX_POINTER
    declare -r INPUT_SINSIX_FAMILY=RR(mmux_libc_AF_INET)
    declare    OUPUT_SINSIX_FAMILY

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_INSIX_POINTER 1 RR(mmux_libc_sockaddr_insix_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_family_set RR(SOCKADDR_INSIX_POINTER) RR(INPUT_SINSIX_FAMILY) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_family_ref OUPUT_SINSIX_FAMILY        RR(SOCKADDR_INSIX_POINTER) )
	dotest-equal RR(INPUT_SINSIX_FAMILY) RR(OUPUT_SINSIX_FAMILY)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_insix-sinsix_addr-pointer-1.1 () {
    declare SOCKADDR_INSIX_POINTER SINSIX_ADDR_POINTER

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_INSIX_POINTER 1 RR(mmux_libc_sockaddr_insix_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_addr_pointer_ref SINSIX_ADDR_POINTER RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_memcpy RR(SINSIX_ADDR_POINTER) RR(mmux_libc_insixaddr_loopback_pointer) \
					  RR(mmux_libc_insix_addr_SIZEOF) )
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_insix-sinsix_flowinfo-1.1 () {
    declare SOCKADDR_INSIX_POINTER
    declare -r INPUT_SINSIX_FLOWINFO=0
    declare    OUPUT_SINSIX_FLOWINFO

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_INSIX_POINTER 1 RR(mmux_libc_sockaddr_insix_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_flowinfo_set RR(SOCKADDR_INSIX_POINTER) RR(INPUT_SINSIX_FLOWINFO) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_flowinfo_ref OUPUT_SINSIX_FLOWINFO RR(SOCKADDR_INSIX_POINTER) )
	dotest-equal RR(INPUT_SINSIX_FLOWINFO) RR(OUPUT_SINSIX_FLOWINFO)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_insix-sinsix_scope_id-1.1 () {
    declare SOCKADDR_INSIX_POINTER
    declare -r INPUT_SINSIX_SCOPE_ID=0
    declare    OUPUT_SINSIX_SCOPE_ID

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_INSIX_POINTER 1 RR(mmux_libc_sockaddr_insix_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_scope_id_set RR(SOCKADDR_INSIX_POINTER) RR(INPUT_SINSIX_SCOPE_ID) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_scope_id_ref OUPUT_SINSIX_SCOPE_ID RR(SOCKADDR_INSIX_POINTER) )
	dotest-equal RR(INPUT_SINSIX_SCOPE_ID) RR(OUPUT_SINSIX_SCOPE_ID)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-sockaddr_insix-sinsix_port-1.1 () {
    declare SOCKADDR_INSIX_POINTER
    declare -r INPUT_SINSIX_PORT=8080
    declare    OUPUT_SINSIX_PORT

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc SOCKADDR_INSIX_POINTER 1 RR(mmux_libc_sockaddr_insix_SIZEOF),
				  mmux_libc_free RR(SOCKADDR_INSIX_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_port_set RR(SOCKADDR_INSIX_POINTER) RR(INPUT_SINSIX_PORT) )
	mbfl_location_leave_when_failure( mmux_libc_sinsix_port_ref OUPUT_SINSIX_PORT        RR(SOCKADDR_INSIX_POINTER) )
	dotest-equal RR(INPUT_SINSIX_PORT) RR(OUPUT_SINSIX_PORT)
    }
    mbfl_location_leave
}


#### struct addrinfo: allocation and release

function sockets-struct-addrinfo-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ADDRINFO_PTR

	declare -A OUPUT
	declare -A INPUT=([AI_FLAGS]=$(( mmux_libc_AI_V4MAPPED | mmux_libc_AI_ADDRCONFIG ))
			  [AI_FAMILY]=RR(mmux_libc_AF_INET)
			  [AI_SOCKTYPE]=RR(mmux_libc_SOCK_STREAM)
			  [AI_PROTOCOL]=RR(mmux_libc_IPPROTO_TCP)
			  [AI_ADDRLEN]=0
			  [AI_ADDR]='0x0'
			  [AI_CANONNAME]=
			  [AI_NEXT]='0x0'
			  [ASCII_CANONNAME]='localhost')

	mbfl_location_compensate( mmux_pointer_from_bash_string INPUT[AI_CANONNAME] WW(INPUT,ASCII_CANONNAME),
				  mmux_libc_free RR(INPUT,AI_CANONNAME) )

	dotest-option-debug && mbfl_array_dump INPUT

	mbfl_location_compensate( mmux_libc_addrinfo_calloc ADDRINFO_PTR		\
							    WW(INPUT,AI_FLAGS)		\
							    WW(INPUT,AI_FAMILY)		\
							    WW(INPUT,AI_SOCKTYPE)	\
							    WW(INPUT,AI_PROTOCOL)	\
							    WW(INPUT,AI_ADDRLEN)	\
							    WW(INPUT,AI_ADDR)		\
							    WW(INPUT,AI_CANONNAME)	\
							    WW(INPUT,AI_NEXT),
				  mmux_libc_free RR(ADDRINFO_PTR) )

	mbfl_location_leave_when_failure( mmux_libc_ai_flags_ref	OUPUT[AI_FLAGS]	    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_family_ref	OUPUT[AI_FAMILY]    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_socktype_ref	OUPUT[AI_SOCKTYPE]  RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_protocol_ref	OUPUT[AI_PROTOCOL]  RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_ref	OUPUT[AI_ADDRLEN]   RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addr_ref		OUPUT[AI_ADDR]	    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_canonname_ref	OUPUT[AI_CANONNAME] RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_next_ref		OUPUT[AI_NEXT]	    RR(ADDRINFO_PTR) )

	mbfl_location_leave_when_failure( mmux_libc_addrinfo_dump RR(ADDRINFO_PTR) >&2 )

	dotest-debug WW(OUPUT,AI_CANONNAME)

	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string OUPUT[ASCII_CANONNAME] WW(OUPUT,AI_CANONNAME) )

	dotest-option-debug && mbfl_array_dump OUPUT

	dotest-equal     QQ(OUPUT,AI_FLAGS)     QQ(INPUT,AI_FLAGS) &&
	    dotest-equal QQ(OUPUT,AI_FAMILY)    QQ(INPUT,AI_FAMILY) &&
	    dotest-equal QQ(OUPUT,AI_SOCKTYPE)  QQ(INPUT,AI_SOCKTYPE) &&
	    dotest-equal QQ(OUPUT,AI_PROTOCOL)  QQ(INPUT,AI_PROTOCOL) &&
	    dotest-equal QQ(OUPUT,AI_ADDRLEN)   QQ(INPUT,AI_ADDRLEN) &&
	    dotest-equal QQ(OUPUT,AI_ADDR)      QQ(INPUT,AI_ADDR) &&
	    dotest-equal QQ(OUPUT,AI_CANONNAME) QQ(INPUT,AI_CANONNAME) &&
	    dotest-equal QQ(OUPUT,AI_NEXT)      QQ(INPUT,AI_NEXT)
    }
    mbfl_location_leave
}

# Let's write this in a way that can be copied in the documentation.
#
function sockets-struct-addrinfo-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ADDRINFO_PTR

	declare -A OUPUT
	declare -A INPUT=([AI_FLAGS]=$(( mmux_libc_AI_V4MAPPED | mmux_libc_AI_ADDRCONFIG ))
			  [AI_FAMILY]=RR(mmux_libc_AF_INET)
			  [AI_SOCKTYPE]=RR(mmux_libc_SOCK_STREAM)
			  [AI_PROTOCOL]=RR(mmux_libc_IPPROTO_TCP)
			  [AI_ADDRLEN]=0
			  [AI_ADDR]='0x0'
			  [AI_CANONNAME]=
			  [AI_NEXT]='0x0'
			  [ASCII_CANONNAME]='localhost')

	mbfl_location_compensate( mmux_pointer_from_bash_string INPUT[AI_CANONNAME] ${INPUT[ASCII_CANONNAME]},
				  mmux_libc_free RR(INPUT,AI_CANONNAME) )

	dotest-option-debug && mbfl_array_dump INPUT

	mbfl_location_compensate( mmux_libc_addrinfo_calloc ADDRINFO_PTR		\
							    ${INPUT[AI_FLAGS]}		\
							    ${INPUT[AI_FAMILY]}		\
							    ${INPUT[AI_SOCKTYPE]}	\
							    ${INPUT[AI_PROTOCOL]}	\
							    ${INPUT[AI_ADDRLEN]}	\
							    ${INPUT[AI_ADDR]}		\
							    ${INPUT[AI_CANONNAME]}	\
							    ${INPUT[AI_NEXT]},
				  mmux_libc_free RR(ADDRINFO_PTR) )

	mbfl_location_leave_when_failure( mmux_libc_ai_flags_ref	OUPUT[AI_FLAGS]	    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_family_ref	OUPUT[AI_FAMILY]    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_socktype_ref	OUPUT[AI_SOCKTYPE]  RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_protocol_ref	OUPUT[AI_PROTOCOL]  RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_ref	OUPUT[AI_ADDRLEN]   RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addr_ref		OUPUT[AI_ADDR]	    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_canonname_ref	OUPUT[AI_CANONNAME] RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_next_ref		OUPUT[AI_NEXT]	    RR(ADDRINFO_PTR) )

	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string OUPUT[ASCII_CANONNAME] ${OUPUT[AI_CANONNAME]} )

	dotest-option-debug && mbfl_array_dump OUPUT
	dotest-option-debug && mmux_libc_addrinfo_dump RR(ADDRINFO_PTR)

	dotest-equal     ${OUPUT[AI_FLAGS]}     ${INPUT[AI_FLAGS]} &&
	    dotest-equal ${OUPUT[AI_FAMILY]}    ${INPUT[AI_FAMILY]} &&
	    dotest-equal ${OUPUT[AI_SOCKTYPE]}  ${INPUT[AI_SOCKTYPE]} &&
	    dotest-equal ${OUPUT[AI_PROTOCOL]}  ${INPUT[AI_PROTOCOL]} &&
	    dotest-equal ${OUPUT[AI_ADDRLEN]}   ${INPUT[AI_ADDRLEN]} &&
	    dotest-equal ${OUPUT[AI_ADDR]}      ${INPUT[AI_ADDR]} &&
	    dotest-equal ${OUPUT[AI_CANONNAME]} ${INPUT[AI_CANONNAME]} &&
	    dotest-equal ${OUPUT[AI_NEXT]}      ${INPUT[AI_NEXT]}
    }
    mbfl_location_leave
}


#### struct addrinfo: setters and getters

function sockets-struct-addrinfo-ai_flags-1.1 () {
    declare ADDRINFO_POINTER
    declare -ri INPUT_AI_FLAGS=$(( mmux_libc_AI_V4MAPPED | mmux_libc_AI_ADDRCONFIG ))
    declare     OUPUT_AI_FLAGS

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_flags_set RR(ADDRINFO_POINTER) RR(INPUT_AI_FLAGS) )
	mbfl_location_leave_when_failure( mmux_libc_ai_flags_ref OUPUT_AI_FLAGS        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_FLAGS) RR(OUPUT_AI_FLAGS)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_family-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_FAMILY=RR(mmux_libc_AF_INET)
    declare    OUPUT_AI_FAMILY

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_family_set RR(ADDRINFO_POINTER) RR(INPUT_AI_FAMILY) )
	mbfl_location_leave_when_failure( mmux_libc_ai_family_ref OUPUT_AI_FAMILY        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_FAMILY) RR(OUPUT_AI_FAMILY)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_socktype-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_SOCKTYPE=RR(mmux_libc_SOCK_STREAM)
    declare    OUPUT_AI_SOCKTYPE

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_socktype_set RR(ADDRINFO_POINTER) RR(INPUT_AI_SOCKTYPE) )
	mbfl_location_leave_when_failure( mmux_libc_ai_socktype_ref OUPUT_AI_SOCKTYPE        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_SOCKTYPE) RR(OUPUT_AI_SOCKTYPE)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_protocol-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_PROTOCOL=0
    declare    OUPUT_AI_PROTOCOL

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_protocol_set RR(ADDRINFO_POINTER) RR(INPUT_AI_PROTOCOL) )
	mbfl_location_leave_when_failure( mmux_libc_ai_protocol_ref OUPUT_AI_PROTOCOL        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_PROTOCOL) RR(OUPUT_AI_PROTOCOL)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_addrlen-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_ADDRLEN=RR(mmux_libc_sockaddr_in_SIZEOF)
    declare    OUPUT_AI_ADDRLEN

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_set RR(ADDRINFO_POINTER) RR(INPUT_AI_ADDRLEN) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_ref OUPUT_AI_ADDRLEN RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_ADDRLEN) RR(OUPUT_AI_ADDRLEN)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_addr-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_ADDR='0x0'
    declare    OUPUT_AI_ADDR

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addr_set RR(ADDRINFO_POINTER) RR(INPUT_AI_ADDR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addr_ref OUPUT_AI_ADDR        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_ADDR) RR(OUPUT_AI_ADDR)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_canonname-1.1 () {
    declare ADDRINFO_POINTER

    declare -r INPUT_ASCII_CANONNAME='ciao.ciao'
    declare    OUPUT_ASCII_CANONNAME

    declare INPUT_AI_CANONNAME
    declare OUPUT_AI_CANONNAME

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_compensate( mmux_pointer_from_bash_string INPUT_AI_CANONNAME WW(INPUT_ASCII_CANONNAME),
				  mmux_libc_free RR(INPUT_AI_CANONNAME) )
	mbfl_location_leave_when_failure( mmux_libc_ai_canonname_set RR(ADDRINFO_POINTER) RR(INPUT_AI_CANONNAME) )
	mbfl_location_leave_when_failure( mmux_libc_ai_canonname_ref OUPUT_AI_CANONNAME RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string OUPUT_ASCII_CANONNAME WW(OUPUT_AI_CANONNAME) )
	dotest-equal RR(INPUT_AI_CANONNAME) RR(OUPUT_AI_CANONNAME) &&
	    dotest-equal RR(INPUT_AI_CANONNAME) RR(OUPUT_AI_CANONNAME)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-ai_next-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_NEXT='0x0'
    declare    OUPUT_AI_NEXT

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_next_set RR(ADDRINFO_POINTER) RR(INPUT_AI_NEXT) )
	mbfl_location_leave_when_failure( mmux_libc_ai_next_ref OUPUT_AI_NEXT        RR(ADDRINFO_POINTER) )
	dotest-equal RR(INPUT_AI_NEXT) RR(OUPUT_AI_NEXT)
    }
    mbfl_location_leave
}


#### struct addrinfo: setters and printers

function sockets-struct-addrinfo-printer-ai_flags-1.1 () {
    declare ADDRINFO_POINTER
    declare -ri INPUT_AI_FLAGS=$(( mmux_libc_AI_V4MAPPED | mmux_libc_AI_ADDRCONFIG ))
    declare     OUPUT_AI_FLAGS

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_flags_set RR(ADDRINFO_POINTER) RR(INPUT_AI_FLAGS) )
	mbfl_location_leave_when_failure( OUPUT_AI_FLAGS=$( mmux_libc_ai_flags_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_FLAGS) RR(OUPUT_AI_FLAGS)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_family-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_FAMILY=RR(mmux_libc_AF_INET)
    declare    OUPUT_AI_FAMILY

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_family_set RR(ADDRINFO_POINTER) RR(INPUT_AI_FAMILY) )
	mbfl_location_leave_when_failure( OUPUT_AI_FAMILY=$( mmux_libc_ai_family_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_FAMILY) RR(OUPUT_AI_FAMILY)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_socktype-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_SOCKTYPE=RR(mmux_libc_SOCK_STREAM)
    declare    OUPUT_AI_SOCKTYPE

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_socktype_set RR(ADDRINFO_POINTER) RR(INPUT_AI_SOCKTYPE) )
	mbfl_location_leave_when_failure( OUPUT_AI_SOCKTYPE=$( mmux_libc_ai_socktype_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_SOCKTYPE) RR(OUPUT_AI_SOCKTYPE)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_protocol-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_PROTOCOL=0
    declare    OUPUT_AI_PROTOCOL

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_protocol_set RR(ADDRINFO_POINTER) RR(INPUT_AI_PROTOCOL) )
	mbfl_location_leave_when_failure( OUPUT_AI_PROTOCOL=$( mmux_libc_ai_protocol_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_PROTOCOL) RR(OUPUT_AI_PROTOCOL)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_addrlen-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_ADDRLEN=RR(mmux_libc_sockaddr_in_SIZEOF)
    declare    OUPUT_AI_ADDRLEN

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_set RR(ADDRINFO_POINTER) RR(INPUT_AI_ADDRLEN) )
	mbfl_location_leave_when_failure( OUPUT_AI_ADDRLEN=$( mmux_libc_ai_addrlen_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_ADDRLEN) RR(OUPUT_AI_ADDRLEN)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_addr-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_ADDR='0x0'
    declare    OUPUT_AI_ADDR

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addr_set RR(ADDRINFO_POINTER) RR(INPUT_AI_ADDR) )
	mbfl_location_leave_when_failure( OUPUT_AI_ADDR=$( mmux_libc_ai_addr_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_ADDR) RR(OUPUT_AI_ADDR)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_canonname-1.1 () {
    declare ADDRINFO_POINTER

    declare -r INPUT_ASCII_CANONNAME='ciao.ciao'
    declare    OUPUT_ASCII_CANONNAME

    declare INPUT_AI_CANONNAME
    declare OUPUT_AI_CANONNAME

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_compensate( mmux_pointer_from_bash_string INPUT_AI_CANONNAME WW(INPUT_ASCII_CANONNAME),
				  mmux_libc_free RR(INPUT_AI_CANONNAME) )
	mbfl_location_leave_when_failure( mmux_libc_ai_canonname_set RR(ADDRINFO_POINTER) RR(INPUT_AI_CANONNAME) )
	mbfl_location_leave_when_failure( OUPUT_AI_CANONNAME=$( mmux_libc_ai_canonname_print RR(ADDRINFO_POINTER) ) )
	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string OUPUT_ASCII_CANONNAME WW(OUPUT_AI_CANONNAME) )
	dotest-equal RR(INPUT_AI_CANONNAME) RR(OUPUT_AI_CANONNAME) &&
	    dotest-equal RR(INPUT_AI_CANONNAME) RR(OUPUT_AI_CANONNAME)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-struct-addrinfo-printer-ai_next-1.1 () {
    declare ADDRINFO_POINTER
    declare -r INPUT_AI_NEXT='0x0'
    declare    OUPUT_AI_NEXT

    mbfl_location_enter
    {
	mbfl_location_compensate( mmux_libc_calloc ADDRINFO_POINTER 1 RR(mmux_libc_addrinfo_SIZEOF),
				  mmux_libc_free RR(ADDRINFO_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_ai_next_set RR(ADDRINFO_POINTER) RR(INPUT_AI_NEXT) )
	mbfl_location_leave_when_failure( OUPUT_AI_NEXT=$( mmux_libc_ai_next_print RR(ADDRINFO_POINTER) ) )
	dotest-equal RR(INPUT_AI_NEXT) RR(OUPUT_AI_NEXT)
    }
    mbfl_location_leave
}


#### inet_aton, inet_ntoa

function sockets-inet_aton-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r ASCII_ADDR='127.0.0.1'
	declare UINT32_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_aton UINT32_ADDR WW(ASCII_ADDR) )

	dotest-debug WW(UINT32_ADDR)
	dotest-predicate mmux_string_is_uint32 WW(UINT32_ADDR)
    }
    mbfl_location_leave
}
function sockets-inet_ntoa-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_ADDR='127.0.0.1'
	declare UINT32_ADDR OUTPUT_ASCII_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_aton UINT32_ADDR WW(INPUT_ASCII_ADDR) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntoa OUTPUT_ASCII_ADDR RR(UINT32_ADDR) )

	dotest-debug WW(UINT32_ADDR) WW(OUTPUT_ASCII_ADDR)
	if dotest-option-debug
	then printf '%x\n' WW(UINT32_ADDR) >&2
	fi
	dotest-equal WW(INPUT_ASCII_ADDR) WW(OUTPUT_ASCII_ADDR)
    }
    mbfl_location_leave
}


#### inet_addr

function sockets-inet_addr-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_ADDR='127.0.0.1'
	declare UINT32_ADDR OUTPUT_ASCII_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_addr UINT32_ADDR WW(INPUT_ASCII_ADDR) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntoa OUTPUT_ASCII_ADDR RR(UINT32_ADDR) )

	dotest-debug UINT32_ADDR=WW(UINT32_ADDR) OUTPUT_ASCII_ADDR=WW(OUTPUT_ASCII_ADDR) UINT32_ADDR_HEX=$(printf '%x\n' WW(UINT32_ADDR))
	dotest-equal WW(INPUT_ASCII_ADDR) WW(OUTPUT_ASCII_ADDR)
    }
    mbfl_location_leave
}

# Invalid input: detect false exit status.
#
function sockets-inet_addr-2.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_ADDR='ciao'
	declare UINT32_ADDR

	! mmux_libc_inet_addr UINT32_ADDR WW(INPUT_ASCII_ADDR)
    }
    mbfl_location_leave
}


#### inet_network

function sockets-inet_network-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r INPUT_ASCII_ADDR='1.2.3.4'
	declare UINT32_ADDR OUTPUT_ASCII_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_network UINT32_ADDR WW(INPUT_ASCII_ADDR) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntoa OUTPUT_ASCII_ADDR RR(UINT32_ADDR) )

	dotest-debug UINT32_ADDR=WW(UINT32_ADDR) OUTPUT_ASCII_ADDR=WW(OUTPUT_ASCII_ADDR) UINT32_ADDR_HEX=$(printf '%x\n' WW(UINT32_ADDR))
	dotest-equal '4.3.2.1' WW(OUTPUT_ASCII_ADDR)
    }
    mbfl_location_leave
}


#### inet_makeaddr

function sockets-inet_makeaddr-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri UINT32_NET_ADDR='16#FFFFFF00'
	declare -ri UINT32_LOCAL_ADDR='16#00000012'
	declare -ri EXPECTED_UINT32_ADDR='16#12FFFFFF'
	declare UINT32_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_makeaddr UINT32_ADDR RR(UINT32_NET_ADDR) RR(UINT32_LOCAL_ADDR) )

	dotest-debug UINT32_ADDR=WW(UINT32_ADDR) UINT32_ADDR_HEX=$(printf '%x\n' WW(UINT32_ADDR))
	dotest-equal WW(EXPECTED_UINT32_ADDR) WW(UINT32_ADDR)
    }
    mbfl_location_leave
}


#### inet_lnaof

function sockets-inet_lnaof-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri UINT32_ADDR='16#12FFFFFF'
	declare -ri EXPECTED_UINT32_LOCAL_ADDR='16#12'
	declare -i UINT32_LOCAL_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_lnaof UINT32_LOCAL_ADDR WW(UINT32_ADDR) )

	dotest-debug UINT32_LOCAL_ADDR=WW(UINT32_LOCAL_ADDR) UINT32_LOCAL_ADDR_HEX=$(printf '%x\n' WW(UINT32_LOCAL_ADDR))
	dotest-equal WW(EXPECTED_UINT32_LOCAL_ADDR) WW(UINT32_LOCAL_ADDR)
    }
    mbfl_location_leave
}


#### inet_pton

function sockets-inet_pton-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r AF_TYPE=RR(mmux_libc_AF_INET)
	declare -r INPUT_ASCII_IN_ADDR='127.0.0.1'
	declare IN_ADDR_POINTER
	declare -i UINT32_ADDR
	declare OUTPUT_ASCII_IN_ADDR

	mbfl_location_compensate( mmux_libc_calloc IN_ADDR_POINTER 1 RR(mmux_libc_in_addr_SIZEOF),
				  mmux_libc_free RR(IN_ADDR_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(AF_TYPE) WW(INPUT_ASCII_IN_ADDR) RR(IN_ADDR_POINTER) )
	mbfl_location_leave_when_failure( mmux_uint32_pointer_ref UINT32_ADDR RR(IN_ADDR_POINTER) 0 )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntoa OUTPUT_ASCII_IN_ADDR RR(UINT32_ADDR) )

	dotest-debug UINT32_ADDR=WW(UINT32_ADDR) OUTPUT_ASCII_IN_ADDR=WW(OUTPUT_ASCII_IN_ADDR)
	dotest-equal WW(INPUT_ASCII_IN_ADDR) WW(OUTPUT_ASCII_IN_ADDR)
    }
    mbfl_location_leave
}
function sockets-inet_pton-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r AF_TYPE=RR(mmux_libc_AF_INET)
	declare -r INPUT_ASCII_IN_ADDR='127.0.0.1'
	declare IN_ADDR_POINTER
	declare OUTPUT_ASCII_IN_ADDR

	mbfl_location_compensate( mmux_libc_calloc IN_ADDR_POINTER 1 RR(mmux_libc_in_addr_SIZEOF),
				  mmux_libc_free RR(IN_ADDR_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(AF_TYPE) WW(INPUT_ASCII_IN_ADDR) RR(IN_ADDR_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntop RR(AF_TYPE) RR(IN_ADDR_POINTER) OUTPUT_ASCII_IN_ADDR )

	dotest-debug OUTPUT_ASCII_IN_ADDR=WW(OUTPUT_ASCII_IN_ADDR)
	dotest-equal WW(INPUT_ASCII_IN_ADDR) WW(OUTPUT_ASCII_IN_ADDR)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-inet_pton-2.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r AF_TYPE=RR(mmux_libc_AF_INET6)
	declare -r INPUT_ASCII_INSIX_ADDR='1:2:3:4:5:6:7:8'
	declare INSIX_ADDR_POINTER
	declare OUTPUT_ASCII_INSIX_ADDR

	mbfl_location_compensate( mmux_libc_calloc INSIX_ADDR_POINTER 1 RR(mmux_libc_insix_addr_SIZEOF),
				  mmux_libc_free RR(INSIX_ADDR_POINTER) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(AF_TYPE) WW(INPUT_ASCII_INSIX_ADDR) RR(INSIX_ADDR_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_inet_ntop RR(AF_TYPE) RR(INSIX_ADDR_POINTER) OUTPUT_ASCII_INSIX_ADDR )

	dotest-debug OUTPUT_ASCII_INSIX_ADDR=WW(OUTPUT_ASCII_INSIX_ADDR)
	dotest-equal WW(INPUT_ASCII_INSIX_ADDR) WW(OUTPUT_ASCII_INSIX_ADDR)
    }
    mbfl_location_leave
}


#### inet_netof

function sockets-inet_netof-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -ri UINT32_ADDR='16#12FFFFFF'
	declare -ri EXPECTED_UINT32_NET_ADDR='16#FFFFFF'
	declare -i UINT32_NET_ADDR

	mbfl_location_leave_when_failure( mmux_libc_inet_netof UINT32_NET_ADDR WW(UINT32_ADDR) )

	dotest-debug UINT32_NET_ADDR=WW(UINT32_NET_ADDR) UINT32_NET_ADDR_HEX=$(printf '%x\n' WW(UINT32_NET_ADDR))
	dotest-equal WW(EXPECTED_UINT32_NET_ADDR) WW(UINT32_NET_ADDR)
    }
    mbfl_location_leave
}


#### getsockopt

function sockets-getsockopt-sint-SO_BROADCAST-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_BROADCAST) )

	dotest-debug 'OPTVAL[SO_BROADCAST]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_DEBUG-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DEBUG) )

	dotest-debug 'OPTVAL[SO_DEBUG]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_DONTROUTE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DONTROUTE) )

	dotest-debug 'OPTVAL[SO_DONTROUTE]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_ERROR-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_ERROR) )

	dotest-debug 'OPTVAL[SO_ERROR]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_KEEPALIVE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_KEEPALIVE) )

	dotest-debug 'OPTVAL[SO_KEEPALIVE]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_OOBINLINE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_OOBINLINE) )

	dotest-debug 'OPTVAL[SO_OOBINLINE]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_REUSEADDR-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_REUSEADDR) )

	dotest-debug 'OPTVAL[SO_REUSEADDR]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_TYPE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_TYPE) )

	dotest-debug 'OPTVAL[SO_TYPE]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-sint-SO_STYLE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_STYLE) )

	dotest-debug 'OPTVAL[SO_STYLE]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_sint WW(OPTVAL)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getsockopt-usize-SO_SNDBUF-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_SNDBUF) )

	dotest-debug 'OPTVAL[SO_SNDBUF]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_usize WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-getsockopt-usize-SO_RCVBUF-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_RCVBUF) )

	dotest-debug 'OPTVAL[SO_RCVBUF]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_usize WW(OPTVAL)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getsockopt-SO_LINGER-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD
	declare -A OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_LINGER) )

	#mbfl_array_dump OPTVAL
	dotest-debug 'OPTVAL[ONOFF]'=WW(OPTVAL, ONOFF)
	dotest-debug 'OPTVAL[LINGER]'=WW(OPTVAL, LINGER)
	dotest-predicate mmux_string_is_sint WW(OPTVAL, ONOFF) &&
	    dotest-predicate mmux_string_is_sint WW(OPTVAL, LINGER)
    }
    mbfl_location_leave
}


#### setsockopt

function sockets-setsockopt-sint-SO_BROADCAST-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_BROADCAST) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_BROADCAST) )

	dotest-debug 'OPTVAL[SO_BROADCAST]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}
# NOTE It appears setting SO_DEBUG requires special privileges, so it will not work here.  I admit I
# have never tried it.  (Marco Maggi; Nov 20, 2024)
function disabled-sockets-setsockopt-sint-SO_DEBUG-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	dotest-debug setting
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DEBUG) 1 )
	dotest-debug setted, getting
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DEBUG) )
	dotest-debug getted

	dotest-debug 'OPTVAL[SO_DEBUG]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-setsockopt-sint-SO_DONTROUTE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DONTROUTE) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_DONTROUTE) )

	dotest-debug 'OPTVAL[SO_DONTROUTE]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-setsockopt-sint-SO_KEEPALIVE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_KEEPALIVE) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_KEEPALIVE) )

	dotest-debug 'OPTVAL[SO_KEEPALIVE]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-setsockopt-sint-SO_OOBINLINE-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_OOBINLINE) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_OOBINLINE) )

	dotest-debug 'OPTVAL[SO_OOBINLINE]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}
function sockets-setsockopt-sint-SO_REUSEADDR-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_REUSEADDR) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_REUSEADDR) )

	dotest-debug 'OPTVAL[SO_REUSEADDR]'=WW(OPTVAL)
	dotest-equal 1 WW(OPTVAL)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

# NOTE Apparently: setting the option SO_SNDBUF is just a suggestion, not an order.  The system does
# what it wants.  (Marco Maggi; Nov 20, 2024)
function sockets-setsockopt-usize-SO_SNDBUF-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_SNDBUF) 4096 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_SNDBUF) )

	dotest-debug 'OPTVAL[SO_SNDBUF]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_usize WW(OPTVAL)
    }
    mbfl_location_leave
}
# NOTE Apparently: setting the option SO_RCVBUF is just a suggestion, not an order.  The system does
# what it wants.  (Marco Maggi; Nov 20, 2024)
function sockets-setsockopt-usize-SO_RCVBUF-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_RCVBUF) 1 )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_RCVBUF) )

	dotest-debug 'OPTVAL[SO_RCVBUF]'=WW(OPTVAL)
	dotest-predicate mmux_string_is_usize WW(OPTVAL)
    }
    mbfl_location_leave
}
### ------------------------------------------------------------------------

function sockets-setsockopt-SO_LINGER-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD
	declare -Ar SETTER_OPTVAL=([ONOFF]=1 [LINGER]=123)
	declare -A  GETTER_OPTVAL

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) 0,
				  mmux_libc_close RR(SOCKFD) )
	#mbfl_array_dump SETTER_OPTVAL

	mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_LINGER) SETTER_OPTVAL )
	mbfl_location_leave_when_failure( mmux_libc_getsockopt GETTER_OPTVAL RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_LINGER) )

	#mbfl_array_dump GETTER_OPTVAL
	dotest-debug 'GETTER_OPTVAL[ONOFF]'=WW(GETTER_OPTVAL, ONOFF)
	dotest-debug 'GETTER_OPTVAL[LINGER]'=WW(GETTER_OPTVAL, LINGER)

	dotest-equal     WW(SETTER_OPTVAL, ONOFF)  WW(GETTER_OPTVAL, ONOFF) &&
	    dotest-equal WW(SETTER_OPTVAL, LINGER) WW(GETTER_OPTVAL, LINGER)
    }
    mbfl_location_leave
}


#### getaddrinfo

function sockets-getaddrinfo-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare GAI_ERRNUM GAI_ERRMSG
	declare  HINTS_ADDRINFO_PTR ADDRINFO_LINKED_LIST_PTR ADDRINFO_PTR
	declare -r ASCII_CANONNAME='localhost'
	declare -r ASCII_SERVICE='smtp'
	declare AI_CANONNAME_PTR AI_CANONNAME_STRING

	mbfl_location_compensate( mmux_libc_addrinfo_calloc HINTS_ADDRINFO_PTR,
				  mmux_libc_free         RR(HINTS_ADDRINFO_PTR) )
	{
	    declare -r HINTS_AI_FLAGS=$(( RR(mmux_libc_AI_V4MAPPED) | RR(mmux_libc_AI_ADDRCONFIG) | RR(mmux_libc_AI_CANONNAME) ))

	    mbfl_location_leave_when_failure( mmux_libc_ai_flags_set     RR(HINTS_ADDRINFO_PTR) RR(HINTS_AI_FLAGS) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_family_set    RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_AF_UNSPEC) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_socktype_set  RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_SOCK_STREAM) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_protocol_set  RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_IPPROTO_TCP) )
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_addrinfo_dump RR(HINTS_ADDRINFO_PTR) 'hints' >&2 )
	}

	mbfl_location_compensate( mmux_libc_getaddrinfo WW(ASCII_CANONNAME) QQ(ASCII_SERVICE) RR(HINTS_ADDRINFO_PTR) \
							ADDRINFO_LINKED_LIST_PTR,
				  mmux_libc_freeaddrinfo RR(ADDRINFO_LINKED_LIST_PTR) )

	ADDRINFO_PTR=RR(ADDRINFO_LINKED_LIST_PTR)
	until mmux_pointer_is_zero RR(ADDRINFO_PTR)
	do
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_addrinfo_dump RR(ADDRINFO_PTR) >&2 )

	    # We put this here because we loop until ADDRINFO_PTR is NULL.
	    mbfl_location_leave_when_failure( mmux_libc_ai_canonname_ref AI_CANONNAME_PTR RR(ADDRINFO_PTR) )
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string AI_CANONNAME_STRING WW(AI_CANONNAME_PTR) )

	    mbfl_location_leave_when_failure( mmux_libc_ai_next_ref ADDRINFO_PTR RR(ADDRINFO_PTR) )
	done

	dotest-debug WW(ASCII_CANONNAME) WW(AI_CANONNAME_STRING)
	dotest-equal WW(ASCII_CANONNAME) WW(AI_CANONNAME_STRING)
    }
    mbfl_location_leave
}


#### getnameinfo

function sockets-getnameinfo-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare GAI_ERRNUM GAI_ERRMSG
	declare  HINTS_ADDRINFO_PTR ADDRINFO_LINKED_LIST_PTR ADDRINFO_PTR
	declare -r ASCII_CANONNAME='localhost'
	declare -r ASCII_SERVICE='smtp'
	declare AI_CANONNAME_PTR AI_CANONNAME_STRING
	declare AI_ADDR AI_ADDRLEN
	declare HOST_STR SERV_STR

	mbfl_location_compensate( mmux_libc_addrinfo_calloc HINTS_ADDRINFO_PTR,
				  mmux_libc_free         RR(HINTS_ADDRINFO_PTR) )
	{
	    declare -r HINTS_AI_FLAGS=$(( RR(mmux_libc_AI_V4MAPPED) | RR(mmux_libc_AI_ADDRCONFIG) | RR(mmux_libc_AI_CANONNAME) ))

	    mbfl_location_leave_when_failure( mmux_libc_ai_flags_set     RR(HINTS_ADDRINFO_PTR) RR(HINTS_AI_FLAGS) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_family_set    RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_AF_INET) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_socktype_set  RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_SOCK_STREAM) )
	    mbfl_location_leave_when_failure( mmux_libc_ai_protocol_set  RR(HINTS_ADDRINFO_PTR) RR(mmux_libc_IPPROTO_TCP) )
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_addrinfo_dump RR(HINTS_ADDRINFO_PTR) 'hints' >&2 )
	}

	mbfl_location_compensate( mmux_libc_getaddrinfo WW(ASCII_CANONNAME) QQ(ASCII_SERVICE) RR(HINTS_ADDRINFO_PTR) \
							ADDRINFO_LINKED_LIST_PTR,
				  mmux_libc_freeaddrinfo RR(ADDRINFO_LINKED_LIST_PTR) )

	ADDRINFO_PTR=RR(ADDRINFO_LINKED_LIST_PTR)

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_addrinfo_dump RR(HINTS_ADDRINFO_PTR) >&2 )

	mbfl_location_leave_when_failure( mmux_libc_ai_addr_ref    AI_ADDR    RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_ai_addrlen_ref AI_ADDRLEN RR(ADDRINFO_PTR) )
	mbfl_location_leave_when_failure( mmux_libc_getnameinfo RR(AI_ADDR) RR(AI_ADDRLEN) HOST_STR SERV_STR 0 )

	dotest-debug HOST=WW(HOST_STR) SERV=WW(SERV_STR)
	dotest-equal WW(ASCII_CANONNAME) WW(HOST_STR)
    }
    mbfl_location_leave
}


#### hosts database

function sockets-gethostent-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare HOSTENT_PTR
	declare -i IDX=0

	mbfl_location_compensate( mmux_libc_sethostent 0,
				  mmux_libc_endhostent )

	mbfl_location_leave_when_failure( mmux_libc_gethostent HOSTENT_PTR )

	until mmux_pointer_is_zero RR(HOSTENT_PTR)
	do
	    if dotest-option-debug
	    then
		{
		    mmux_libc_hostent_dump RR(HOSTENT_PTR) "hostent[$IDX]"
		    echo
		} >&2
	    fi
	    mbfl_location_leave_when_failure( mmux_libc_gethostent HOSTENT_PTR )
	    let ++IDX
	done

	true
    }
    mbfl_location_leave
}


#### services database

function sockets-getservent-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR
	declare -i IDX=0

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )

	until mmux_pointer_is_zero RR(SERVENT_PTR)
	do
	    if dotest-option-debug
	    then
		{
		    mmux_libc_servent_dump RR(SERVENT_PTR) "servent[$IDX]"
		    echo
		} >&2
	    fi
	    mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	    let ++IDX
	done

	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getservbyname-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR

	mbfl_location_leave_when_failure( mmux_libc_getservbyname SERVENT_PTR 'smtp' 'tcp' )

	if mmux_pointer_is_positive RR(SERVENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_servent_dump RR(SERVENT_PTR) >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}
function sockets-getservbyname-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR

	mbfl_location_leave_when_failure( mmux_libc_getservbyname SERVENT_PTR 'smtp' )

	if mmux_pointer_is_positive RR(SERVENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_servent_dump RR(SERVENT_PTR) >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getservbyport-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR
	declare -i HOST_BYTEORDER_PORT=25
	declare -i NETWORK_BYTEORDER_PORT

	mbfl_location_leave_when_failure( mmux_libc_htons NETWORK_BYTEORDER_PORT RR(HOST_BYTEORDER_PORT) )
	mbfl_location_leave_when_failure( mmux_libc_getservbyport SERVENT_PTR RR(NETWORK_BYTEORDER_PORT) 'tcp' )

	if mmux_pointer_is_positive RR(SERVENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_servent_dump RR(SERVENT_PTR) "servent[$IDX]" >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}
function sockets-getservbyport-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR
	declare -i HOST_BYTEORDER_PORT=25
	declare -i NETWORK_BYTEORDER_PORT

	mbfl_location_leave_when_failure( mmux_libc_htons NETWORK_BYTEORDER_PORT RR(HOST_BYTEORDER_PORT) )
	mbfl_location_leave_when_failure( mmux_libc_getservbyport SERVENT_PTR RR(NETWORK_BYTEORDER_PORT) )

	if mmux_pointer_is_positive RR(SERVENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_servent_dump RR(SERVENT_PTR) "servent[$IDX]" >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-servent-s_name-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR S_NAME

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_s_name_ref S_NAME RR(SERVENT_PTR) )

	dotest-debug S_NAME=WW(S_NAME)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-servent-s_aliases-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR S_ALIASES

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_s_aliases_ref S_ALIASES RR(SERVENT_PTR) )

	dotest-debug S_ALIASES=WW(S_ALIASES)

	if mmux_pointer_is_positive RR(S_ALIASES)
	then
	    declare ALIAS_PTR ALIAS_STR
	    declare -i IDX=0

	    mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(S_ALIASES) RR(IDX) )
	    dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    until mmux_pointer_is_zero RR(ALIAS_PTR)
	    do
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string ALIAS_STR RR(ALIAS_PTR) )
		dotest-debug ALIAS_STR=WW(ALIAS_STR)
		let ++IDX
		mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(S_ALIASES) RR(IDX) )
		dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    done
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-servent-s_port-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR S_PORT

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_s_port_ref S_PORT RR(SERVENT_PTR) )

	dotest-debug S_PORT=WW(S_PORT)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-servent-s_proto-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR S_PROTO

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_s_proto_ref S_PROTO RR(SERVENT_PTR) )

	dotest-debug S_PROTO=WW(S_PROTO)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-servent-dump-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SERVENT_PTR

	mbfl_location_compensate( mmux_libc_setservent 0,
				  mmux_libc_endservent )

	mbfl_location_leave_when_failure( mmux_libc_getservent SERVENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_servent_dump RR(SERVENT_PTR) )
    }
    mbfl_location_leave
}


#### protocols database

function sockets-getprotoent-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR
	declare -i IDX=0

	mbfl_location_compensate( mmux_libc_setprotoent 0,
				  mmux_libc_endprotoent )

	mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )

	until mmux_pointer_is_zero RR(PROTOENT_PTR)
	do
	    if dotest-option-debug
	    then
		{
		    mmux_libc_protoent_dump RR(PROTOENT_PTR) "protoent[$IDX]"
		    echo
		} >&2
	    fi
	    mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )
	    let ++IDX
	done

	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getprotobyname-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR

	mbfl_location_leave_when_failure( mmux_libc_getprotobyname PROTOENT_PTR 'tcp' )

	if mmux_pointer_is_positive RR(PROTOENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_protoent_dump RR(PROTOENT_PTR) >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getprotobynumber-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR

	mbfl_location_leave_when_failure( mmux_libc_getprotobynumber PROTOENT_PTR RR(mmux_libc_IPPROTO_TCP) )

	if mmux_pointer_is_positive RR(PROTOENT_PTR)
	then
	    if dotest-option-debug
	    then mmux_libc_protoent_dump RR(PROTOENT_PTR) >&2
	    fi
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-protoent-p_name-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR S_NAME

	mbfl_location_compensate( mmux_libc_setprotoent 0,
				  mmux_libc_endprotoent )

	mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_p_name_ref S_NAME RR(PROTOENT_PTR) )

	dotest-debug S_NAME=WW(S_NAME)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-protoent-p_aliases-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR S_ALIASES

	mbfl_location_compensate( mmux_libc_setprotoent 0,
				  mmux_libc_endprotoent )

	mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_p_aliases_ref S_ALIASES RR(PROTOENT_PTR) )

	dotest-debug S_ALIASES=WW(S_ALIASES)

	if mmux_pointer_is_positive RR(S_ALIASES)
	then
	    declare ALIAS_PTR ALIAS_STR
	    declare -i IDX=0

	    mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(S_ALIASES) RR(IDX) )
	    dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    until mmux_pointer_is_zero RR(ALIAS_PTR)
	    do
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string ALIAS_STR RR(ALIAS_PTR) )
		dotest-debug ALIAS_STR=WW(ALIAS_STR)
		let ++IDX
		mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(S_ALIASES) RR(IDX) )
		dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    done
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-protoent-p_proto-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR S_PROTO

	mbfl_location_compensate( mmux_libc_setprotoent 0,
				  mmux_libc_endprotoent )

	mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_p_proto_ref S_PROTO RR(PROTOENT_PTR) )

	dotest-debug S_PROTO=WW(S_PROTO)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-protoent-dump-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare PROTOENT_PTR

	mbfl_location_compensate( mmux_libc_setprotoent 0,
				  mmux_libc_endprotoent )

	mbfl_location_leave_when_failure( mmux_libc_getprotoent PROTOENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_protoent_dump RR(PROTOENT_PTR) )
    }
    mbfl_location_leave
}


#### networks database

function sockets-getnetent-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR
	declare -i IDX=0

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )

	until mmux_pointer_is_zero RR(NETENT_PTR)
	do
	    if dotest-option-debug
	    then
		{
		    mmux_libc_netent_dump RR(NETENT_PTR) "netent[$IDX]"
		    echo
		} >&2
	    fi
	    mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	    let ++IDX
	done

	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getnetbyname-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR N_NAME

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_name_ref N_NAME RR(NETENT_PTR) )
	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string N_NAME RR(N_NAME) )
	mbfl_location_leave_when_failure( mmux_libc_getnetbyname NETENT_PTR RR(N_NAME) )

	if dotest-option-debug
	then mmux_libc_netent_dump RR(NETENT_PTR) >&2
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-getnetbyaddr-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR N_NET

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_net_ref N_NET RR(NETENT_PTR) )
	dotest-debug N_NET=RR(N_NET)
	mbfl_location_leave_when_failure( mmux_libc_getnetbyaddr NETENT_PTR RR(N_NET)  RR(mmux_libc_AF_INET))

	if dotest-option-debug
	then mmux_libc_netent_dump RR(NETENT_PTR) >&2
	fi
	true
    }
    mbfl_location_leave
}
function sockets-getnetbyaddr-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR
	declare N_NET_STR='127.0.0.0'
	declare IN_ADDR_POINTER
	declare N_NET_NETWORK_BYTEORDER
	declare N_NET_HOST_BYTEORDER

	mbfl_location_compensate( mmux_libc_calloc IN_ADDR_POINTER 1 RR(mmux_libc_in_addr_SIZEOF),
				  mmux_libc_free RR(IN_ADDR_POINTER) )
	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(N_NET_STR) RR(IN_ADDR_POINTER) )
	mbfl_location_leave_when_failure( mmux_uint32_pointer_ref N_NET_NETWORK_BYTEORDER RR(IN_ADDR_POINTER) 0 )
	mbfl_location_leave_when_failure( mmux_libc_ntohl N_NET_HOST_BYTEORDER RR(N_NET_NETWORK_BYTEORDER)  )
	mbfl_location_leave_when_failure( mmux_libc_getnetbyaddr NETENT_PTR RR(N_NET_HOST_BYTEORDER) RR(mmux_libc_AF_INET))

	if dotest-option-debug
	then mmux_libc_netent_dump RR(NETENT_PTR) >&2
	fi

	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-netent-n_name-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR N_NAME

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_name_ref N_NAME RR(NETENT_PTR) )
	dotest-debug N_NAME=WW(N_NAME)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-netent-n_aliases-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR N_ALIASES

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_aliases_ref N_ALIASES RR(NETENT_PTR) )

	dotest-debug N_ALIASES=WW(N_ALIASES)

	if mmux_pointer_is_positive RR(N_ALIASES)
	then
	    declare ALIAS_PTR ALIAS_STR
	    declare -i IDX=0

	    mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(N_ALIASES) RR(IDX) )
	    dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    until mmux_pointer_is_zero RR(ALIAS_PTR)
	    do
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string ALIAS_STR RR(ALIAS_PTR) )
		dotest-debug ALIAS_STR=WW(ALIAS_STR)
		let ++IDX
		mbfl_location_leave_when_failure( mmux_pointer_array_ref ALIAS_PTR RR(N_ALIASES) RR(IDX) )
		dotest-debug ALIAS_PTR=WW(ALIAS_PTR)
	    done
	fi
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-netent-n_addrtype-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR S_PROTO

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_addrtype_ref N_ADDRTYPE RR(NETENT_PTR) )

	dotest-debug N_ADDRTYPE=WW(N_ADDRTYPE)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-netent-n_net-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR N_NET

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_n_net_ref N_NET RR(NETENT_PTR) )

	dotest-debug N_NET=WW(N_NET)
	true
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

function sockets-netent-dump-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare NETENT_PTR

	mbfl_location_compensate( mmux_libc_setnetent 0,
				  mmux_libc_endnetent )

	mbfl_location_leave_when_failure( mmux_libc_getnetent NETENT_PTR )
	mbfl_location_leave_when_failure( mmux_libc_netent_dump RR(NETENT_PTR) )
    }
    mbfl_location_leave
}


#### socketpair

function sockets-socketpair-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD1 SOCKFD2

	mbfl_location_leave_when_failure( mmux_libc_socketpair SOCKFD1 SOCKFD2 \
							       RR(mmux_libc_PF_LOCAL) \
							       RR(mmux_libc_SOCK_STREAM) \
							       RR(mmux_libc_IPPROTO_IP) )
	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD1) RR(mmux_libc_SHUT_RDWR)"
	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD2) RR(mmux_libc_SHUT_RDWR)"

	# Socket 1.
	{
	    declare STR_1_TO_2='hello world'
	    declare STR_1_TO_2_BUFPTR
	    declare STR_1_TO_2_BUFLEN
	    declare NBYTES_SENT_BY_SOCKFD1

	    mbfl_location_leave_when_failure( mmux_pointer_from_bash_string STR_1_TO_2_BUFPTR WW(STR_1_TO_2) )
	    mbfl_location_leave_when_failure( mmux_libc_strlen STR_1_TO_2_BUFLEN WW(STR_1_TO_2_BUFPTR) )
	    mbfl_location_leave_when_failure( mmux_libc_send NBYTES_SENT_BY_SOCKFD1 \
							     RR(SOCKFD1) RR(STR_1_TO_2_BUFPTR) RR(STR_1_TO_2_BUFLEN) \
							     RR(mmux_libc_MSG_ZERO) )
	    dotest-debug SOCKFD1=RR(SOCKFD1) sent to SOCKFD2=RR(SOCKFD2) STR=\"WW(STR_1_TO_2)\"
	}

	# Socket 2.
	{
	    declare NBYTES_RECV_BY_SOCKFD2
	    declare STR_2_FROM_1_BUFLEN='4096'
	    declare STR_2_FROM_1_BUFPTR
	    declare STR_2_FROM_1

	    mbfl_location_compensate( mmux_libc_calloc STR_2_FROM_1_BUFPTR 1 RR(STR_2_FROM_1_BUFLEN),
				      mmux_libc_free RR(STR_2_FROM_1_BUFPTR) )

	    mbfl_location_leave_when_failure( mmux_libc_recv NBYTES_RECV_BY_SOCKFD2 \
							     RR(SOCKFD2) RR(STR_2_FROM_1_BUFPTR) RR(STR_2_FROM_1_BUFLEN) \
							     RR(mmux_libc_MSG_ZERO) )
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string STR_2_FROM_1 RR(STR_2_FROM_1_BUFPTR) RR(NBYTES_RECV_BY_SOCKFD2) )
	    dotest-debug SOCKFD2=RR(SOCKFD2) recv from SOCKFD1=RR(SOCKFD1) STR=\"WW(STR_2_FROM_1)\"
	}

	dotest-equal RR(STR_1_TO_2_BUFLEN) RR(NBYTES_SENT_BY_SOCKFD1) &&
	    dotest-equal RR(STR_1_TO_2_BUFLEN) RR(NBYTES_RECV_BY_SOCKFD2) &&
	    dotest-equal WW(STR_1_TO_2) WW(STR_2_FROM_1)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

# This  is like  "sockets-socketpair-1.1"  but evaluates  the builtins  in  functions, handling  the
# SOCKFD1 in a subprocess.
#
function sockets-socketpair-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare -r  MESSAGE_STRING='hello world'
	declare -ri MESSAGE_LENGTH=mbfl_string_len(MESSAGE_STRING)

	declare SOCKFD1 SOCKFD2

	mbfl_location_leave_when_failure( mmux_libc_socketpair SOCKFD1 SOCKFD2 \
							       RR(mmux_libc_PF_LOCAL) \
							       RR(mmux_libc_SOCK_STREAM) \
							       RR(mmux_libc_IPPROTO_IP) )

	( mbfl_location_leave_when_failure( sockfd1-sockets-socketpair-1.2 ) )
	mbfl_location_leave_when_failure( sockfd2-sockets-socketpair-1.2 )
    }
    mbfl_location_leave
}
function sockfd1-sockets-socketpair-1.2 () {
    mbfl_location_enter
    {
	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD1) RR(mmux_libc_SHUT_RDWR)"

	declare STR_1_TO_2=RR(MESSAGE_STRING)
	declare STR_1_TO_2_BUFPTR
	declare STR_1_TO_2_BUFLEN
	declare NBYTES_SENT_BY_SOCKFD1

	mbfl_location_leave_when_failure( mmux_pointer_from_bash_string STR_1_TO_2_BUFPTR WW(STR_1_TO_2) )
	mbfl_location_leave_when_failure( mmux_libc_strlen STR_1_TO_2_BUFLEN WW(STR_1_TO_2_BUFPTR) )
	mbfl_location_leave_when_failure( mmux_libc_send NBYTES_SENT_BY_SOCKFD1 \
							 RR(SOCKFD1) RR(STR_1_TO_2_BUFPTR) RR(STR_1_TO_2_BUFLEN) \
							 RR(mmux_libc_MSG_ZERO) )
	dotest-debug SOCKFD1=RR(SOCKFD1) sent to SOCKFD2=RR(SOCKFD2) STR=\"WW(STR_1_TO_2)\"
	dotest-equal RR(MESSAGE_LENGTH) RR(NBYTES_SENT_BY_SOCKFD1)
    }
    mbfl_location_leave
    mbfl_exit
}
function sockfd2-sockets-socketpair-1.2 () {
    mbfl_location_enter
    {
	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD2) RR(mmux_libc_SHUT_RDWR)"

	declare STR_2_FROM_1_BUFLEN=4096
	declare STR_2_FROM_1_BUFPTR
	declare STR_2_FROM_1
	declare NBYTES_RECV_BY_SOCKFD2

	mbfl_location_compensate( mmux_libc_calloc STR_2_FROM_1_BUFPTR 1 RR(STR_2_FROM_1_BUFLEN),
				  mmux_libc_free RR(STR_2_FROM_1_BUFPTR) )

	mbfl_location_leave_when_failure( mmux_libc_recv NBYTES_RECV_BY_SOCKFD2 \
							 RR(SOCKFD2) RR(STR_2_FROM_1_BUFPTR) RR(STR_2_FROM_1_BUFLEN) \
							 0 )
	mbfl_location_leave_when_failure( mmux_pointer_to_bash_string STR_2_FROM_1 RR(STR_2_FROM_1_BUFPTR) RR(NBYTES_RECV_BY_SOCKFD2) )
	dotest-debug SOCKFD2=RR(SOCKFD2) recv from SOCKFD1=RR(SOCKFD1) STR=\"WW(STR_2_FROM_1)\"
	dotest-equal RR(MESSAGE_LENGTH) RR(NBYTES_RECV_BY_SOCKFD2) &&
	    dotest-equal WW(MESSAGE_STRING) WW(STR_2_FROM_1)
    }
    mbfl_location_leave
}


#### shutdown

function sockets-shutdown-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare SOCKFD1 SOCKFD2

	mbfl_location_leave_when_failure( mmux_libc_socketpair SOCKFD1 SOCKFD2 \
							       RR(mmux_libc_PF_LOCAL) \
							       RR(mmux_libc_SOCK_STREAM) \
							       RR(mmux_libc_IPPROTO_IP) )
	mmux_libc_shutdown RR(SOCKFD1) RR(mmux_libc_SHUT_RD)
	mmux_libc_shutdown RR(SOCKFD2) RR(mmux_libc_SHUT_WR)

	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD1) RR(mmux_libc_SHUT_WR)"
	mbfl_location_handler "mmux_libc_shutdown RR(SOCKFD2) RR(mmux_libc_SHUT_RD)"

	# Socket 1.
	{
	    declare STR_1_TO_2='hello world'
	    declare STR_1_TO_2_BUFPTR
	    declare STR_1_TO_2_BUFLEN
	    declare NBYTES_SENT_BY_SOCKFD1

	    mbfl_location_leave_when_failure( mmux_pointer_from_bash_string STR_1_TO_2_BUFPTR WW(STR_1_TO_2) )
	    mbfl_location_leave_when_failure( mmux_libc_strlen STR_1_TO_2_BUFLEN WW(STR_1_TO_2_BUFPTR) )
	    mbfl_location_leave_when_failure( mmux_libc_send NBYTES_SENT_BY_SOCKFD1 \
							     RR(SOCKFD1) RR(STR_1_TO_2_BUFPTR) RR(STR_1_TO_2_BUFLEN) \
							     RR(mmux_libc_MSG_ZERO) )
	    dotest-debug SOCKFD1=RR(SOCKFD1) sent to SOCKFD2=RR(SOCKFD2) STR=\"WW(STR_1_TO_2)\"
	}

	# Socket 2.
	{
	    declare NBYTES_RECV_BY_SOCKFD2
	    declare STR_2_FROM_1_BUFLEN='4096'
	    declare STR_2_FROM_1_BUFPTR
	    declare STR_2_FROM_1

	    mbfl_location_compensate( mmux_libc_calloc STR_2_FROM_1_BUFPTR 1 RR(STR_2_FROM_1_BUFLEN),
				      mmux_libc_free RR(STR_2_FROM_1_BUFPTR) )

	    mbfl_location_leave_when_failure( mmux_libc_recv NBYTES_RECV_BY_SOCKFD2 \
							     RR(SOCKFD2) RR(STR_2_FROM_1_BUFPTR) RR(STR_2_FROM_1_BUFLEN) \
							     RR(mmux_libc_MSG_ZERO) )
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string STR_2_FROM_1 RR(STR_2_FROM_1_BUFPTR) RR(NBYTES_RECV_BY_SOCKFD2) )
	    dotest-debug SOCKFD2=RR(SOCKFD2) recv from SOCKFD1=RR(SOCKFD1) STR=\"WW(STR_2_FROM_1)\"
	}

	dotest-equal RR(STR_1_TO_2_BUFLEN) RR(NBYTES_SENT_BY_SOCKFD1) &&
	    dotest-equal RR(STR_1_TO_2_BUFLEN) RR(NBYTES_RECV_BY_SOCKFD2) &&
	    dotest-equal WW(STR_1_TO_2) WW(STR_2_FROM_1)
    }
    mbfl_location_leave
}


#### client/server stream connection: sockaddr_un, socket, bind, listen, accept, connect, read, write, close

function sockets-stream-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug
	mbfl_location_handler dotest-clean-files

	declare ERRNO

	# NOTE Override  the TMPDIR  set by  the Makefile.  We  know that  using "/tmp"  works here,
	# because "sockaddr_un"  does not  require the  pathneme to  be executable,  so it  does not
	# matter if "/tmp" is mounted "noexec".  We override it because tha maximum path length of a
	# "sockaddr_un"  is  quite  short;  I  overflow  it on  my  system,  because  I  use  nested
	# directories.  (Marco Maggi; Dec  1, 2024)
	declare -r TMPDIR='/tmp'
	declare -r PATHNAME=$(dotest-mkpathname 'mmux-sockets-stream-1.1')
	declare SOCKADDR_UN_PTR
	declare SOCKADDR_UN_LEN
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_un_calloc SOCKADDR_UN_PTR SOCKADDR_UN_LEN RR(mmux_libc_AF_LOCAL) WW(PATHNAME),
				  mmux_libc_free RR(SOCKADDR_UN_PTR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_un_dump RR(SOCKADDR_UN_PTR) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-stream-1.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-stream-1.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-stream-1.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	if false
	then
	    {
		dotest-debug 'setting socket option REUSEADDR'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SERVER_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_REUSEADDR) 1 )
	    }
	fi

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_UN_PTR) RR(SOCKADDR_UN_LEN) )
	dotest-debug 'listening'
	mbfl_location_leave_when_failure( mmux_libc_listen RR(SERVER_SOCKFD) 10 )

	{
	    declare CONNECTED_SOCKFD CONNECTED_SOCKADDR_PTR CONNECTED_SOCKADDR_LEN='1024'

	    mbfl_location_compensate( mmux_libc_calloc CONNECTED_SOCKADDR_PTR 1 RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_free RR(CONNECTED_SOCKADDR_PTR) )

	    dotest-debug 'accepting'
	    mbfl_location_compensate( mmux_libc_accept CONNECTED_SOCKFD CONNECTED_SOCKADDR_LEN \
						       RR(SERVER_SOCKFD) \
						       RR(CONNECTED_SOCKADDR_PTR) RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_close RR(CONNECTED_SOCKFD) )
	    	dotest-option-debug &&
		    mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(CONNECTED_SOCKADDR_PTR) 'server_connection_sockaddr' >&2 )

	    if false
	    then
		{
		    declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		    dotest-debug 'setting socket option LINGER'
		    mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(CONNECTED_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
									   RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
		}
	    fi

	    # Reading from client.
	    {
		declare DONEVAR
		declare BUFLEN='4096'
		declare BUFPTR
		declare BUFSTR

		mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
		dotest-debug 'reading' CONNECTED_SOCKFD=RR(CONNECTED_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
		mbfl_location_leave_when_failure( mmux_libc_read DONEVAR RR(CONNECTED_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
		dotest-debug DONEVAR=QQ(DONEVAR)
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
		dotest-debug BUFSTR="$BUFSTR"
	    }
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-stream-1.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-stream-1.1-sleep )

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SOCKFD) )

	if false
	then
	    {
		declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		dotest-debug 'setting socket option LINGER'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
	    }
	fi

	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(SOCKFD) RR(SOCKADDR_UN_PTR) RR(SOCKADDR_UN_LEN) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'writing'
	    mbfl_location_leave_when_failure( mmux_libc_write DONEVAR RR(SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-stream-1.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server stream connection: sockaddr_un, socket, bind, listen, accept, connect, send, recv, shutdown

function sockets-stream-1.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug
	mbfl_location_handler dotest-clean-files

	declare ERRNO

	# NOTE Override  the TMPDIR  set by  the Makefile.  We  know that  using "/tmp"  works here,
	# because "sockaddr_un"  does not  require the  pathneme to  be executable,  so it  does not
	# matter if "/tmp" is mounted "noexec".  We override it because tha maximum path length of a
	# "sockaddr_un"  is  quite  short;  I  overflow  it on  my  system,  because  I  use  nested
	# directories.  (Marco Maggi; Dec  1, 2024)
	declare -r TMPDIR='/tmp'
	declare -r PATHNAME=$(dotest-mkpathname 'mmux-sockets-stream-1.2')
	declare SOCKADDR_UN
	declare SOCKADDR_UN_LENGTH
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_un_calloc SOCKADDR_UN SOCKADDR_UN_LENGTH RR(mmux_libc_AF_LOCAL) WW(PATHNAME),
				  mmux_libc_free RR(SOCKADDR_UN) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_un_dump RR(SOCKADDR_UN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-stream-1.2 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-stream-1.2 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-stream-1.2 () {
    mbfl_location_enter
    {
	declare SOCKFD

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SOCKFD) )

	if false
	then
	    {
		dotest-debug 'setting socket option REUSEADDR'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) RR(mmux_libc_SO_REUSEADDR) 1 )
	    }
	fi

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SOCKFD) RR(SOCKADDR_UN) RR(SOCKADDR_UN_LENGTH) )
	dotest-debug 'listening'
	mbfl_location_leave_when_failure( mmux_libc_listen RR(SOCKFD) 10 )

	{
	    declare CONNECTED_SOCKFD CONNECTED_SOCKADDR_PTR CONNECTED_SOCKADDR_LEN='1024'

	    mbfl_location_compensate( mmux_libc_calloc CONNECTED_SOCKADDR_PTR 1 RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_free RR(CONNECTED_SOCKADDR_PTR) )

	    dotest-debug 'accepting'
	    mbfl_location_compensate( mmux_libc_accept CONNECTED_SOCKFD CONNECTED_SOCKADDR_LEN \
						       RR(SOCKFD) \
						       RR(CONNECTED_SOCKADDR_PTR) RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_shutdown RR(CONNECTED_SOCKFD) RR(mmux_libc_SHUT_RDWR) )
	    dotest-debug 'accepted'
	    dotest-option-debug &&
		mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(CONNECTED_SOCKADDR_PTR) 'server_connection_sockaddr' >&2 )

	    if false
	    then
		{
		    declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		    dotest-debug 'setting socket option LINGER'
		    mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(CONNECTED_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
									   RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
		}
	    fi

	    # Reading from client.
	    {
		declare DONEVAR
		declare BUFLEN='4096'
		declare BUFPTR
		declare BUFSTR

		mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
		dotest-debug 'receiving' CONNECTED_SOCKFD=RR(CONNECTED_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
		mbfl_location_leave_when_failure( mmux_libc_recv DONEVAR RR(CONNECTED_SOCKFD) \
								 RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
		dotest-debug DONEVAR=QQ(DONEVAR)
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
		dotest-debug BUFSTR="$BUFSTR"
	    }
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-stream-1.2 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-stream-1.2-sleep )

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_shutdown RR(SOCKFD) RR(mmux_libc_SHUT_RDWR) )

	if false
	then
	    {
		declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		dotest-debug 'setting socket option LINGER'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
	    }
	fi

	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(SOCKFD) RR(SOCKADDR_UN) RR(SOCKADDR_UN_LENGTH) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sending'
	    mbfl_location_leave_when_failure( mmux_libc_send DONEVAR RR(SOCKFD) RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-stream-1.2-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server stream connection: sockaddr_in, socket, bind, listen, accept, connect, send, recv, shutdown

function sockets-stream-2.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_IN SIN_ADDR SIN_PORT='8080' ASCII_ADDR='127.0.0.1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN RR(mmux_libc_AF_INET) SIN_ADDR RR(SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(ASCII_ADDR) RR(SIN_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-stream-2.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-stream-2.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-stream-2.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_TCP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	if true
	then
	    {
		dotest-debug 'setting socket option REUSEADDR'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SERVER_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_REUSEADDR) 1 )
	    }
	fi

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'listening'
	mbfl_location_leave_when_failure( mmux_libc_listen RR(SERVER_SOCKFD) 10 )

	{
	    declare CONNECTED_SOCKFD CONNECTED_SOCKADDR_PTR CONNECTED_SOCKADDR_LEN='1024'

	    mbfl_location_compensate( mmux_libc_calloc CONNECTED_SOCKADDR_PTR 1 RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_free RR(CONNECTED_SOCKADDR_PTR) )

	    dotest-debug 'accepting'
	    mbfl_location_compensate( mmux_libc_accept CONNECTED_SOCKFD CONNECTED_SOCKADDR_LEN \
						       RR(SERVER_SOCKFD) \
						       RR(CONNECTED_SOCKADDR_PTR) RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_shutdown RR(CONNECTED_SOCKFD) RR(mmux_libc_SHUT_RDWR) )
	    	dotest-option-debug &&
		    mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(CONNECTED_SOCKADDR_PTR) 'server_connection_sockaddr' >&2 )

	    if true
	    then
		{
		    declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		    dotest-debug 'setting socket option LINGER'
		    mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(CONNECTED_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
									   RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
		}
	    fi

	    # Reading from client.
	    {
		declare DONEVAR
		declare BUFLEN='4096'
		declare BUFPTR
		declare BUFSTR

		mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
		dotest-debug 'receiving' CONNECTED_SOCKFD=RR(CONNECTED_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
		mbfl_location_leave_when_failure( mmux_libc_recv DONEVAR RR(CONNECTED_SOCKFD) \
								 RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
		dotest-debug DONEVAR=QQ(DONEVAR)
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
		dotest-debug BUFSTR="$BUFSTR"
	    }
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-stream-2.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-stream-2.1-sleep )

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_TCP),
				  mmux_libc_shutdown RR(SOCKFD) RR(mmux_libc_SHUT_RDWR) )

	if true
	then
	    {
		declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		dotest-debug 'setting socket option LINGER'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
	    }
	fi

	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sending'
	    mbfl_location_leave_when_failure( mmux_libc_send DONEVAR RR(SOCKFD) RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-stream-2.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server stream connection: sockaddr_in, socket, bind, listen, accept4, connect, send, recv, shutdown

function sockets-stream-2.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_IN SIN_ADDR SIN_PORT='8080' ASCII_ADDR='127.0.0.1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN RR(mmux_libc_AF_INET) SIN_ADDR RR(SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(ASCII_ADDR) RR(SIN_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-stream-2.2 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-stream-2.2 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-stream-2.2 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_TCP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	if true
	then
	    {
		dotest-debug 'setting socket option REUSEADDR'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SERVER_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_REUSEADDR) 1 )
	    }
	fi

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'listening'
	mbfl_location_leave_when_failure( mmux_libc_listen RR(SERVER_SOCKFD) 10 )

	{
	    declare CONNECTED_SOCKFD CONNECTED_SOCKADDR_PTR CONNECTED_SOCKADDR_LEN='1024'

	    mbfl_location_compensate( mmux_libc_calloc CONNECTED_SOCKADDR_PTR 1 RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_free RR(CONNECTED_SOCKADDR_PTR) )

	    dotest-debug 'accepting4'
	    mbfl_location_compensate( mmux_libc_accept4 CONNECTED_SOCKFD CONNECTED_SOCKADDR_LEN \
							RR(SERVER_SOCKFD) \
							RR(CONNECTED_SOCKADDR_PTR) RR(CONNECTED_SOCKADDR_LEN) \
							RR(mmux_libc_SOCK_CLOEXEC),
				      mmux_libc_shutdown RR(CONNECTED_SOCKFD) RR(mmux_libc_SHUT_RDWR) )
	    	dotest-option-debug &&
		    mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(CONNECTED_SOCKADDR_PTR) 'server_connection_sockaddr' >&2 )

	    if true
	    then
		{
		    declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		    dotest-debug 'setting socket option LINGER'
		    mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(CONNECTED_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
									   RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
		}
	    fi

	    # Reading from client.
	    {
		declare DONEVAR
		declare BUFLEN='4096'
		declare BUFPTR
		declare BUFSTR

		mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
		dotest-debug 'receiving' CONNECTED_SOCKFD=RR(CONNECTED_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
		mbfl_location_leave_when_failure( mmux_libc_recv DONEVAR RR(CONNECTED_SOCKFD) \
								 RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
		dotest-debug DONEVAR=QQ(DONEVAR)
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
		dotest-debug BUFSTR="$BUFSTR"
	    }
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-stream-2.2 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-stream-2.2-sleep )

	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_TCP),
				  mmux_libc_shutdown RR(SOCKFD) RR(mmux_libc_SHUT_RDWR) )

	if true
	then
	    {
		declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		dotest-debug 'setting socket option LINGER'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
	    }
	fi

	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sending'
	    mbfl_location_leave_when_failure( mmux_libc_send DONEVAR RR(SOCKFD) RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-stream-2.2-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server stream connection: sockaddr_insix, socket, bind, listen, accept, connect, send, recv, shutdown

function sockets-stream-3.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_INSIX SINSIX_ADDR SINSIX_PORT='8080' ASCII_ADDR='::1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_insix_calloc SOCKADDR_INSIX RR(mmux_libc_AF_INET6) SINSIX_ADDR 0 0 RR(SINSIX_PORT),
				  mmux_libc_free RR(SOCKADDR_INSIX) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET6) WW(ASCII_ADDR) RR(SINSIX_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_insix_dump RR(SOCKADDR_INSIX) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-stream-3.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-stream-3.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-stream-3.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	dotest-debug 'creating server socket'
	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET6) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	if true
	then
	    {
		dotest-debug 'setting socket option REUSEADDR'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SERVER_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_REUSEADDR) 1 )
	    }
	fi

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_INSIX) RR(mmux_libc_sockaddr_insix_SIZEOF) )
	dotest-debug 'listening'
	mbfl_location_leave_when_failure( mmux_libc_listen RR(SERVER_SOCKFD) 10 )

	{
	    declare CONNECTED_SOCKFD CONNECTED_SOCKADDR_PTR CONNECTED_SOCKADDR_LEN='1024'

	    mbfl_location_compensate( mmux_libc_calloc CONNECTED_SOCKADDR_PTR 1 RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_free RR(CONNECTED_SOCKADDR_PTR) )

	    dotest-debug 'accepting'
	    mbfl_location_compensate( mmux_libc_accept CONNECTED_SOCKFD CONNECTED_SOCKADDR_LEN \
						       RR(SERVER_SOCKFD) \
						       RR(CONNECTED_SOCKADDR_PTR) RR(CONNECTED_SOCKADDR_LEN),
				      mmux_libc_shutdown RR(CONNECTED_SOCKFD) RR(mmux_libc_SHUT_RDWR) )

	    dotest-option-debug &&
		mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(CONNECTED_SOCKADDR_PTR) 'server_connection_sockaddr' >&2 )

	    if true
	    then
		{
		    declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		    dotest-debug 'setting socket option LINGER'
		    mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(CONNECTED_SOCKFD) RR(mmux_libc_SOL_SOCKET) \
									   RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
		}
	    fi

	    # Reading from client.
	    {
		declare DONEVAR
		declare BUFLEN='4096'
		declare BUFPTR
		declare BUFSTR

		mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
		dotest-debug 'receiving' CONNECTED_SOCKFD=RR(CONNECTED_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
		mbfl_location_leave_when_failure( mmux_libc_recv DONEVAR RR(CONNECTED_SOCKFD) \
								 RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
		dotest-debug DONEVAR=QQ(DONEVAR)
		mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
		dotest-debug BUFSTR="$BUFSTR"
	    }
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-stream-3.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-stream-3.1-sleep )

	dotest-debug 'creating client socket'
	mbfl_location_compensate( mmux_libc_socket SOCKFD RR(mmux_libc_PF_INET6) RR(mmux_libc_SOCK_STREAM) RR(mmux_libc_IPPROTO_TCP),
				  mmux_libc_shutdown RR(SOCKFD) RR(mmux_libc_SHUT_RDWR) )

	if true
	then
	    {
		declare -A SOCKOPT_LINGER=([ONOFF]=1 [LINGER]=1)
		dotest-debug 'setting socket option LINGER'
		mbfl_location_leave_when_failure( mmux_libc_setsockopt RR(SOCKFD) RR(mmux_libc_SOL_SOCKET) \
								       RR(mmux_libc_SO_LINGER) SOCKOPT_LINGER )
	    }
	fi

	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(SOCKFD) RR(SOCKADDR_INSIX) RR(mmux_libc_sockaddr_insix_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sending'
	    mbfl_location_leave_when_failure( mmux_libc_send DONEVAR RR(SOCKFD) RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-stream-3.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server datagram: sockaddr_un, socket, bind, connect, write, read, close

function sockets-dgram-1.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug
	mbfl_location_handler dotest-clean-files

	declare ERRNO

	# NOTE Override  the TMPDIR  set by  the Makefile.  We  know that  using "/tmp"  works here,
	# because "sockaddr_un"  does not  require the  pathneme to  be executable,  so it  does not
	# matter if "/tmp" is mounted "noexec".  We override it because tha maximum path length of a
	# "sockaddr_un"  is  quite  short;  I  overflow  it on  my  system,  because  I  use  nested
	# directories.  (Marco Maggi; Dec 1, 2024)
	declare -r TMPDIR='/tmp'
	declare -r PATHNAME=$(dotest-mkpathname 'mmux-sockets-dgram-1.1')
	declare SOCKADDR_UN_PTR
	declare SOCKADDR_UN_LEN
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_un_calloc SOCKADDR_UN_PTR SOCKADDR_UN_LEN RR(mmux_libc_AF_LOCAL) WW(PATHNAME),
				  mmux_libc_free RR(SOCKADDR_UN_PTR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_un_dump RR(SOCKADDR_UN_PTR) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-dgram-1.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-dgram-1.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-dgram-1.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_UN_PTR) RR(SOCKADDR_UN_LEN) )

	# Reading from client.
	{
	    declare DONEVAR
	    declare BUFLEN='4096'
	    declare BUFPTR
	    declare BUFSTR

	    mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'reading' SERVER_SOCKFD=RR(SERVER_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
	    mbfl_location_leave_when_failure( mmux_libc_read DONEVAR RR(SERVER_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug DONEVAR=QQ(DONEVAR)
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
	    dotest-debug BUFSTR="$BUFSTR"
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-dgram-1.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare CLIENT_SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-dgram-1.1-sleep )

	mbfl_location_compensate( mmux_libc_socket CLIENT_SOCKFD RR(mmux_libc_PF_LOCAL) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(CLIENT_SOCKFD) )

	# We call "connect()" to establish a default  destination for CLIENT_SOCKFD; this way we can
	# use "write()" to send data.
	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(CLIENT_SOCKFD) RR(SOCKADDR_UN_PTR) RR(SOCKADDR_UN_LEN) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(CLIENT_SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(CLIENT_SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'writing'
	    mbfl_location_leave_when_failure( mmux_libc_write DONEVAR RR(CLIENT_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-dgram-1.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server datagram: sockaddr_in, socket, bind, connect, write, read, close

function sockets-dgram-2.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_IN SIN_ADDR SIN_PORT='8080' ASCII_ADDR='127.0.0.1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN RR(mmux_libc_AF_INET) SIN_ADDR RR(SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(ASCII_ADDR) RR(SIN_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-dgram-2.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-dgram-2.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )

	# Reading from client.
	{
	    declare DONEVAR
	    declare BUFLEN='4096'
	    declare BUFPTR
	    declare BUFSTR

	    mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'reading' SERVER_SOCKFD=RR(SERVER_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
	    mbfl_location_leave_when_failure( mmux_libc_read DONEVAR RR(SERVER_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug DONEVAR=QQ(DONEVAR)
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
	    dotest-debug BUFSTR="$BUFSTR"
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-dgram-2.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare CLIENT_SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.1-sleep )

	mbfl_location_compensate( mmux_libc_socket CLIENT_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(CLIENT_SOCKFD) )

	# We call "connect()" to establish a default  destination for CLIENT_SOCKFD; this way we can
	# use "write()" to send data.
	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(CLIENT_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(CLIENT_SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(CLIENT_SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'writing'
	    mbfl_location_leave_when_failure( mmux_libc_write DONEVAR RR(CLIENT_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-dgram-2.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server datagram: sockaddr_in, socket, bind, connect, send, recv, close

function sockets-dgram-2.2 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_IN SIN_ADDR SIN_PORT='8080' ASCII_ADDR='127.0.0.1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN RR(mmux_libc_AF_INET) SIN_ADDR RR(SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(ASCII_ADDR) RR(SIN_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.2 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-dgram-2.2 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-dgram-2.2 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )

	# Receiving from client.
	{
	    declare DONEVAR
	    declare BUFLEN='4096'
	    declare BUFPTR
	    declare BUFSTR

	    mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'receiving' SERVER_SOCKFD=RR(SERVER_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
	    mbfl_location_leave_when_failure( mmux_libc_recv DONEVAR RR(SERVER_SOCKFD) \
							     RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug DONEVAR=QQ(DONEVAR)
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
	    dotest-debug BUFSTR="$BUFSTR"
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-dgram-2.2 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare CLIENT_SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.2-sleep )

	mbfl_location_compensate( mmux_libc_socket CLIENT_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(CLIENT_SOCKFD) )

	# We call "connect()" to establish a default  destination for CLIENT_SOCKFD; this way we can
	# use "write()" to send data.
	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(CLIENT_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(CLIENT_SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(CLIENT_SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Sending to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sending'
	    mbfl_location_leave_when_failure( mmux_libc_send DONEVAR RR(CLIENT_SOCKFD) RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-dgram-2.2-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server datagram: sockaddr_in, socket, bind, sendto, recvfrom, close

function sockets-dgram-2.3 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_IN SIN_ADDR SIN_PORT='8080' ASCII_ADDR='127.0.0.1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_in_calloc SOCKADDR_IN RR(mmux_libc_AF_INET) SIN_ADDR RR(SIN_PORT),
				  mmux_libc_free RR(SOCKADDR_IN) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET) WW(ASCII_ADDR) RR(SIN_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_in_dump RR(SOCKADDR_IN) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.3 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-dgram-2.3 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-dgram-2.3 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )

	# Receiving from client.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN='4096'
	    declare DONEVAR BUFLEN='4096' BUFPTR BUFSTR

	    mbfl_location_compensate( mmux_libc_calloc PEER_SOCKADDR_PTR 1 RR(PEER_SOCKADDR_LEN),
				      mmux_libc_free RR(PEER_SOCKADDR_PTR) )

	    mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )

	    dotest-debug 'receiving from' SERVER_SOCKFD=RR(SERVER_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
	    mbfl_location_leave_when_failure( mmux_libc_recvfrom DONEVAR PEER_SOCKADDR_LEN RR(SERVER_SOCKFD) \
								 RR(BUFPTR) RR(BUFLEN) RR(mmux_libc_MSG_ZERO) \
								 RR(PEER_SOCKADDR_PTR) RR(PEER_SOCKADDR_LEN))
	    dotest-debug DONEVAR=QQ(DONEVAR)
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
	    mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_sockaddr' >&2 )
	    dotest-debug BUFSTR="$BUFSTR"
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-dgram-2.3 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare CLIENT_SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-dgram-2.3-sleep )

	mbfl_location_compensate( mmux_libc_socket CLIENT_SOCKFD RR(mmux_libc_PF_INET) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(CLIENT_SOCKFD) )

	# Sending to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'sendtoing'
	    mbfl_location_leave_when_failure( mmux_libc_sendto DONEVAR RR(CLIENT_SOCKFD) RR(BUFPTR) RR(BUFLEN) \
							       RR(mmux_libc_MSG_ZERO) \
							       RR(SOCKADDR_IN) RR(mmux_libc_sockaddr_in_SIZEOF) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-dgram-2.3-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### client/server datagram: sockaddr_insix, socket, bind, connect, write, read, close

function sockets-dgram-3.1 () {
    mbfl_location_enter
    {
	dotest-unset-debug

	declare ERRNO
	declare SOCKADDR_INSIX SINSIX_ADDR SINSIX_PORT='8080' ASCII_ADDR='::1'
	declare CLIENT_PID

	mbfl_location_compensate( mmux_libc_sockaddr_insix_calloc SOCKADDR_INSIX RR(mmux_libc_AF_INET6) SINSIX_ADDR 0 0 RR(SINSIX_PORT),
				  mmux_libc_free RR(SOCKADDR_INSIX) )

	mbfl_location_leave_when_failure( mmux_libc_inet_pton RR(mmux_libc_AF_INET6) WW(ASCII_ADDR) RR(SINSIX_ADDR) )

	dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_insix_dump RR(SOCKADDR_INSIX) >&2 )

	dotest-debug 'running client in background'
	mbfl_location_leave_when_failure( client-sockets-dgram-3.1 ) &
	CLIENT_PID=$!

	dotest-debug 'running server in foreground'
	mbfl_location_leave_when_failure( server-sockets-dgram-3.1 )

	dotest-debug "waiting for client pid RR(CLIENT_PID)"
	wait RR(CLIENT_PID)
	dotest-debug "client terminated"
	true
    }
    mbfl_location_leave
}
function server-sockets-dgram-3.1 () {
    mbfl_location_enter
    {
	declare SERVER_SOCKFD

	mbfl_location_compensate( mmux_libc_socket SERVER_SOCKFD RR(mmux_libc_PF_INET6) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(SERVER_SOCKFD) )

	dotest-debug 'binding'
	mbfl_location_leave_when_failure( mmux_libc_bind RR(SERVER_SOCKFD) RR(SOCKADDR_INSIX) RR(mmux_libc_sockaddr_insix_SIZEOF) )

	# Reading from client.
	{
	    declare DONEVAR
	    declare BUFLEN='4096'
	    declare BUFPTR
	    declare BUFSTR

	    mbfl_location_compensate( mmux_libc_calloc BUFPTR 1 RR(BUFLEN), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'reading' SERVER_SOCKFD=RR(SERVER_SOCKFD) BUFPTR=RR(BUFPTR) BUFLEN=RR(BUFLEN)
	    mbfl_location_leave_when_failure( mmux_libc_read DONEVAR RR(SERVER_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug DONEVAR=QQ(DONEVAR)
	    mbfl_location_leave_when_failure( mmux_pointer_to_bash_string BUFSTR RR(BUFPTR) RR(DONEVAR) )
	    dotest-debug BUFSTR="$BUFSTR"
	}
	true
    }
    mbfl_location_leave
}
function client-sockets-dgram-3.1 () {
    mbfl_location_enter
    {
	declare ERRNO
	declare CLIENT_SOCKFD

	dotest-debug 'give the parent process the time to listen'
	mbfl_location_leave_when_failure( client-sockets-dgram-3.1-sleep )

	mbfl_location_compensate( mmux_libc_socket CLIENT_SOCKFD RR(mmux_libc_PF_INET6) RR(mmux_libc_SOCK_DGRAM) RR(mmux_libc_IPPROTO_IP),
				  mmux_libc_close RR(CLIENT_SOCKFD) )

	# We call "connect()" to establish a default  destination for CLIENT_SOCKFD; this way we can
	# use "write()" to send data.
	dotest-debug 'connecting'
	mbfl_location_leave_when_failure( mmux_libc_connect RR(CLIENT_SOCKFD) RR(SOCKADDR_INSIX) RR(mmux_libc_sockaddr_insix_SIZEOF) )
	dotest-debug 'connected'

	# Get peer socket's address informations.
	{
	    declare PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN

	    dotest-debug 'getpeering address'
	    mbfl_location_compensate( mmux_libc_getpeername RR(CLIENT_SOCKFD) PEER_SOCKADDR_PTR PEER_SOCKADDR_LEN,
				      mmux_libc_free RR(PEER_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(PEER_SOCKADDR_PTR) 'peer_address' >&2 )
	}

	# Get client socket's own address informations.
	{
	    declare OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN

	    dotest-debug 'getsockname address'
	    mbfl_location_compensate( mmux_libc_getsockname RR(CLIENT_SOCKFD) OWN_SOCKADDR_PTR OWN_SOCKADDR_LEN,
				      mmux_libc_free RR(OWN_SOCKADDR_PTR))
	    dotest-option-debug && mbfl_location_leave_when_failure( mmux_libc_sockaddr_dump RR(OWN_SOCKADDR_PTR) 'own_address' >&2 )
	}

	# Writing to server.
	{
	    declare DONEVAR
	    declare BUFSTR='hello world'
	    declare BUFLEN=mbfl_string_len(BUFSTR)
	    declare BUFPTR

	    mbfl_location_compensate( mmux_pointer_from_bash_string BUFPTR WW(BUFSTR), mmux_libc_free RR(BUFPTR) )
	    dotest-debug 'writing'
	    mbfl_location_leave_when_failure( mmux_libc_write DONEVAR RR(CLIENT_SOCKFD) RR(BUFPTR) RR(BUFLEN) )
	    dotest-debug written DONEVAR=QQ(DONEVAR)
	}
	true
    }
    mbfl_location_leave
    dotest-debug 'exiting client process'
    mbfl_exit
}
function client-sockets-dgram-3.1-sleep () {
    mbfl_location_enter
    {
	declare REQUESTED_TIMESPEC REMAINING_TIMESPEC

	mbfl_location_compensate(mmux_libc_timespec_calloc REQUESTED_TIMESPEC 1 0, mmux_libc_free RR(REQUESTED_TIMESPEC))
	mbfl_location_compensate(mmux_libc_timespec_calloc REMAINING_TIMESPEC,     mmux_libc_free RR(REMAINING_TIMESPEC))
	mbfl_location_leave_when_failure( mmux_libc_nanosleep RR(REQUESTED_TIMESPEC) RR(REMAINING_TIMESPEC) )
    }
    mbfl_location_leave
}


#### let's go

dotest sockets-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
