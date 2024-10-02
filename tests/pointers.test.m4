#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for raw memory accessor and mutator builtins
#!# Date: Sep  9, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/pointers.test ; less tests/pointers.log
#!#
#!#	that will select these tests.
#!#
#!# Copyright (c) 2024 Marco Maggi
#!# <mrc.mgg@gmail.com>
#!#
#!# The author hereby  grants permission to use,  copy, modify, distribute, and  license this software
#!# and its documentation  for any purpose, provided  that existing copyright notices  are retained in
#!# all copies and that this notice is  included verbatim in any distributions.  No written agreement,
#!# license,  or royalty  fee is  required for  any  of the  authorized uses.   Modifications to  this
#!# software may  be copyrighted by their  authors and need  not follow the licensing  terms described
#!# here, provided that the new terms are clearly indicated  on the first page of each file where they
#!# apply.
#!#
#!# IN NO EVENT SHALL THE AUTHOR OR DISTRIBUTORS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
#!# INCIDENTAL, OR CONSEQUENTIAL DAMAGES  ARISING OUT OF THE USE OF  THIS SOFTWARE, ITS DOCUMENTATION,
#!# OR ANY  DERIVATIVES THEREOF,  EVEN IF  THE AUTHOR  HAVE BEEN  ADVISED OF  THE POSSIBILITY  OF SUCH
#!# DAMAGE.
#!#
#!# THE AUTHOR AND  DISTRIBUTORS SPECIFICALLY DISCLAIM ANY WARRANTIES, INCLUDING,  BUT NOT LIMITED TO,
#!# THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.
#!# THIS  SOFTWARE IS  PROVIDED  ON AN  \"AS  IS\" BASIS,  AND  THE AUTHOR  AND  DISTRIBUTORS HAVE  NO
#!# OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
#!#


#### macros

MBFL_DEFINE_QQ_MACRO
MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)

source "$MMUX_LIBRARY"


#### array accessors and mutators: pointer

function pointers-pointer-1.1 () {
    declare PTR VALUE

    dotest-unset-debug
    dotest-debug max pointer value ${mmux_libc_MAX_POINTER}

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR $((32 * ${mmux_libc_SIZEOF_POINTER:?})) 1
	then mbfl_location_handler "mmux_libc_free $PTR"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_pointer_pointer_set $PTR 0 "${mmux_libc_MAX_POINTER:?}"
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_pointer_pointer_ref VALUE $PTR 0
	then mbfl_location_leave_then_return_failure
	fi
    }
    mbfl_location_leave
    dotest-equal "${mmux_libc_MAX_POINTER:?}" QQ(VALUE)
}
function pointers-pointer-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR $((32 * ${mmux_libc_SIZEOF_POINTER:?})) 1
	then mbfl_location_handler "mmux_libc_free $PTR"
	else mbfl_location_leave_then_return_failure
	fi

	{
	    if ! mmux_pointer_pointer_set $PTR  0 '0x12'
	    then mbfl_location_leave_then_return_failure
	    fi
	    if ! mmux_pointer_pointer_set $PTR  8 '0x34'
	    then mbfl_location_leave_then_return_failure
	    fi
	    if ! mmux_pointer_pointer_set $PTR 16 '0x56'
	    then mbfl_location_leave_then_return_failure
	    fi

	    if mmux_pointer_pointer_ref VALUE $PTR 0
	    then VALUES[0]=$VALUE
	    else mbfl_location_leave_then_return_failure
	    fi
	    if mmux_pointer_pointer_ref VALUE $PTR 8
	    then VALUES[1]=$VALUE
	    else mbfl_location_leave_then_return_failure
	    fi
	    if mmux_pointer_pointer_ref VALUE $PTR 16
	    then VALUES[2]=$VALUE
	    else mbfl_location_leave_then_return_failure
	    fi
	}
    }
    mbfl_location_leave

    dotest-equal '0x12' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0x34' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0x56' mbfl_slot_qref(VALUES,2)
}
function pointers-pointer-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    #dotest-set-debug

    mbfl_location_enter
    {
	mbfl_declare_varref(ID)

	if mmux_libc_calloc PTR $((32 * ${mmux_libc_SIZEOF_POINTER:?})) 1
	then mbfl_location_handler "mmux_libc_free $PTR" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_pointer_pointer_set $PTR  0 '0x12'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_pointer_pointer_set $PTR  8 '0x34'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_pointer_pointer_set $PTR 16 '0x56'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR $PTR $((64 * ${mmux_libc_SIZEOF_POINTER:?}))
	then
	    dotest-debug removing handler QQ(ID)
	    mbfl_location_remove_handler_by_id QQ(ID)
	    mbfl_location_handler "mmux_libc_free $PTR"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_pointer_pointer_ref VALUE $PTR 0
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_pointer_pointer_ref VALUE $PTR 8
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_pointer_pointer_ref VALUE $PTR 16
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
    }
    mbfl_location_leave

    dotest-equal '0x12' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0x34' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0x56' mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: schar

