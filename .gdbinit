#set print pretty on
set confirm off

define pl
    set $_pos=($arg0)->next
 
    while ($_pos != ($arg0))
        set $_ptr_=($arg1 *)((char *)$_pos - (char *)&((($arg1 *)0)->$arg2))
        print $_ptr_
        print *$_ptr_
        set $_pos = $_pos->next
    end
end

define plc
    set $_pos=(listc_t *)($arg0)->link.next
    while ($_pos != ($arg0))
        print $_pos->data
        print *($arg1 *)$_pos->data
        set $_pos = (listc_t *)$_pos->link.next
    end
end

define list_pid_maybe
  set $name = $arg1
  set $c = ' '
  if $arg0 == tbsvr_frame_.my_proc_idx
    set $c = '*'
  end
  if $arg0 != -1
    printf "%02d %5d %-4s%c", $arg0, tbsvr_frame_.svr_pid_list[$arg0], $name, $c
  end
  if $arg0 >= 1 && $arg0 <= tbsvr_frame_.wthr_proc_cnt
    set $tid_start = tbsvr_frame_.proc_cnt + tbsvr_frame_.wthr_per_proc * ($arg0 - 1)
    printf "%02d - %02d", $tid_start, $tid_start + tbsvr_frame_.wthr_per_proc -1
  end
  printf "\n"
end

define list_pid
  list_pid_maybe 0 "MTHR"
  set $i = 1
  while $i <= tbsvr_frame_.wthr_proc_cnt
    list_pid_maybe $i "WTHR "
    set $i = $i + 1
  end
  list_pid_maybe tbsvr_frame_.alba_proc_idx "ALBA"
  list_pid_maybe tbsvr_frame_.lgwr_proc_idx "LGWR"
  list_pid_maybe tbsvr_frame_.larc_proc_idx "LARC"
  list_pid_maybe tbsvr_frame_.ckpt_proc_idx "CKPT"
  list_pid_maybe tbsvr_frame_.dbwr_first_proc_idx "DBWR"
end
document list_pid
[list_pid] displays pid mappings
end

define list_tid_info
  printf "TID = "
  output tb_get_tid()
  printf ", "
  output sess_info_[tb_get_tid()].status
  printf ", "
  print_txinfo_all
  printf "\n"
  bt $arg0
end

define list_tid
  set $bt_cnt = 5
  if $argc > 0
    set $bt_cnt = $arg0
  end
  thr apply all list_tid_info $bt_cnt
end
document list_tid
[list_tid] displays tid to gdb thread # mapping
end

define print_plan
  set $ppn = (ppn_t *)$arg0
  set $i = 1
  set $max = 1
  set $ppn_nodes = (ppn_t **)calloc(1000, 4)
  set $ppn_nodes[1] = $ppn

  while $i <= $max
    if $ppn_nodes[$i]
      set $ppn = $ppn_nodes[$i]
      set $ppn_nodes[2 * $i] = $ppn->sub_L
      set $ppn_nodes[2 * $i + 1] = $ppn->sub_R
      if $ppn->sub_L
        set $max = 2 * $i
      end
      if $ppn->sub_R
        set $max = 2 * $i + 1
      end
    end
    set $i = $i + 1
  end

  set $i = 1
  while $i != 0 && $i <= $max
    if !$ppn_nodes[$i]
      if $i * 2 <= $max && $ppn_nodes[$i * 2]
        set $i = $i * 2
      else
        if $i * 2 + 1 <= $max && $ppn_nodes[$i * 2 + 1]
          set $i = $i * 2 + 1
        else
          set $i = $i / 2
        end
      end
    else
      set $level = 0
      set $j = $i
      while $j > 0
        set $j = $j / 2
        set $level = $level + 1
      end
      set $level = $level * 4
      _print_plan_indent $level
      # printf "[%02d] ", $i

      set $ppn = $ppn_nodes[$i]
      output $ppn->ex_op
      echo \n
      set $ppn_nodes[$i] = 0
    end
  end
  set $dummy = free($ppn_nodes)
end
document print_plan
print_plan [ppn]
end

define _print_plan_indent
  set $_print_plan_rec_indents = "                                                                "
  set $_print_plan_rec_length = strlen($_print_plan_rec_indents)
  printf "%s", (char *)&$_print_plan_rec_indents[$_print_plan_rec_length - $arg0]
end

define print_cur_tx
  print sess_info_[tb_get_tid()].txinfo
end
document print_cur_tx
usage: print_cur_tx
end

