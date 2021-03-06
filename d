READ(2)                                                Linux Programmer's Manual                                               READ(2)

NNAAMMEE
       read - read from a file descriptor

SSYYNNOOPPSSIISS
       ##iinncclluuddee <<uunniissttdd..hh>>

       ssssiizzee__tt rreeaadd((iinntt _f_d,, vvooiidd **_b_u_f,, ssiizzee__tt _c_o_u_n_t));;

DDEESSCCRRIIPPTTIIOONN
       rreeaadd() attempts to read up to _c_o_u_n_t bytes from file descriptor _f_d into the buffer starting at _b_u_f.

       On  files that support seeking, the read operation commences at the file offset, and the file offset is incremented by the num‐
       ber of bytes read.  If the file offset is at or past the end of file, no bytes are read, and rreeaadd() returns zero.

       If _c_o_u_n_t is zero, rreeaadd() _m_a_y detect the errors described below.  In the absence of any errors, or if rreeaadd() does not check  for
       errors, a rreeaadd() with a _c_o_u_n_t of 0 returns zero and has no other effects.

       According  to  POSIX.1, if _c_o_u_n_t is greater than SSSSIIZZEE__MMAAXX, the result is implementation-defined; see NOTES for the upper limit
       on Linux.

RREETTUURRNN VVAALLUUEE
       On success, the number of bytes read is returned (zero indicates end of file), and the file position is advanced by  this  num‐
       ber.   It  is  not  an  error if this number is smaller than the number of bytes requested; this may happen for example because
       fewer bytes are actually available right now (maybe because we were close to end-of-file, or because  we  are  reading  from  a
       pipe, or from a terminal), or because rreeaadd() was interrupted by a signal.  See also NOTES.

       On  error,  -1 is returned, and _e_r_r_n_o is set appropriately.  In this case, it is left unspecified whether the file position (if
       any) changes.

EERRRROORRSS
       EEAAGGAAIINN The file descriptor _f_d refers to a file other than a socket and has been marked nonblocking (OO__NNOONNBBLLOOCCKK), and  the  read
              would block.  See ooppeenn(2) for further details on the OO__NNOONNBBLLOOCCKK flag.

       EEAAGGAAIINN or EEWWOOUULLDDBBLLOOCCKK
              The  file  descriptor  _f_d  refers  to  a  socket and has been marked nonblocking (OO__NNOONNBBLLOOCCKK), and the read would block.
              POSIX.1-2001 allows either error to be returned for this case, and does not require these constants  to  have  the  same
              value, so a portable application should check for both possibilities.

       EEBBAADDFF  _f_d is not a valid file descriptor or is not open for reading.

       EEFFAAUULLTT _b_u_f is outside your accessible address space.

       EEIINNTTRR  The call was interrupted by a signal before any data was read; see ssiiggnnaall(7).

       EEIINNVVAALL _f_d  is  attached to an object which is unsuitable for reading; or the file was opened with the OO__DDIIRREECCTT flag, and either
              the address specified in _b_u_f, the value specified in _c_o_u_n_t, or the file offset is not suitably aligned.

       EEIINNVVAALL _f_d was created via a call to ttiimmeerrffdd__ccrreeaattee(2) and the wrong size buffer was given to rreeaadd(); see ttiimmeerrffdd__ccrreeaattee(2)  for
              further information.

       EEIIOO    I/O  error.  This will happen for example when the process is in a background process group, tries to read from its con‐
              trolling terminal, and either it is ignoring or blocking SSIIGGTTTTIINN or its process group is orphaned.  It  may  also  occur
              when  there  is  a  low-level I/O error while reading from a disk or tape.  A further possible cause of EEIIOO on networked
              filesystems is when an advisory lock had been taken out on the file descriptor and this lock has  been  lost.   See  the
              _L_o_s_t _l_o_c_k_s section of ffccnnttll(2) for further details.

       EEIISSDDIIRR _f_d refers to a directory.

       Other errors may occur, depending on the object connected to _f_d.

CCOONNFFOORRMMIINNGG TTOO
       SVr4, 4.3BSD, POSIX.1-2001.

NNOOTTEESS
       The types _s_i_z_e___t and _s_s_i_z_e___t are, respectively, unsigned and signed integer data types specified by POSIX.1.

       On  Linux,  rreeaadd()  (and  similar system calls) will transfer at most 0x7ffff000 (2,147,479,552) bytes, returning the number of
       bytes actually transferred.  (This is true on both 32-bit and 64-bit systems.)

       On NFS filesystems, reading small amounts of data will update the timestamp only the first time, subsequent calls  may  not  do
       so.   This  is  caused  by  client side attribute caching, because most if not all NFS clients leave _s_t___a_t_i_m_e (last file access
       time) updates to the server, and client side reads satisfied from the client's cache will not cause  _s_t___a_t_i_m_e  updates  on  the
       server  as  there  are no server-side reads.  UNIX semantics can be obtained by disabling client-side attribute caching, but in
       most situations this will substantially increase server load and decrease performance.

BBUUGGSS
       According to POSIX.1-2008/SUSv4 Section XSI 2.9.7 ("Thread Interactions with Regular File Operations"):

           All of the following functions shall be atomic with respect to each other in the effects  specified  in  POSIX.1-2008  when
           they operate on regular files or symbolic links: ...

       Among  the  APIs  subsequently listed are rreeaadd() and rreeaaddvv(2).  And among the effects that should be atomic across threads (and
       processes) are updates of the file offset.  However, on Linux before version 3.14, this was not the case: if two processes that
       share  an open file description (see ooppeenn(2)) perform a rreeaadd() (or rreeaaddvv(2)) at the same time, then the I/O operations were not
       atomic with respect updating the file offset, with the result that the reads in the two processes might  (incorrectly)  overlap
       in the blocks of data that they obtained.  This problem was fixed in Linux 3.14.

SSEEEE AALLSSOO
       cclloossee(2), ffccnnttll(2), iiooccttll(2), llsseeeekk(2), ooppeenn(2), pprreeaadd(2), rreeaaddddiirr(2), rreeaaddlliinnkk(2), rreeaaddvv(2), sseelleecctt(2), wwrriittee(2), ffrreeaadd(3)

CCOOLLOOPPHHOONN
       This  page  is  part of release 5.10 of the Linux _m_a_n_-_p_a_g_e_s project.  A description of the project, information about reporting
       bugs, and the latest version of this page, can be found at https://www.kernel.org/doc/man-pages/.

Linux                                                         2018-02-02                                                       READ(2)