function pointers-schar-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_schar_pointer_set $PTR 0 12
	mmux_schar_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-schar-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_schar_pointer_set $PTR  0 12
	mmux_schar_pointer_set $PTR  8 34
	mmux_schar_pointer_set $PTR 16 56

	mmux_schar_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_schar_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_schar_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 34 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 56 mbfl_slot_qref(VALUES,2)
}
function pointers-schar-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_schar_pointer_set $PTR  0 12
	mmux_schar_pointer_set $PTR  8 34
	mmux_schar_pointer_set $PTR 16 56
	mmux_libc_realloc PTR $PTR 2048
	mmux_schar_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_schar_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_schar_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 34 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 56 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uchar

function pointers-uchar-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uchar_pointer_set $PTR 0 12
	mmux_uchar_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-uchar-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uchar_pointer_set $PTR  0 12
	mmux_uchar_pointer_set $PTR  8 34
	mmux_uchar_pointer_set $PTR 16 56

	mmux_uchar_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uchar_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uchar_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 34 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 56 mbfl_slot_qref(VALUES,2)
}
function pointers-uchar-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uchar_pointer_set $PTR  0 12
	mmux_uchar_pointer_set $PTR  8 34
	mmux_uchar_pointer_set $PTR 16 56
	mmux_libc_realloc PTR $PTR 2048
	mmux_uchar_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uchar_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uchar_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 34 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 56 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sshort

function pointers-sshort-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sshort_pointer_set $PTR 0 123
	mmux_sshort_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-sshort-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sshort_pointer_set $PTR  0 123
	mmux_sshort_pointer_set $PTR  8 456
	mmux_sshort_pointer_set $PTR 16 789

	mmux_sshort_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sshort_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sshort_pointer_ref VALUE $PTR 16	;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-sshort-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sshort_pointer_set $PTR  0 123
	mmux_sshort_pointer_set $PTR  8 456
	mmux_sshort_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_sshort_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sshort_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sshort_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: ushort

function pointers-ushort-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ushort_pointer_set $PTR 0 123
	mmux_ushort_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-ushort-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ushort_pointer_set $PTR  0 123
	mmux_ushort_pointer_set $PTR  8 456
	mmux_ushort_pointer_set $PTR 16 789

	mmux_ushort_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ushort_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ushort_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-ushort-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ushort_pointer_set $PTR  0 123
	mmux_ushort_pointer_set $PTR  8 456
	mmux_ushort_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_ushort_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ushort_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ushort_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sint

function pointers-sint-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint_pointer_set $PTR 0 123
	mmux_sint_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-sint-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint_pointer_set $PTR  0 123
	mmux_sint_pointer_set $PTR  8 456
	mmux_sint_pointer_set $PTR 16 789

	mmux_sint_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-sint-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint_pointer_set $PTR  0 123
	mmux_sint_pointer_set $PTR  8 456
	mmux_sint_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_sint_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uint

function pointers-uint-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint_pointer_set $PTR 0 123
	mmux_uint_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-uint-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint_pointer_set $PTR  0 123
	mmux_uint_pointer_set $PTR  8 456
	mmux_uint_pointer_set $PTR 16 789

	mmux_uint_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-uint-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint_pointer_set $PTR  0 123
	mmux_uint_pointer_set $PTR  8 456
	mmux_uint_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_uint_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: slong

function pointers-slong-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_slong_pointer_set $PTR 0 123
	mmux_slong_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-slong-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_slong_pointer_set $PTR  0 123
	mmux_slong_pointer_set $PTR  8 456
	mmux_slong_pointer_set $PTR 16 789

	mmux_slong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_slong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_slong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-slong-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_slong_pointer_set $PTR  0 123
	mmux_slong_pointer_set $PTR  8 456
	mmux_slong_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_slong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_slong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_slong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: ulong