# print commands
define print_buf
  set $buf = (tcbuf_t *)$arg0
  printf "buf=%d/%d.%d %s (bh=%d/%d.%d %s)\n", \
          $buf->tsid, $buf->dba>>22, $buf->dba<<22>>22, \
          tcbh_get_lockmode_name($buf->lock), \
          $buf->bh->tsid, $buf->bh->dba>>22, $buf->bh->dba<<22>>22, \
          tcbh_get_lockmode_name($buf->bh->mode)
end
document print_buf
usage: print_buf buf
end

define print_cv
  set $cv = (redocv_t *)$arg0
  printf "op=%s::%s(%d.%d)\n", \
      redocv_infos[$cv->opcode1].name, \
      redocv_infos[$cv->opcode1].info[$cv->opcode2].minor_name, \
      $cv->opcode1, $cv->opcode2
end
document print_cv
usage: print_cv cv
end

define print_cvlist
  set $cvlist = (cvlist_t *)$arg0
  set $i = 0
  while $i < $cvlist->cur
    printf "[%02d] ", $i
    print_cv $cvlist->cv_items[$i]->cv
    printf "     "
    print_buf $cvlist->cv_items[$i]->handle
    set $i = $i + 1
  end
end
document print_cvlist
usage: print_cvlist cvlist
end

define print_wlist_all
   set $elem = ((wlist_t *)$arg0)->elems.next
   set $head = $elem
   set $i = 0
   set $wlist_link_offset = (int)&((wlist_elem_t *)0)->b.link

   while $head != $elem || $i == 0
     set $wlist_elem = (wlist_elem_t *)((char *)$elem - $wlist_link_offset)
     printf "tid: %2d, elem=0x%x\n", $wlist_elem->b.tid, $wlist_elem
     set $elem = $wlist_elem->b.link.next
     set $i = 1
   end
end
document print_wlist_all
usage: print_wlist_all wlist
end

define print_so
  set $x = thr_info_[tb_get_tid()]
  set $t = $x->ti_so_list.next
  set $i = $t->prev
  while $t != $i
    printf "addr = 0x%x, so_type = ", $t
    output ((so_t *) $t)->so_type
    printf ", so_scope = "
    output ((so_t *) $t)->so_scope
    printf "\n"
    set $t = $t->next
  end
end
document print_so
usage: print_so
end

define print_tx_so
  set $x = sess_info_[tb_get_tid()]->txinfo
  set $t = $x->so_list.next
  set $i = $t->prev
  while $t != $i
    printf "addr = 0x%x, so_type = ", $t
    output ((so_t *) $t)->so_type
    printf ", so_scope = "
    output ((so_t *) $t)->so_scope
    printf "\n"
    set $t = $t->next
  end
end
document print_so
usage: print_so
end

define print_wlock_wlist
  set $x = (wlist_t *) $arg0
  set $i = $x->elems.next
  set $t = $i->prev
  set $o = (int) &(((wlist_elem_base_t *) 0)->link)

  printf "    WLIST type = "
  output $x->so_type
  printf "\n"
  while $i != $t
    set $e = (wlock_elem_t *) ((char *) $i - $o)
    printf "        tid = %2d, mode = ", $e->b.tid
    output $e->mode
    printf "\n"
    set $i = $i->next
  end
end
document print_wlock_wlist
usage: print_wlock_wlist wlist
end

define print_wlock
  set $pw = (wlock_t *) $arg0

  printf "WLOCK type = "
  output $pw->type
  printf "\n"

  print_wlock_wlist &$pw->owners
  print_wlock_wlist &$pw->converters
  print_wlock_wlist &$pw->waiters
end
document print_wlock
usage: print_wlock wlock
end

define print_wlock_by_elem
  set $pe = (wlock_elem_t *) $arg0
  print_wlock $pe->lock
end
document print_wlock_by_elem
usage: print_wlock_by_elem wlock_elem
end

define print_list_entry
   set $offset = (int)&(($arg1 *)0)->$arg2
   set $ptr = ($arg1 *)((char *)($arg0) - $offset)
   print $ptr
   print *$ptr
end
document print_list_entry
dump list entry
<link_ptr> : list_link_t pointer
<type_needed> : type that you want to convert to
<link_name> : link name embbeded in <type_needed>

this is almost same as list_entry macro in list.h

usage: print_list_entry <link_ptr> <type_needed> <link_name>

end

define print_likey
    call td_likey_dump(&debug_dstream, (tdikey_t *)$arg0)
end
document print_likey
[print_likey key] will dump index key to screen
end

define print_key
    call tdikey_dump(&debug_dstream, (tdikey_t *)$arg0)
