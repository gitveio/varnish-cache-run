#!/bin/bash

export ret="MAIN.uptime,MAIN.sess_conn,MAIN.sess_drop,MAIN.sess_fail,MAIN.client_req,MAIN.cache_hit,MAIN.cache_hit_grace,MAIN.cache_hitpass,MAIN.cache_hitmiss,MAIN.cache_miss,MAIN.pools,MAIN.threads,MAIN.threads_limited,MAIN.threads_created,MAIN.n_object,MAIN.n_vampireobject,MAIN.n_objectcore,MAIN.n_objecthead,MAIN.n_backend,MAIN.n_expired,MAIN.n_lru_nuked,MAIN.n_lru_moved,MAIN.s_sess,MAIN.s_pipe,MAIN.s_pass,MAIN.s_fetch,MAIN.s_synth,MAIN.s_resp_hdrbytes,MAIN.s_resp_bodybytes,MAIN.shm_records,MAIN.shm_writes,MAIN.shm_flushes,MAIN.shm_cont,MAIN.shm_cycles,MAIN.backend_req"

sh internal/stat-internal.sh | awk 'BEGIN{split(ENVIRON["ret"],a,",");for(k in a){arr[a[k]]=1}}{if(arr[$1] == 1){print $0}}'
