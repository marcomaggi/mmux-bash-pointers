#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for mathematics builtin
#!# Date: Oct 16, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/mathematics.test ; less tests/mathematics.log
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


#### double

mmux_double_set_format "%.5f"

function mathematics-double-sin-1.1 () {
    declare -r OP='1.2' EXPECTED_ROP='0.93204'
    declare ROP

    mmux_double_sin ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}



#### complexd

function mathematics-complexd-sin-1.1 () {
    declare -r OP='(1.2)+i*(3.4)' EXPECTED_ROP='(1.397940880601799e+01)+i*(5.422815472463402e+00)'
    declare ROP

    mmux_complexd_sin ROP WW(OP)
    mmux_complexd_equal_relepsilon WW(EXPECTED_ROP) WW(ROP)
}


#### let's go

dotest mathematics-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End: