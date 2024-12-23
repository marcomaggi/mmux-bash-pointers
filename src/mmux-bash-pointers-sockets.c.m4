/*
  Part of: MMUX Bash Pointers
  Contents: implementation of sockets builtins
  Date: Nov 18, 2024

  Abstract

	This module implements sockets builtins.

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

#undef  IS_POINTER_REPRESENTATION
#define IS_POINTER_REPRESENTATION(ARGVJ)	((2 < strlen(ARGVJ)) && ('0' == ARGVJ[0]) && ('1' == ARGVJ[1]))


/** --------------------------------------------------------------------
 ** Helpers.
 ** ----------------------------------------------------------------- */

typedef FILE *					mmux_libc_stream_t;

typedef struct addrinfo				mmux_libc_addrinfo_tag_t;
typedef mmux_libc_addrinfo_tag_t *		mmux_libc_addrinfo_t;

typedef struct sockaddr				mmux_libc_sockaddr_tag_t;
typedef mmux_libc_sockaddr_tag_t *		mmux_libc_sockaddr_t;

typedef struct sockaddr_un			mmux_libc_sockaddr_un_tag_t;
typedef mmux_libc_sockaddr_un_tag_t *		mmux_libc_sockaddr_un_t;

typedef struct sockaddr_in			mmux_libc_sockaddr_in_tag_t;
typedef mmux_libc_sockaddr_in_tag_t *		mmux_libc_sockaddr_in_t;

typedef struct sockaddr_in6			mmux_libc_sockaddr_insix_tag_t;
typedef mmux_libc_sockaddr_insix_tag_t *	mmux_libc_sockaddr_insix_t;

typedef struct hostent				mmux_libc_hostent_tag_t;
typedef mmux_libc_hostent_tag_t *		mmux_libc_hostent_t;

typedef struct servent				mmux_libc_servent_tag_t;
typedef mmux_libc_servent_tag_t *		mmux_libc_servent_t;

typedef struct protoent				mmux_libc_protoent_tag_t;
typedef mmux_libc_protoent_tag_t *		mmux_libc_protoent_t;

typedef struct netent				mmux_libc_netent_tag_t;
typedef mmux_libc_netent_tag_t *		mmux_libc_netent_t;

/* ------------------------------------------------------------------ */

static void
sa_family_to_asciiz_name(char const ** name_p, int sa_family)
{
  switch (sa_family) {
#if (defined MMUX_HAVE_AF_ALG)
  case AF_ALG:
    *name_p = "AF_ALG";
    break;
#endif
#if (defined MMUX_HAVE_AF_APPLETALK)
  case AF_APPLETALK:
    *name_p = "AF_APPLETALK";
    break;
#endif
#if (defined MMUX_HAVE_AF_AX25)
  case AF_AX25:
    *name_p = "AF_AX25";
    break;
#endif
#if (defined MMUX_HAVE_AF_BLUETOOTH)
  case AF_BLUETOOTH:
    *name_p = "AF_BLUETOOTH";
    break;
#endif
#if (defined MMUX_HAVE_AF_CAN)
  case AF_CAN:
    *name_p = "AF_CAN";
    break;
#endif
#if (defined MMUX_HAVE_AF_DECnet)
  case AF_DECnet:
    *name_p = "AF_DECnet";
    break;
#endif
#if (defined MMUX_HAVE_AF_IB)
  case AF_IB:
    *name_p = "AF_IB";
    break;
#endif
#if (defined MMUX_HAVE_AF_INET6)
  case AF_INET6:
    *name_p = "AF_INET6";
    break;
#endif
#if (defined MMUX_HAVE_AF_INET)
  case AF_INET:
    *name_p = "AF_INET";
    break;
#endif
#if (defined MMUX_HAVE_AF_IPX)
  case AF_IPX:
    *name_p = "AF_IPX";
    break;
#endif
#if (defined MMUX_HAVE_AF_KCM)
  case AF_KCM:
    *name_p = "AF_KCM";
    break;
#endif
#if (defined MMUX_HAVE_AF_KEY)
  case AF_KEY:
    *name_p = "AF_KEY";
    break;
#endif
#if (defined MMUX_HAVE_AF_LLC)
  case AF_LLC:
    *name_p = "AF_LLC";
    break;
#endif
#if (defined MMUX_HAVE_AF_LOCAL)
  case AF_LOCAL:
    *name_p = "AF_LOCAL";
    break;
#endif
#if (defined MMUX_HAVE_AF_MPLS)
  case AF_MPLS:
    *name_p = "AF_MPLS";
    break;
#endif
#if (defined MMUX_HAVE_AF_NETLINK)
  case AF_NETLINK:
    *name_p = "AF_NETLINK";
    break;
#endif
#if (defined MMUX_HAVE_AF_PACKET)
  case AF_PACKET:
    *name_p = "AF_PACKET";
    break;
#endif
#if (defined MMUX_HAVE_AF_PPPOX)
  case AF_PPPOX:
    *name_p = "AF_PPPOX";
    break;
#endif
#if (defined MMUX_HAVE_AF_RDS)
  case AF_RDS:
    *name_p = "AF_RDS";
    break;
#endif
#if (defined MMUX_HAVE_AF_TIPC)
  case AF_TIPC:
    *name_p = "AF_TIPC";
    break;
#endif
#if (defined MMUX_HAVE_AF_UNSPEC)
  case AF_UNSPEC:
    *name_p = "AF_UNSPEC";
    break;
#endif
#if (defined MMUX_HAVE_AF_VSOCK)
  case AF_VSOCK:
    *name_p = "AF_VSOCK";
    break;
#endif
#if (defined MMUX_HAVE_AF_X25)
  case AF_X25:
    *name_p = "AF_X25";
    break;
#endif
#if (defined MMUX_HAVE_AF_XDP)
  case AF_XDP:
    *name_p = "AF_XDP";
    break;
#endif
  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static void
sa_socktype_to_asciiz_name(char const ** name_p, int sa_socktype)
{
  switch (sa_socktype) {
#if (defined MMUX_HAVE_SOCK_STREAM)
  case SOCK_STREAM:
    *name_p = "SOCK_STREAM";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_DGRAM)
  case SOCK_DGRAM:
    *name_p = "SOCK_DGRAM";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_DCCP)
  case SOCK_DCCP:
    *name_p = "SOCK_DCCP";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_PACKET)
  case SOCK_PACKET:
    *name_p = "SOCK_PACKET";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_RAW)
  case SOCK_RAW:
    *name_p = "SOCK_RAW";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_RDM)
  case SOCK_RDM:
    *name_p = "SOCK_RDM";
    break;
#endif

#if (defined MMUX_HAVE_SOCK_SEQPACKET)
  case SOCK_SEQPACKET:
    *name_p = "SOCK_SEQPACKET";
    break;
#endif

  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static void
sa_ipproto_to_asciiz_name(char const ** name_p, int sa_ipproto)
{
  switch (sa_ipproto) {
#if (defined MMUX_HAVE_IPPROTO_AH)
  case IPPROTO_AH:
    *name_p = "IPPROTO_AH";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_BEETPH)
  case IPPROTO_BEETPH:
    *name_p = "IPPROTO_BEETPH";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_COMP)
  case IPPROTO_COMP:
    *name_p = "IPPROTO_COMP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_DCCP)
  case IPPROTO_DCCP:
    *name_p = "IPPROTO_DCCP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_EGP)
  case IPPROTO_EGP:
    *name_p = "IPPROTO_EGP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_ENCAP)
  case IPPROTO_ENCAP:
    *name_p = "IPPROTO_ENCAP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_ESP)
  case IPPROTO_ESP:
    *name_p = "IPPROTO_ESP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_ETHERNET)
  case IPPROTO_ETHERNET:
    *name_p = "IPPROTO_ETHERNET";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_GRE)
  case IPPROTO_GRE:
    *name_p = "IPPROTO_GRE";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_ICMP)
  case IPPROTO_ICMP:
    *name_p = "IPPROTO_ICMP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_IDP)
  case IPPROTO_IDP:
    *name_p = "IPPROTO_IDP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_IGMP)
  case IPPROTO_IGMP:
    *name_p = "IPPROTO_IGMP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_IP)
  case IPPROTO_IP:
    *name_p = "IPPROTO_IP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_IPIP)
  case IPPROTO_IPIP:
    *name_p = "IPPROTO_IPIP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_IPV6)
  case IPPROTO_IPV6:
    *name_p = "IPPROTO_IPV6";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_MPLS)
  case IPPROTO_MPLS:
    *name_p = "IPPROTO_MPLS";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_MPTCP)
  case IPPROTO_MPTCP:
    *name_p = "IPPROTO_MPTCP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_MTP)
  case IPPROTO_MTP:
    *name_p = "IPPROTO_MTP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_PIM)
  case IPPROTO_PIM:
    *name_p = "IPPROTO_PIM";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_PUP)
  case IPPROTO_PUP:
    *name_p = "IPPROTO_PUP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_RAW)
  case IPPROTO_RAW:
    *name_p = "IPPROTO_RAW";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_RSVP)
  case IPPROTO_RSVP:
    *name_p = "IPPROTO_RSVP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_SCTP)
  case IPPROTO_SCTP:
    *name_p = "IPPROTO_SCTP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_TCP)
  case IPPROTO_TCP:
    *name_p = "IPPROTO_TCP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_TP)
  case IPPROTO_TP:
    *name_p = "IPPROTO_TP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_UDP)
  case IPPROTO_UDP:
    *name_p = "IPPROTO_UDP";
    break;
#endif

#if (defined MMUX_HAVE_IPPROTO_UDPLITE)
  case IPPROTO_UDPLITE:
    *name_p = "IPPROTO_UDPLITE";
    break;
