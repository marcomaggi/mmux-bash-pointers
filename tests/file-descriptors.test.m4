#!#
#!# Part of: MMUX Bash Pointers
#!# Contents: tests for file descriptors builtins
#!# Date: Oct  1, 2024
#!#
#!# Abstract
#!#
#!#	This file must be executed with one among:
#!#
#!#		$ make all check TESTS=tests/file-descriptors.test ; less tests/file-descriptors.log
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


#### opening and closing

function file-descriptors-open-close-1.1 () {
    dotest-unset-debug
    mbfl_location_enter
    {
	declare -i FD RV ERRNO=0
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT | mmux_libc_O_EXCL))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))
	declare -r FILENAME=$(dotest-mkpathname 'name.ext')
	mbfl_location_handler dotest-clean-files

	dotest-debug mmux_libc_O_RDWR=WW(mmux_libc_O_RDWR)
	dotest-debug mmux_libc_O_CREAT=WW(mmux_libc_O_CREAT)
	dotest-debug mmux_libc_O_EXCL=WW(mmux_libc_O_EXCL)
	dotest-debug FLAGS=WW(FLAGS)

	if ! mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then
	    mbfl_declare_varref(MSG)
	    mmux_libc_strerror _(MSG) $ERRNO
	    mbfl_message_error_printf 'opening file: %s\n' QQ(MSG)
	    mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_close $FD
	then mbfl_location_leave_then_return_failure
	fi
    }
    mbfl_location_leave
}


#### opening, closing, reading with "read", writing with "write"

function file-descriptors-read-write-1.1 () {
    mbfl_location_enter
    {
	declare -i FD DONE OFFSET SIZE=5
	declare BUFFER
	mbfl_declare_index_array_varref(RESULT)
	mbfl_declare_index_array_varref(ORIGIN_DATA,(11 22 33 44 55))
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))

	declare -r FILENAME=$(dotest-mkfile 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD"
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_malloc BUFFER $SIZE
	then mbfl_location_handler "mmux_libc_free $BUFFER"
	else mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-memory-from-array WW(BUFFER) _(ORIGIN_DATA) WW(SIZE)

	if ! mmux_libc_lseek OFFSET $FD 0 $mmux_libc_SEEK_SET
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_write DONE $FD $BUFFER $SIZE
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_lseek OFFSET $FD 0 $mmux_libc_SEEK_SET
	then mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_read DONE $FD $BUFFER $SIZE
	then mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-array-from-memory _(RESULT) WW(BUFFER) WW(SIZE)
	#mbfl_array_dump _(RESULT) RESULT

	dotest-equal $SIZE $DONE && \
	    dotest-equal 11 mbfl_slot_qref(RESULT, 0) && \
	    dotest-equal 22 mbfl_slot_qref(RESULT, 1) && \
	    dotest-equal 33 mbfl_slot_qref(RESULT, 2) && \
	    dotest-equal 44 mbfl_slot_qref(RESULT, 3) && \
	    dotest-equal 55 mbfl_slot_qref(RESULT, 4)
    }
    mbfl_location_leave
}


#### dup

function file-descriptors-dup-1.1 () {
    mbfl_location_enter
    {
	declare -i FD DONE OFFSET SIZE=5
	declare BUFFER
	mbfl_declare_index_array_varref(RESULT)
	mbfl_declare_index_array_varref(ORIGIN_DATA,(11 22 33 44 55))
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))

	mbfl_declare_varref(ID)

	declare -r FILENAME=$(dotest-mkfile 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_malloc BUFFER $SIZE
	then mbfl_location_handler "mmux_libc_free $BUFFER"
	else mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-memory-from-array WW(BUFFER) _(ORIGIN_DATA) WW(SIZE)

	if ! mmux_libc_pwrite DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_dup FD $FD
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_close WW(FD)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_pread DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-array-from-memory _(RESULT) WW(BUFFER) WW(SIZE)
	#mbfl_array_dump _(RESULT) RESULT

	dotest-equal $SIZE $DONE && \
	    dotest-equal 11 mbfl_slot_qref(RESULT, 0) && \
	    dotest-equal 22 mbfl_slot_qref(RESULT, 1) && \
	    dotest-equal 33 mbfl_slot_qref(RESULT, 2) && \
	    dotest-equal 44 mbfl_slot_qref(RESULT, 3) && \
	    dotest-equal 55 mbfl_slot_qref(RESULT, 4)
    }
    mbfl_location_leave
}


#### dup2

function file-descriptors-dup2-1.1 () {
    mbfl_location_enter
    {
	declare -i FD NEW_FD DONE OFFSET SIZE=5
	declare BUFFER
	mbfl_declare_index_array_varref(RESULT)
	mbfl_declare_index_array_varref(ORIGIN_DATA,(11 22 33 44 55))
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))

	mbfl_declare_varref(ID)

	declare -r FILENAME=$(dotest-mkfile 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_malloc BUFFER $SIZE
	then mbfl_location_handler "mmux_libc_free $BUFFER"
	else mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-memory-from-array WW(BUFFER) _(ORIGIN_DATA) WW(SIZE)

	if ! mmux_libc_pwrite DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	# I'm so dirty...
	NEW_FD=$(( FD + 1 ))

	if mmux_libc_dup2 FD $FD $NEW_FD
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_close WW(NEW_FD)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_pread DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-array-from-memory _(RESULT) WW(BUFFER) WW(SIZE)
	#mbfl_array_dump _(RESULT) RESULT

	dotest-equal $SIZE $DONE && \
	    dotest-equal 11 mbfl_slot_qref(RESULT, 0) && \
	    dotest-equal 22 mbfl_slot_qref(RESULT, 1) && \
	    dotest-equal 33 mbfl_slot_qref(RESULT, 2) && \
	    dotest-equal 44 mbfl_slot_qref(RESULT, 3) && \
	    dotest-equal 55 mbfl_slot_qref(RESULT, 4)
    }
    mbfl_location_leave
}


