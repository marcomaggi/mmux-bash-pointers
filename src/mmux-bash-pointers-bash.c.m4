/*
  Part of: MMUX Bash Pointers
  Contents: GNU Bash API
  Date: Sep 25, 2024

  Abstract

	As much as possible: everything Bash  should go here.  Ideally: Bash's header
	files should be inluded only here.

  Copyright (C) 2024 Marco Maggi <mrc.mgg@gmail.com>

  This program is free  software: you can redistribute it and/or  modify it under the
  terms of the  GNU Lesser General Public  License as published by  the Free Software
  Foundation, either version 3 of the License, or (at your option) any later version.

  This program  is distributed in the  hope that it  will be useful, but  WITHOUT ANY
  WARRANTY; without  even the implied  warranty of  MERCHANTABILITY or FITNESS  FOR A
  PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License along with
  this program.  If not, see <http://www.gnu.org/licenses/>.
*/


/** --------------------------------------------------------------------
 ** Headers.
 ** ----------------------------------------------------------------- */

#include "mmux-bash-pointers-internals.h"

/* We  really need  to pay  attention to  the order  in which  we include  the files,
   otherwise errors will ensue. */
#include "bashtypes.h"
#include "bashjmp.h"
#include "builtins.h"
#include "shell.h"
#include "common.h"


/** --------------------------------------------------------------------
 ** Shell builtins interface.
 ** ----------------------------------------------------------------- */

mmux_rv_t
mmux_bash_builtin_implementation_function (mmux_bash_word_list_t word_list,
					   mmux_bash_builtin_validate_argc_t * validate_argc,
                                           mmux_bash_builtin_custom_implementation_function_t * custom_implementation_function)
{
  WORD_LIST *	list = (WORD_LIST *) word_list;
  char **	argv;
  int		argc;
  int		rv;

  argv = make_builtin_argv(list, &argc);
  if (argv) {
    if (validate_argc(argc)) {
      rv = custom_implementation_function(argc, (char const * const *) argv);
    } else {
      builtin_usage();
      rv = EX_USAGE;
    }
    free(argv);
  } else {
    fprintf(stderr, "$1: error: internal error accessing list of builtin operands\n");
    rv = EXECUTION_FAILURE;
  }
  return rv;
}
mmux_rv_t
mmux_bash_builtin_implementation_function_no_options (mmux_bash_word_list_t word_list,
						      mmux_bash_builtin_validate_argc_t * validate_argc,
						      mmux_bash_builtin_custom_implementation_function_t * custom_implementation_function)
{
  WORD_LIST *	list = (WORD_LIST *) word_list;

  if (no_options(list)) {
    return (EX_USAGE);
  } else {
    char **	argv;
    int		argc;
    int		rv;

    argv = make_builtin_argv(list, &argc);
    if (argv) {
      if (validate_argc(argc)) {
	rv = custom_implementation_function(argc, (char const * const *) argv);
      } else {
	builtin_usage();
	rv = EX_USAGE;
      }
      free(argv);
    } else {
      fprintf(stderr, "$1: error: internal error accessing list of builtin operands\n");
      rv = EXECUTION_FAILURE;
    }
    return rv;
  }
}


/** --------------------------------------------------------------------
 ** Binding values to shell variables.
 ** ----------------------------------------------------------------- */

static int
store_string_in_variable (char const * variable_name, char const * const s_value, char const * const caller_name, bool global_variable)
{
  SHELL_VAR *	shell_variable MMUX_BASH_POINTERS_UNUSED;
  int		flags = 0;

  if (global_variable) {
    shell_variable = bind_global_variable(variable_name, (char *)s_value, flags);
  } else {
    shell_variable = bind_variable(variable_name, (char *)s_value, flags);
  }
  if (shell_variable) {
    return EXECUTION_SUCCESS;
  } else {
    if (caller_name) {
      if (global_variable) {
	fprintf(stderr, "%s: failed binding value to global shell variable: \"%s\"=\"%s\"\n", caller_name, variable_name, s_value);
      } else {
	fprintf(stderr, "%s: failed binding value to shell variable: \"%s\"=\"%s\"\n", caller_name, variable_name, s_value);
      }
    }
    return EXECUTION_FAILURE;
  }
}
int
mmux_bash_store_string_in_variable (char const * variable_name, char const * const s_value, char const * const caller_name)
{
  return store_string_in_variable(variable_name, s_value, caller_name, false);
}
int
mmux_bash_store_string_in_global_variable (char const * variable_name, char const * const s_value, char const * const caller_name)
{
  return store_string_in_variable(variable_name, s_value, caller_name, true);
}