#endif

  default:
    break;
  }
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_sockaddr_un_dump (mmux_libc_stream_t stream, mmux_libc_sockaddr_un_t sockaddr_un_pointer, char const * struct_name)
{
  int	rv;

  {
    char const *	sun_name = "unknown";

    sa_family_to_asciiz_name(&sun_name, sockaddr_un_pointer->sun_family);
    rv = fprintf(stream, "%s.sun_family = \"%d\" (%s)\n", struct_name, sockaddr_un_pointer->sun_family, sun_name);
    if (0 > rv) { return true; }
  }

  {
    rv = fprintf(stream, "%s.sun_path = \"%s\"\n", struct_name, sockaddr_un_pointer->sun_path);
    if (0 > rv) { return true; }
  }
  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_sockaddr_in_dump (mmux_libc_stream_t stream, mmux_libc_sockaddr_in_t sockaddr_in_pointer, char const * struct_name)
{
  int	rv;

  {
    char const *	sin_name = "unknown";

    sa_family_to_asciiz_name(&sin_name, sockaddr_in_pointer->sin_family);
    rv = fprintf(stream, "%s.sin_family = \"%d\" (%s)\n", struct_name, sockaddr_in_pointer->sin_family, sin_name);
    if (0 > rv) { return true; }
  }

  {
#undef  presentation_len
#define presentation_len	512
    char	presentation_buf[presentation_len];

    inet_ntop(sockaddr_in_pointer->sin_family, &(sockaddr_in_pointer->sin_addr), presentation_buf, presentation_len);
    presentation_buf[presentation_len-1] = '\0';
    rv = fprintf(stream, "%s.sin_addr = \"%s\"\n", struct_name, presentation_buf);
    if (0 > rv) { return true; }
  }

  {
    rv = fprintf(stream, "%s.sin_port = \"%d\"\n", struct_name, ntohs(sockaddr_in_pointer->sin_port));
    if (0 > rv) { return true; }
  }
  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_sockaddr_insix_dump (mmux_libc_stream_t stream, mmux_libc_sockaddr_insix_t sockaddr_in6_pointer, char const * const struct_name)
{
  int	rv;

  {
    char const *	sin6_name = "unknown";

    sa_family_to_asciiz_name(&sin6_name, sockaddr_in6_pointer->sin6_family);
    rv = fprintf(stream, "%s.sin6_family = \"%d\" (%s)\n", struct_name, sockaddr_in6_pointer->sin6_family, sin6_name);
    if (0 > rv) { return true; }
  }

  {
#undef  presentation_len
#define presentation_len	512
    char	presentation_buf[presentation_len];

    inet_ntop(sockaddr_in6_pointer->sin6_family, &(sockaddr_in6_pointer->sin6_addr), presentation_buf, presentation_len);
    presentation_buf[presentation_len-1] = '\0';
    rv = fprintf(stream, "%s.sin6_addr = \"%s\"\n", struct_name, presentation_buf);
    if (0 > rv) { return true; }
  }

  rv = fprintf(stream, "%s.sin6_flowinfo = \"%lu\"\n", struct_name, (mmux_ulong_t)(sockaddr_in6_pointer->sin6_flowinfo));
  if (0 > rv) { return true; }

  rv = fprintf(stream, "%s.sin6_scope_id = \"%lu\"\n", struct_name, (mmux_ulong_t)(sockaddr_in6_pointer->sin6_scope_id));
  if (0 > rv) { return true; }

  rv = fprintf(stream, "%s.sin6_port = \"%d\"\n", struct_name, ntohs(sockaddr_in6_pointer->sin6_port));
  if (0 > rv) { return true; }

  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_hostent_dump (mmux_libc_stream_t stream, mmux_libc_hostent_t hostent_pointer, char const * struct_name)
{
  int	aliases_idx   = 0;
  int	addr_list_idx = 0;
  int	rv;

  rv = fprintf(stream, "%s.h_name = \"%s\"\n", struct_name, hostent_pointer->h_name);

  if (NULL != hostent_pointer->h_aliases) {
    for (; hostent_pointer->h_aliases[aliases_idx]; ++aliases_idx) {
      rv = fprintf(stream, "%s.h_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, hostent_pointer->h_aliases[aliases_idx]);
      if (0 > rv) { return true; }
    }
  }
  if (0 == aliases_idx) {
    rv = fprintf(stream, "%s.h_aliases = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  rv = fprintf(stream, "%s.h_addrtype = \"%d\"", struct_name, hostent_pointer->h_addrtype);
  if (0 > rv) { return true; }

  switch (hostent_pointer->h_addrtype) {
  case AF_INET:
    rv = fprintf(stream, " (AF_INET)\n");
    if (0 > rv) { return true; }
    break;
  case AF_INET6:
    rv = fprintf(stream, " (AF_INET6)\n");
    if (0 > rv) { return true; }
    break;
  default:
    rv = fprintf(stream, "\n");
    if (0 > rv) { return true; }
    break;
  }

  rv = fprintf(stream, "%s.h_length = \"%d\"\n", struct_name, hostent_pointer->h_length);
  if (0 > rv) { return true; }

  if (NULL != hostent_pointer->h_addr_list) {
    for (; hostent_pointer->h_addr_list[addr_list_idx]; ++addr_list_idx) {
#undef  presentation_len
#define presentation_len	512
      char	presentation_buf[presentation_len];

      inet_ntop(hostent_pointer->h_addrtype, hostent_pointer->h_addr_list[addr_list_idx], presentation_buf, presentation_len);
      presentation_buf[presentation_len-1] = '\0';
      rv = fprintf(stream, "%s.h_addr_list[%d] = \"%s\"\n", struct_name, addr_list_idx, presentation_buf);
      if (0 > rv) { return true; }
    }
  }
  if (0 == addr_list_idx) {
    rv = fprintf(stream, "%s.h_addr_list = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  if (NULL != hostent_pointer->h_addr) {
#undef  presentation_len
#define presentation_len	512
    char	presentation_buf[presentation_len];

    inet_ntop(hostent_pointer->h_addrtype, hostent_pointer->h_addr, presentation_buf, presentation_len);
    presentation_buf[presentation_len-1] = '\0';
    rv = fprintf(stream, "%s.h_addr = \"%s\"\n", struct_name, presentation_buf);
    if (0 > rv) { return true; }
  } else {
    rv = fprintf(stream, "%s.h_addr = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_servent_dump (mmux_libc_stream_t stream, mmux_libc_servent_t servent_pointer, char const * const struct_name)
{
  int	aliases_idx = 0;
  int	rv;

  rv = fprintf(stream, "%s.s_name = \"%s\"\n", struct_name, servent_pointer->s_name);
  if (0 > rv) { return true; }

  if (NULL != servent_pointer->s_aliases) {
    for (; servent_pointer->s_aliases[aliases_idx]; ++aliases_idx) {
      rv = fprintf(stream, "%s.s_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, servent_pointer->s_aliases[aliases_idx]);
      if (0 > rv) { return true; }
    }
  }
  if (0 == aliases_idx) {
    rv = fprintf(stream, "%s.s_aliases = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  rv = fprintf(stream, "%s.s_port = \"%d\"\n", struct_name, ntohs(servent_pointer->s_port));
  if (0 > rv) { return true; }

  rv = fprintf(stream, "%s.s_proto = \"%s\"\n", struct_name, servent_pointer->s_proto);
  if (0 > rv) { return true; }

  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_protoent_dump (mmux_libc_stream_t stream, mmux_libc_protoent_t protoent_pointer, char const * struct_name)
{
  int	aliases_idx = 0;
  int	rv;

  rv = fprintf(stream, "%s.s_name = \"%s\"\n", struct_name, protoent_pointer->p_name);
  if (0 > rv) { return true; }

  if (NULL != protoent_pointer->p_aliases) {
    for (; protoent_pointer->p_aliases[aliases_idx]; ++aliases_idx) {
      rv = fprintf(stream, "%s.s_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, protoent_pointer->p_aliases[aliases_idx]);
      if (0 > rv) { return true; }
    }
  }
  if (0 == aliases_idx) {
    rv = fprintf(stream, "%s.s_aliases = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  rv = fprintf(stream, "%s.s_proto = \"%d\"\n", struct_name, protoent_pointer->p_proto);
  if (0 > rv) { return true; }

  return false;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_netent_dump (mmux_libc_stream_t stream, mmux_libc_netent_t netent_pointer, char const * struct_name)
{
  int	aliases_idx = 0;
  int	rv;

  rv = fprintf(stream, "%s.n_name = \"%s\"\n", struct_name, netent_pointer->n_name);
  if (0 > rv) { return true; }

  if (NULL != netent_pointer->n_aliases) {
    for (; netent_pointer->n_aliases[aliases_idx]; ++aliases_idx) {
      rv = fprintf(stream, "%s.n_aliases[%d] = \"%s\"\n", struct_name, aliases_idx, netent_pointer->n_aliases[aliases_idx]);
      if (0 > rv) { return true; }
    }
  }
  if (0 == aliases_idx) {
    rv = fprintf(stream, "%s.n_aliases = \"0x0\"\n", struct_name);
    if (0 > rv) { return true; }
  }

  rv = fprintf(stream, "%s.n_addrtype = \"%d\"\n", struct_name, netent_pointer->n_addrtype);
  if (0 > rv) { return true; }

  /* The value "netent_pointer->n_net" is in host byte order. */
  {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK	512
    char		net_str[IS_THIS_ENOUGH_QUESTION_MARK];
    mmux_uint32_t	network_byteorder_net = htonl(netent_pointer->n_net);

    inet_ntop(netent_pointer->n_addrtype, &(network_byteorder_net), net_str, (mmux_socklen_t)IS_THIS_ENOUGH_QUESTION_MARK);

    rv = fprintf(stream, "%s.n_net = \"%lu\" (%s)\n", struct_name, (mmux_ulong_t)(netent_pointer->n_net), net_str);
    if (0 > rv) { return true; }
  }
  return MMUX_SUCCESS;
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_sockaddr_dump (mmux_libc_stream_t stream, mmux_libc_sockaddr_t sockaddr_pointer, char const * const struct_name)
{
  int	rv;

  {
    char const *	family_name = "unknown";

    sa_family_to_asciiz_name(&family_name, sockaddr_pointer->sa_family);
    rv = fprintf(stream, "%s.sa_family = \"%d\" (%s)\n", struct_name, (sockaddr_pointer->sa_family), family_name);
    if (0 > rv) { return true; }
  }

  switch (sockaddr_pointer->sa_family) {
  case AF_INET:
    return mmux_libc_sockaddr_in_dump(stream, (mmux_libc_sockaddr_in_t)sockaddr_pointer, struct_name);

  case AF_INET6:
    return mmux_libc_sockaddr_insix_dump(stream, (mmux_libc_sockaddr_insix_t)sockaddr_pointer, struct_name);

  case AF_LOCAL:
    return mmux_libc_sockaddr_un_dump(stream, (mmux_libc_sockaddr_un_t)sockaddr_pointer, struct_name);

  default:
    return false;
  }
}

/* ------------------------------------------------------------------ */

static bool
mmux_libc_addrinfo_dump (mmux_libc_stream_t stream, mmux_libc_addrinfo_t addrinfo_pointer, char const * struct_name)
{
  int	rv;

  /* Inspect the field: ai_flags */
  {
    bool	not_first_flags = false;

    rv = fprintf(stream, "%s.ai_flags = \"%d\"", struct_name, addrinfo_pointer->ai_flags);
    if (0 > rv) { return true; }

    if (AI_ADDRCONFIG & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_ADDRCONFIG");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_ADDRCONFIG");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_ALL & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_ALL");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_ALL");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_CANONIDN & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_CANONIDN");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_CANONIDN");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_CANONNAME & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_CANONNAME");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_CANONNAME");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_IDN & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_IDN");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_IDN");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_NUMERICSERV & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_NUMERICSERV");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_NUMERICSERV");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_PASSIVE & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_PASSIVE");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_PASSIVE");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (AI_V4MAPPED & addrinfo_pointer->ai_flags ) {
      if (not_first_flags) {
	rv = fprintf(stream, " | AI_V4MAPPED");
	if (0 > rv) { return true; }
      } else {
	rv = fprintf(stream, " (AI_V4MAPPED");
	if (0 > rv) { return true; }
	not_first_flags = true;
      }
    }

    if (not_first_flags) {
      rv = fprintf(stream, ")\n");
      if (0 > rv) { return true; }
    } else {
      rv = fprintf(stream, "\n");
      if (0 > rv) { return true; }
    }
  }

  /* Inspect the field: ai_family */
  {
    char const *	ai_name = "unknown";

    sa_family_to_asciiz_name(&ai_name, addrinfo_pointer->ai_family);
    rv = fprintf(stream, "%s.ai_family = \"%d\" (%s)\n", struct_name, addrinfo_pointer->ai_family, ai_name);
    if (0 > rv) { return true; }
  }

  /* Inspect the field: ai_socktype */
  {
    char const *	ai_name = "unknown";

    sa_socktype_to_asciiz_name(&ai_name, addrinfo_pointer->ai_socktype);
    rv = fprintf(stream, "%s.ai_socktype = \"%d\" (%s)\n", struct_name, addrinfo_pointer->ai_socktype, ai_name);
    if (0 > rv) { return true; }
  }

  /* Inspect the field: ai_protocol */
  {
    char const *	ai_name = "unknown";

    sa_ipproto_to_asciiz_name(&ai_name, addrinfo_pointer->ai_protocol);
    rv = fprintf(stream, "%s.ai_protocol = \"%d\" (%s)\n", struct_name, addrinfo_pointer->ai_protocol, ai_name);
    if (0 > rv) { return true; }
  }

  /* Inspect the field: ai_addrlen */
  {
    char const *	known_struct_name = "unknown struct type";

    switch (addrinfo_pointer->ai_addrlen) {
    case sizeof(mmux_libc_sockaddr_in_tag_t):
      known_struct_name ="struct sockaddr_in";
      break;

    case sizeof(mmux_libc_sockaddr_insix_tag_t):
      known_struct_name ="struct sockaddr_in6";
      break;

    case sizeof(mmux_libc_sockaddr_un_tag_t):
      known_struct_name ="struct sockaddr_un";
      break;
    }

    rv = fprintf(stream, "%s.ai_addrlen = \"%d\" (%s)\n", struct_name, addrinfo_pointer->ai_addrlen, known_struct_name);
    if (0 > rv) { return true; }
  }

  /* Inspect the field: ai_addr, it is a pointer to "struct sockaddr" */
  {
    size_t	buflen = 1024;
    char	bufstr[buflen];

    memset(bufstr, '\0', buflen);
    inet_ntop(addrinfo_pointer->ai_family, &(addrinfo_pointer->ai_addr), bufstr, buflen);

    rv = fprintf(stream, "%s.ai_addr = \"%p\" (%s)\n", struct_name, (mmux_pointer_t)(addrinfo_pointer->ai_addr), bufstr);
    if (0 > rv) { return true; }
  }

  /* Inspect the field: ai_canonname */
  {
    if (addrinfo_pointer->ai_canonname) {
      rv = fprintf(stream, "%s.ai_canonname = \"%p\" (%s)\n", struct_name,
		   (mmux_pointer_t)(addrinfo_pointer->ai_canonname),
		   addrinfo_pointer->ai_canonname);
      if (0 > rv) { return true; }
    } else {
      rv = fprintf(stream, "%s.ai_canonname = \"%p\"\n", struct_name, (mmux_pointer_t)(addrinfo_pointer->ai_canonname));
      if (0 > rv) { return true; }
    }
  }

  /* Inspect the field: ai_next */
  {
    rv = fprintf(stream, "%s.ai_next = \"%p\"\n", struct_name, (mmux_pointer_t)(addrinfo_pointer->ai_next));
    if (0 > rv) { return true; }
  }

  return false;
}


/** --------------------------------------------------------------------
 ** Sockets: struct sockaddr.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sa_family_ref]]])
{
  char const *		sa_family_varname;
  mmux_pointer_t	_sockaddr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sa_family_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_pointer,	2);
  {
    struct sockaddr *	sockaddr_pointer = _sockaddr_pointer;

    return mmux_sshort_bind_to_bash_variable(sa_family_varname, sockaddr_pointer->sa_family, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SA_FAMILY_VAR SOCKADDR_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_dump]]])
{
  mmux_pointer_t	_sockaddr_pointer;
  char const *		struct_name = "struct sockaddr";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_sockaddr_t	sockaddr_pointer = _sockaddr_pointer;
    bool			rv = mmux_libc_sockaddr_dump(stdout, sockaddr_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct sockaddr_un.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_un_calloc]]])
{
  char const *		sockaddr_un_pointer_varname;
  char const *		sockaddr_un_length_varname;
  mmux_sint_t		family;
  char const *		pathname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sockaddr_un_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sockaddr_un_length_varname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(family,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(pathname,	4);
  {
    struct sockaddr_un	name;

    /* This chunk comes from the documentation of GLIBC. */
    {
      name.sun_family = family;
      strncpy(name.sun_path, pathname, sizeof(name.sun_path));
      name.sun_path[sizeof(name.sun_path) - 1] = '\0';
    }
    {
      /* NOTE: It  appears that "SUN_LEN()" does  not include the terminating  nul of
	 "sun_path" in its computation;  at least this is what I  observe.  So we add
	 it to the memory  block to be able to extract the path  as an ASCIIZ string.
	 The reported length is still the value computed by "SUN_LEN()", because that
	 is what  is needed  to pass  when calling "bind()".   (Marco Maggi;  Nov 18,
	 2024) */
      size_t			addr_len = SUN_LEN(&name);
      mmux_libc_sockaddr_un_t	addr_ptr = calloc(1, 1+addr_len);

      memcpy(addr_ptr, &name, 1+addr_len);
      {
	mmux_bash_rv_t	rv;

	rv = mmux_pointer_bind_to_bash_variable(sockaddr_un_pointer_varname, addr_ptr, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != rv) { goto error_binding_variables; }

	rv = mmux_usize_bind_to_bash_variable(sockaddr_un_length_varname, addr_len, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != rv) { goto error_binding_variables; }

	return rv;

      error_binding_variables:
	free(addr_ptr);
	return rv;
      }
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_UN_POINTER_VAR SOCKADDR_UN_LENGTH_VAR SUN_FAMILY SUN_PATH"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sun_family_ref]]])
{
  char const *		sun_family_varname;
  mmux_pointer_t	pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sun_family_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(pointer,	2);
  {
    mmux_libc_sockaddr_un_t	sockaddr_un_pointer = pointer;

    return mmux_sshort_bind_to_bash_variable(sun_family_varname, sockaddr_un_pointer->sun_family, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SUN_FAMILY_VAR SOCKADDR_UN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sun_path_ref]]])
{
  char const *		sun_path_varname;
  mmux_pointer_t	pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sun_path_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(pointer,	2);
  {
    mmux_libc_sockaddr_un_t	sockaddr_un_pointer = pointer;

    return mmux_string_bind_to_bash_variable(sun_path_varname, sockaddr_un_pointer->sun_path, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SUN_PATH_VAR SOCKADDR_UN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_un_dump]]])
{
  mmux_pointer_t	_sockaddr_un_pointer;
  char const *		struct_name = "struct sockaddr_un";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_un_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_sockaddr_un_t	sockaddr_un_pointer = _sockaddr_un_pointer;
    bool			rv = mmux_libc_sockaddr_un_dump(stdout, sockaddr_un_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_UN_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct sockaddr_in.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_in_calloc]]])
{
  char const *		sockaddr_in_pointer_varname;
  mmux_sshort_t		sin_family;
  char const *		sin_addr_pointer_varname;
  mmux_ushort_t		host_byteorder_sin_port;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sockaddr_in_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SSHORT(sin_family,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin_addr_pointer_varname,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USHORT(host_byteorder_sin_port,	4);
  {
    mmux_uint32_t		network_byteorder_sin_addr	= INADDR_NONE;
    mmux_ushort_t		network_byteorder_sin_port	= htons(host_byteorder_sin_port);
    mmux_libc_sockaddr_in_t	name				= calloc(1, sizeof(struct sockaddr_in));
    mmux_bash_rv_t		brv;

    name->sin_family      = (sa_family_t)sin_family;
    name->sin_addr.s_addr = network_byteorder_sin_addr;
    name->sin_port        = network_byteorder_sin_port;

    brv = mmux_pointer_bind_to_bash_variable(sockaddr_in_pointer_varname, name, MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

    brv = mmux_pointer_bind_to_bash_variable(sin_addr_pointer_varname, &(name->sin_addr), MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

    return brv;

  error_binding_variables:
    free(name);
    return brv;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN_POINTER_VAR SIN_FAMILY IN_ADDR_POINTER SIN_PORT"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_family_ref]]])
{
  char const *		sin_family_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin_family_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = addr_pointer;

    return mmux_sshort_bind_to_bash_variable(sin_family_varname, sockaddr_in_pointer->sin_family, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SIN_FAMILY_VAR SOCKADDR_IN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_family_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_sint_t		sin_family;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sin_family,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = addr_pointer;

    sockaddr_in_pointer->sin_family = sin_family;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN_POINTER SIN_FAMILY"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_addr_ref]]])
{
  char const *		network_byteorder_sin_addr_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_byteorder_sin_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer        = addr_pointer;
    mmux_uint32_t		network_byteorder_sin_addr = sockaddr_in_pointer->sin_addr.s_addr;

    return mmux_uint32_bind_to_bash_variable(network_byteorder_sin_addr_varname, network_byteorder_sin_addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETWORK_BYTEORDER_SIN_ADDR_VAR SOCKADDR_IN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_addr_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_uint32_t		network_byteorder_sin_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(network_byteorder_sin_addr,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = addr_pointer;

    sockaddr_in_pointer->sin_addr.s_addr = network_byteorder_sin_addr;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN_POINTER NETWORK_BYTEORDER_SIN_ADDR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_addr_pointer_ref]]])
{
  char const *		sin_addr_pointer_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin_addr_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = addr_pointer;
    mmux_pointer_t		sin_addr_pointer    = &(sockaddr_in_pointer->sin_addr.s_addr);

    return mmux_pointer_bind_to_bash_variable(sin_addr_pointer_varname, sin_addr_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SIN_ADDR_POINTER_VAR SOCKADDR_IN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_port_ref]]])
{
  char const *		host_byteorder_sin_port_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(host_byteorder_sin_port_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer        = addr_pointer;
    mmux_uint16_t		network_byteorder_sin_port = sockaddr_in_pointer->sin_port;
    mmux_uint16_t		host_byteorder_sin_port    = ntohs(network_byteorder_sin_port);

    return mmux_uint16_bind_to_bash_variable(host_byteorder_sin_port_varname, host_byteorder_sin_port, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOST_BYTEORDER_SIN_PORT_VAR SOCKADDR_IN_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin_port_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_uint16_t		host_byte_order_sin_port;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT16(host_byte_order_sin_port,	2);
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = addr_pointer;

    sockaddr_in_pointer->sin_port = htons(host_byte_order_sin_port);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN_POINTER HOST_BYTEORDER_SIN_PORT"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_in_dump]]])
{
  mmux_pointer_t	_sockaddr_in_pointer;
  char const *		struct_name = "struct sockaddr_in";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_in_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_sockaddr_in_t	sockaddr_in_pointer = _sockaddr_in_pointer;
    bool			rv = mmux_libc_sockaddr_in_dump(stdout, sockaddr_in_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct sockaddr_in6.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_in6_calloc]]])
{
  char const *		sockaddr_in6_pointer_varname;
  mmux_sshort_t		sin6_family;
  char const *		sin6_addr_pointer_varname;
  mmux_uint32_t		network_byteorder_sin6_flowinfo;
  mmux_uint32_t		network_byteorder_sin6_scope_id;
  mmux_uint16_t		host_byteorder_sin6_port;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sockaddr_in6_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SSHORT(sin6_family,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin6_addr_pointer_varname,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(network_byteorder_sin6_flowinfo,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(network_byteorder_sin6_scope_id,	5);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT16(host_byteorder_sin6_port,	6);
  {
    mmux_ushort_t		network_byteorder_sin6_port	= htons(host_byteorder_sin6_port);
    mmux_libc_sockaddr_insix_t	name				= calloc(1, sizeof(struct sockaddr_in6));
    mmux_bash_rv_t		brv;

    name->sin6_family      = (sa_family_t)sin6_family;
    name->sin6_flowinfo    = network_byteorder_sin6_flowinfo;
    name->sin6_scope_id    = network_byteorder_sin6_scope_id;
    name->sin6_port        = network_byteorder_sin6_port;

    brv = mmux_pointer_bind_to_bash_variable(sockaddr_in6_pointer_varname, name, MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

    brv = mmux_pointer_bind_to_bash_variable(sin6_addr_pointer_varname, &(name->sin6_addr), MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

    return brv;

  error_binding_variables:
    free(name);
    return brv;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(7 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER_VAR SIN6_FAMILY SIN6_ADDR_POINTER_VAR SIN6_FLOWINFO SIN6_SCOPE_ID SIN6_PORT"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_family_ref]]])
{
  char const *		sin6_family_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin6_family_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;

    return mmux_sshort_bind_to_bash_variable(sin6_family_varname, sockaddr_in6_pointer->sin6_family, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SIN6_FAMILY_VAR SOCKADDR_IN6_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_family_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_sint_t		sin6_family;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sin6_family,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;

    sockaddr_in6_pointer->sin6_family = sin6_family;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER SIN6_FAMILY"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_addr_pointer_ref]]])
{
  char const *		sin6_addr_pointer_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sin6_addr_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;
    struct in6_addr *		sin6_addr_pointer    = &(sockaddr_in6_pointer->sin6_addr);

    return mmux_pointer_bind_to_bash_variable(sin6_addr_pointer_varname, sin6_addr_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOST_BYTEORDER_SIN6_ADDR_VAR SOCKADDR_IN6_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_flowinfo_ref]]])
{
  char const *		network_byteorder_sin6_flowinfo_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_byteorder_sin6_flowinfo_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer            = addr_pointer;
    mmux_uint32_t		network_byteorder_sin6_flowinfo = sockaddr_in6_pointer->sin6_flowinfo;

    return mmux_uint32_bind_to_bash_variable(network_byteorder_sin6_flowinfo_varname, network_byteorder_sin6_flowinfo,
					     MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETWORK_BYTEORDER_SIN6_FLOWINFO_VAR SOCKADDR_IN6_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_flowinfo_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_uint32_t		sin6_flowinfo;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(sin6_flowinfo,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;

    sockaddr_in6_pointer->sin6_flowinfo = sin6_flowinfo;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER SIN6_FLOWINFO"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_scope_id_ref]]])
{
  char const *		network_byteorder_sin6_scope_id_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_byteorder_sin6_scope_id_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer            = addr_pointer;
    mmux_uint32_t		network_byteorder_sin6_scope_id = sockaddr_in6_pointer->sin6_scope_id;

    return mmux_uint32_bind_to_bash_variable(network_byteorder_sin6_scope_id_varname, network_byteorder_sin6_scope_id,
					     MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETWORK_BYTEORDER_SIN6_SCOPE_ID_VAR SOCKADDR_IN6_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_scope_id_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_uint32_t		sin6_scope_id;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(sin6_scope_id,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;

    sockaddr_in6_pointer->sin6_scope_id = sin6_scope_id;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER SIN6_SCOPE_ID"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_port_ref]]])
{
  char const *		host_byteorder_sin6_port_varname;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(host_byteorder_sin6_port_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer        = addr_pointer;
    mmux_uint16_t		network_byteorder_sin6_port = sockaddr_in6_pointer->sin6_port;
    mmux_uint16_t		host_byteorder_sin6_port    = ntohs(network_byteorder_sin6_port);

    return mmux_uint16_bind_to_bash_variable(host_byteorder_sin6_port_varname, host_byteorder_sin6_port, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOST_BYTEORDER_SIN6_PORT_VAR SOCKADDR_IN6_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sin6_port_set]]])
{
  mmux_pointer_t	addr_pointer;
  mmux_uint16_t		sin6_port;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT16(sin6_port,	2);
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = addr_pointer;

    sockaddr_in6_pointer->sin6_port = htons(sin6_port);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER SIN6_PORT"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sockaddr_in6_dump]]])
{
  mmux_pointer_t	_sockaddr_in6_pointer;
  char const *		struct_name = "struct sockaddr_in6";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_in6_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_sockaddr_insix_t	sockaddr_in6_pointer = _sockaddr_in6_pointer;
    bool			rv = mmux_libc_sockaddr_insix_dump(stdout, sockaddr_in6_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_IN6_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct addrinfo.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_addrinfo_calloc]]])
{
  char const *		addrinfo_pointer_varname;
  mmux_sint_t		ai_flags		= 0;
  mmux_sint_t		ai_family		= AF_UNSPEC;
  mmux_sint_t		ai_socktype		= 0;
  mmux_sint_t		ai_protocol		= 0;
  mmux_socklen_t	ai_addrlen		= 0;
  mmux_pointer_t	addr_pointer		= NULL;
  mmux_pointer_t	canonname_pointer	= NULL;
  mmux_pointer_t	next_pointer		= NULL;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addrinfo_pointer_varname,	1);
  if (10 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(ai_flags,	2);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(ai_family,	3);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(ai_socktype,	4);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(ai_protocol,	5);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(ai_addrlen,	6);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	7);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(canonname_pointer,	8);
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(next_pointer,	9);
  }
  {
    struct sockaddr *	ai_addr           = addr_pointer;
    char *		ai_canonname      = canonname_pointer;
    mmux_libc_addrinfo_t	ai_next           = next_pointer;
    mmux_libc_addrinfo_t	addrinfo_pointer  = calloc(1, sizeof(struct addrinfo));
    mmux_bash_rv_t	brv;

    addrinfo_pointer->ai_flags		= ai_flags;
    addrinfo_pointer->ai_family		= ai_family;
    addrinfo_pointer->ai_socktype	= ai_socktype;
    addrinfo_pointer->ai_protocol	= ai_protocol;
    addrinfo_pointer->ai_addrlen	= ai_addrlen;
    addrinfo_pointer->ai_addr		= ai_addr;
    addrinfo_pointer->ai_canonname	= ai_canonname;
    addrinfo_pointer->ai_next		= ai_next;

    brv = mmux_pointer_bind_to_bash_variable(addrinfo_pointer_varname, addrinfo_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

    return brv;

  error_binding_variables:
    free(addrinfo_pointer);
    return brv;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (10 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ADDRINFO_POINTER_VAR [AI_FLAGS AI_FAMILY AI_SOCKTYPE AI_PROTOCOL AI_ADDRLEN AI_ADDR AI_CANONNAME AI_NEXT]"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_ADDRINFO_SETTER_GETTER]]],[[[
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_ref]]])
{
  char const *		$1_varname;
  mmux_pointer_t	_addrinfo_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM($1_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_addrinfo_pointer,	2);
  {
    mmux_libc_addrinfo_t	addrinfo_pointer = _addrinfo_pointer;

    return mmux_$2_bind_to_bash_variable($1_varname, addrinfo_pointer->$1, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR ADDRINFO_POINTER"]]])

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_set]]])
{
  mmux_pointer_t	_addrinfo_pointer;
  mmux_$2_t		$1;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_addrinfo_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_$3($1,				2);
  {
    mmux_libc_addrinfo_t	addrinfo_pointer = _addrinfo_pointer;

    addrinfo_pointer->$1 = $1;
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR ADDRINFO_POINTER"]]])
]]])

DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_flags]]],		[[[sint]]],[[[SINT]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_family]]],		[[[sint]]],[[[SINT]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_socktype]]],		[[[sint]]],[[[SINT]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_protocol]]],		[[[sint]]],[[[SINT]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_addrlen]]],		[[[socklen]]],[[[SOCKLEN]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_addr]]],		[[[pointer]]],[[[POINTER]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_canonname]]],	[[[pointer]]],[[[POINTER]]])
DEFINE_STRUCT_ADDRINFO_SETTER_GETTER([[[ai_next]]],		[[[pointer]]],[[[POINTER]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_addrinfo_dump]]])
{
  mmux_pointer_t	_addrinfo_pointer;
  char const *		struct_name = "struct addrinfo";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_addrinfo_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_addrinfo_t	addrinfo_pointer = _addrinfo_pointer;
    bool			rv = mmux_libc_addrinfo_dump(stdout, addrinfo_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ADDRINFO_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct hostent.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_hostent_calloc]]])
{
  char const *		hostent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(hostent_pointer_varname,	1);
  {
    mmux_libc_hostent_t	ptr = calloc(1, sizeof(struct hostent));

    return mmux_pointer_bind_to_bash_variable(hostent_pointer_varname, ptr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOSTENT_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_HOSTENT_GETTER]]],[[[
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_ref]]])
{
  char const *		$1_varname;
  mmux_pointer_t	_hostent_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM($1_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_hostent_pointer,	2);
  {
    mmux_libc_hostent_t	hostent_pointer = _hostent_pointer;

    return mmux_$2_bind_to_bash_variable($1_varname, hostent_pointer->$1, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR HOSTENT_POINTER"]]])
]]])

DEFINE_STRUCT_HOSTENT_GETTER([[[h_name]]],		[[[string]]])
DEFINE_STRUCT_HOSTENT_GETTER([[[h_aliases]]],		[[[pointer]]])
DEFINE_STRUCT_HOSTENT_GETTER([[[h_addrtype]]],		[[[sint]]])
DEFINE_STRUCT_HOSTENT_GETTER([[[h_length]]],		[[[sint]]])
DEFINE_STRUCT_HOSTENT_GETTER([[[h_addr_list]]],		[[[pointer]]])
DEFINE_STRUCT_HOSTENT_GETTER([[[h_addr]]],		[[[pointer]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_hostent_dump]]])
{
  mmux_pointer_t	_hostent_pointer;
  char const *		struct_name = "struct hostent";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_hostent_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_hostent_t	hostent_pointer = _hostent_pointer;
    bool		rv = mmux_libc_hostent_dump(stdout, hostent_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOSTENT_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct servent.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_servent_calloc]]])
{
  char const *		servent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(servent_pointer_varname,	1);
  {
    mmux_libc_servent_t	ptr = calloc(1, sizeof(struct servent));

    return mmux_pointer_bind_to_bash_variable(servent_pointer_varname, ptr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SERVENT_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_SERVENT_GETTER]]],[[[
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_ref]]])
{
  char const *		$1_varname;
  mmux_pointer_t	_servent_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM($1_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_servent_pointer,	2);
  {
    mmux_libc_servent_t	servent_pointer = _servent_pointer;

    return mmux_$2_bind_to_bash_variable($1_varname, servent_pointer->$1, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR SERVENT_POINTER"]]])
]]])