function pointers-ulong-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ulong_pointer_set $PTR 0 123
	mmux_ulong_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-ulong-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ulong_pointer_set $PTR  0 123
	mmux_ulong_pointer_set $PTR  8 456
	mmux_ulong_pointer_set $PTR 16 789

	mmux_ulong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ulong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ulong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-ulong-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ulong_pointer_set $PTR  0 123
	mmux_ulong_pointer_set $PTR  8 456
	mmux_ulong_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_ulong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ulong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ulong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sllong

function pointers-sllong-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sllong_pointer_set $PTR 0 123
	mmux_sllong_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-sllong-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sllong_pointer_set $PTR  0 123
	mmux_sllong_pointer_set $PTR  8 456
	mmux_sllong_pointer_set $PTR 16 789

	mmux_sllong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sllong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sllong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-sllong-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sllong_pointer_set $PTR  0 123
	mmux_sllong_pointer_set $PTR  8 456
	mmux_sllong_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_sllong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sllong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sllong_pointer_ref VALUE $PTR 16	;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: ullong

function pointers-ullong-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ullong_pointer_set $PTR 0 123
	mmux_ullong_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-ullong-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ullong_pointer_set $PTR  0 123
	mmux_ullong_pointer_set $PTR  8 456
	mmux_ullong_pointer_set $PTR 16 789

	mmux_ullong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ullong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ullong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-ullong-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ullong_pointer_set $PTR  0 123
	mmux_ullong_pointer_set $PTR  8 456
	mmux_ullong_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_ullong_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ullong_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ullong_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: ssize

function pointers-ssize-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ssize_pointer_set $PTR 0 123
	mmux_ssize_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-ssize-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ssize_pointer_set $PTR  0 123
	mmux_ssize_pointer_set $PTR  8 456
	mmux_ssize_pointer_set $PTR 16 789

	mmux_ssize_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ssize_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ssize_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-ssize-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ssize_pointer_set $PTR  0 123
	mmux_ssize_pointer_set $PTR  8 456
	mmux_ssize_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_ssize_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ssize_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_ssize_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: usize

function pointers-usize-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_usize_pointer_set $PTR 0 123
	mmux_usize_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 123 QQ(VALUE)
}
function pointers-usize-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_usize_pointer_set $PTR  0 123
	mmux_usize_pointer_set $PTR  8 456
	mmux_usize_pointer_set $PTR 16 789

	mmux_usize_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_usize_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_usize_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}
function pointers-usize-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_usize_pointer_set $PTR  0 123
	mmux_usize_pointer_set $PTR  8 456
	mmux_usize_pointer_set $PTR 16 789
	mmux_libc_realloc PTR $PTR 2048
	mmux_usize_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_usize_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_usize_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 123 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 456 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 789 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: float

function pointers-float-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_float_pointer_set $PTR 0 1.23
	mmux_float_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 0X1.3AE148P+0 QQ(VALUE)
}
function pointers-float-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_float_pointer_set $PTR  0 1.23
	mmux_float_pointer_set $PTR  8 4.56
	mmux_float_pointer_set $PTR 16 7.89

	mmux_float_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_float_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_float_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 0X1.3AE148P+0 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 0X1.23D70AP+2 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 0X1.F8F5C2P+2 mbfl_slot_qref(VALUES,2)
}
function pointers-float-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_float_pointer_set $PTR  0 1.23
	mmux_float_pointer_set $PTR  8 4.56
	mmux_float_pointer_set $PTR 16 7.89
	mmux_libc_realloc PTR $PTR 2048
	mmux_float_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_float_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_float_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 0X1.3AE148P+0 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 0X1.23D70AP+2 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 0X1.F8F5C2P+2 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: double

function pointers-double-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_double_pointer_set $PTR 0 1.23
	mmux_double_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal '0X1.3AE147AE147AEP+0' QQ(VALUE)
}
function pointers-double-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_double_pointer_set $PTR  0 1.23
	mmux_double_pointer_set $PTR  8 4.56
	mmux_double_pointer_set $PTR 16 7.89

	mmux_double_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_double_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_double_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '0X1.3AE147AE147AEP+0' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0X1.23D70A3D70A3DP+2' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0X1.F8F5C28F5C28FP+2' mbfl_slot_qref(VALUES,2)
}
function pointers-double-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_double_pointer_set $PTR  0 1.23
	mmux_double_pointer_set $PTR  8 4.56
	mmux_double_pointer_set $PTR 16 7.89
	mmux_libc_realloc PTR $PTR 2048
	mmux_double_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_double_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_double_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '0X1.3AE147AE147AEP+0' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0X1.23D70A3D70A3DP+2' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0X1.F8F5C28F5C28FP+2' mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: ldouble

