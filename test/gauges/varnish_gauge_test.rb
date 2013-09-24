require_relative '../test_helper'

class VarnishGaugeTest < MiniTest::Unit::TestCase
  attr_accessor :json, :gauge

  def host ; 'example.com' ; end
  def username ; 'adam' ; end
  def password ; 'password' ; end

  def setup
    super
    @gauge = Harness::VarnishGauge.new host, username, password
    @json = <<-json
      {
        "timestamp": "2013-09-23T22:55:15",
        "client_conn": {"value": 0, "flag": "a","description": "Client connections accepted" },
        "client_drop": {"value": 5, "flag": "a","description": "Connection dropped, no sess/wrk" },
        "client_req": {"value": 84556861, "flag": "a","description": "Client requests received" },
        "cache_hit": {"value": 1036019, "flag": "a","description": "Cache hits" },
        "cache_hitpass": {"value": 85592917, "flag": "a","description": "Cache hits for pass" },
        "cache_miss": {"value": 42631, "flag": "a","description": "Cache misses" },
        "backend_conn": {"value": 40013, "flag": "a","description": "Backend conn. success" },
        "backend_unhealthy": {"value": 3504722, "flag": "a","description": "Backend conn. not attempted" },
        "backend_busy": {"value": 80916878, "flag": "a","description": "Backend conn. too many" },
        "backend_fail": {"value": 0, "flag": "a","description": "Backend conn. failures" },
        "backend_reuse": {"value": 0, "flag": "a","description": "Backend conn. reuses" },
        "backend_toolate": {"value": 220596, "flag": "a","description": "Backend conn. was closed" },
        "backend_recycle": {"value": 0, "flag": "a","description": "Backend conn. recycles" },
        "backend_retry": {"value": 0, "flag": "a","description": "Backend conn. retry" },
        "fetch_head": {"value": 0, "flag": "a","description": "Fetch head" },
        "fetch_length": {"value": 0, "flag": "a","description": "Fetch with Length" },
        "fetch_chunked": {"value": 228231, "flag": "a","description": "Fetch chunked" },
        "fetch_eof": {"value": 904488, "flag": "a","description": "Fetch EOF" },
        "fetch_bad": {"value": 737, "flag": "a","description": "Fetch had bad headers" },
        "fetch_close": {"value": 67, "flag": "a","description": "Fetch wanted close" },
        "fetch_oldhttp": {"value": 6575, "flag": "a","description": "Fetch pre HTTP/1.1 closed" },
        "fetch_zero": {"value": 0, "flag": "a","description": "Fetch zero len" },
        "fetch_failed": {"value": 6578, "flag": "a","description": "Fetch failed" },
        "fetch_1xx": {"value": 13916, "flag": "a","description": "Fetch no body (1xx)" },
        "fetch_204": {"value": 56814, "flag": "a","description": "Fetch no body (204)" },
        "fetch_304": {"value": 90, "flag": "a","description": "Fetch no body (304)" },
        "n_sess_mem": {"value": 41, "flag": "i","description": "N struct sess_mem" },
        "n_sess": {"value": 33989, "flag": "i","description": "N struct sess" },
        "n_object": {"value": 0, "flag": "i","description": "N struct object" },
        "n_vampireobject": {"value": 822808, "flag": "i","description": "N unresurrected objects" },
        "n_objectcore": {"value": 0, "flag": "i","description": "N struct objectcore" },
        "n_objecthead": {"value": 81690, "flag": "i","description": "N struct objecthead" },
        "n_waitinglist": {"value": 0, "flag": "i","description": "N struct waitinglist" },
        "n_vbc": {"value": 6, "flag": "i","description": "N struct vbc" },
        "n_wrk": {"value": 16544049, "flag": "i","description": "N worker threads" },
        "n_wrk_create": {"value": 0, "flag": "a","description": "N worker threads created" },
        "n_wrk_failed": {"value": 631006, "flag": "a","description": "N worker threads not created" },
        "n_wrk_max": {"value": 20, "flag": "a","description": "N worker threads limited" },
        "n_wrk_lqueue": {"value": 0, "flag": "a","description": "work request queue length" },
        "n_wrk_queued": {"value": 85212875, "flag": "a","description": "N queued work requests" },
        "n_wrk_drop": {"value": 0, "flag": "a","description": "N dropped work requests" },
        "n_backend": {"value": 6300814, "flag": "i","description": "N backends" },
        "n_expired": {"value": 87102449, "flag": "i","description": "N expired objects" },
        "n_lru_nuked": {"value": 146, "flag": "i","description": "N LRU nuked objects" },
        "n_lru_moved": {"value": 69307648, "flag": "i","description": "N LRU moved objects" },
        "losthdr": {"value": 85814928, "flag": "a","description": "HTTP header overflows" },
        "n_objsendfile": {"value": 60441105913, "flag": "a","description": "Objects sent with sendfile" },
        "n_objwrite": {"value": 207939561558, "flag": "a","description": "Objects sent with write" },
        "n_objoverflow": {"value": 169491, "flag": "a","description": "Objects overflowing workspace" },
        "s_sess": {"value": 0, "flag": "a","description": "Total Sessions" },
        "s_req": {"value": 0, "flag": "a","description": "Total Requests" },
        "s_pipe": {"value": 86970666, "flag": "a","description": "Total pipe" },
        "s_pass": {"value": 29381735, "flag": "a","description": "Total pass" },
        "s_fetch": {"value": 9724856547, "flag": "a","description": "Total fetch" },
        "s_hdrbytes": {"value": 309315533, "flag": "a","description": "Total header bytes" },
        "s_bodybytes": {"value": 0, "flag": "a","description": "Total body bytes" },
        "sess_closed": {"value": 53077, "flag": "a","description": "Session Closed" },
        "sess_pipeline": {"value": 4944, "flag": "a","description": "Session Pipeline" },
        "sess_readahead": {"value": 37563, "flag": "a","description": "Session Read Ahead" },
        "sess_linger": {"value": 0, "flag": "a","description": "Session Linger" },
        "sess_herd": {"value": 0, "flag": "a","description": "Session herd" },
        "shm_records": {"value": 15742734, "flag": "a","description": "SHM records" },
        "shm_writes": {"value": 15742734, "flag": "a","description": "SHM writes" },
        "shm_flushes": {"value": 85812084, "flag": "a","description": "SHM flushes due to overflow" },
        "shm_cont": {"value": 20, "flag": "a","description": "SHM MTX contention" },
        "shm_cycles": {"value": 20, "flag": "a","description": "SHM cycles through buffer" },
        "sms_nreq": {"value": 0, "flag": "a","description": "SMS allocator requests" },
        "sms_nobj": {"value": 5, "flag": "i","description": "SMS outstanding allocations" },
        "sms_nbytes": {"value": 5, "flag": "i","description": "SMS outstanding bytes" },
        "sms_balloc": {"value": 0, "flag": "i","description": "SMS bytes allocated" },
        "sms_bfree": {"value": 1134, "flag": "i","description": "SMS bytes freed" },
        "backend_req": {"value": 1467, "flag": "a","description": "Backend requests made" },
        "n_vcl": {"value": 2, "flag": "a","description": "N vcl total" },
        "n_vcl_avail": {"value": 18178495, "flag": "a","description": "N vcl available" },
        "n_vcl_discard": {"value": 15793197, "flag": "a","description": "N vcl discarded" },
        "n_ban": {"value": 15793196, "flag": "i","description": "N total active bans" },
        "n_ban_gone": {"value": 0, "flag": "i","description": "N total gone bans" },
        "n_ban_add": {"value": 0, "flag": "a","description": "N new bans added" },
        "n_ban_retire": {"value": 0, "flag": "a","description": "N old bans deleted" },
        "n_ban_obj_test": {"value": 0, "flag": "a","description": "N objects tested" },
        "n_ban_re_test": {"value": 553741, "flag": "a","description": "N regexps tested against" },
        "n_ban_dups": {"value": 0, "flag": "a","description": "N duplicate bans removed" },
        "hcb_nolock": {"value": 0, "flag": "a","description": "HCB Lookups without lock" },
        "hcb_lock": {"value": 0, "flag": "a","description": "HCB Lookups with lock" },
        "hcb_insert": {"value": 0, "flag": "a","description": "HCB Inserts" },
        "esi_errors": {"value": 0, "flag": "a","description": "ESI parse errors (unlock)" },
        "esi_warnings": {"value": 0, "flag": "a","description": "ESI parse warnings (unlock)" },
        "accept_fail": {"value": 47779719, "flag": "a","description": "Accept failures" },
        "client_drop_late": {"value": 2011178236782, "flag": "a","description": "Connection dropped late" },
        "uptime": {"value": 7021781765249302528, "flag": "a","description": "Client uptime" },
        "dir_dns_lookups": {"value": 29549, "flag": "a","description": "DNS director lookups" },
        "dir_dns_failed": {"value": 0, "flag": "a","description": "DNS director failed lookups" },
        "dir_dns_hit": {"value": 0, "flag": "a","description": "DNS director cached lookups hit" },
        "dir_dns_cache_full": {"value": 0, "flag": "a","description": "DNS director full dnscache" },
        "vmods": {"value": 0, "flag": "i","description": "Loaded VMODs" },
        "n_gzip": {"value": 0, "flag": "a","description": "Gzip operations" },
        "n_gunzip": {"value": 0, "flag": "a","description": "Gunzip operations" },
        "sess_pipe_overflow": {"value": 0, "flag": "c","description": "Dropped sessions due to session pipe overflow" },
        "LCK.sms.creat": {"type": "LCK", "ident": "sms", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.sms.destroy": {"type": "LCK", "ident": "sms", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.sms.locks": {"type": "LCK", "ident": "sms", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.sms.colls": {"type": "LCK", "ident": "sms", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.smp.creat": {"type": "LCK", "ident": "smp", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.smp.destroy": {"type": "LCK", "ident": "smp", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.smp.locks": {"type": "LCK", "ident": "smp", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.smp.colls": {"type": "LCK", "ident": "smp", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.sma.creat": {"type": "LCK", "ident": "sma", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.sma.destroy": {"type": "LCK", "ident": "sma", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.sma.locks": {"type": "LCK", "ident": "sma", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.sma.colls": {"type": "LCK", "ident": "sma", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.smf.creat": {"type": "LCK", "ident": "smf", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.smf.destroy": {"type": "LCK", "ident": "smf", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.smf.locks": {"type": "LCK", "ident": "smf", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.smf.colls": {"type": "LCK", "ident": "smf", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.hsl.creat": {"type": "LCK", "ident": "hsl", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.hsl.destroy": {"type": "LCK", "ident": "hsl", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.hsl.locks": {"type": "LCK", "ident": "hsl", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.hsl.colls": {"type": "LCK", "ident": "hsl", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.hcb.creat": {"type": "LCK", "ident": "hcb", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.hcb.destroy": {"type": "LCK", "ident": "hcb", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.hcb.locks": {"type": "LCK", "ident": "hcb", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.hcb.colls": {"type": "LCK", "ident": "hcb", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.hcl.creat": {"type": "LCK", "ident": "hcl", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.hcl.destroy": {"type": "LCK", "ident": "hcl", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.hcl.locks": {"type": "LCK", "ident": "hcl", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.hcl.colls": {"type": "LCK", "ident": "hcl", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.vcl.creat": {"type": "LCK", "ident": "vcl", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.vcl.destroy": {"type": "LCK", "ident": "vcl", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.vcl.locks": {"type": "LCK", "ident": "vcl", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.vcl.colls": {"type": "LCK", "ident": "vcl", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.stat.creat": {"type": "LCK", "ident": "stat", "value": 7169389, "flag": "a","description": "Created locks" },
        "LCK.stat.destroy": {"type": "LCK", "ident": "stat", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.stat.locks": {"type": "LCK", "ident": "stat", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.stat.colls": {"type": "LCK", "ident": "stat", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.sessmem.creat": {"type": "LCK", "ident": "sessmem", "value": 116, "flag": "a","description": "Created locks" },
        "LCK.sessmem.destroy": {"type": "LCK", "ident": "sessmem", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.sessmem.locks": {"type": "LCK", "ident": "sessmem", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.sessmem.colls": {"type": "LCK", "ident": "sessmem", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.wstat.creat": {"type": "LCK", "ident": "wstat", "value": 29285, "flag": "a","description": "Created locks" },
        "LCK.wstat.destroy": {"type": "LCK", "ident": "wstat", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.wstat.locks": {"type": "LCK", "ident": "wstat", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.wstat.colls": {"type": "LCK", "ident": "wstat", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.herder.creat": {"type": "LCK", "ident": "herder", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.herder.destroy": {"type": "LCK", "ident": "herder", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.herder.locks": {"type": "LCK", "ident": "herder", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.herder.colls": {"type": "LCK", "ident": "herder", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.wq.creat": {"type": "LCK", "ident": "wq", "value": 29284, "flag": "a","description": "Created locks" },
        "LCK.wq.destroy": {"type": "LCK", "ident": "wq", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.wq.locks": {"type": "LCK", "ident": "wq", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.wq.colls": {"type": "LCK", "ident": "wq", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.objhdr.creat": {"type": "LCK", "ident": "objhdr", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.objhdr.destroy": {"type": "LCK", "ident": "objhdr", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.objhdr.locks": {"type": "LCK", "ident": "objhdr", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.objhdr.colls": {"type": "LCK", "ident": "objhdr", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.exp.creat": {"type": "LCK", "ident": "exp", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.exp.destroy": {"type": "LCK", "ident": "exp", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.exp.locks": {"type": "LCK", "ident": "exp", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.exp.colls": {"type": "LCK", "ident": "exp", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.lru.creat": {"type": "LCK", "ident": "lru", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.lru.destroy": {"type": "LCK", "ident": "lru", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.lru.locks": {"type": "LCK", "ident": "lru", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.lru.colls": {"type": "LCK", "ident": "lru", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.cli.creat": {"type": "LCK", "ident": "cli", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.cli.destroy": {"type": "LCK", "ident": "cli", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.cli.locks": {"type": "LCK", "ident": "cli", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.cli.colls": {"type": "LCK", "ident": "cli", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.ban.creat": {"type": "LCK", "ident": "ban", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.ban.destroy": {"type": "LCK", "ident": "ban", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.ban.locks": {"type": "LCK", "ident": "ban", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.ban.colls": {"type": "LCK", "ident": "ban", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.vbp.creat": {"type": "LCK", "ident": "vbp", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.vbp.destroy": {"type": "LCK", "ident": "vbp", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.vbp.locks": {"type": "LCK", "ident": "vbp", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.vbp.colls": {"type": "LCK", "ident": "vbp", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.vbe.creat": {"type": "LCK", "ident": "vbe", "value": 6581861, "flag": "a","description": "Created locks" },
        "LCK.vbe.destroy": {"type": "LCK", "ident": "vbe", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.vbe.locks": {"type": "LCK", "ident": "vbe", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.vbe.colls": {"type": "LCK", "ident": "vbe", "value": 0, "flag": "a","description": "Collisions" },
        "LCK.backend.creat": {"type": "LCK", "ident": "backend", "value": 0, "flag": "a","description": "Created locks" },
        "LCK.backend.destroy": {"type": "LCK", "ident": "backend", "value": 0, "flag": "a","description": "Destroyed locks" },
        "LCK.backend.locks": {"type": "LCK", "ident": "backend", "value": 0, "flag": "a","description": "Lock Operations" },
        "LCK.backend.colls": {"type": "LCK", "ident": "backend", "value": 0, "flag": "a","description": "Collisions" },
        "SMA.s0.c_req": {"type": "SMA", "ident": "s0", "value": 8386111880971681792, "flag": "a","description": "Allocator requests" },
        "SMA.s0.c_fail": {"type": "SMA", "ident": "s0", "value": 18380892363816960, "flag": "a","description": "Allocator failures" },
        "SMA.s0.c_bytes": {"type": "SMA", "ident": "s0", "value": 7953764122015825920, "flag": "a","description": "Bytes allocated" },
        "SMA.s0.c_freed": {"type": "SMA", "ident": "s0", "value": 500068346227, "flag": "a","description": "Bytes freed" },
        "SMA.s0.g_alloc": {"type": "SMA", "ident": "s0", "value": 0, "flag": "i","description": "Allocations outstanding" },
        "SMA.s0.g_bytes": {"type": "SMA", "ident": "s0", "value": 0, "flag": "i","description": "Bytes outstanding" },
        "SMA.s0.g_space": {"type": "SMA", "ident": "s0", "value": 0, "flag": "i","description": "Bytes available" },
        "SMA.Transient.c_req": {"type": "SMA", "ident": "Transient", "value": 8386111880971681792, "flag": "a","description": "Allocator requests" },
        "SMA.Transient.c_fail": {"type": "SMA", "ident": "Transient", "value": 19494710527655936, "flag": "a","description": "Allocator failures" },
        "SMA.Transient.c_bytes": {"type": "SMA", "ident": "Transient", "value": 7018408549474631680, "flag": "a","description": "Bytes allocated" },
        "SMA.Transient.c_freed": {"type": "SMA", "ident": "Transient", "value": 3330185636177276021, "flag": "a","description": "Bytes freed" },
        "SMA.Transient.g_alloc": {"type": "SMA", "ident": "Transient", "value": 4047658754839162416, "flag": "i","description": "Allocations outstanding" },
        "SMA.Transient.g_bytes": {"type": "SMA", "ident": "Transient", "value": 691025968, "flag": "i","description": "Bytes outstanding" },
        "SMA.Transient.g_space": {"type": "SMA", "ident": "Transient", "value": 0, "flag": "i","description": "Bytes available" },
        "VBE.default(127.0.0.1,,8080).vcls": {"type": "VBE", "ident": "default(127.0.0.1,,8080)", "value": 0, "flag": "i","description": "VCL references" },
        "VBE.default(127.0.0.1,,8080).happy": {"type": "VBE", "ident": "default(127.0.0.1,,8080)", "value": 0, "flag": "b","description": "Happy health probes" },
        "VBE.app(127.0.0.1,,8080).vcls": {"type": "VBE", "ident": "app(127.0.0.1,,8080)", "value": 2699576, "flag": "i","description": "VCL references" },
        "VBE.app(127.0.0.1,,8080).happy": {"type": "VBE", "ident": "app(127.0.0.1,,8080)", "value": 0, "flag": "b","description": "Happy health probes" },
        "VBE.mobile(127.0.0.1,,8081).vcls": {"type": "VBE", "ident": "mobile(127.0.0.1,,8081)", "value": 10546, "flag": "i","description": "VCL references" },
        "VBE.mobile(127.0.0.1,,8081).happy": {"type": "VBE", "ident": "mobile(127.0.0.1,,8081)", "value": 0, "flag": "b","description": "Happy health probes" },
        "VBE.admin(127.0.0.1,,8082).vcls": {"type": "VBE", "ident": "admin(127.0.0.1,,8082)", "value": 11593457570688044, "flag": "i","description": "VCL references" },
        "VBE.admin(127.0.0.1,,8082).happy": {"type": "VBE", "ident": "admin(127.0.0.1,,8082)", "value": 0, "flag": "b","description": "Happy health probes" },
        "VBE.stage(37.123.145.122,,8000).vcls": {"type": "VBE", "ident": "stage(37.123.145.122,,8000)", "value": 11596790465309740, "flag": "i","description": "VCL references" },
        "VBE.stage(37.123.145.122,,8000).happy": {"type": "VBE", "ident": "stage(37.123.145.122,,8000)", "value": 0, "flag": "b","description": "Happy health probes" },
        "VBE.public_api(127.0.0.1,,8083).vcls": {"type": "VBE", "ident": "public_api(127.0.0.1,,8083)", "value": 0, "flag": "i","description": "VCL references" },
        "VBE.PUBLIC_API(127.0.0.1,,8083).HAPPY": {"TYPE": "VBE", "IDENT": "PUBLIC_API(127.0.0.1,,8083)", "VALUE": 0, "FLAG": "B","DESCRIPTION": "HAPPY HEALTH PROBES" }
      }
    json

    stub_request(:get, "#{username}:#{password}@#{host}/stats").to_return({
      status: 200,
      body: json
    })
  end

  def test_measures_misses
    log
    assert_gauge 'varnish.misses'
  end

  def test_measures_hits
    log
    assert_gauge 'varnish.hits'
  end

  def test_measures_hit_rate
    log
    assert_gauge 'varnish.hit_rate'
  end

  def test_measures_objects_in_cache
    log
    assert_gauge 'varnish.cached'
  end

  def test_measures_connections
    log
    assert_gauge 'varnish.connections'
  end

  def test_measures_requests
    log
    assert_gauge 'varnish.requests'
  end

  private
  def log
    gauge.log
  end
end