DEFINE_STRUCT_SERVENT_GETTER([[[s_name]]],		[[[string]]])
DEFINE_STRUCT_SERVENT_GETTER([[[s_aliases]]],		[[[pointer]]])
DEFINE_STRUCT_SERVENT_GETTER([[[s_port]]],		[[[sint]]])
DEFINE_STRUCT_SERVENT_GETTER([[[s_proto]]],		[[[string]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_servent_dump]]])
{
  mmux_pointer_t	_servent_pointer;
  char const *		struct_name = "struct servent";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_servent_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_servent_t	servent_pointer = _servent_pointer;
    bool		rv = mmux_libc_servent_dump(stdout, servent_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SERVENT_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct protoent.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_protoent_calloc]]])
{
  char const *		protoent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(protoent_pointer_varname,	1);
  {
    mmux_libc_protoent_t	ptr = calloc(1, sizeof(struct protoent));

    return mmux_pointer_bind_to_bash_variable(protoent_pointer_varname, ptr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PROTOENT_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_PROTOENT_GETTER]]],[[[
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_ref]]])
{
  char const *		$1_varname;
  mmux_pointer_t	_protoent_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM($1_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_protoent_pointer,	2);
  {
    mmux_libc_protoent_t	protoent_pointer = _protoent_pointer;

    return mmux_$2_bind_to_bash_variable($1_varname, protoent_pointer->$1, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR PROTOENT_POINTER"]]])
]]])