if test -v mmux_libc_SIZEOF_LDOUBLE
then

function pointers-ldouble-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ldouble_pointer_set $PTR 0 1.23
	mmux_ldouble_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal '0X9.D70A3D70A3D70A4P-3' QQ(VALUE)
}
function pointers-ldouble-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ldouble_pointer_set $PTR  0 1.23
	mmux_ldouble_pointer_set $PTR 32 4.56
	mmux_ldouble_pointer_set $PTR 64 7.89

	mmux_ldouble_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ldouble_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_ldouble_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '0X9.D70A3D70A3D70A4P-3' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0X9.1EB851EB851EB85P-1' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0XF.C7AE147AE147AE1P-1' mbfl_slot_qref(VALUES,2)
}
function pointers-ldouble-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ldouble_pointer_set $PTR  0 1.23
	mmux_ldouble_pointer_set $PTR 32 4.56
	mmux_ldouble_pointer_set $PTR 64 7.89
	mmux_libc_realloc PTR $PTR 2048
	mmux_ldouble_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_ldouble_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_ldouble_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '0X9.D70A3D70A3D70A4P-3' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '0X9.1EB851EB851EB85P-1' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '0XF.C7AE147AE147AE1P-1' mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: float32

if test -v mmux_libc_SIZEOF_FLOAT32
then

function pointers-float32-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT32))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float32_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float32-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT32))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT32))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT32))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float32_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float32_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float32_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float32-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT32))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT32))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT32))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float32_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float32_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float32_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: float64

if test -v mmux_libc_SIZEOF_FLOAT64
then

function pointers-float64-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT64))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float64_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float64-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT64))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT64))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT64))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float64_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float64_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float64_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float64-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT64))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT64))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT64))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float64_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float64_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float64_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: float128

if test -v mmux_libc_SIZEOF_FLOAT128
then

function pointers-float128-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT128))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float128_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float128-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT128))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT128))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT128))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float128_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float128_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float128_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float128-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT128))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT128))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT128))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float128_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float128_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float128_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: float32x

if test -v mmux_libc_SIZEOF_FLOAT32X
then

function pointers-float32x-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT32X))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float32x_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float32x-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT32X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT32X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT32X))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float32x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float32x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float32x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float32x-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT32X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT32X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT32X))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT32X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float32x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float32x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float32x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float32x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float32x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: float64x

if test -v mmux_libc_SIZEOF_FLOAT64X
then

function pointers-float64x-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT64X))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float64x_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float64x-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT64X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT64X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT64X))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float64x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float64x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float64x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float64x-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT64X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT64X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT64X))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT64X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float64x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float64x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float64x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float64x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float64x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: float128x

if test -v mmux_libc_SIZEOF_FLOAT128X
then

function pointers-float128x-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_FLOAT128X))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	mmux_float128x_equal_absmargin '0X1.3AE148P+0' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-float128x-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT128X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT128X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT128X))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float128x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float128x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float128x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-float128x-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_FLOAT128X))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_FLOAT128X))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_FLOAT128X))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_FLOAT128X)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_float128x_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_float128x_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_float128x_equal_absmargin     '0X1.3AE148P+0' mbfl_slot_qref(VALUES,0) &&
	    mmux_float128x_equal_absmargin '0X1.23D70AP+2' mbfl_slot_qref(VALUES,1) &&
	    mmux_float128x_equal_absmargin '0X1.F8F5C2P+2' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: decimal32

if test -v mmux_libc_SIZEOF_DECIMAL32
then

function pointers-decimal32-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_DECIMAL32))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug  WW(mmux_libc_SIZEOF_DECIMAL32) '1.230000' WW(VALUE)
	mmux_decimal32_equal_absmargin '1.230000' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-decimal32-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL32))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL32))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL32))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal32_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal32_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal32_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-decimal32-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL32))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL32))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL32))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL32)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX1) '4.560000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal32_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal32_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal32_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal32_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal32_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: decimal64

if test -v mmux_libc_SIZEOF_DECIMAL64
then

function pointers-decimal64-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_DECIMAL64))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug  WW(mmux_libc_SIZEOF_DECIMAL64) '1.230000' WW(VALUE)
	mmux_decimal64_equal_absmargin '1.230000' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-decimal64-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL64))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL64))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL64))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal64_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal64_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal64_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-decimal64-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL64))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL64))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL64))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL64)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX1) '4.560000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal64_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal64_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal64_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal64_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal64_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: decimal128

if test -v mmux_libc_SIZEOF_DECIMAL128
then

function pointers-decimal128-1.1 () {
    declare PTR VALUE
    declare -ri NITEMS=99
    declare -ri INDEX0=$((17 * mmux_libc_SIZEOF_DECIMAL128))

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug  WW(mmux_libc_SIZEOF_DECIMAL128) '1.230000' WW(VALUE)
	mmux_decimal128_equal_absmargin '1.230000' QQ(VALUE)
    }
    mbfl_location_leave
}
function pointers-decimal128-1.2 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL128))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL128))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL128))

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX0) '1.23'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX1) '4.56'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal128_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal128_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal128_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}
function pointers-decimal128-1.3 () {
    declare PTR VALUE
    declare -a VALUES
    declare -ri NITEMS=99 NITEMS2=333
    declare -ri INDEX0=$((0 * mmux_libc_SIZEOF_DECIMAL128))
    declare -ri INDEX1=$((3 * mmux_libc_SIZEOF_DECIMAL128))
    declare -ri INDEX2=$((5 * mmux_libc_SIZEOF_DECIMAL128))
    mbfl_declare_varref(ID)

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_libc_calloc PTR WW(NITEMS) WW(mmux_libc_SIZEOF_DECIMAL128)
	then mbfl_location_handler "mmux_libc_free WW(PTR)" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX0) '1.230000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX1) '4.560000'
	then mbfl_location_leave_then_return_failure
	fi
	if ! mmux_decimal128_pointer_set WW(PTR) WW(INDEX2) '7.89'
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_realloc PTR WW(PTR) $((WW(NITEMS2) * ${mmux_libc_SIZEOF_POINTER:?}))
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_free WW(PTR)"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX0)
	then VALUES[0]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX1)
	then VALUES[1]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi
	if mmux_decimal128_pointer_ref VALUE WW(PTR) WW(INDEX2)
	then VALUES[2]=$VALUE
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug expected=0X1.3AE148P+0 got=mbfl_slot_qref(VALUES,0)

	mmux_decimal128_equal_absmargin     '1.230000' mbfl_slot_qref(VALUES,0) &&
	    mmux_decimal128_equal_absmargin '4.560000' mbfl_slot_qref(VALUES,1) &&
	    mmux_decimal128_equal_absmargin '7.890000' mbfl_slot_qref(VALUES,2)
    }
    mbfl_location_leave
}

fi


#### array accessors and mutators: complexf

function pointers-complexf-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF) 10
    {
	mmux_complexf_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF) 10
    {
	mmux_complexf_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF) 10
    {
	mmux_complexf_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: complexd

function pointers-complexd-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXD) 10
    {
	mmux_complexd_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexd_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal '(0X1.3333333333333P+0)+i*(0X1.B333333333333P+1)' QQ(VALUE)
}
function pointers-complexd-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXD) 10
    {
	mmux_complexd_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexd_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '(0X1.3333333333333P+0)+i*(0X1.B333333333333P+1)' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '(0X1.6666666666666P+2)+i*(0X1.F333333333333P+2)' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '(0X1.2P+3)+i*(0X1.3333333333333P+0)'             mbfl_slot_qref(VALUES,2)
}
function pointers-complexd-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXD) 10
    {
	mmux_complexd_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd_pointer_set $PTR  32 '(5.6)+i*(7.8)'
	mmux_complexd_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexd_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal     '(0X1.3333333333333P+0)+i*(0X1.B333333333333P+1)' mbfl_slot_qref(VALUES,0) &&
	dotest-equal '(0X1.6666666666666P+2)+i*(0X1.F333333333333P+2)' mbfl_slot_qref(VALUES,1) &&
	dotest-equal '(0X1.2P+3)+i*(0X1.3333333333333P+0)'             mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: complexld

if test -v mmux_libc_SIZEOF_COMPLEXLD
then

function pointers-complexld-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXLD) 10
    {
	mmux_complexld_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexld_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexld_equal '(1.2)+i*(3.4)' QQ(VALUE)
}
function pointers-complexld-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXLD) 10
    {
	mmux_complexld_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexld_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexld_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexld_pointer_ref VALUE $PTR  0		;VALUES[0]=$VALUE
	mmux_complexld_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexld_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexld_equal     '(1.2)+i*(3.4)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexld_equal '(5.6)+i*(7.8)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexld_equal '(9.0)+i*(1.2)' mbfl_slot_qref(VALUES,2)
}
function pointers-complexld-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXLD) 10
    {
	mmux_complexld_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexld_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexld_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexld_pointer_ref VALUE $PTR  0		;VALUES[0]=$VALUE
	mmux_complexld_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexld_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexld_equal     '(1.2)+i*(3.4)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexld_equal '(5.6)+i*(7.8)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexld_equal '(9.0)+i*(1.2)' mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf32

if test -v mmux_libc_SIZEOF_COMPLEXF32
then

function pointers-complexf32-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32) 10
    {
	mmux_complexf32_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf32_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf32_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf32-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32) 10
    {
	mmux_complexf32_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf32_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf32_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf32_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf32_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf32_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf32_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf32_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf32-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32) 10
    {
	mmux_complexf32_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf32_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf32_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf32_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf32_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf32_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf32_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf32_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf64

if test -v mmux_libc_SIZEOF_COMPLEXF64
then

function pointers-complexf64-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64) 10
    {
	mmux_complexf64_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf64_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf64_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf64-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64) 10
    {
	mmux_complexf64_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf64_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf64_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf64_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf64_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf64_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf64_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf64_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf64-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64) 10
    {
	mmux_complexf64_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf64_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf64_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf64_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf64_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf64_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf64_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf64_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf128

if test -v mmux_libc_SIZEOF_COMPLEXF128
then

function pointers-complexf128-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128) 10
    {
	mmux_complexf128_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf128_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf128_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf128-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128) 10
    {
	mmux_complexf128_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf128_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf128_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf128_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf128_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf128_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf128_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf128_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf128_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf128-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128) 10
    {
	mmux_complexf128_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf128_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf128_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf128_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf128_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf128_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf128_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf128_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf128_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf32x

if test -v mmux_libc_SIZEOF_COMPLEXF32X
then

function pointers-complexf32x-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32X) 10
    {
	mmux_complexf32x_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf32x_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf32x_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf32x-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32X) 10
    {
	mmux_complexf32x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf32x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf32x_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf32x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf32x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf32x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf32x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf32x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf32x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf32x-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF32X) 10
    {
	mmux_complexf32x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf32x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf32x_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf32x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf32x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf32x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf32x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf32x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf32x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf64x

if test -v mmux_libc_SIZEOF_COMPLEXF64X
then

function pointers-complexf64x-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64X) 10
    {
	mmux_complexf64x_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf64x_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf64x_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf64x-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64X) 10
    {
	mmux_complexf64x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf64x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf64x_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf64x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf64x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf64x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf64x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf64x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf64x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf64x-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF64X) 10
    {
	mmux_complexf64x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf64x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf64x_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf64x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf64x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf64x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf64x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf64x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf64x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexf128x

if test -v mmux_libc_SIZEOF_COMPLEXF128X
then

function pointers-complexf128x-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128X) 10
    {
	mmux_complexf128x_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexf128x_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexf128x_equal_absmargin '(0X1.333334P+0)+i*(0X1.B33334P+1)' QQ(VALUE)
}
function pointers-complexf128x-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128X) 10
    {
	mmux_complexf128x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf128x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf128x_pointer_set $PTR 64 '(9.0)+i*(1.2)'

	mmux_complexf128x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf128x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf128x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf128x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf128x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf128x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}
function pointers-complexf128x-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR WW(mmux_libc_SIZEOF_COMPLEXF128X) 10
    {
	mmux_complexf128x_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexf128x_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexf128x_pointer_set $PTR 64 '(9.0)+i*(1.2)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexf128x_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexf128x_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexf128x_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexf128x_equal_absmargin     '(0X1.333334P+0)+i*(0X1.B33334P+1)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexf128x_equal_absmargin '(0X1.666666P+2)+i*(0X1.F33334P+2)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexf128x_equal_absmargin '(0X1.2P+3)+i*(0X1.333334P+0)'      mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexd32

if test -v mmux_libc_SIZEOF_COMPLEXD32
then

function pointers-complexd32-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD32)
    {
	mmux_complexd32_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexd32_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexd32_equal_absmargin '(1.20000)+i*(3.40000)' QQ(VALUE)
}
function pointers-complexd32-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD32)
    {
	mmux_complexd32_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd32_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd32_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'

	mmux_complexd32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd32_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd32_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd32_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd32_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd32_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}
