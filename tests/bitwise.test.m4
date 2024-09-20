#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for bitwise builtins
#!# Date: Sep 19, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/bitwise.bash ; less tests/bitwise.log
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


#### bitwise operations for type: pointer

function bitwise-pointer-and-1.1 () {
    declare ROP OP=0x101 MASK=0x100
    declare EXPECTED_ROP=$(( OP & MASK ))

    printf -v EXPECTED_ROP '0x%x' WW(EXPECTED_ROP)

    bitwise-and-pointer ROP WW(OP) WW(MASK)

    dotest-unset-debug
    dotest-debug ROP=WW(ROP) EXPECTED_ROP=WW(EXPECTED_ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-pointer-or-1.1 () {
    declare ROP OP=0x100 MASK=0x111
    declare EXPECTED_ROP=$(( OP | MASK ))

    printf -v EXPECTED_ROP '0x%x' WW(EXPECTED_ROP)

    bitwise-or-pointer ROP WW(OP) WW(MASK)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-pointer-xor-1.1 () {
    declare ROP OP=0x100 MASK=0x111
    declare EXPECTED_ROP=$(( OP ^ MASK ))

    printf -v EXPECTED_ROP '0x%x' WW(EXPECTED_ROP)

    bitwise-xor-pointer ROP WW(OP) WW(MASK)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-pointer-not-1.1 () {
    declare ROP OP=0x100
    declare EXPECTED_ROP=$(( ~ OP ))

    printf -v EXPECTED_ROP '0x%x' WW(EXPECTED_ROP)

    bitwise-not-pointer ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: schar

function bitwise-schar-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-schar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-schar-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-schar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-schar-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-schar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-schar-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-schar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-schar-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-schar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-schar-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-schar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-schar-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-schar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-schar-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-schar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-schar-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-schar ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-schar-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-schar ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uchar

function bitwise-uchar-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uchar-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uchar-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uchar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uchar-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uchar-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uchar-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uchar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uchar-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uchar-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uchar-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uchar ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uchar-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UCHAR - OP ))

    bitwise-not-uchar ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sshort

function bitwise-sshort-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sshort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sshort-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sshort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sshort-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sshort ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sshort-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sshort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sshort-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sshort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sshort-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sshort ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sshort-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sshort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sshort-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sshort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sshort-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sshort ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sshort-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sshort ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: ushort

function bitwise-ushort-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-ushort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ushort-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-ushort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ushort-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-ushort ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ushort-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-ushort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ushort-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-ushort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ushort-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-ushort ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ushort-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-ushort ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ushort-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-ushort ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ushort-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-ushort ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-ushort-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_USHORT - OP ))

    bitwise-not-ushort ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sint

function bitwise-sint-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sint ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sint-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sint ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uint

function bitwise-uint-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uint ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uint-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINT - OP ))

    bitwise-not-uint ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: slong

function bitwise-slong-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-slong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-slong-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-slong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-slong-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-slong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-slong-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-slong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-slong-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-slong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-slong-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-slong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-slong-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-slong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-slong-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-slong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-slong-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-slong ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-slong-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-slong ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: ulong

function bitwise-ulong-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-ulong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ulong-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-ulong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ulong-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-ulong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ulong-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-ulong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ulong-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-ulong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ulong-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-ulong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ulong-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-ulong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ulong-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-ulong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ulong-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-ulong ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-ulong-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( -1 * ( 1 +  OP ) ))

    bitwise-not-ulong ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sllong

function bitwise-sllong-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sllong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sllong-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sllong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sllong-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sllong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sllong-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sllong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sllong-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sllong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sllong-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sllong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sllong-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sllong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sllong-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sllong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sllong-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sllong ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sllong-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sllong ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: ullong

function bitwise-ullong-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-ullong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ullong-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-ullong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ullong-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-ullong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ullong-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-ullong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ullong-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-ullong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ullong-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-ullong ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ullong-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-ullong ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ullong-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-ullong ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ullong-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-ullong ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-ullong-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( -1 * ( 1 + OP ) ))

    bitwise-not-ullong ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sint8

function bitwise-sint8-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint8-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint8-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sint8 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint8-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint8-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint8-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sint8 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint8-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint8-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint8-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sint8 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sint8-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sint8 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uint8

function bitwise-uint8-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint8-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint8-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uint8 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint8-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint8-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint8-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uint8 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint8-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uint8 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint8-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uint8 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint8-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uint8 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uint8-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINT8 - OP ))

    bitwise-not-uint8 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sint16

function bitwise-sint16-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint16-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint16-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sint16 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint16-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint16-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint16-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sint16 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint16-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint16-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint16-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sint16 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sint16-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sint16 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uint16

function bitwise-uint16-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint16-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint16-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uint16 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint16-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint16-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint16-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uint16 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint16-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uint16 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint16-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uint16 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint16-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uint16 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uint16-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINT16 - OP ))

    bitwise-not-uint16 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sint32

function bitwise-sint32-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint32-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint32-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sint32 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint32-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint32-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint32-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sint32 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint32-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint32-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint32-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sint32 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sint32-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sint32 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uint32

function bitwise-uint32-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint32-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint32-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uint32 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint32-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint32-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint32-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uint32 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint32-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uint32 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint32-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uint32 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint32-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uint32 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uint32-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINT32 - OP ))

    bitwise-not-uint32 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sint64

function bitwise-sint64-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint64-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sint64-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sint64 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint64-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint64-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint64-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sint64 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sint64-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint64-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sint64-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sint64 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sint64-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sint64 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uint64

function bitwise-uint64-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint64-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uint64-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uint64 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint64-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint64-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint64-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uint64 ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uint64-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uint64 ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint64-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uint64 ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uint64-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uint64 ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uint64-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINT64 - OP ))

    bitwise-not-uint64 ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sintmax