DEFINE_STRUCT_PROTOENT_GETTER([[[p_name]]],		[[[string]]])
DEFINE_STRUCT_PROTOENT_GETTER([[[p_aliases]]],		[[[pointer]]])
DEFINE_STRUCT_PROTOENT_GETTER([[[p_proto]]],		[[[sint]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_protoent_dump]]])
{
  mmux_pointer_t	_protoent_pointer;
  char const *		struct_name = "struct protoent";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_protoent_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_protoent_t	protoent_pointer = _protoent_pointer;
    bool		rv = mmux_libc_protoent_dump(stdout, protoent_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PROTOENT_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: struct netent.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_netent_calloc]]])
{
  char const *		netent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(netent_pointer_varname,	1);
  {
    mmux_libc_netent_t	ptr = calloc(1, sizeof(struct netent));

    return mmux_pointer_bind_to_bash_variable(netent_pointer_varname, ptr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETENT_POINTER_VAR"]]])

/* ------------------------------------------------------------------ */

m4_define([[[DEFINE_STRUCT_NETENT_GETTER]]],[[[
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_$1_ref]]])
{
  char const *		$1_varname;
  mmux_pointer_t	_netent_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM($1_varname,		1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_netent_pointer,	2);
  {
    mmux_libc_netent_t	netent_pointer = _netent_pointer;

    return mmux_$2_bind_to_bash_variable($1_varname, netent_pointer->$1, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER MMUX_M4_TOUPPER([[[$1]]])_VAR NETENT_POINTER"]]])
]]])

DEFINE_STRUCT_NETENT_GETTER([[[n_name]]],		[[[string]]])
DEFINE_STRUCT_NETENT_GETTER([[[n_aliases]]],		[[[pointer]]])
DEFINE_STRUCT_NETENT_GETTER([[[n_addrtype]]],		[[[sint]]])
DEFINE_STRUCT_NETENT_GETTER([[[n_net]]],		[[[ulong]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_netent_dump]]])
{
  mmux_pointer_t	_netent_pointer;
  char const *		struct_name = "struct netent";

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_netent_pointer,	1);
  if (3 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(struct_name,	2);
  }
  {
    mmux_libc_netent_t	netent_pointer = _netent_pointer;
    bool		rv = mmux_libc_netent_dump(stdout, netent_pointer, struct_name);

    return (false == rv)? MMUX_SUCCESS : MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((2 == argc) || (3 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETENT_POINTER [STRUCT_NAME]"]]])


/** --------------------------------------------------------------------
 ** Sockets: byte order.
 ** ----------------------------------------------------------------- */

/* Host-to-network short int. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_htons]]])
{
  char const *		network_byteorder_number_varname;
  mmux_uint16_t		host_byteorder_number;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_byteorder_number_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT16(host_byteorder_number,	2);
  {
    mmux_uint16_t	network_byteorder_number = htons(host_byteorder_number);

    return mmux_uint16_bind_to_bash_variable(network_byteorder_number_varname, network_byteorder_number, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETWORK_BYTEORDER_NUMBER_VAR HOST_BYTEORDER_NUMBER"]]])

/* ------------------------------------------------------------------ */

/* Network-to-host short int. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_ntohs]]])
{
  char const *		host_byteorder_number_varname;
  mmux_uint16_t		network_byteorder_number;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(host_byteorder_number_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT16(network_byteorder_number,	2);
  {
    mmux_uint16_t	host_byteorder_number = ntohs(network_byteorder_number);

    return mmux_uint16_bind_to_bash_variable(host_byteorder_number_varname, host_byteorder_number, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOST_BYTEORDER_NUMBER_VAR NETWORK_BYTEORDER_NUMBER"]]])

/* ------------------------------------------------------------------ */

/* Host-to-network long int. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_htonl]]])
{
  char const *		network_byteorder_number_varname;
  mmux_uint32_t		host_byteorder_number;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_byteorder_number_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(host_byteorder_number,	2);
  {
    mmux_uint32_t	network_byteorder_number = htonl(host_byteorder_number);

    return mmux_uint32_bind_to_bash_variable(network_byteorder_number_varname, network_byteorder_number, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETWORK_BYTEORDER_NUMBER_VAR HOST_BYTEORDER_NUMBER"]]])

/* ------------------------------------------------------------------ */

/* Network-to-host long int. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_ntohl]]])
{
  char const *		host_byteorder_number_varname;
  mmux_uint32_t		network_byteorder_number;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(host_byteorder_number_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(network_byteorder_number,	2);
  {
    mmux_uint32_t	host_byteorder_number = ntohl(network_byteorder_number);

    return mmux_uint32_bind_to_bash_variable(host_byteorder_number_varname, host_byteorder_number, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOST_BYTEORDER_NUMBER_VAR NETWORK_BYTEORDER_NUMBER"]]])


/** --------------------------------------------------------------------
 ** Sockets: host address conversion.
 ** ----------------------------------------------------------------- */

/* ASCII-to-network */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_aton]]])
{
  char const *		in_addr_varname;
  char const *		ascii_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_in_addr,	2);
  {
    struct in_addr	name;
    int			rv   = inet_aton(ascii_in_addr, &name);

    if (0 != rv) {
      mmux_uint32_t	addr = name.s_addr;

      return mmux_uint32_bind_to_bash_variable(in_addr_varname, addr, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_set_ERRNO(EINVAL, MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IN_ADDR_VAR ASCII_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_addr]]])
{
  char const *		in_addr_varname;
  char const *		ascii_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_in_addr,	2);
  {
    mmux_uint32_t	addr = inet_addr(ascii_in_addr);

    return mmux_uint32_bind_to_bash_variable(in_addr_varname, addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IN_ADDR_VAR ASCII_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

/* Network to ASCII. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_ntoa]]])
{
  char const *		ascii_in_addr_varname;
  mmux_uint32_t		addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(addr,	2);
  {
    struct in_addr	name          = { .s_addr = addr };
    char const *	ascii_in_addr = inet_ntoa(name);

    return mmux_string_bind_to_bash_variable(ascii_in_addr_varname, ascii_in_addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ASCII_IN_ADDR_VAR IN_ADDR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_network]]])
{
  char const *		network_in_addr_varname;
  char const *		ascii_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(network_in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_in_addr,	2);
  {
    mmux_uint32_t	network_addr = inet_network(ascii_in_addr);

    if (INADDR_NONE != network_addr) {
      return mmux_uint32_bind_to_bash_variable(network_in_addr_varname, network_addr, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_set_ERRNO(EINVAL, MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IN_ADDR_VAR ASCII_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_makeaddr]]])
{
  char const *		uint32_in_addr_varname;
  mmux_uint32_t		uint32_net_in_addr;
  mmux_uint32_t		uint32_local_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(uint32_in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(uint32_net_in_addr,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(uint32_local_in_addr,	3);
  {
    struct	in_addr	addr = inet_makeaddr(uint32_net_in_addr, uint32_local_in_addr);

    return mmux_uint32_bind_to_bash_variable(uint32_in_addr_varname, addr.s_addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ASCII_IN_ADDR_VAR UINT32_NET_IN_ADDR UINT32_LOCAL_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

/* Local network address of. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_lnaof]]])
{
  char const *		uint32_local_in_addr_varname;
  mmux_uint32_t		uint32_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(uint32_local_in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(uint32_in_addr,	2);
  {
    struct in_addr	name          = { .s_addr = uint32_in_addr };
    mmux_uint32_t	local_in_addr = inet_lnaof(name);

    return mmux_uint32_bind_to_bash_variable(uint32_local_in_addr_varname, local_in_addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER UINT32_LOCAL_IN_ADDR_VAR UINT32_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

/* network part address of. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_netof]]])
{
  char const *		uint32_local_in_addr_varname;
  mmux_uint32_t		uint32_in_addr;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(uint32_local_in_addr_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(uint32_in_addr,	2);
  {
    struct in_addr	name          = { .s_addr = uint32_in_addr };
    mmux_uint32_t	local_in_addr = inet_netof(name);

    return mmux_uint32_bind_to_bash_variable(uint32_local_in_addr_varname, local_in_addr, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER UINT32_NET_IN_ADDR_VAR UINT32_IN_ADDR"]]])

/* ------------------------------------------------------------------ */

/* Presentation-to-network. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_pton]]])
{
  mmux_sint_t		af_type;
  char const *		ascii_addr;
  mmux_pointer_t	addr_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(af_type,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_addr,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	3);
  {
    int		rv = inet_pton(af_type, ascii_addr, addr_pointer);

    if (rv) {
      return MMUX_SUCCESS;
    } else {
      mmux_bash_pointers_set_ERRNO(EINVAL, MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER AF_TYPE ASCII_ADDR ADDR_POINTER"]]])

/* ------------------------------------------------------------------ */

/* Network-to-presentation. */
MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_inet_ntop]]])
{
  mmux_sint_t		af_type;
  mmux_pointer_t	addr_pointer;
  char const *		ascii_addr_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(af_type,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ascii_addr_varname,	3);
  {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK	512
    char		ascii_addr[IS_THIS_ENOUGH_QUESTION_MARK];
    char const *	rv = inet_ntop(af_type, addr_pointer, (char *)ascii_addr, (socklen_t)IS_THIS_ENOUGH_QUESTION_MARK);

    if (NULL != rv) {
      return mmux_string_bind_to_bash_variable(ascii_addr_varname, ascii_addr, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER AF_TYPE ASCII_ADDR ADDR_POINTER"]]])


/** --------------------------------------------------------------------
 ** Sockets: getaddrinfo, freeaddrinfo, getnameinfo.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getaddrinfo]]])
{
  char const *		node;
  char const *		service;
  mmux_pointer_t	_hints_pointer;
  char const *		addrinfo_linked_list_varname;

  if (IS_POINTER_REPRESENTATION(argv[1])) {
    mmux_pointer_t	_node;
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_node,	1);
    node = _node;
  } else {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(node,	1);
  }
  if (IS_POINTER_REPRESENTATION(argv[2])) {
    mmux_pointer_t	_service;
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_service,	2);
    service = _service;
  } else {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(service,	2);
  }
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_hints_pointer,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addrinfo_linked_list_varname,	4);
  {
    mmux_libc_addrinfo_t	hints_pointer = _hints_pointer;
    mmux_libc_addrinfo_t	addrinfo_linked_list;

    if (0 == strlen(node))    { node    = NULL; }
    if (0 == strlen(service)) { service = NULL; }
    {
      int	rv = getaddrinfo(node, service, hints_pointer, &addrinfo_linked_list);

      if (0 == rv) {
	return mmux_pointer_bind_to_bash_variable(addrinfo_linked_list_varname, addrinfo_linked_list, MMUX_BASH_BUILTIN_STRING_NAME);
      } else {
	mmux_bash_rv_t	brv;

	brv = mmux_sint_bind_to_bash_variable("GAI_ERRNUM", rv, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != brv) { return brv; }

	return mmux_string_bind_to_bash_variable("GAI_ERRMSG", gai_strerror(rv), MMUX_BASH_BUILTIN_STRING_NAME);
      }
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NODE SERVICE HINTS_ADDRINFO_POINTER ADDRINFO_LINKED_LIST_VARNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_freeaddrinfo]]])
{
  mmux_pointer_t	addrinfo_pointer;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addrinfo_pointer,	1);
  {
    free(addrinfo_pointer);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER ADDRINFO_POINTER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getnameinfo]]])
{
  mmux_pointer_t	_sockaddr_pointer;
  mmux_socklen_t	socklen;
  char const *		host_varname;
  char const *		serv_varname;
  mmux_sint_t		flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_sockaddr_pointer,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(socklen,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(host_varname,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(serv_varname,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	5);
  {
    struct sockaddr *	sockaddr_pointer = _sockaddr_pointer;
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK	512
    char		host[IS_THIS_ENOUGH_QUESTION_MARK];
    char		serv[IS_THIS_ENOUGH_QUESTION_MARK];
    int			rv = getnameinfo(sockaddr_pointer, socklen,
					 host, IS_THIS_ENOUGH_QUESTION_MARK,
					 serv, IS_THIS_ENOUGH_QUESTION_MARK,
					 flags);

    if (0 == rv) {
      mmux_bash_rv_t	brv;

      brv = mmux_string_bind_to_bash_variable(host_varname, host, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { return brv; }

      return mmux_string_bind_to_bash_variable(serv_varname, serv, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_rv_t	brv;

      brv = mmux_sint_bind_to_bash_variable("GAI_ERRNUM", rv, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { return brv; }

      return mmux_string_bind_to_bash_variable("GAI_ERRMSG", gai_strerror(rv), MMUX_BASH_BUILTIN_STRING_NAME);
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKADDR_PTR SOCKADDR_LEN HOST_VAR SERV_VAR FLAGS"]]])


/** --------------------------------------------------------------------
 ** Sockets: hosts database.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sethostent]]])
{
  mmux_sint_t		stayopen;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(stayopen,	1);
  {
    sethostent(stayopen);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAYOPEN"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_endhostent]]])
{
  endhostent();
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(1 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_gethostent]]])
{
  char const *		hostent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(hostent_pointer_varname,	1);
  {
    mmux_libc_hostent_t	he = gethostent();

    return mmux_pointer_bind_to_bash_variable(hostent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER HOSTENT_PTR_VAR"]]])


/** --------------------------------------------------------------------
 ** Sockets: services database.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_setservent]]])
{
  mmux_sint_t		stayopen;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(stayopen,	1);
  {
    setservent(stayopen);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAYOPEN"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_endservent]]])
{
  endservent();
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(1 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getservent]]])
{
  char const *		servent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(servent_pointer_varname,	1);
  {
    mmux_libc_servent_t	he = getservent();

    return mmux_pointer_bind_to_bash_variable(servent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SERVENT_PTR_VAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getservbyname]]])
{
  char const *		servent_pointer_varname;
  char const *		name;
  char const *		proto = NULL;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(servent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(name,	2);
  if (4 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(proto,	3);
  }
  {
    mmux_libc_servent_t	he = getservbyname(name, proto);

    return mmux_pointer_bind_to_bash_variable(servent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((3 == argc) || (4 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SERVENT_PTR_VAR NAME [PROTO]"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getservbyport]]])
{
  char const *		servent_pointer_varname;
  mmux_sint_t		port;
  char const *		proto = NULL;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(servent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(port,	2);
  if (4 == argc) {
    MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(proto,	3);
  }
  {
    mmux_libc_servent_t	he = getservbyport(port, proto);

    return mmux_pointer_bind_to_bash_variable(servent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[((3 == argc) || (4 == argc))]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SERVENT_PTR_VAR PORT [PROTO]"]]])


/** --------------------------------------------------------------------
 ** Sockets: protocols database.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_setprotoent]]])
{
  mmux_sint_t		stayopen;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(stayopen,	1);
  {
    setprotoent(stayopen);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAYOPEN"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_endprotoent]]])
{
  endprotoent();
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(1 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getprotoent]]])
{
  char const *		protoent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(protoent_pointer_varname,	1);
  {
    mmux_libc_protoent_t	he = getprotoent();

    return mmux_pointer_bind_to_bash_variable(protoent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PROTOENT_PTR_VAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getprotobyname]]])
{
  char const *		protoent_pointer_varname;
  char const *		name;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(protoent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(name,	2);
  {
    mmux_libc_protoent_t	he = getprotobyname(name);

    return mmux_pointer_bind_to_bash_variable(protoent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PROTOENT_PTR_VAR NAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getprotobynumber]]])
{
  char const *		protoent_pointer_varname;
  mmux_sint_t		proto;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(protoent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(proto,	2);
  {
    mmux_libc_protoent_t	he = getprotobynumber(proto);

    return mmux_pointer_bind_to_bash_variable(protoent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER PROTOENT_PTR_VAR NUMBER"]]])


/** --------------------------------------------------------------------
 ** Sockets: networks database.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_setnetent]]])
{
  mmux_sint_t		stayopen;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(stayopen,	1);
  {
    setnetent(stayopen);
    return MMUX_SUCCESS;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER STAYOPEN"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_endnetent]]])
{
  endnetent();
  return MMUX_SUCCESS;
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(1 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getnetent]]])
{
  char const *		netent_pointer_varname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(netent_pointer_varname,	1);
  {
    mmux_libc_netent_t	he = getnetent();

    return mmux_pointer_bind_to_bash_variable(netent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETENT_PTR_VAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getnetbyname]]])
{
  char const *		netent_pointer_varname;
  char const *		name;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(netent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(name,	2);
  {
    mmux_libc_netent_t	he = getnetbyname(name);

    return mmux_pointer_bind_to_bash_variable(netent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETENT_PTR_VAR NAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getnetbyaddr]]])
{
  char const *		netent_pointer_varname;
  mmux_uint32_t		net;
  mmux_sint_t		type;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(netent_pointer_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT32(net,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(type,	3);
  {
    mmux_libc_netent_t	he = getnetbyaddr(net, type);

    return mmux_pointer_bind_to_bash_variable(netent_pointer_varname, he, MMUX_BASH_BUILTIN_STRING_NAME);
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NETENT_PTR_VAR UINT32_NET SINT_TYPE"]]])


/** --------------------------------------------------------------------
 ** Sockets: interface naming.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_if_nametoindex]]])
{
  char const *		ifindex_varname;
  char const *		ifname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ifindex_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ifname,	2);
  {
    int		rv = if_nametoindex(ifname);

    if (0 == rv) {
      return MMUX_FAILURE;
    } else {
      return mmux_uint_bind_to_bash_variable(ifindex_varname, rv, MMUX_BASH_BUILTIN_STRING_NAME);
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IFINDEX_VAR IFNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_if_indextoname]]])
{
  char const *		ifname_varname;
  mmux_uint_t		ifindex;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(ifname_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_UINT(ifindex,	2);
  {
    char	buffer[IFNAMSIZ];
    char *	rv = if_indextoname(ifindex, buffer);

    if (NULL == rv) {
      return MMUX_FAILURE;
    } else {
      return mmux_string_bind_to_bash_variable(ifname_varname, buffer, MMUX_BASH_BUILTIN_STRING_NAME);
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IFINDEX_VAR IFNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_if_nameindex_to_array]]])
{
  char const *		index_array_name;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(index_array_name,	1);
  {
    mmux_bash_index_array_variable_t	index_array_variable;
    mmux_bash_rv_t			rv;

    rv = mmux_bash_index_array_find_or_make_mutable(&index_array_variable, index_array_name, MMUX_BASH_BUILTIN_STRING_NAME);
    if (MMUX_SUCCESS != rv) { return rv; }
    {
      struct if_nameindex * A = if_nameindex();

      for (int i=0; NULL != A[i].if_name; ++i) {
	mmux_bash_index_array_key_t	index_array_key   = A[i].if_index;
	char *				index_array_value = A[i].if_name;

	rv = mmux_bash_index_array_bind(index_array_variable, index_array_key, index_array_value, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != rv) { break; }
      }
      if_freenameindex(A);
      return rv;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(2 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER IF_NAMEINDEX_ARRAY_VAR"]]])


/** --------------------------------------------------------------------
 ** Sockets: creation, closure, pair.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_socket]]])
{
  char const *	sock_varname;
  mmux_sint_t	namespace, style, protocol;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sock_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(namespace,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(style,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(protocol,	4);
  {
    int		sock = socket(namespace, style, protocol);

    if (-1 != sock) {
      mmux_bash_rv_t	brv;

      brv = mmux_sint_bind_to_bash_variable(sock_varname, sock, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) {
	close(sock);
      }
      return brv;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCK_VAR NAMESPACE STYLE PROTOCOL"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_shutdown]]])
{
  mmux_sint_t		sock, how;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(how,	2);
  {
    int		rv = shutdown(sock, how);

    if (0 == rv) {
      return MMUX_SUCCESS;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCK HOW"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_socketpair]]])
{
  char const *	sock_varname1;
  char const *	sock_varname2;
  mmux_sint_t	namespace, style, protocol;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sock_varname1,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(sock_varname2,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(namespace,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(style,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(protocol,	5);
  {
    int		socks[2];
    int		rv = socketpair(namespace, style, protocol, socks);

    if (0 == rv) {
      mmux_bash_rv_t	brv;

      brv = mmux_sint_bind_to_bash_variable(sock_varname1, socks[0], MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      brv = mmux_sint_bind_to_bash_variable(sock_varname2, socks[1], MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      return brv;

    error_binding_variables:
      close(socks[0]);
      close(socks[1]);
      return brv;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKFD1_VAR SOCKFD2_VAR PF_NAMESPACE SOCK_STYLE IPPROTO_PROTOCOL"]]])


/** --------------------------------------------------------------------
 ** Sockets: stream client.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_connect]]])
{
  mmux_sint_t		sock;
  mmux_pointer_t	addr_pointer;
  mmux_usize_t		sockaddr_length;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(sockaddr_length,	3);
  {
    struct sockaddr *	sockaddr_pointer = addr_pointer;
    int			rv = connect(sock, sockaddr_pointer, sockaddr_length);

    if (0 == rv) {
      return MMUX_SUCCESS;
    } else {
      if (0) { fprintf(stderr, "%s: error %s\n", __func__, strerror(errno)); }
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCK SOCKADDR_POINTER SOCKADDR_LENGTH"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getpeername]]])
{
  mmux_sint_t		sock;
  char const *		addr_pointer_var;
  char const *		addr_length_var;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addr_pointer_var,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addr_length_var,	3);
  {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK		1024
    mmux_socklen_t	addr_length = IS_THIS_ENOUGH_QUESTION_MARK;
    mmux_uint8_t	buffer[addr_length];
    struct sockaddr *	addr = (struct sockaddr *)buffer;
    int			rv   = getpeername(sock, addr, &addr_length);

    if (0 == rv) {
      struct sockaddr *	sockaddr_pointer = calloc(1, addr_length);

      if (NULL == sockaddr_pointer) {
	mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
	return MMUX_FAILURE;
      } else {
	mmux_bash_rv_t	brv;

	memcpy(sockaddr_pointer, addr, addr_length);

	brv = mmux_pointer_bind_to_bash_variable(addr_pointer_var, sockaddr_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

	brv = mmux_socklen_bind_to_bash_variable(addr_length_var, addr_length, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

	return brv;

      error_binding_variables:
	free(sockaddr_pointer);
	return brv;
      }
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKFD SOCKADDR_POINTER_VAR SOCKADDR_LENGTH_VAR"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getsockname]]])
{
  mmux_sint_t		sock;
  char const *		addr_pointer_var;
  char const *		addr_length_var;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addr_pointer_var,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(addr_length_var,	3);
  {
#undef  IS_THIS_ENOUGH_QUESTION_MARK
#define IS_THIS_ENOUGH_QUESTION_MARK		1024
    mmux_socklen_t	addr_length = IS_THIS_ENOUGH_QUESTION_MARK;
    mmux_uint8_t	buffer[addr_length];
    struct sockaddr *	addr = (struct sockaddr *)buffer;
    int			rv   = getsockname(sock, addr, &addr_length);

    if (0 == rv) {
      struct sockaddr *	sockaddr_pointer = calloc(1, addr_length);

      if (NULL == sockaddr_pointer) {
	mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
	return MMUX_FAILURE;
      } else {
	mmux_bash_rv_t	brv;

	memcpy(sockaddr_pointer, addr, addr_length);

	brv = mmux_pointer_bind_to_bash_variable(addr_pointer_var, sockaddr_pointer, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

	brv = mmux_socklen_bind_to_bash_variable(addr_length_var, addr_length, MMUX_BASH_BUILTIN_STRING_NAME);
	if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

	return brv;

      error_binding_variables:
	free(sockaddr_pointer);
	return brv;
      }
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKFD SOCKADDR_POINTER_VAR SOCKADDR_LENGTH_VAR"]]])


/** --------------------------------------------------------------------
 ** Sockets: stream server.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_bind]]])
{
  mmux_sint_t		sock;
  mmux_pointer_t	addr_pointer;
  mmux_socklen_t	addr_length;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(addr_length,	3);
  {
    struct sockaddr *	sockaddr_pointer = addr_pointer;
    int			rv               = bind(sock, sockaddr_pointer, addr_length);

    if (0 == rv) {
      return MMUX_SUCCESS;
    } else {
      if (0) { fprintf(stderr, "%s: error binding %s\n", __func__, strerror(errno)); }
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(4 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKFD SOCKADDR_POINTER SOCKADDR_LENGTH"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_listen]]])
{
  mmux_sint_t		sock, N;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(N,	2);
  {
    int		rv = listen(sock, N);

    if (0 == rv) {
      return MMUX_SUCCESS;
    } else {
      if (0) { fprintf(stderr, "%s: error %s\n", __func__, strerror(errno)); }
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(3 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCKFD N"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_accept]]])
{
  char const *		connected_sock_varname;
  char const *		connected_sockaddr_length_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	addr_pointer;
  mmux_socklen_t	allocated_sockaddr_length;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(connected_sock_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(connected_sockaddr_length_varname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(allocated_sockaddr_length,	5);
  {
    struct sockaddr *	sockaddr_pointer          = addr_pointer;
    mmux_socklen_t	connected_sockaddr_length = allocated_sockaddr_length;
    int			connected_sock            = accept(sock, sockaddr_pointer, &connected_sockaddr_length);

    if (-1 != connected_sock) {
      mmux_bash_rv_t	brv;

      brv = mmux_sint_bind_to_bash_variable(connected_sock_varname, connected_sock, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      brv = mmux_socklen_bind_to_bash_variable(connected_sockaddr_length_varname, connected_sockaddr_length, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      return brv;

    error_binding_variables:
      close(connected_sock);
      return brv;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER CONNECTED_SOCK_VAR CONNECTED_SOCKADDR_LENGTH_VAR SOCK SOCKADDR_POINTER ALLOCATED_SOCKADDR_LENGTH"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_accept4]]])
{
MMUX_BASH_CONDITIONAL_CODE([[[HAVE_ACCEPT4]]],[[[
  char const *		connected_sock_varname;
  char const *		connected_sockaddr_length_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	addr_pointer;
  mmux_socklen_t	allocated_sockaddr_length;
  mmux_sint_t		flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(connected_sock_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(connected_sockaddr_length_varname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(allocated_sockaddr_length,	5);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	6);
  {
    struct sockaddr *	sockaddr_pointer          = addr_pointer;
    mmux_socklen_t	connected_sockaddr_length = allocated_sockaddr_length;
    int			connected_sock            = accept4(sock, sockaddr_pointer, &connected_sockaddr_length, flags);

    if (-1 != connected_sock) {
      mmux_bash_rv_t	brv;

      brv = mmux_sint_bind_to_bash_variable(connected_sock_varname, connected_sock, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      brv = mmux_socklen_bind_to_bash_variable(connected_sockaddr_length_varname, connected_sockaddr_length, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      return brv;

    error_binding_variables:
      close(connected_sock);
      return brv;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
]]],[[[
  fprintf(stderr, "MMUX Bash Pointers: error: builtin \"%s\" not implemented because underlying C language function not available.\n",
	  MMUX_BASH_BUILTIN_STRING_NAME);
  return MMUX_FAILURE;
]]])
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(7 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER CONNECTED_SOCK_VAR CONNECTED_SOCKADDR_LENGTH_VAR SOCK SOCKADDR_POINTER ALLOCATED_SOCKADDR_LENGTH FLAGS"]]])


/** --------------------------------------------------------------------
 ** Sockets: sending and receiving.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_send]]])
{
  char const *		number_of_bytes_sent_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	buffer_pointer;
  mmux_usize_t		buffer_length;
  mmux_sint_t		flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(number_of_bytes_sent_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(buffer_pointer,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(buffer_length,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	5);
  {
    mmux_ssize_t	number_of_bytes_sent = send(sock, buffer_pointer, buffer_length, flags);

    if (-1 != number_of_bytes_sent) {
      return mmux_ssize_bind_to_bash_variable(number_of_bytes_sent_varname, number_of_bytes_sent, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NUMBER_OF_BYTES_SENT_VAR SOCK BUFFER_POINTER BUFFER_LENGTH FLAGS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_recv]]])
{
  char const *		number_of_bytes_received_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	buffer_pointer;
  mmux_usize_t		buffer_length;
  mmux_sint_t		flags;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(number_of_bytes_received_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(buffer_pointer,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(buffer_length,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	5);
  {
    mmux_ssize_t	number_of_bytes_received = recv(sock, buffer_pointer, buffer_length, flags);

    if (-1 != number_of_bytes_received) {
      return mmux_ssize_bind_to_bash_variable(number_of_bytes_received_varname, number_of_bytes_received, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(6 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NUMBER_OF_BYTES_RECEIVED_VAR SOCK BUFFER_POINTER BUFFER_LENGTH FLAGS"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_sendto]]])
{
  char const *		number_of_bytes_sent_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	buffer_pointer;
  mmux_usize_t		buffer_length;
  mmux_sint_t		flags;
  mmux_pointer_t	addr_pointer;
  mmux_socklen_t	sockaddr_length;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(number_of_bytes_sent_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(buffer_pointer,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(buffer_length,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	5);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(addr_pointer,	6);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(sockaddr_length,	7);
  {
    struct sockaddr *	sockaddr_pointer     = addr_pointer;
    mmux_ssize_t	number_of_bytes_sent = sendto(sock, buffer_pointer, buffer_length, flags, sockaddr_pointer, sockaddr_length);

    if (-1 != number_of_bytes_sent) {
      return mmux_ssize_bind_to_bash_variable(number_of_bytes_sent_varname, number_of_bytes_sent, MMUX_BASH_BUILTIN_STRING_NAME);
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(8 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NUMBER_OF_BYTES_SENT_VAR SOCK BUFFER_POINTER BUFFER_LENGTH FLAGS SOCKADDR_POINTER SOCKADDR_LENGTH"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_recvfrom]]])
{
  char const *		number_of_bytes_received_varname;
  char const *		peer_sockaddr_length_varname;
  mmux_sint_t		sock;
  mmux_pointer_t	buffer_pointer;
  mmux_usize_t		buffer_length;
  mmux_sint_t		flags;
  mmux_pointer_t	_peer_sockaddr_pointer;
  mmux_socklen_t	peer_sockaddr_allocated_length;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(number_of_bytes_received_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(peer_sockaddr_length_varname,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(buffer_pointer,	4);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(buffer_length,	5);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(flags,	6);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_POINTER(_peer_sockaddr_pointer,	7);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SOCKLEN(peer_sockaddr_allocated_length,	8);
  {
    struct sockaddr *	peer_sockaddr_pointer     = _peer_sockaddr_pointer;
    mmux_socklen_t	peer_sockaddr_length      = peer_sockaddr_allocated_length;
    mmux_ssize_t	number_of_bytes_received  = recvfrom(sock, buffer_pointer, buffer_length, flags,
							     peer_sockaddr_pointer, &peer_sockaddr_length);

    if (-1 != number_of_bytes_received) {
      mmux_bash_rv_t	brv;

      brv =  mmux_ssize_bind_to_bash_variable(number_of_bytes_received_varname, number_of_bytes_received, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      brv = mmux_socklen_bind_to_bash_variable(peer_sockaddr_length_varname, peer_sockaddr_length, MMUX_BASH_BUILTIN_STRING_NAME);
      if (MMUX_SUCCESS != brv) { goto error_binding_variables; }

      return brv;

    error_binding_variables:
      return brv;
    } else {
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(9 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER NUMBER_OF_BYTES_RECEIVED_VAR CONNECTED_SOCKADDR_LENGTH_VAR SOCK BUFFER_POINTER BUFFER_LENGTH FLAGS SOCKADDR_POINTER ALLOCATED_SOCKADDR_LENGTH"]]])


/** --------------------------------------------------------------------
 ** Sockets: options.
 ** ----------------------------------------------------------------- */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_getsockopt]]])
{
  char const *		option_value_varname;
  mmux_sint_t		sock;
  mmux_sint_t		level;
  mmux_sint_t		optname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(option_value_varname,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(level,	3);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(optname,	4);
  {
    switch (optname) {
    case SO_BROADCAST:
    case SO_DEBUG:
    case SO_DONTROUTE:
    case SO_ERROR:
    case SO_KEEPALIVE:
    case SO_OOBINLINE:
    case SO_REUSEADDR:
    case SO_TYPE: /* case SO_STYLE: it is an alias for SO_TYPE */
      /* The option value is an "int". */
      {
	mmux_sint_t	optval;
	mmux_socklen_t	optlen = sizeof(mmux_sint_t);
	int		rv = getsockopt(sock, level, optname, &optval, &optlen);

	if (0 == rv) {
	  return mmux_sint_bind_to_bash_variable(option_value_varname, optval, MMUX_BASH_BUILTIN_STRING_NAME);
	} else {
	  goto error_calling_getsockopt;
	}
      }
      break;

    case SO_RCVBUF: /* size of receiving buffer */
    case SO_SNDBUF: /* size of sending buffer */
      /* The option value is a "size_t". */
      {
	mmux_usize_t	optval = 0;
	mmux_socklen_t	optlen = sizeof(mmux_usize_t);
	int		rv = getsockopt(sock, level, optname, &optval, &optlen);

	if (0 == rv) {
	  return mmux_sint_bind_to_bash_variable(option_value_varname, optval, MMUX_BASH_BUILTIN_STRING_NAME);
	} else {
	  goto error_calling_getsockopt;
	}
      }
      break;

    case SO_LINGER:
      /* The option value is a "struct linger". */
      {
	struct linger	optval;
	mmux_socklen_t	optlen = sizeof(optval);
	int		rv = getsockopt(sock, level, optname, &optval, &optlen);

	if (-1 == rv) {
	  goto error_calling_getsockopt;
	} else {
	  if (0) { fprintf(stderr, "%s: called getsockopt l_onoff=%d, l_linger=%d\n", __func__, optval.l_onoff, optval.l_linger); }
	  mmux_bash_assoc_array_variable_t	assoc_array_variable;
	  mmux_bash_rv_t			brv;

	  brv = mmux_bash_assoc_array_find_or_make_mutable(&assoc_array_variable, option_value_varname, MMUX_BASH_BUILTIN_STRING_NAME);
	  if (MMUX_SUCCESS != brv) { return brv; }

	  brv = mmux_bash_assoc_array_bind(assoc_array_variable, "ONOFF", (optval.l_onoff)? "1" : "0", MMUX_BASH_BUILTIN_STRING_NAME);
	  if (MMUX_SUCCESS != brv) { return brv; }
	  {
	    mmux_sint_t	requested_size = mmux_sint_sprint_size(optval.l_linger);

	    if (-1 == requested_size) {
	      goto error_converting_l_linger;
	    } else {
	      char	timeout_period_in_seconds[requested_size];

	      rv = mmux_sint_sprint(timeout_period_in_seconds, requested_size, optval.l_linger);
	      if (0 != rv) { goto error_converting_l_linger; }

	      brv = mmux_bash_assoc_array_bind(assoc_array_variable, "LINGER", timeout_period_in_seconds, MMUX_BASH_BUILTIN_STRING_NAME);
	      if (MMUX_SUCCESS != brv) { return brv; }
	    }
	    return MMUX_SUCCESS;

	  error_converting_l_linger:
	    fprintf(stderr, "%s: error: failure while converting l_linger to string\n", MMUX_BASH_BUILTIN_STRING_NAME);
	    return MMUX_FAILURE;
	  }
	}
      }
      break;

    default:
      errno = EINVAL;
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }

  error_calling_getsockopt:
    mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
    return MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER OPTION_VALUE_VAR SOCK LEVEL OPTNAME"]]])

/* ------------------------------------------------------------------ */

MMUX_BASH_BUILTIN_MAIN([[[mmux_libc_setsockopt]]])
{
  mmux_sint_t		sock;
  mmux_sint_t		level;
  mmux_sint_t		optname;

  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(sock,	1);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(level,	2);
  MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(optname,	3);
  {
    switch (optname) {
    case SO_BROADCAST:
    case SO_DEBUG:
    case SO_DONTROUTE:
    case SO_KEEPALIVE:
    case SO_OOBINLINE:
    case SO_REUSEADDR:
      /* The  option  SO_TYPE  ==  SO_STYLE   and  SO_ERROR  are  not  available  for
	 setting. */
      {
	mmux_sint_t	optval;

	MMUX_BASH_PARSE_BUILTIN_ARGNUM_SINT(optval,	4);
	{
	  mmux_socklen_t	optlen = sizeof(optval);
	  int			rv = setsockopt(sock, level, optname, &optval, optlen);

	  if (0 == rv) {
	    return MMUX_SUCCESS;
	  } else {
	    goto error_calling_setsockopt;
	  }
	}
      }
      break;

    case SO_RCVBUF: /* size of receiving buffer */
    case SO_SNDBUF: /* size of sending buffer */
      /* The option value is a "size_t". */
      {
	mmux_usize_t	optval;

	MMUX_BASH_PARSE_BUILTIN_ARGNUM_USIZE(optval,	4);
	{
	  mmux_socklen_t	optlen = sizeof(optval);
	  int			rv = setsockopt(sock, level, optname, &optval, optlen);

	  if (0 == rv) {
	    return MMUX_SUCCESS;
	  } else {
	    goto error_calling_setsockopt;
	  }
	}
      }
      break;

    case SO_LINGER:
      /* The option value is a "struct linger". */
      {
	char const *	option_value_array_varname;

	MMUX_BASH_PARSE_BUILTIN_ARGNUM_BASH_PARM(option_value_array_varname,	4);
	{
	    mmux_bash_assoc_array_variable_t	assoc_array_variable;
	    char const *			assoc_array_value;
	    struct linger			optval;
	    mmux_bash_rv_t			brv;

	    brv = mmux_bash_assoc_array_find_existent(&assoc_array_variable, option_value_array_varname, MMUX_BASH_BUILTIN_STRING_NAME);
	    if (MMUX_SUCCESS != brv) { return brv; }

	    /* Retrieve the value of the key "ONOFF". */
	    {
	      brv = mmux_bash_assoc_array_ref(assoc_array_variable, "ONOFF", &assoc_array_value, MMUX_BASH_BUILTIN_STRING_NAME);
	      if (MMUX_SUCCESS != brv) { return brv; }
	      if (0 == strcmp("0",assoc_array_value)) {
		optval.l_onoff = 0;
	      } else {
		optval.l_onoff = 1;
	      }
	    }

	    /* Retrieve the value of the key "LINGER". */
	    {
	      mmux_sint_t	timeout_period_in_seconds;

	      brv = mmux_bash_assoc_array_ref(assoc_array_variable, "LINGER", &assoc_array_value, MMUX_BASH_BUILTIN_STRING_NAME);
	      if (false == mmux_sint_parse(&timeout_period_in_seconds, assoc_array_value, MMUX_BASH_BUILTIN_STRING_NAME)) {
		optval.l_linger = timeout_period_in_seconds;
	      } else {
		return MMUX_FAILURE;
	      }
	    }

	    {
	      if (0) { fprintf(stderr, "%s: calling setsockopt l_onoff=%d, l_linger=%d\n", __func__, optval.l_onoff, optval.l_linger); }
	      mmux_socklen_t	optlen = sizeof(optval);
	      int		rv = setsockopt(sock, level, optname, &optval, optlen);

	      if (0 == rv) {
		return MMUX_SUCCESS;
	      } else {
		goto error_calling_setsockopt;
	      }
	  }
	}
      }
      break;

    default:
      errno = EINVAL;
      mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
      return MMUX_FAILURE;
    }

  error_calling_setsockopt:
    mmux_bash_pointers_consume_errno(MMUX_BASH_BUILTIN_STRING_NAME);
    return MMUX_FAILURE;
  }
}
MMUX_BASH_DEFINE_TYPICAL_BUILTIN_FUNCTION([[[MMUX_BASH_BUILTIN_IDENTIFIER]]],
    [[[(5 == argc)]]],
    [[["MMUX_BASH_BUILTIN_IDENTIFIER SOCK LEVEL OPTNAME OPTION_VALUE"]]])


/** --------------------------------------------------------------------
 ** Module initialisation.
 ** ----------------------------------------------------------------- */

mmux_bash_rv_t
mmux_bash_pointers_init_sockets_module (void)
{
  mmux_bash_rv_t	brv;

  {
    brv = mmux_bash_create_global_sint_variable("mmux_libc_in_addr_SIZEOF",  sizeof(struct in_addr), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_in6_addr_SIZEOF",  sizeof(struct in6_addr), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_sockaddr_in_SIZEOF",  sizeof(struct sockaddr_in), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_sockaddr_in6_SIZEOF",  sizeof(struct sockaddr_in6), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_sockaddr_un_SIZEOF",  sizeof(struct sockaddr_un), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_addrinfo_SIZEOF", sizeof(struct addrinfo), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_hostent_SIZEOF", sizeof(struct hostent), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_bash_create_global_sint_variable("mmux_libc_servent_SIZEOF", sizeof(struct servent), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }
  }

  {
    brv = mmux_pointer_bind_to_bash_variable("mmux_libc_in6addr_loopback_pointer", (mmux_pointer_t)&(in6addr_loopback), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }

    brv = mmux_pointer_bind_to_bash_variable("mmux_libc_in6addr_any_pointer", (mmux_pointer_t)&(in6addr_any), NULL);
    if (MMUX_SUCCESS != brv) { return brv; }
  }

  return MMUX_SUCCESS;
}

/* end of file */
