/*
  Part of: MMUX Bash Pointers
  Contents: implementation of core file descriptor builtins
  Date: Oct  1, 2024

  Abstract

	This module implements core file descriptor builtins.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

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


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_open]]])
{
  int			flags;
  mode_t		mode = 0;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[flags]]],[[[argv[3]]]]);
  if (5 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARG_MODE([[[mode]]],[[[argv[4]]]]);
  }

  {
    int		rv = open(argv[2], flags, mode);
    if (-1 != rv) {
      return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_open]]],
    [[[((4 == argc) || (5 == argc))]]],
    [[["mmux_libc_open FDVAR FILENAME FLAGS [MODE]"]]],
    [[["Open a file, store the file descriptor in FDVAR."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_close]]])
{
  int	fd;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],[[[argv[1]]]]);

  {
    int		rv = close(fd);
    if (-1 != rv) {
      return MMUX_SUCCESS;
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_close]]],
    [[[(2 == argc)]]],
    [[["mmux_libc_close FD"]]],
    [[["Close a file descriptor."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_read]]])
{
  int		fd;
  void *	buffer;
  size_t	size;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_POINTER([[[buffer]]],	[[[argv[3]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_USIZE([[[size]]],		[[[argv[4]]]]);

  {
    ssize_t	done = read(fd, buffer, size);
    if (-1 != done) {
      return mmux_ssize_bind_to_variable(argv[1], done, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_read]]],
    [[[(5 == argc)]]],
    [[["mmux_libc_read DONEVAR FD BUFFER SIZE"]]],
    [[["Read SIZE bytes from FD and store them in BUFFER, store in DONEVAR the number of bytes read."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_write]]])
{
  int		fd;
  void *	buffer;
  size_t	size;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_POINTER([[[buffer]]],	[[[argv[3]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_USIZE([[[size]]],		[[[argv[4]]]]);

  {
    ssize_t	done = write(fd, buffer, size);
    if (-1 != done) {
      return mmux_ssize_bind_to_variable(argv[1], done, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_write]]],
    [[[(5 == argc)]]],
    [[["mmux_libc_write DONEVAR FD BUFFER SIZE"]]],
    [[["Write SIZE bytes to FD from BUFFER, store in DONEVAR the number of bytes written."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_pread]]])
{
  int		fd;
  void *	buffer;
  size_t	size;
  mmux_off_t	offset;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_POINTER([[[buffer]]],	[[[argv[3]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_USIZE([[[size]]],		[[[argv[4]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_OFF([[[offset]]],		[[[argv[5]]]]);

  {
    ssize_t	done = pread(fd, buffer, size, offset);
    if (-1 != done) {
      return mmux_ssize_bind_to_variable(argv[1], done, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_pread]]],
    [[[(6 == argc)]]],
    [[["mmux_libc_pread DONEVAR FD BUFFER SIZE OFFSET"]]],
    [[["Read SIZE bytes from FD, at OFFSET from the current position, and store them in BUFFER, store in DONEVAR the number of bytes read."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_pwrite]]])
{
  int		fd;
  void *	buffer;
  size_t	size;
  mmux_off_t	offset;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_POINTER([[[buffer]]],	[[[argv[3]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_USIZE([[[size]]],		[[[argv[4]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_OFF([[[offset]]],		[[[argv[5]]]]);

  {
    ssize_t	done = pwrite(fd, buffer, size, offset);
    if (-1 != done) {
      return mmux_ssize_bind_to_variable(argv[1], done, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_pwrite]]],
    [[[(6 == argc)]]],
    [[["mmux_libc_pwrite DONEVAR FD BUFFER SIZE OFFSET"]]],
    [[["Write SIZE bytes to FD, at OFFSET from the current position, from BUFFER, store in DONEVAR the number of bytes written."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_lseek]]])
{
  int		fd, whence;
  mmux_off_t	offset;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_OFF([[[offset]]],		[[[argv[3]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[whence]]],	[[[argv[4]]]]);

  {
    offset = lseek(fd, offset, whence);
    if (-1 != offset) {
      return mmux_off_bind_to_variable(argv[1], offset, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_lseek]]],
    [[[(5 == argc)]]],
    [[["mmux_libc_lseek OFFVAR FD OFFSET WHENCE"]]],
    [[["Change the file position of FD of OFFSET from WHENCE, store in OFFVAR the resulting file position."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_dup]]])
{
  int	fd;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]], [[[argv[2]]]]);

  {
    fd = dup(fd);
    if (-1 != fd) {
      return mmux_sint_bind_to_variable(argv[1], fd, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_dup]]],
    [[[(3 == argc)]]],
    [[["mmux_libc_dup FDVAR FD"]]],
    [[["Duplicate the file descriptor FD, store the result in FDVAR."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_dup2]]])
{
  int	rv, old_fd, new_fd;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[old_fd]]], [[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[new_fd]]], [[[argv[3]]]]);

  {
    rv = dup2(old_fd, new_fd);
    if (-1 != rv) {
      return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
    } else {
      return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
    }
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_dup2]]],
    [[[(4 == argc)]]],
    [[["mmux_libc_dup2 RVAR OLD_FD NEW_FD"]]],
    [[["Duplicate the file descriptor OLD_FD to NEW_FD, then close OLD_FD, store the result in RVAR."]]])



MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fcntl]]])
{
  int	fd, command;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[command]]],	[[[argv[3]]]]);

  switch (command) {
#if ((defined MMUX_HAVE_F_DUPFD) && (1 == MMUX_HAVE_F_DUPFD))
  case F_DUPFD:
    {
      if (5 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv, new_fd;

	MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[new_fd]]],	[[[argv[4]]]]);
	rv = fcntl(fd, command, new_fd);
	if (-1 != rv) {
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_GETFD) && (1 == MMUX_HAVE_F_GETFD))
  case F_GETFD:
    {
      if (4 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv;

	rv = fcntl(fd, command);
	if (-1 != rv) {
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_GETFL) && (1 == MMUX_HAVE_F_GETFL))
  case F_GETFL:
    {
      if (4 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv;

	rv = fcntl(fd, command);
	if (-1 != rv) {
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_GETLK) && (1 == MMUX_HAVE_F_GETLK))
  case F_GETLK:
    {
      goto mmux_error_parsing_builtin_argument;
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_GETOWN) && (1 == MMUX_HAVE_F_GETOWN))
  case F_GETOWN:
    {
      goto mmux_error_parsing_builtin_argument;
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_SETFD) && (1 == MMUX_HAVE_F_SETFD))
  case F_SETFD:
    {
      if (5 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv, flags;

	MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[flags]]],	[[[argv[4]]]]);

	rv = fcntl(fd, command, flags);
	if (-1 != rv) {
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_SETFL) && (1 == MMUX_HAVE_F_SETFL))
  case F_SETFL:
    {
      if (5 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv, flags;

	MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[flags]]],	[[[argv[4]]]]);

	rv = fcntl(fd, command, flags);
	if (-1 != rv) {
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_SETLKW) && (1 == MMUX_HAVE_F_SETLKW))
  case F_SETLKW:
    {
      goto mmux_error_parsing_builtin_argument;
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_SETLK) && (1 == MMUX_HAVE_F_SETLK))
  case F_SETLK:
    {
      goto mmux_error_parsing_builtin_argument;
    }
    break;
#endif
#if ((defined MMUX_HAVE_F_SETOWN) && (1 == MMUX_HAVE_F_SETOWN))
  case F_SETOWN:
    {
      goto mmux_error_parsing_builtin_argument;
    }
    break;
#endif
  default:
    fprintf(stderr, "%s: error: invalid command parameter \"%s\"\n", MMUX_BUILTIN_NAME_STR, argv[3]);
    goto mmux_error_parsing_builtin_argument;
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_fcntl]]],
    [[[(4 <= argc)]]],
    [[["mmux_libc_fcntl RVAR FD COMMAND ARG ..."]]],
    [[["Call fcntl with the given arguments, store the result in RVAR."]]])


MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_ioctl]]])
{
  int	fd, command;

  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[fd]]],		[[[argv[2]]]]);
  MMUX_BASH_PARSE_BUILTIN_ARG_SINT([[[command]]],	[[[argv[3]]]]);

  switch (command) {
#if ((defined MMUX_HAVE_SIOCATMARK) && (1 == MMUX_HAVE_SIOCATMARK))
  case SIOCATMARK:
    {
      if (5 != argc) {
	return mmux_bash_builtin_wrong_num_of_args();
      } else {
	int	rv, atmark;

	rv = ioctl(fd, command, &atmark);
	if (-1 != rv) {
	  mmux_sint_bind_to_variable(argv[4], atmark, MMUX_BUILTIN_NAME_STR);
	  return mmux_sint_bind_to_variable(argv[1], rv, MMUX_BUILTIN_NAME_STR);
	} else {
	  return mmux_bash_pointers_consume_errno(MMUX_BUILTIN_NAME_STR);
	}
      }
    }
    break;
#endif
  default:
    fprintf(stderr, "%s: error: invalid command parameter \"%s\"\n", MMUX_BUILTIN_NAME_STR, argv[3]);
    goto mmux_error_parsing_builtin_argument;
  }

  MMUX_BASH_BUILTIN_ARG_PARSER_ERROR_BRANCH;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[mmux_libc_ioctl]]],
    [[[(4 <= argc)]]],
    [[["mmux_libc_ioctl RVAR FD COMMAND ARG ..."]]],
    [[["Call ioctl with the given arguments, store the result in RVAR."]]])


/* end of file */