end
document print_key
[print_key key] will dump index key to screen
end

define print_rpdata
    call rpdata_dump(&debug_dstream, (void *)$arg0, (int)$arg1)
end
document print_rpdata
[print_rpdata rpdata colcnt] will dump rpdata to screen
end

define print_rp
    call rp_dump_internal(&debug_dstream, (rp_t *)$arg0)
end
document print_rp
[print_rowno rp] will dump rp to screen
end

define print_rowno
    call rp_dump(&debug_dstream, (tdrp_t *)td_dblk_get_rp($arg0, (td_dblk_dl_t *)tcblk_get_body((tcblk_t *)($arg0)), $arg1), (uint16_t)$arg1)
end
document print_rowno
[print_rowno blk rowno] will rp #'rowno' in 'blk' to screen
end

define print_irp
    call td_ilblk_dump_rp(&debug_dstream, (td_ilblk_dl_t *)tcblk_get_body((tcblk_t *)($arg0)), (tdirp_t *)td_ilblk_get_rp($arg0, (td_ilblk_dl_t *)tcblk_get_body((tcblk_t *)($arg0)), $arg1), (uint16_t)$arg1)
end
document print_irp
[print_irp blk rowno] will dump index leaf block row piece to screen
end

define print_ibrp
    call td_ibblk_dump_rp(&debug_dstream, (td_ibblk_dl_t *)tcblk_get_body((tcblk_t *)($arg0)), (tdibrp_t *)td_ibblk_get_rp($arg0, (td_ibblk_dl_t *)tcblk_get_body((tcblk_t *)($arg0)), $arg1), (uint16_t)$arg1)
end
document print_ibrp
[print_ibrp blk rowno] will dump index branch block row piece to screen
end

define print_txinfo
  set $txinfo = sess_info_[tb_get_tid()].txinfo
  if $argc > 0
    set $txinfo = (txinfo_t *)$arg0
  end
  if $txinfo
    printf "xid=[%d.%d.%d], uea=%d/%d.%d.%d, %c%c\n", \
           $txinfo->xid.usgmt_id, $txinfo->xid.slotno, $txinfo->xid.wrapno, \
           $txinfo->uea.dba>>22, $txinfo->uea.dba<<10>>10, \
           $txinfo->uea.seqno, $txinfo->uea.rowno, \
           ($txinfo->is_rollback ? 'R' : ' '), \
           ($txinfo->ignore_softlimit ? 'I' : ' ')
  end
end
document print_txinfo
usage: print_txinfo [txinfo]

dumps txinfo. use txinfo of current session if arg is missing.
end

define print_txinfo_all
  set $info = sess_info_[tb_get_tid()].txinfo
  while $info
    print_txinfo $info
    set $info = $info->parent
  end
end
document print_txinfo_all
usage: print_txinfo_all

dumps txinfo recursively.
end

define print_sess
  set $sess = &sess_info_[tb_get_tid()]
  if $argc > 0
    if $arg0 < thr_cnt_
      set $sess = &sess_info_[(int)$arg0]
    end
    if $arg0 >= thr_cnt_
      set $sess = (sess_info_t *)$arg0
    end
  end
  printf "SESS:[%d] serial_no=%d, status=", \
        $sess - &sess_info_[0], $sess->sess_serial_no
  output $sess->status
  printf ", flags=%x, clid=%d\n", $sess->flags, $sess->clid
  printf "    "
  print_txinfo $sess->txinfo
  printf "    userid=%d(%s), schema=%d(%d)\n", \
         $sess->userid, $sess->username, $sess->schemaid, $sess->schemaname
  printf "    role=%d[", $sess->enabled_role_cnt
  set $i = 0
  while $i < $sess->enabled_role_cnt
    printf "%d, ", $sess->enabled_roles[$i]
    set $i = $i + 1
  end
  printf "]\n"
end
document print_sess
usage: print_sess [session]

dumps session information. use current session if arg is missing
<session> argument can be one of the followings:
   tid       (tid_t)
   sess_info (sess_info_t *)
end

define print_uextmap
  if $argc > 0
    set $uextmap = $arg0
  end
  if $argc == 0
    set $uextmap = uextmap
  end
  call uextmap_dump(&debug_dstream, $uextmap)
end
document print_uextmap
usage: print_uextmap [uextmap]

print uextmap. use 'uextmap' variable if arg is missing
end

define print_bh
  call tcbh_dump(&debug_dstream, $arg0)
end
document print_bh
usage: print_bh bh

print buffer header information
end