/* ------------------------------------------------------------------ */

static int
store_sint_in_variable (char const * variable_name, int value, char const * const caller_name, bool global_variable)
{
  int	required_nbytes;

  /* Compute the number of required characters, INCLUDING the terminating zero. */
  {
    /* According to  the documentation,  when the  output is  truncated: "snprintf()"
       returns the number of required bytes, EXCLUDING the terminating null byte. */
    required_nbytes = snprintf(NULL, 0, "%d", value);
    if (0 > required_nbytes) {
      return EXECUTION_FAILURE;
    }
    ++required_nbytes;
  }

  /* Convert the value to string then store it. */
  {
    char	s_value[required_nbytes];
    int		to_be_written_chars;

    /* According  to  the documentation:  "snprintf()"  writes  the terminating  null
       byte. */
    to_be_written_chars = snprintf(s_value, required_nbytes, "%d", value);
    if (required_nbytes == (1+to_be_written_chars)) {
      return store_string_in_variable(variable_name, s_value, caller_name, global_variable);
    } else {
      return EXECUTION_FAILURE;
    }
  }
}

int
mmux_bash_store_sint_in_variable (char const * variable_name, int value, char const * const caller_name)
{
  return store_sint_in_variable(variable_name, value, caller_name, false);
}
int
mmux_bash_store_sint_in_global_variable (char const * variable_name, int value, char const * const caller_name)
{
  return store_sint_in_variable(variable_name, value, caller_name, true);
}

/* ------------------------------------------------------------------ */

int
mmux_bash_create_global_string_variable (char const * const variable_name, char const * const s_value, char const * const caller_name)
{
  SHELL_VAR	* shell_variable = find_global_variable(variable_name);

  if (NULL == shell_variable) {
    return mmux_bash_store_string_in_global_variable(variable_name, s_value, caller_name);
  } else {
    if (caller_name) {
      fprintf(stderr, "%s: failed creation of global variable, it already exists: \"%s\"\n", caller_name, variable_name);
    }
    return EXECUTION_FAILURE;
  }
}
int
mmux_bash_create_global_sint_variable (char const * const variable_name, int value, char const * const caller_name)
{
  int	required_nbytes;

  /* Compute the number of required characters, INCLUDING the terminating zero. */
  {
    /* According to  the documentation,  when the  output is  truncated: "snprintf()"
       returns the number of required bytes, EXCLUDING the terminating null byte. */
    required_nbytes = snprintf(NULL, 0, "%d", value);
    if (0 > required_nbytes) {
      return EXECUTION_FAILURE;
    }
    ++required_nbytes;
  }

  /* Convert the value to string then store it. */
  {
    char	s_value[required_nbytes];
    int		to_be_written_chars;

    /* According  to  the documentation:  "snprintf()"  writes  the terminating  null
       byte. */
    to_be_written_chars = snprintf(s_value, required_nbytes, "%d", value);
    if (required_nbytes == (1+to_be_written_chars)) {
      return mmux_bash_create_global_string_variable(variable_name, s_value, caller_name);
    } else {
      if (caller_name) {
	fprintf(stderr, "%s: failed creation of global sint variable, conversion error: \"%s\"=\"%d\"\n",
		caller_name, variable_name, value);
      }
      return EXECUTION_FAILURE;
    }
  }
}


/** --------------------------------------------------------------------
 ** Retrieving values from shell variables.
 ** ----------------------------------------------------------------- */

int
mmux_bash_get_shell_variable_string_value (char const ** p_variable_value, char const * const variable_name,
					   char const * const caller_name)
{
  SHELL_VAR *		shell_variable;

  shell_variable = find_variable(variable_name);
  if (shell_variable && var_isset(shell_variable)) {
    *p_variable_value = value_cell(shell_variable);
    return EXECUTION_SUCCESS;
  } else {
    if (caller_name) {
      fprintf(stderr, "%s: error: failed access to shell variable: \"%s\"\n", caller_name, variable_name);
    }
    return EXECUTION_FAILURE;
  }
}

/* end of file */