#### fcntl

function file-descriptors-fcntl-F_DUPFD-1.1 () {
    mbfl_location_enter
    {
	declare -i rv FD DONE OFFSET SIZE=5
	declare BUFFER
	mbfl_declare_index_array_varref(RESULT)
	mbfl_declare_index_array_varref(ORIGIN_DATA,(11 22 33 44 55))
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))

	mbfl_declare_varref(ID)

	declare -r FILENAME=$(dotest-mkfile 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD" _(ID)
	else mbfl_location_leave_then_return_failure
	fi

	if mmux_libc_malloc BUFFER $SIZE
	then mbfl_location_handler "mmux_libc_free $BUFFER"
	else mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-memory-from-array WW(BUFFER) _(ORIGIN_DATA) WW(SIZE)

	if ! mmux_libc_pwrite DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	# I'm so dirty...
	NEW_FD=$(( FD + 1 ))

	if mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_DUPFD) WW(NEW_FD)
	then mbfl_location_replace_handler_by_id WW(ID) "mmux_libc_close WW(FD)"
	else mbfl_location_leave_then_return_failure
	fi

	if ! mmux_libc_pread DONE $FD $BUFFER $SIZE 0
	then mbfl_location_leave_then_return_failure
	fi

	mmux-bash-pointers-array-from-memory _(RESULT) WW(BUFFER) WW(SIZE)
	#mbfl_array_dump _(RESULT) RESULT

	dotest-equal $SIZE $DONE && \
	    dotest-equal 11 mbfl_slot_qref(RESULT, 0) && \
	    dotest-equal 22 mbfl_slot_qref(RESULT, 1) && \
	    dotest-equal 33 mbfl_slot_qref(RESULT, 2) && \
	    dotest-equal 44 mbfl_slot_qref(RESULT, 3) && \
	    dotest-equal 55 mbfl_slot_qref(RESULT, 4)
    }
    mbfl_location_leave
}

### ------------------------------------------------------------------------

if test -v mmux_libc_F_GETFD -a -v mmux_libc_F_SETFD -a -v mmux_libc_FD_CLOEXEC
then

function file-descriptors-fcntl-F_GETFD-1.1 () {
    dotest-unset-debug
    mbfl_location_enter
    {
	declare -i FD RV ERRNO=0
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT | mmux_libc_O_EXCL))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))
	declare -r FILENAME=$(dotest-mkpathname 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD"
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug opened

	if ! mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_SETFD) WW(mmux_libc_FD_CLOEXEC)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug setted

	if ! mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_GETFD)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug getted

	dotest-equal WW(mmux_libc_FD_CLOEXEC) WW(RV)
    }
    mbfl_location_leave
}

fi

### ------------------------------------------------------------------------

if test -v mmux_libc_F_GETFL -a -v mmux_libc_F_SETFL -a -v mmux_libc_FD_CLOEXEC
then

function file-descriptors-fcntl-F_GETFL-1.1 () {
    dotest-unset-debug
    mbfl_location_enter
    {
	declare -i FD RV ERRNO=0
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT | mmux_libc_O_EXCL))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))
	declare -r FILENAME=$(dotest-mkpathname 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD"
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug opened

	if ! mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_GETFL)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug getted
	dotest-equal WW(mmux_libc_O_RDWR) $(( WW(RV) & WW(mmux_libc_O_RDWR) ))
    }
    mbfl_location_leave
}

function file-descriptors-fcntl-F_GETFL-1.2 () {
    dotest-unset-debug
    mbfl_location_enter
    {
	declare -i FD RV ERRNO=0
	declare -i FLAGS=$((mmux_libc_O_RDWR | mmux_libc_O_CREAT | mmux_libc_O_EXCL))
	declare -i MODE=$((mmux_libc_S_IRUSR | mmux_libc_S_IWUSR))
	declare -r FILENAME=$(dotest-mkpathname 'name.ext')
	mbfl_location_handler dotest-clean-files

	if mmux_libc_open FD QQ(FILENAME) WW(FLAGS) WW(MODE)
	then mbfl_location_handler "mmux_libc_close $FD"
	else mbfl_location_leave_then_return_failure
	fi

	dotest-debug opened

	if ! mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_SETFL) WW(mmux_libc_O_APPEND)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug setted

	if ! mmux_libc_fcntl RV WW(FD) WW(mmux_libc_F_GETFL)
	then mbfl_location_leave_then_return_failure
	fi

	dotest-debug getted
	dotest-equal WW(mmux_libc_O_RDWR) $(( WW(RV) & WW(mmux_libc_O_RDWR) ))
    }
    mbfl_location_leave
}

fi


#### let's go

dotest file-descriptors-
dotest-final-report

### end of file
# Local Variables:
# mode: sh
# End:
