#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for output-format builtins
#!# Date: Sep 30, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/output-formats.test ; less tests/output-formats.log
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

MBFL_DEFINE_QQ_MACRO
MBFL_DEFINE_UNDERSCORE_MACRO_FOR_SLOTS


#### setup

mbfl_embed_library(__LIBMBFL_LINKER__)
mbfl_linker_source_library_by_stem(core)
mbfl_linker_source_library_by_stem(tests)
mbfl_linker_source_library_by_stem(mmux-bash-packages)
mbfl_linker_source_library_by_stem(mmux-bash-pointers)


#### type variables: float

function output-formats-float-1.0 () {
    declare CURRENT_FORMAT

    mmux_float_ref_format CURRENT_FORMAT
    dotest-equal "%A" WW(CURRENT_FORMAT)
}
function output-formats-float-1.1 () {
    declare ROP OP='123.4567890'
    declare -r EXPECTED_ROP='123.4567890'

    mmux_float_add ROP WW(OP)
    mmux_float_equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-float-1.2 () {
    declare ROP OP='123.4567890' OLD_FORMAT
    # This is a "float" number, it has limited precision.
    #                        0123456789
    declare -r EXPECTED_ROP='123.456787'

    mbfl_location_enter
    {
	if mmux_float_set_format '%f' OLD_FORMAT
	then mbfl_location_handler "mmux_float_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_float_add ROP WW(OP)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-float-1.3 () {
    declare ROP OP='123.4567890' OLD_FORMAT
    #                        012345
    declare -r EXPECTED_ROP='123.46'

    mbfl_location_enter
    {
	if mmux_float_set_format '%.2f' OLD_FORMAT
	then mbfl_location_handler "mmux_float_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_float_add ROP WW(OP)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function output-formats-float-2.1 () {
    if test -v mmux_float_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456787'

	mmux_float_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float-2.2 () {
    if test -v mmux_float_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: double

function output-formats-double-1.0 () {
    declare CURRENT_FORMAT

    mmux_float_ref_format CURRENT_FORMAT
    dotest-equal "%A" WW(CURRENT_FORMAT)
}
function output-formats-double-1.1 () {
    declare ROP OP='123.4567890'
    declare -r EXPECTED_ROP='123.4567890'

    mmux_double_add ROP WW(OP)
    mmux_double_equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-double-1.2 () {
    declare ROP OP='123.4567890' OLD_FORMAT
    #                        0123456789
    declare -r EXPECTED_ROP='123.456789'

    mbfl_location_enter
    {
	if mmux_double_set_format '%f' OLD_FORMAT
	then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_double_add ROP WW(OP)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-double-1.3 () {
    declare ROP OP='123.4567890' OLD_FORMAT
    #                        012345
    declare -r EXPECTED_ROP='123.46'

    mbfl_location_enter
    {
	if mmux_double_set_format '%.2f' OLD_FORMAT
	then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_double_add ROP WW(OP)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

### examples for the documentation

function output-formats-double-2.1 () {
    declare ROP OP='123.4567890' OLD_FORMAT
    #                        012345
    declare -r EXPECTED_ROP='1.234568e+02'

    mbfl_location_enter
    {
	if mmux_double_set_format '%e' OLD_FORMAT
	then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_double_add ROP WW(OP)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-double-2.2 () {
    declare OLD_FORMAT ROP OP1='123.4' OP2='567.8'
    declare -r EXPECTED_ROP='6.912000e+02'

    mbfl_location_enter
    {
	if mmux_double_set_format '%e' OLD_FORMAT
	then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	else mbfl_location_leave_then_return_failure
	fi
	mmux_double_add ROP WW(OP1) WW(OP2)
    }
    mbfl_location_leave

    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function output-formats-double-2.3 () {
    declare OLD_FORMAT ROPA ROPB OP1='12340000' OP2='56780000'
    declare -r EXPECTED_ROPA='69120000' EXPECTED_ROPB='7e+07'

    dotest-unset-debug

    mbfl_location_enter
    {
	if mmux_double_set_format '%.0e' OLD_FORMAT
	then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	else
	    printf '%s:error in format\n' "$FUNCNAME" >&2
	    mbfl_location_leave_then_return_failure
	fi

	mmux_sintmax_add ROPA WW(OP1) WW(OP2)
	dotest-debug WW(ROPA) WW(OP1) WW(OP2)
	mmux_double_add  ROPB WW(ROPA)
	dotest-debug WW(ROPB) WW(ROPA)
    }
    mbfl_location_leave


    dotest-debug WW(EXPECTED_ROPB) WW(ROPB)

    dotest-equal     WW(EXPECTED_ROPA) WW(ROPA) &&
	dotest-equal WW(EXPECTED_ROPB) WW(ROPB)
}

### ------------------------------------------------------------------------

function output-formats-double-2.1 () {
    if test -v mmux_double_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_double_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-double-2.2 () {
    if test -v mmux_double_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_double_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: ldouble

function output-formats-ldouble-1.0 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_ldouble_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-ldouble-1.1 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_ldouble_add ROP WW(OP)
	mmux_ldouble_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-ldouble-1.2 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_ldouble_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_ldouble_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_ldouble_add ROP WW(OP)
	}
	mbfl_location_leave
    else dotest-equal WW(EXPECTED_ROP) WW(ROP)
    fi
}
function output-formats-ldouble-1.3 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_ldouble_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_ldouble_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_ldouble_add ROP WW(OP)
	}
	mbfl_location_leave
    else dotest-equal WW(EXPECTED_ROP) WW(ROP)
    fi
}

### ------------------------------------------------------------------------

function output-formats-ldouble-2.1 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_ldouble_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-ldouble-2.2 () {
    if test -v mmux_ldouble_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_ldouble_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float32

function output-formats-float32-1.0 () {
    if test -v mmux_float32_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float32_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float32-1.1 () {
    if test -v mmux_float32_SIZEOF
    then

	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float32_add ROP WW(OP)
	mmux_float32_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32-1.2 () {
    if test -v mmux_float32_SIZEOF
    then

	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456787'

	mbfl_location_enter
	{
	    if mmux_float32_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32-1.3 () {
    if test -v mmux_float32_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float32_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float32-2.1 () {
    if test -v mmux_float32_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456787'

	mmux_float32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32-2.2 () {
    if test -v mmux_float32_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float64

function output-formats-float64-1.0 () {
    if test -v mmux_float64_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float64_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float64-1.1 () {
    if test -v mmux_float64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float64_add ROP WW(OP)
	mmux_float64_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64-1.2 () {
    if test -v mmux_float64_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_float64_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64-1.3 () {
    if test -v mmux_float64_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float64_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float64-2.1 () {
    if test -v mmux_float64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_float64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64-2.2 () {
    if test -v mmux_float64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float128

function output-formats-float128-1.0 () {
    if test -v mmux_float128_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float128_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float128-1.1 () {
    if test -v mmux_float128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float128_add ROP WW(OP)
	mmux_float128_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128-1.2 () {
    if test -v mmux_float128_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_float128_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128-1.3 () {
    if test -v mmux_float128_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float128_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float128-2.1 () {
    if test -v mmux_float128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_float128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128-2.2 () {
    if test -v mmux_float128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float32x

function output-formats-float32x-1.0 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float32x_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float32x-1.1 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float32x_add ROP WW(OP)
	mmux_float32x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32x-1.2 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_float32x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float32x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32x-1.3 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float32x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float32x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float32x-2.1 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_float32x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float32x-2.2 () {
    if test -v mmux_float32x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float32x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float64x

function output-formats-float64x-1.0 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float64x_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float64x-1.1 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float64x_add ROP WW(OP)
	mmux_float64x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64x-1.2 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_float64x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float64x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64x-1.3 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float64x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float64x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float64x-2.1 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_float64x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float64x-2.2 () {
    if test -v mmux_float64x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float64x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: float128x

function output-formats-float128x-1.0 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_float128x_ref_format CURRENT_FORMAT
	dotest-equal "%A" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-float128x-1.1 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_float128x_add ROP WW(OP)
	mmux_float128x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128x-1.2 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_float128x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float128x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128x-1.3 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_float128x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_float128x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-float128x-2.1 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_float128x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-float128x-2.2 () {
    if test -v mmux_float128x_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_float128x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: decimal32

function output-formats-decimal32-1.0 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_decimal32_ref_format CURRENT_FORMAT
	dotest-equal "%f" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-decimal32-1.1 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.456800'

	mmux_decimal32_add ROP WW(OP)
	mmux_decimal32_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal32-1.2 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456800'

	mbfl_location_enter
	{
	    if mmux_decimal32_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal32-1.3 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_decimal32_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-decimal32-2.1 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456800'

	mmux_decimal32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal32-2.2 () {
    if test -v mmux_decimal32_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_decimal32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: decimal64

function output-formats-decimal64-1.0 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_decimal64_ref_format CURRENT_FORMAT
	dotest-equal "%f" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-decimal64-1.1 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_decimal64_add ROP WW(OP)
	mmux_decimal64_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal64-1.2 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_decimal64_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal64-1.3 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_decimal64_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-decimal64-2.1 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_decimal64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal64-2.2 () {
    if test -v mmux_decimal64_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_decimal64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: decimal128

function output-formats-decimal128-1.0 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare CURRENT_FORMAT

	mmux_decimal128_ref_format CURRENT_FORMAT
	dotest-equal "%f" WW(CURRENT_FORMAT)
    else dotest-skipped
    fi
}
function output-formats-decimal128-1.1 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r EXPECTED_ROP='123.4567890'

	mmux_decimal128_add ROP WW(OP)
	mmux_decimal128_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal128-1.2 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        0123456789
	declare -r EXPECTED_ROP='123.456789'

	mbfl_location_enter
	{
	    if mmux_decimal128_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal128-1.3 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare ROP OP='123.4567890' OLD_FORMAT
	#                        012345
	declare -r EXPECTED_ROP='123.46'

	mbfl_location_enter
	{
	    if mmux_decimal128_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_decimal128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-decimal128-2.1 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='123.456789'

	mmux_decimal128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-decimal128-2.2 () {
    if test -v mmux_decimal128_SIZEOF
    then
	declare ROP OP='123.4567890'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='123.46'

	mmux_decimal128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf

function output-formats-complexf-1.1 () {
    if test -v mmux_complexf_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf_add ROP WW(OP)
	mmux_complexf_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf-1.2 () {
    if test -v mmux_complexf_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456787)+i*(789.012329)'

	mbfl_location_enter
	{
	    if mmux_float_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf-1.3 () {
    if test -v mmux_complexf_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf-2.1 () {
    if test -v mmux_complexf_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456787)+i*(789.012329)'

	mmux_complexf_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf-2.2 () {
    if test -v mmux_complexf_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexd

function output-formats-complexd-1.1 () {
    if test -v mmux_complexd_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexd_add ROP WW(OP)
	mmux_complexd_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd-1.2 () {
    if test -v mmux_complexd_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_double_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd-1.3 () {
    if test -v mmux_complexd_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_double_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_double_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexd-2.1 () {
    if test -v mmux_complexd_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexd_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd-2.2 () {
    if test -v mmux_complexd_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexd_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexld

function output-formats-complexld-1.1 () {
    if test -v mmux_complexld_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexld_add ROP WW(OP)
	mmux_complexld_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexld-1.2 () {
    if test -v mmux_complexld_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_ldouble_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_ldouble_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexld_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexld-1.3 () {
    if test -v mmux_complexld_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_ldouble_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_ldouble_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexld_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexld-2.1 () {
    if test -v mmux_complexld_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexld_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexld-2.2 () {
    if test -v mmux_complexld_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexld_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf32

function output-formats-complexf32-1.1 () {
    if test -v mmux_complexf32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456787)+i*(789.012329)'

	mmux_complexf32_add ROP WW(OP)
	mmux_complexf32_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32-1.2 () {
    if test -v mmux_complexf32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456787)+i*(789.012329)'

	mbfl_location_enter
	{
	    if mmux_float32_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32-1.3 () {
    if test -v mmux_complexf32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float32_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf32-2.1 () {
    if test -v mmux_complexf32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456787)+i*(789.012329)'

	mmux_complexf32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32-2.2 () {
    if test -v mmux_complexf32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf64

function output-formats-complexf64-1.1 () {
    if test -v mmux_complexf64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf64_add ROP WW(OP)
	mmux_complexf64_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64-1.2 () {
    if test -v mmux_complexf64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_float64_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64-1.3 () {
    if test -v mmux_complexf64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float64_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf64-2.1 () {
    if test -v mmux_complexf64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexf64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64-2.2 () {
    if test -v mmux_complexf64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf128

function output-formats-complexf128-1.1 () {
    if test -v mmux_complexf128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf128_add ROP WW(OP)
	mmux_complexf128_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128-1.2 () {
    if test -v mmux_complexf128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_float128_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128-1.3 () {
    if test -v mmux_complexf128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float128_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf128-2.1 () {
    if test -v mmux_complexf128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexf128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128-2.2 () {
    if test -v mmux_complexf128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf32x

function output-formats-complexf32x-1.1 () {
    if test -v mmux_complexf32x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf32x_add ROP WW(OP)
	mmux_complexf32x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32x-1.2 () {
    if test -v mmux_complexf32x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_float32x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf32x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32x-1.3 () {
    if test -v mmux_complexf32x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float32x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float32x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf32x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf32x-2.1 () {
    if test -v mmux_complexf32x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexf32x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf32x-2.2 () {
    if test -v mmux_complexf32x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf32x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf64x

function output-formats-complexf64x-1.1 () {
    if test -v mmux_complexf64x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf64x_add ROP WW(OP)
	mmux_complexf64x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64x-1.2 () {
    if test -v mmux_complexf64x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_float64x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf64x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64x-1.3 () {
    if test -v mmux_complexf64x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float64x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float64x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf64x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf64x-2.1 () {
    if test -v mmux_complexf64x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexf64x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf64x-2.2 () {
    if test -v mmux_complexf64x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf64x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexf128x

function output-formats-complexf128x-1.1 () {
    if test -v mmux_complexf128x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.4567890)+i*(789.0123456)'

	mmux_complexf128x_add ROP WW(OP)
	mmux_complexf128x_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128x-1.2 () {
    if test -v mmux_complexf128x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_float128x_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf128x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128x-1.3 () {
    if test -v mmux_complexf128x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_float128x_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_float128x_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexf128x_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexf128x-2.1 () {
    if test -v mmux_complexf128x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexf128x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexf128x-2.2 () {
    if test -v mmux_complexf128x_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexf128x_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexd32

# NOTE Remember that the default format for "decimal32" is "%f".

function output-formats-complexd32-1.1 () {
    if test -v mmux_complexd32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456800)+i*(789.012300)'

	mmux_complexd32_add ROP WW(OP)
	mmux_complexd32_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd32-1.2 () {
    if test -v mmux_complexd32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456800)+i*(789.012300)'

	mbfl_location_enter
	{
	    if mmux_decimal32_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd32-1.3 () {
    if test -v mmux_complexd32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_decimal32_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal32_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd32_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexd32-2.1 () {
    if test -v mmux_complexd32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456800)+i*(789.012300)'

	mmux_complexd32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd32-2.2 () {
    if test -v mmux_complexd32_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexd32_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexd64

# NOTE Remember that the default format for "decimal64" is "%f".

function output-formats-complexd64-1.1 () {
    if test -v mmux_complexd64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	dotest-unset-debug

	mmux_complexd64_add ROP WW(OP)
	dotest-debug WW(EXPECTED_ROP) WW(ROP)
	mmux_complexd64_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd64-1.2 () {
    if test -v mmux_complexd64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_decimal64_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd64-1.3 () {
    if test -v mmux_complexd64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_decimal64_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal64_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd64_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexd64-2.1 () {
    if test -v mmux_complexd64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexd64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd64-2.2 () {
    if test -v mmux_complexd64_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexd64_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### type variables: complexd128

# NOTE Remember that the default format for "decimal128" is "%f".

function output-formats-complexd128-1.1 () {
    if test -v mmux_complexd128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexd128_add ROP WW(OP)
	mmux_complexd128_equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd128-1.2 () {
    if test -v mmux_complexd128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mbfl_location_enter
	{
	    if mmux_decimal128_set_format '%f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi

	    mmux_complexd128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd128-1.3 () {
    if test -v mmux_complexd128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)' OLD_FORMAT
	declare -r EXPECTED_ROP='(123.46)+i*(789.01)'

	mbfl_location_enter
	{
	    if mmux_decimal128_set_format '%.2f' OLD_FORMAT
	    then mbfl_location_handler "mmux_decimal128_set_format RR(OLD_FORMAT)"
	    else mbfl_location_leave_then_return_failure
	    fi
	    mmux_complexd128_add ROP WW(OP)
	}
	mbfl_location_leave

	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}

### ------------------------------------------------------------------------

function output-formats-complexd128-2.1 () {
    if test -v mmux_complexd128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%f' EXPECTED_ROP='(123.456789)+i*(789.012346)'

	mmux_complexd128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}
function output-formats-complexd128-2.2 () {
    if test -v mmux_complexd128_SIZEOF
    then
	declare ROP OP='(123.4567890)+i*(789.0123456)'
	declare -r NEW_FORMAT='%.2f' EXPECTED_ROP='(123.46)+i*(789.01)'

	mmux_complexd128_reformat ROP WW(NEW_FORMAT) WW(OP)
	dotest-equal WW(EXPECTED_ROP) WW(ROP)
    else dotest-skipped
    fi
}


#### let's go

dotest output-formats-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