function pointers-complexd32-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD32)
    {
	mmux_complexd32_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd32_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd32_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexd32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd32_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd32_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd32_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd32_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd32_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexd64

if test -v mmux_libc_SIZEOF_COMPLEXD64
then

function pointers-complexd64-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD64)
    {
	mmux_complexd64_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexd64_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexd64_equal_absmargin '(1.20000)+i*(3.40000)' QQ(VALUE)
}
function pointers-complexd64-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD64)
    {
	mmux_complexd64_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd64_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd64_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'

	mmux_complexd64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd64_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd64_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd64_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd64_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd64_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}
function pointers-complexd64-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD64)
    {
	mmux_complexd64_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd64_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd64_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexd64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd64_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd64_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd64_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd64_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd64_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: complexd128

if test -v mmux_libc_SIZEOF_COMPLEXD128
then

function pointers-complexd128-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD128)
    {
	mmux_complexd128_pointer_set $PTR 0 '(1.2)+i*(3.4)'
	mmux_complexd128_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    mmux_complexd128_equal_absmargin '(1.20000)+i*(3.40000)' QQ(VALUE)
}
function pointers-complexd128-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD128)
    {
	mmux_complexd128_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd128_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd128_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'

	mmux_complexd128_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd128_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd128_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd128_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd128_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd128_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}
function pointers-complexd128-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 10 WW(mmux_libc_SIZEOF_COMPLEXD128)
    {
	mmux_complexd128_pointer_set $PTR  0 '(1.2)+i*(3.4)'
	mmux_complexd128_pointer_set $PTR 32 '(5.6)+i*(7.8)'
	mmux_complexd128_pointer_set $PTR 64 '(9.00000)+i*(1.20000)'
	mmux_libc_realloc PTR $PTR 2048
	mmux_complexd128_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_complexd128_pointer_ref VALUE $PTR 32		;VALUES[1]=$VALUE
	mmux_complexd128_pointer_ref VALUE $PTR 64		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    mmux_complexd128_equal_absmargin     '(1.20000)+i*(3.40000)' mbfl_slot_qref(VALUES,0) &&
	mmux_complexd128_equal_absmargin '(5.60000)+i*(7.80000)' mbfl_slot_qref(VALUES,1) &&
	mmux_complexd128_equal_absmargin '(9.00000)+i*(1.20000)' mbfl_slot_qref(VALUES,2)
}

fi


#### array accessors and mutators: sint8

function pointers-sint8-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint8_pointer_set $PTR 0 12
	mmux_sint8_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-sint8-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint8_pointer_set $PTR  0 12
	mmux_sint8_pointer_set $PTR  8 45
	mmux_sint8_pointer_set $PTR 16 78

	mmux_sint8_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint8_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint8_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-sint8-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint8_pointer_set $PTR  0 12
	mmux_sint8_pointer_set $PTR  8 45
	mmux_sint8_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_sint8_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint8_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint8_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uint8

function pointers-uint8-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint8_pointer_set $PTR 0 12
	mmux_uint8_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-uint8-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint8_pointer_set $PTR  0 12
	mmux_uint8_pointer_set $PTR  8 45
	mmux_uint8_pointer_set $PTR 16 78

	mmux_uint8_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint8_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint8_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-uint8-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint8_pointer_set $PTR  0 12
	mmux_uint8_pointer_set $PTR  8 45
	mmux_uint8_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_uint8_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint8_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint8_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sint16

function pointers-sint16-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint16_pointer_set $PTR 0 12
	mmux_sint16_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-sint16-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint16_pointer_set $PTR  0 12
	mmux_sint16_pointer_set $PTR  8 45
	mmux_sint16_pointer_set $PTR 16 78

	mmux_sint16_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint16_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint16_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-sint16-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint16_pointer_set $PTR  0 12
	mmux_sint16_pointer_set $PTR  8 45
	mmux_sint16_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_sint16_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint16_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint16_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uint16

function pointers-uint16-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint16_pointer_set $PTR 0 12
	mmux_uint16_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-uint16-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint16_pointer_set $PTR  0 12
	mmux_uint16_pointer_set $PTR  8 45
	mmux_uint16_pointer_set $PTR 16 78

	mmux_uint16_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint16_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint16_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-uint16-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint16_pointer_set $PTR  0 12
	mmux_uint16_pointer_set $PTR  8 45
	mmux_uint16_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_uint16_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint16_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint16_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sint32

