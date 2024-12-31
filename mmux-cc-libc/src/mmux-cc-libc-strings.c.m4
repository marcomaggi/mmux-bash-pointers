/*
  Part of: MMUX CC Libc
  Contents: string operations
  Date: Dec 31, 2024

  Abstract

	This module implements the strings API.

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

#include <mmux-cc-libc-internals.h>


/** --------------------------------------------------------------------
 ** Inspection.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr)
{
  *result_len_p = strlen(ptr);
  return false;
}
bool
mmux_libc_strnlen (mmux_usize_t * result_len_p, mmux_asciizcp_t ptr, mmux_usize_t maxlen)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNLEN]]],[[[
  *result_len_p = strnlen(ptr, maxlen);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Copying.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcpy (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr)
{
  strcpy(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_strncpy (mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t len)
{
  strncpy(dst_ptr, src_ptr, len);
  return false;
}
bool
mmux_libc_stpcpy(mmux_asciizp_t * result_after_ptr_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr)
{
  *result_after_ptr_p = stpcpy(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_stpncpy(mmux_asciizp_t * result_after_ptr_p, mmux_pointer_t dst_ptr, mmux_pointer_t src_ptr, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STPNCPY]]],[[[
  *result_after_ptr_p = stpncpy(dst_ptr, src_ptr, len);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Duplicating.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strdup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr)
{
  mmux_asciizcp_t	oustr_p = strdup(instr);

  if (NULL != oustr_p) {
    *result_oustr_p = oustr_p;
    return false;
  } else {
    return true;
  }
}
bool
mmux_libc_strndup (mmux_asciizcp_t * result_oustr_p, mmux_asciizcp_t instr, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNDUP]]],[[[
  mmux_asciizcp_t	oustr_p = strndup(instr, len);

  if (NULL != oustr_p) {
    *result_oustr_p = oustr_p;
    return false;
  } else {
    return true;
  }
]]])
}


/** --------------------------------------------------------------------
 ** Concatenating.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr)
{
  strcat(dst_ptr, src_ptr);
  return false;
}
bool
mmux_libc_strncat (mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
  strncat(dst_ptr, src_ptr, len);
  return false;
}


/** --------------------------------------------------------------------
 ** Comparing.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
  *result_p = strcmp(ptr2, ptr1);
  return false;
}
bool
mmux_libc_strncmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
{
  *result_p = strncmp(ptr2, ptr1, len);
  return false;
}
bool
mmux_libc_strcasecmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRCASECMP]]],[[[
  *result_p = strcasecmp(ptr2, ptr1);
  return false;
]]])
}
bool
mmux_libc_strncasecmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1, mmux_usize_t len)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRNCASECMP]]],[[[
  *result_p = strncasecmp(ptr2, ptr1, len);
  return false;
]]])
}
bool
mmux_libc_strverscmp (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
MMUX_CONDITIONAL_FUNCTION_BODY([[[HAVE_STRVERSCMP]]],[[[
  *result_p = strverscmp(ptr2, ptr1);
  return false;
]]])
}


/** --------------------------------------------------------------------
 ** Collation.
 ** ----------------------------------------------------------------- */

bool
mmux_libc_strcoll (mmux_sint_t * result_p, mmux_asciizcp_t ptr2, mmux_asciizcp_t ptr1)
{
  *result_p = strcoll(ptr2, ptr1);
  return false;
}
bool
mmux_libc_strxfrm (mmux_usize_t * result_size_p, mmux_asciizp_t dst_ptr, mmux_asciizcp_t src_ptr, mmux_usize_t len)
{
  *result_size_p = strxfrm(dst_ptr, src_ptr, len);
  return false;
}


/* end of file */