/*
  Part of: MMUX Bash Pointers
  Contents: implementation of file system interface builtins
  Date: Nov 13, 2024

  Abstract

	This module implements file system interface builtins.

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
 ** Hard links.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_link]]])
{
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_system_pathname_t	newname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_link(oldname, newname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDNAME NEWNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_linkat]]])
{
  mmux_libc_file_descriptor_t		oldfd;
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_descriptor_t		newfd;
  mmux_libc_file_system_pathname_t	newname;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(oldfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(newfd,		3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,		5);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_linkat(oldfd, oldname, newfd, newname, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDFD OLDNAME NEWFD NEWNAME FLAGS"]]])


/** --------------------------------------------------------------------
 ** Symbolic links.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_symlink]]])
{
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_system_pathname_t	newname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_symlink(oldname, newname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDNAME NEWNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_readlink]]])
{
  mmux_asciizcp_t			pathname_varname;
  mmux_libc_file_system_pathname_t	linkname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pathname_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(linkname,		2);
  {
    mmux_libc_file_system_pathname_t	pathname;

    MMUX_LIBC_FUNCALL(mmux_libc_readlink_malloc(&pathname, linkname));
    return mmux_libc_ptn_bind_to_bash_variable_then_free(pathname_varname, pathname, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER REAL_PATHNAME_VAR PATHNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_readlinkat]]])
{
  mmux_asciizcp_t			pathname_varname;
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	linkname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pathname_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,			2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(linkname,		3);
  {
    mmux_libc_file_system_pathname_t	pathname;

    MMUX_LIBC_FUNCALL(mmux_libc_readlinkat_malloc(&pathname, dirfd, linkname));
    return mmux_libc_ptn_bind_to_bash_variable_then_free(pathname_varname, pathname, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER REAL_PATHNAME_VAR DIRFD PATHNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_canonicalize_file_name]]])
{
  mmux_asciizcp_t			result_pathname_varname;
  mmux_libc_file_system_pathname_t	in;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(result_pathname_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(in,				2);
  {
    mmux_libc_file_system_pathname_t	ou;

    MMUX_LIBC_FUNCALL(mmux_libc_canonicalize_file_name(&ou, in));
    return mmux_libc_ptn_bind_to_bash_variable_then_free(result_pathname_varname, ou, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER CANON_PATHNAME_VAR PATHNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_realpath]]])
{
  mmux_asciizcp_t			result_pathname_varname;
  mmux_libc_file_system_pathname_t	in;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(result_pathname_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(in,				2);
  {
    mmux_libc_file_system_pathname_t	ou;

    MMUX_LIBC_FUNCALL(mmux_libc_realpath(&ou, in));
    return mmux_libc_ptn_bind_to_bash_variable_then_free(result_pathname_varname, ou, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER CANON_PATHNAME_VAR PATHNAME"]]])


/** --------------------------------------------------------------------
 ** Deleting links.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_unlink]]])
{
  mmux_libc_file_system_pathname_t	pathname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_unlink(pathname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_unlinkat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,		3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_unlinkat(dirfd, pathname, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME FLAGS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_rmdir]]])
{
  mmux_libc_file_system_pathname_t	pathname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_rmdir(pathname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_remove]]])
{
  mmux_libc_file_system_pathname_t	pathname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_remove(pathname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME"]]])


/** --------------------------------------------------------------------
 ** Renaming.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_rename]]])
{
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_system_pathname_t	newname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_rename(oldname, newname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDNAME NEWNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_renameat]]])
{
  mmux_libc_file_descriptor_t		olddirfd;
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_descriptor_t		newdirfd;
  mmux_libc_file_system_pathname_t	newname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(olddirfd,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(newdirfd,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	4);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_renameat(olddirfd, oldname, newdirfd, newname));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDDIRFD OLDNAME NEWDIRFD NEWNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_renameat2]]])
{
  mmux_libc_file_descriptor_t		olddirfd;
  mmux_libc_file_system_pathname_t	oldname;
  mmux_libc_file_descriptor_t		newdirfd;
  mmux_libc_file_system_pathname_t	newname;
  mmux_uint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(olddirfd,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(oldname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(newdirfd,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(newname,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT(flags,		5);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_renameat2(olddirfd, oldname, newdirfd, newname, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLDDIRFD OLDNAME NEWDIRFD NEWNAME FLAGS"]]])


/** --------------------------------------------------------------------
 ** Directories.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_mkdir]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_mode_t				mode;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,		2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_mkdir(pathname, mode));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME MODE"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_mkdirat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_mode_t				mode;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,		3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_mkdirat(dirfd, pathname, mode));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME MODE"]]])


/** --------------------------------------------------------------------
 ** File ownership.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_chown]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_uid_t			uid;
  mmux_libc_gid_t			gid;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_UID(uid,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_GID(gid,		3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_chown(pathname, uid, gid));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME UID GID"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fchown]]])
{
  mmux_libc_file_descriptor_t	fd;
  mmux_libc_uid_t		uid;
  mmux_libc_gid_t		gid;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(fd,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_UID(uid,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_GID(gid,	3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fchown(fd, uid, gid));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER FD UID GID"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_lchown]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_uid_t			uid;
  mmux_libc_gid_t			gid;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_UID(uid,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_GID(gid,		3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_lchown(pathname, uid, gid));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME UID GID"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fchownat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_uid_t			uid;
  mmux_libc_gid_t			gid;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_UID(uid,		3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_GID(gid,		4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,		5);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fchownat(dirfd, pathname, uid, gid, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME UID GID FLAGS"]]])


/** --------------------------------------------------------------------
 ** File access permissions.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_umask]]])
{
  mmux_asciizcp_t	old_mask_varname;
  mmux_mode_t		new_mask;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(old_mask_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(new_mask,			2);
  {
    mmux_mode_t		old_mask;

    MMUX_LIBC_FUNCALL(mmux_libc_umask(&old_mask, new_mask));
    return mmux_mode_bind_to_bash_variable(old_mask_varname, old_mask, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLD_MASK_VAR NEW_MASK"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getumask]]])
{
  mmux_asciizcp_t	current_mask_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(current_mask_varname,	1);
  {
    mmux_mode_t		current_mask;

    MMUX_LIBC_FUNCALL(mmux_libc_getumask(&current_mask));
    return mmux_mode_bind_to_bash_variable(current_mask_varname, current_mask, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OLD_MASK_VAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_chmod]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_mode_t				mode;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,		2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_chmod(pathname, mode));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME MODE"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fchmod]]])
{
  mmux_libc_file_descriptor_t	fd;
  mmux_mode_t			mode;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(fd,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fchmod(fd, mode));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER FD MODE"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fchmodat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_mode_t				mode;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,		3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,		4);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fchmodat(dirfd, pathname, mode, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME MODE FLAGS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_access]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_sint_t				how;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(how,		2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_access(pathname, how));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME HOW"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_faccessat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_sint_t				how;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(how,		3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,		4);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_faccessat(dirfd, pathname, how, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME HOW FLAGS"]]])


/** --------------------------------------------------------------------
 ** Truncating file size.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_truncate]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_off_t				len;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_OFF(len,		2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_truncate(pathname, len));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME LEN"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_ftruncate]]])
{
  mmux_libc_file_descriptor_t	fd;
  mmux_off_t			len;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(fd,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_OFF(len,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_ftruncate(fd, len));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER FD LEN"]]])


/** --------------------------------------------------------------------
 ** File attributes.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_stat_calloc]]])
{
  mmux_asciizcp_t	pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pointer_varname,	1);
  {
    mmux_libc_stat_t *	stat_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_calloc(&stat_pointer, 1, sizeof(mmux_libc_stat_t)));
    return mmux_pointer_bind_to_bash_variable(pointer_varname, stat_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAT_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_mode]]],[[[mode]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_uid]]], [[[libc_uid]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_UID]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_gid]]], [[[libc_gid]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_GID]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_size]]],[[[off]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_OFF]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_ino]]], [[[uintmax]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINTMAX]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_dev]]], [[[uintmax]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINTMAX]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_nlink]]], [[[uintmax]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINTMAX]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_blocks]]], [[[uintmax]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINTMAX]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_blksize]]],[[[uint]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT]]])

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_atime_sec]]],[[[time]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_atime_nsec]]],[[[slong]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_mtime_sec]]],[[[time]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_mtime_nsec]]],[[[slong]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_ctime_sec]]],[[[time]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_stat_t]]],[[[st_ctime_nsec]]],[[[slong]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_SLONG]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_stat_dump]]])
{
  mmux_libc_stat_t *	stat_pointer;
  char const *		struct_name = "struct stat";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_file_descriptor_t		fd;

    MMUX_LIBC_FUNCALL(mmux_libc_stdou(&fd));
    MMUX_LIBC_FUNCALL(mmux_libc_stat_dump(fd, stat_pointer, struct_name));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAT_POINTER [STRUCT_NAME]"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_stat]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_stat_t *			stat_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_stat(pathname, stat_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME STAT_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fstat]]])
{
  mmux_libc_file_descriptor_t	fd;
  mmux_libc_stat_t *		stat_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(fd,			1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fstat(fd, stat_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER FD STAT_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_lstat]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_stat_t *			stat_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_lstat(pathname, stat_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME STAT_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_fstatat]]])
{
  mmux_libc_file_descriptor_t		dirfd;
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_stat_t *			stat_pointer;
  mmux_sint_t				flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(dirfd,			1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,			4);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_fstatat(dirfd, pathname, stat_pointer, flags));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER DIRFD PATHNAME STAT_POINTER FLAGS"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STAT_MODE_PREDICATE]]],[[[MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_S_$1]]])
{
  mmux_mode_t	mode;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_MODE(mode,	1);
  {
    bool	result;

    MMUX_LIBC_FUNCALL(mmux_libc_S_$1(&result, mode));
    return (result)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ST_MODE"]]])]]])

DEFINE_STAT_MODE_PREDICATE([[[ISDIR]]])
DEFINE_STAT_MODE_PREDICATE([[[ISCHR]]])
DEFINE_STAT_MODE_PREDICATE([[[ISBLK]]])
DEFINE_STAT_MODE_PREDICATE([[[ISREG]]])
DEFINE_STAT_MODE_PREDICATE([[[ISFIFO]]])
DEFINE_STAT_MODE_PREDICATE([[[ISLNK]]])
DEFINE_STAT_MODE_PREDICATE([[[ISSOCK]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STAT_PTR_PREDICATE]]],[[[MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_S_$1]]])
{
  mmux_libc_stat_t *	stat_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(stat_pointer,	1);
  {
    bool	result;

    MMUX_LIBC_FUNCALL(mmux_libc_S_$1(&result, stat_pointer));
    return (result)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAT_POINTER"]]])]]])

DEFINE_STAT_PTR_PREDICATE([[[TYPEISMQ]]])
DEFINE_STAT_PTR_PREDICATE([[[TYPEISSEM]]])
DEFINE_STAT_PTR_PREDICATE([[[TYPEISSHM]]])


/** --------------------------------------------------------------------
 ** File times.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_utimbuf_calloc]]])
{
  mmux_asciizcp_t	pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pointer_varname,	1);
  {
    mmux_libc_utimbuf_t *	utimbuf_pointer;

    MMUX_LIBC_FUNCALL(mmux_libc_calloc(&utimbuf_pointer, 1, sizeof(mmux_libc_utimbuf_t)));
    return mmux_pointer_bind_to_bash_variable(pointer_varname, utimbuf_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER UTIMBUF_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_utimbuf_t]]],[[[actime]]], [[[time]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])
DEFINE_MMUX_LIBC_STRUCT_SETTER_AND_GETTER([[[mmux_libc_utimbuf_t]]],[[[modtime]]],[[[time]]],[[[MMUX_BASH_PARSE_BUILTIN_ARGNUM_TIME]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_utimbuf_dump]]])
{
  mmux_libc_utimbuf_t *	utimbuf_pointer;
  char const *		struct_name = "struct utimbuf";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(utimbuf_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_file_descriptor_t		fd;

    MMUX_LIBC_FUNCALL(mmux_libc_stdou(&fd));
    MMUX_LIBC_FUNCALL(mmux_libc_utimbuf_dump(fd, utimbuf_pointer, struct_name));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER UTIMBUF_POINTER [STRUCT_NAME]"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_utime]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_utimbuf_t *			utimbuf_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(utimbuf_pointer,	2);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_utime(pathname, *utimbuf_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME UTIMBUF_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_utimes]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_timeval_t *			access_pointer;
  mmux_libc_timeval_t *			modification_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,			1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(access_pointer,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(modification_pointer,	3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_utimes(pathname, *access_pointer, *modification_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME ACCESS_TIMEVAL_POINTER MODIFICATION_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_lutimes]]])
{
  mmux_libc_file_system_pathname_t	pathname;
  mmux_libc_timeval_t *			access_pointer;
  mmux_libc_timeval_t *			modification_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_PTN(pathname,			1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(access_pointer,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(modification_pointer,	3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_lutimes(pathname, *access_pointer, *modification_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME ACCESS_POINTER MODIFICATION_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_futimes]]])
{
  mmux_libc_file_descriptor_t	fd;
  mmux_libc_timeval_t *		access_pointer;
  mmux_libc_timeval_t *		modification_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_LIBC_FD(fd	,			1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(access_pointer,		2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_TYPED_POINTER(modification_pointer,	3);
  {
    MMUX_LIBC_FUNCALL(mmux_libc_futimes(fd, *access_pointer, *modification_pointer));
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PATHNAME ACCESS_POINTER MODIFICATION_POINTER"]]])


/** --------------------------------------------------------------------
 ** Module initialisation.
 ** ----------------------------------------------------------------- */

mmux_bash_rv_t
mmux_bash_pointers_init_file_system_module (void)
{
  mmux_bash_rv_t	rv;

  rv = mmux_bash_create_global_sint_variable("mmux_libc_stat_SIZEOF",  sizeof(mmux_libc_stat_t), NULL);
  if (MMUX_SUCCESS != rv) { return rv; }

  rv = mmux_bash_create_global_sint_variable("mmux_libc_utimbuf_SIZEOF",  sizeof(mmux_libc_utimbuf_t), NULL);
  if (MMUX_SUCCESS != rv) { return rv; }

  return MMUX_SUCCESS;
}

/* end of file */