define print_bucket
  call tcbucket_dump(&debug_dstream, $arg0)
end
document print_bucket
usage: print_bucket bucket

print buffer cache bucket information
end

define print_rpcol_get_len
    print (((int)*($arg0) <= 250) ? (int)*($arg0) + 1 : (int)((*(($arg0) + 1) << 8) + *(($arg0) + 2)) + 3)
end
document print_rpcol_get_len
usage: print_rpcol_get_len col

print column data length
end

# dump commands
define dump_lf
  set $dstream = thr_info_[tb_get_tid()].ti_dstream
  if !$dstream->filename[0]
    set $dstream = &dump_dstream
  end

  if $argc > 0 && $arg0 > 100
    call tclf_dump_archive($dstream, (char *)$arg0)
    return
  end

  if $argc == 0 || $arg0 < 100
    printf "current log file = %d\n", tccf_get_redo_thread_current_logfile()
    set $nth = 0
    set $max = (tsnval_t)-1
    if $argc > 0
      set $nth = $arg0
    end
    if $argc > 1
      set $max = (tsnval_t) $arg1
    end
    call tclf_dump($dstream, tccf_get_redo_thread_prev_logfile($nth), $max)
  end
end
document dump_lf
usage: dump_lf [nth [max]]
dump log file from nth previous log file until max tsn reaches
end

define dump_dba
  set $dstream = thr_info_[tb_get_tid()].ti_dstream
  if !$dstream->filename[0]
    set $dstream = &dump_dstream
  end
  call tcbuf_dump_current_with_addr($dstream, $arg0, $arg1)
end
document dump_dba
[dump_dba tsid dba] will dump block of (tsid, dba) to tracedump
end

define dump_buf
  set $dstream = thr_info_[tb_get_tid()].ti_dstream
  if !$dstream->filename[0]
    set $dstream = &dump_dstream
  end
  call tcblk_dump($dstream, tcbuf_get_blk($arg0))
end
document dump_buf
[dump_buf buf] will dump buf's block to tracedump
end

define dump_blk
  set $dstream = thr_info_[tb_get_tid()].ti_dstream
  if !$dstream->filename[0]
    set $dstream = &dump_dstream
  end
  call tcblk_dump($dstream, (tcblk_t *)$arg0)
end
document dump_blk
[dump_blk blk] will dump block to tracedump
end

define dump_alloc_regions
  set $h = &(((SVR_alloc_t *) $arg0)->regions)
  set $p = $h->next
  while $p != $h
    printf " addr = %p, size = %d\n", $p, $p->size
    set $p = $p->next
  end
end
document dump_alloc_regions
[dump_alloc_regions allocator] will dump regions in allocator
end

define dump_redzone
  set $d = (alloc_dbginfo_t *) $arg0
  set $f = ((char *) $arg0) + ((sizeof(alloc_dbginfo_t) + 7) / 8 * 8)
  set $r = $f + 8 + $d->size
  printf "FRONT: "
  output/x $f[0]
  printf " "
  output/x $f[1]
  printf " "
  output/x $f[2]
  printf " "
  output/x $f[3]
  printf "   "
  output/x $f[4]
  printf " "
  output/x $f[5]
  printf " "
  output/x $f[6]
  printf " "
  output/x $f[7]
  printf "\n"

  printf "REAR:  "
  output/x $r[0]
  printf " "
  output/x $r[1]
  printf " "
  output/x $r[2]
  printf " "
  output/x $r[3]
  printf "   "
  output/x $r[4]
  printf " "
  output/x $r[5]
  printf " "
  output/x $r[6]
  printf " "
  output/x $r[7]
  printf "\n"
end

define tid_find
  if $argc == 0
    thread apply all p tb_get_tid()
  else
    set $tid = $arg0
    set $n = tbsvr_frame_.wthr_per_proc + 1
    set $xx = -1
    printf "TID: %d, N:%d\n", $tid, $n
    while $n > 0 && $xx == -1
      thread $n
      if tb_get_tid() == $tid
        set $xx = $n
        set $n = 0
      else
        set $n = $n - 1
      end
    end
    if $xx != -1
      printf "thread %d ==> TID %d\n", $xx, $tid
    else
      printf "cannot find tid %d\n", $tid
    end
  end
end
document tid_find
[tid_find [tid]] may find thread having given tid.
if no argument, print all tid.
end

# b ppc_add
# commands
#   silent
#   printf "PLAN FOR '%s':\n", stmt
#   print_plan pp->root
#   printf "PLAN END\n"
#   continue
# end