function pointers-sint32-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint32_pointer_set $PTR 0 12
	mmux_sint32_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-sint32-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint32_pointer_set $PTR  0 12
	mmux_sint32_pointer_set $PTR  8 45
	mmux_sint32_pointer_set $PTR 16 78

	mmux_sint32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint32_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint32_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-sint32-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint32_pointer_set $PTR  0 12
	mmux_sint32_pointer_set $PTR  8 45
	mmux_sint32_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_sint32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint32_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint32_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uint32

function pointers-uint32-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint32_pointer_set $PTR 0 12
	mmux_uint32_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-uint32-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint32_pointer_set $PTR  0 12
	mmux_uint32_pointer_set $PTR  8 45
	mmux_uint32_pointer_set $PTR 16 78

	mmux_uint32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint32_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint32_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-uint32-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint32_pointer_set $PTR  0 12
	mmux_uint32_pointer_set $PTR  8 45
	mmux_uint32_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_uint32_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint32_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint32_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sint64

function pointers-sint64-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint64_pointer_set $PTR 0 12
	mmux_sint64_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-sint64-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint64_pointer_set $PTR  0 12
	mmux_sint64_pointer_set $PTR  8 45
	mmux_sint64_pointer_set $PTR 16 78

	mmux_sint64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint64_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint64_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-sint64-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sint64_pointer_set $PTR  0 12
	mmux_sint64_pointer_set $PTR  8 45
	mmux_sint64_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_sint64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_sint64_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_sint64_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: uint64

function pointers-uint64-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint64_pointer_set $PTR 0 12
	mmux_uint64_pointer_ref VALUE $PTR 0
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}
function pointers-uint64-1.2 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint64_pointer_set $PTR  0 12
	mmux_uint64_pointer_set $PTR  8 45
	mmux_uint64_pointer_set $PTR 16 78

	mmux_uint64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint64_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint64_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}
function pointers-uint64-1.3 () {
    declare PTR VALUE
    declare -a VALUES

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uint64_pointer_set $PTR  0 12
	mmux_uint64_pointer_set $PTR  8 45
	mmux_uint64_pointer_set $PTR 16 78
	mmux_libc_realloc PTR $PTR 2048
	mmux_uint64_pointer_ref VALUE $PTR 0		;VALUES[0]=$VALUE
	mmux_uint64_pointer_ref VALUE $PTR 8		;VALUES[1]=$VALUE
	mmux_uint64_pointer_ref VALUE $PTR 16		;VALUES[2]=$VALUE
    }
    mmux_libc_free $PTR

    dotest-equal 12 mbfl_slot_qref(VALUES,0) &&
	dotest-equal 45 mbfl_slot_qref(VALUES,1) &&
	dotest-equal 78 mbfl_slot_qref(VALUES,2)
}


#### array accessors and mutators: sintmax

function pointers-sintmax-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sintmax_pointer_set $PTR 5 12
	mmux_sintmax_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: uintmax

function pointers-uintmax-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uintmax_pointer_set $PTR 5 12
	mmux_uintmax_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: sintptr

function pointers-sintptr-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_sintptr_pointer_set $PTR 5 12
	mmux_sintptr_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: uintptr

function pointers-uintptr-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uintptr_pointer_set $PTR 5 12
	mmux_uintptr_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: ptrdiff

function pointers-ptrdiff-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_ptrdiff_pointer_set $PTR 5 12
	mmux_ptrdiff_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: mode

function pointers-mode-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_mode_pointer_set $PTR 5 12
	mmux_mode_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: off

function pointers-off-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_off_pointer_set $PTR 5 12
	mmux_off_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: pid

function pointers-pid-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_pid_pointer_set $PTR 5 12
	mmux_pid_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: uid

function pointers-uid-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_uid_pointer_set $PTR 5 12
	mmux_uid_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### array accessors and mutators: gid

function pointers-gid-1.1 () {
    declare PTR VALUE

    mmux_libc_calloc PTR 1024 1
    {
	mmux_gid_pointer_set $PTR 5 12
	mmux_gid_pointer_ref VALUE $PTR 5
    }
    mmux_libc_free $PTR
    dotest-equal 12 QQ(VALUE)
}


#### let's go

dotest pointers-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