function bitwise-sintmax-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sintmax-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sintmax-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sintmax ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sintmax-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintmax-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintmax-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sintmax ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sintmax-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintmax-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintmax-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sintmax ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sintmax-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sintmax ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uintmax

function bitwise-uintmax-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uintmax-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uintmax-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uintmax ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uintmax-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintmax-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintmax-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uintmax ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uintmax-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uintmax ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintmax-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uintmax ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintmax-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uintmax ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uintmax-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINTMAX - OP ))

    bitwise-not-uintmax ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: sintptr

function bitwise-sintptr-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-sintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sintptr-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-sintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-sintptr-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-sintptr ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sintptr-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-sintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintptr-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-sintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintptr-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-sintptr ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-sintptr-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-sintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintptr-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-sintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-sintptr-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-sintptr ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-sintptr-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-sintptr ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uintptr

function bitwise-uintptr-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uintptr-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uintptr-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uintptr ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uintptr-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintptr-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintptr-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uintptr ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uintptr-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uintptr ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintptr-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uintptr ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uintptr-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uintptr ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uintptr-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_UINTPTR - OP ))

    bitwise-not-uintptr ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: ssize

function bitwise-ssize-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-ssize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ssize-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-ssize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ssize-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-ssize ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ssize-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-ssize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ssize-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-ssize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ssize-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-ssize ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ssize-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-ssize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ssize-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-ssize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ssize-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-ssize ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-ssize-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-ssize ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: usize

function bitwise-usize-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-usize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-usize-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-usize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-usize-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-usize ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-usize-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-usize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-usize-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-usize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-usize-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-usize ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-usize-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-usize ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-usize-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-usize ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-usize-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-usize ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-usize-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( libc_MAX_USIZE - OP ))

    bitwise-not-usize ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: ptrdiff

function bitwise-ptrdiff-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-ptrdiff ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ptrdiff-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-ptrdiff ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-ptrdiff-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-ptrdiff ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ptrdiff-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-ptrdiff ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ptrdiff-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-ptrdiff ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ptrdiff-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-ptrdiff ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-ptrdiff-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-ptrdiff ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ptrdiff-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-ptrdiff ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-ptrdiff-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-ptrdiff ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-ptrdiff-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-ptrdiff ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: off

function bitwise-off-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-off ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-off-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-off ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-off-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-off ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-off-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-off ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-off-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-off ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-off-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-off ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-off-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-off ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-off-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-off ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-off-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-off ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-off-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-off ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: mode

function bitwise-mode-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-mode ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-mode-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-mode ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-mode-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-mode ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-mode-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-mode ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-mode-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-mode ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-mode-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-mode ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-mode-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-mode ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-mode-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-mode ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-mode-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-mode ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-mode-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-mode ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: pid

function bitwise-pid-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-pid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-pid-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-pid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-pid-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-pid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-pid-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-pid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-pid-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-pid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-pid-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-pid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-pid-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-pid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-pid-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-pid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-pid-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-pid ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-pid-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-pid ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: uid

function bitwise-uid-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-uid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uid-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-uid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-uid-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-uid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uid-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-uid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uid-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-uid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uid-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-uid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-uid-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-uid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uid-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-uid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-uid-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-uid ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-uid-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-uid ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: gid

function bitwise-gid-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-gid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-gid-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-gid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-gid-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-gid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-gid-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-gid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-gid-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-gid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-gid-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-gid ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-gid-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-gid ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-gid-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-gid ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-gid-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-gid ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-gid-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-gid ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: wchar

function bitwise-wchar-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-wchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-wchar-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-wchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-wchar-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-wchar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-wchar-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-wchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wchar-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-wchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wchar-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-wchar ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-wchar-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-wchar ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wchar-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-wchar ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wchar-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-wchar ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-wchar-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-wchar ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### bitwise operations for type: wint

function bitwise-wint-and-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-and-wint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-wint-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 & 2))

    bitwise-and-wint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-and-wint-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 & 2 & 3 & 5 & 7 & 11 & 13))

    bitwise-and-wint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-wint-or-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-or-wint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wint-or-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 | 2))

    bitwise-or-wint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wint-or-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=3 OP3=5 OP4=7 OP5=11 OP6=13
    declare -r EXPECTED_ROP=$((1 | 2 | 3 | 5 | 7 | 11 | 13))

    bitwise-or-wint ROP WW(OP0) WW(OP1) WW(OP2) WW(OP3) WW(OP4) WW(OP5) WW(OP6)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-wint-xor-1.1 () {
    declare ROP OP=1
    declare -r EXPECTED_ROP='1'

    bitwise-xor-wint ROP WW(OP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wint-xor-1.2 () {
    declare ROP OP0=1 OP1=2
    declare -r EXPECTED_ROP=$((1 ^ 2))

    bitwise-xor-wint ROP WW(OP0) WW(OP1)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}
function bitwise-wint-xor-1.3 () {
    declare ROP OP0=1 OP1=2 OP2=4
    declare -r EXPECTED_ROP=$((1 ^ 2 ^ 4))

    bitwise-xor-wint ROP WW(OP0) WW(OP1) WW(OP2)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}

### ------------------------------------------------------------------------

function bitwise-not-wint-1.1 () {
    declare ROP OP=123
    declare -r EXPECTED_ROP=$(( ~ OP ))

    bitwise-not-wint ROP WW(OP)
    dotest-unset-debug
    dotest-debug ROP=WW(ROP)
    dotest-equal WW(EXPECTED_ROP) WW(ROP)
}


#### let's go

dotest bitwise-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End: