
  test("coroutines", function (print, p, expect, uv)
    local touch = 0
    local function wait(ms)
      local this = coroutine.running()
      assert(this)
      local timer = uv.new_timer()
      timer:start(ms, 0, function ()
        timer:close()
        touch = touch + 1
        coroutine.resume(this)
        touch = touch + 1
      end)
      coroutine.yield()
      touch = touch + 1
      return touch
    end

    coroutine.wrap(function()
      print("begin wait")
      local touched = wait(1000)
      assert(touched==touch)
      print("end wait")
    end)()

    uv.run()

    assert(touch==3)
  end)

  test("test thread create", function(print, p, expect, uv)
    local delay = 100
    uv.update_time()
    local before = uv.now()
    local thread = uv.new_thread(function(delay)
      local uv = require('luv')
      local t1 = uv.thread_self()
      uv.sleep(delay)
      local t2 = uv.thread_self()
      assert(t1:equal(t2))
      assert(tostring(t1)==tostring(t2))
      _G.print('  In', uv.thread_self())
    end,delay)
    uv.thread_join(thread)
    uv.update_time()
    local elapsed = uv.now() - before
    p({
      delay = delay,
      elapsed = elapsed
    })
    assert(elapsed >= delay, "elapsed should be at least delay ")
  end)

  test("test thread create with arguments", function(print, p, expect, uv)
    uv.update_time()
    local before = uv.now()
    local args = {500, 'string', nil, false, 5, "helloworld"}
    local unpack = unpack or table.unpack
    uv.new_thread(function(num,s,null,bool,five,hw)
      assert(type(num) == "number")
      assert(type(s) == "string")
      assert(null == nil)
      assert(bool == false)
      assert(five == 5)
      assert(hw == 'helloworld')
      require('luv').sleep(100)
    end, unpack(args)):join()
    uv.update_time()
    local elapsed = uv.now() - before
    assert(elapsed >= 100, "elapsed should be at least delay ")
  end)

  test("test thread sleep msecs in main thread", function(print, p, expect, uv)
    local delay = 100
    uv.update_time()
    local before = uv.now()
    print('Running', uv.thread_self())
    uv.sleep(delay)
    print('Running', uv.thread_self())
    uv.update_time()
    local elapsed = uv.now() - before
    p({
      delay = delay,
      elapsed = elapsed
    })
    assert(elapsed >= delay, "elapsed should be at least delay ")
  end)

  test("test thread create with options table", function(print, p, expect, uv)
    local delay = 100
    uv.update_time()
    local before = uv.now()
    local args = {delay, 'string', nil, false, 5, 3.14, "helloworld"}
    local unpack = unpack or table.unpack
    uv.new_thread({stack_size=0}, function(delay,s,null,bool,five,pi,hw)
      assert(type(delay) == "number")
      assert(type(s) == "string")
      assert(null == nil)
      assert(bool == false)
      assert(five == 5)
      assert(tostring(five) == '5', 'invalid integer to string ('..tostring(five)..')')
      if math.type then
        assert(math.type(five) == 'integer', 'invalid integer')
      end
      assert(pi == 3.14, 'invalid decimal number')
      assert(hw == 'helloworld')
      require('luv').sleep(delay)
    end, unpack(args)):join()
    uv.update_time()
    local elapsed = uv.now() - before
    p({
      delay = delay,
      elapsed = elapsed
    })
    assert(elapsed >= 100, "elapsed should be at least delay ")
  end, "1.26.0")

  test("test thread arguments limit", function(print, p, expect, uv)
    local args = {}
    args[1] = uv.new_async(expect(function (n)
      assert(n==9)
      args[1]:close()
    end))
    for i=2, 10 do
      args[i] = i
    end
    local unpack = unpack or table.unpack
    uv.new_thread(function(...)
      local arg = {...}
      assert(#arg == 9)
      arg[1]:send(#arg)
    end, unpack(args)):join()
    assert(#args==10)
  end)

  test("test avoid thread be released before it done", function(print, p, expect, uv)
    uv.new_thread(function(...)
        io.write(table.concat({...}, " ") .. ' from thread\n')
      end, 'hello', 'world')
    collectgarbage('collect')
    collectgarbage('collect')
    collectgarbage('collect')
  end)

  test("thread_getcpu", function(print, p, expect, uv)
    local cpu, err = uv.thread_getcpu()
    if not cpu then
      print(err, "skipping")
      return
    end
    -- starts at 1 to match the tables used by getaffinity/setaffinity
    assert(cpu >= 1)
  end, "1.45.0")

  test("getaffinity, setaffinity", function(print, p, expect, uv)
    local mask_size, err = uv.cpumask_size()
    if not mask_size then
      print(err, "skipping")
      return
    end
    uv.new_thread(function(cpumask_size)
      local _uv = require('luv')
      local thread = _uv.thread_self()
      local affinity = assert(thread:getaffinity())
      assert(#affinity == cpumask_size)

      -- set every cpu's affinity to false except the current cpu
      local cur_cpu = _uv.thread_getcpu()
      -- even though this table may not be a full array-like table,
      -- this still works because `setaffinity` will treat any missing
      -- CPU numbers up to cpumask_size as having a setting of `false`
      local affinity_to_set = {
        [cur_cpu] = true,
      }
      local prev_affinity = assert(thread:setaffinity(affinity_to_set, true))
      -- the returned affinity should match the original affinity
      assert(#prev_affinity == #affinity)
      for i=1,#affinity do
        assert(prev_affinity[i] == affinity[i])
      end

      local new_affinity = thread:getaffinity()
      assert(#new_affinity == cpumask_size)
      for i=1,#new_affinity do
        local expected_setting = i == cur_cpu
        assert(new_affinity[i] == expected_setting)
      end
    end, mask_size):join()
  end, "1.45.0")

  test("getpriority, setpriority", function(_, p, _, uv)
    assert(type(uv.constants.THREAD_PRIORITY_HIGHEST)=='number')
    assert(type(uv.constants.THREAD_PRIORITY_ABOVE_NORMAL)=='number')
    assert(type(uv.constants.THREAD_PRIORITY_NORMAL)=='number')
    assert(type(uv.constants.THREAD_PRIORITY_BELOW_NORMAL)=='number')
    assert(type(uv.constants.THREAD_PRIORITY_LOWEST)=='number')

    local sem = uv.new_sem(0)
    local thread = uv.new_thread(function(sem)
      local _uv = require('luv')
      local self = _uv.thread_self()
      _uv.sem_wait(sem)
      local priority = assert(self:getpriority())
      print('priority in thread', priority)
    end, sem)

    uv.sleep(100)

    local priority = assert(thread:getpriority())
    print('default priority', priority)

    assert(thread:setpriority(uv.constants.THREAD_PRIORITY_LOWEST))
    priority = assert(thread:getpriority())
    print('priority after change', priority)

    sem:post()
    thread:join()
  end, "1.48.0")

  test("getname, setname", function(_, p, _, uv)
    local thread = uv.new_thread(function()
      local _uv = require('luv')

      local self = _uv.thread_self()
      local name = "abc"
      assert(_uv.thread_setname(name))
      local new_name = _uv.thread_getname(self)
      assert(new_name == name, 'unexpected name: '..tostring(new_name))
    end)
    thread:join()
  end, "1.50.0")

  test("detach", function(_, p, _, uv)
    local thread = uv.new_thread(function(...)
      print(table.concat({...}, ' ') .. ' from detached thread')
    end, 'hello', 'world')
    thread:detach()
  end, "1.50.0")

  test("get type", function (print, p, expect, uv)
    local pipe = assert(uv.new_pipe())

    local typename, typeid = pipe:get_type()
    assert(typename == "pipe")

    local typename_, typeid_ = uv.handle_get_type(pipe)
    assert(typename == typename_)
    assert(typeid == typeid_)

    pipe:close()
  end, "1.19.0")


  test("idle time", function (print, p, expect, uv)
    local NS_TO_MS = 1000000
    local timeout = 1000
    local timer = uv.new_timer()
    local counter = 0
    timer:start(timeout, 0, function()
      counter = counter + 1
      local t = uv.hrtime()

      -- Spin for 500 ms to spin loop time out of the delta check.
      while uv.hrtime() - t < 600 * NS_TO_MS do end
      timer:close()

      local metrics = uv.metrics_info()
      p(metrics)
      assert(metrics.loop_count > 0)
      assert(metrics.events >= 0)
      assert(metrics.events_waiting >= 0)
    end)

    local metrics = assert(uv.metrics_info())
    p(metrics)
    assert(metrics.loop_count >= 0)
    assert(metrics.events >= 0)
    assert(metrics.events_waiting >= 0)
  end, "1.45.0")

local function setTimeout(callback, ms)
  local timer = uv.new_timer()
  timer:start(ms, 0, function()
    uv.walk(function(...)
      print('uv.walk() in Main Lua', ...)
    end)
    timer:stop()
    timer:close()
    callback()
  end)
  return timer
end

setTimeout(function()
  print('Main Lua done')
end, 1000)

local delay = 100
uv.update_time()
local before = uv.now()
local thread = uv.new_thread(function(delay)
  local uv = require('uv')
  local t1 = uv.thread_self()
  uv.sleep(delay)
  local t2 = uv.thread_self()
  assert(t1:equal(t2))
  assert(tostring(t1)==tostring(t2))
  _G.print('Running', uv.thread_self())

  assert(_THREAD)

  local function setTimeout(callback, ms)
    local timer = uv.new_timer()
    timer:start(ms, 0, function()
      uv.walk(function(...)
        print('in thread Lua', ...)
      end)
      timer:stop()
      timer:close()
      callback()
    end)
    return timer
  end

  setTimeout(function()
    print('thread Lua done')
  end, 1000)
  uv.run()
end,delay)
print('launch thread:', thread)

uv.thread_join(thread)
-- uv.update_time()
-- local elapsed = uv.now() - before
-- assert(elapsed >= delay, "elapsed should be at least delay ")

uv.run()
print('DONE')
  -- port of https://github.com/libuv/libuv/blob/fa8b4f27c023638918e645ef997c3b56a3a5e681/test/test-metrics.c#L39-L63
  test("idle time", function (print, p, expect, uv)
    local NS_TO_MS = 1000000
    local timeout = 1000
    uv.loop_configure('metrics_idle_time')
    local timer = uv.new_timer()
    local counter = 0
    timer:start(timeout, 0, function()
      counter = counter + 1
      local t = uv.hrtime()

      -- Spin for 500 ms to spin loop time out of the delta check.
      while uv.hrtime() - t < 600 * NS_TO_MS do end
      timer:close()

      local idle_time = uv.metrics_idle_time()
      assert(idle_time <= (timeout + 500) * NS_TO_MS, "idle_time larger than expected: "..idle_time)
      assert(idle_time >= (timeout - 500) * NS_TO_MS, "idle_time smaller than expected: "..idle_time)
    end)
  end)

local function bench(uv, p, count, fn)
    collectgarbage()
    local before
    local notify = count / 8
    for i = 1, count do
      fn()
      if i % notify == 0 then
        uv.run()
        collectgarbage()
        local now = uv.resident_set_memory()
        if not before then before = now end
        p(i, now)
      end
    end
    uv.run()
    collectgarbage()
    local after = uv.resident_set_memory()
    p{
      before = before,
      after = after,
    }
    assert(after < before * 1.5)
  end

  test("fs-write", function (print, p, expect, uv)
    bench(uv, p, 0xf00, function ()
      local path = "_test_"
      local fd = assert(uv.fs_open(path, "w", 438))
      uv.fs_write(fd, "Hello World\n", -1)
      uv.fs_write(fd, {"with\n", "more\n", "lines\n"}, -1)
      uv.fs_close(fd)
      uv.fs_unlink(path)
    end)
  end)

local workerPath = pathJoin(module.dir, "worker.lua")
for i = 1, #uv.cpu_info() do
  local pipe = uv.new_pipe(true)
  local child, pid
  child, pid = uv.spawn(uv.exepath(), {
    args = {workerPath},
    stdio = {0,1,2,pipe},
  }, function (code, signal)
    print("Worker " .. i .. " exited with code " .. code .. " and signal " .. signal)
    uv.close(child)
  end)
  uv.write2(pipe, ".", server, function (err)
    assert(not err, err)
    uv.close(pipe)
  end)
  print("Worker " .. i .. " spawned at pid " .. pid)
end
print("Test HTTP server at http://127.0.0.1:808
require('tap')(function(test)

  test('main', function()
    p('main:',thread.self())
  end)

  test('thread', function()
    local thr = thread.start(function(a,b,c)
      local thread = require'thread'
      local fs = require'fs'
      assert(a+b==c)
      print(string.format('%d+%d=%d',a,b,c))
      p('child',thread.self())

      local fd = assert(fs.openSync('thread.tmp', "w+"))
      fs.writeSync(fd,0,tostring(thread.self()))
      assert(fs.closeSync(fd))
    end,2,4,6)
    local id = tostring(thr)
    thr:join()

    local chunk = fs.readFileSync('thread.tmp')
    p(chunk,id)
    assert(chunk==id)
    fs.unlinkSync('thread.tmp')
  end)

  test('threadpool', function()
    local work = thread.work(
      function(n)
        local thread = require'thread'

        local self = tostring(thread.self())
        return self, n, n*n
      end,
      function(id,n,r)
        print(id,n,r)
        p('work result cb', id, n*n==r)
      end
    )

    thread.queue(work, 2)
    thread.queue(work, 4)
    thread.queue(work, 6)
    thread.queue(work, 8)
    thread.queue(work, 2)
    thread.queue(work, 4)
    thread.queue(work, 6)
    thread.queue(work, 8)
  end)
end)
require('tap')(function (test)
  local path = require('path')
  local fs = require('fs')
  local __dirname = module.dir
  local name = 'test-pipe'
  local tmp_file = path.join(__dirname, 'tmp', name)
  fs.writeFileSync(tmp_file, "")

  local streamEventClosed = false
  local streamEventAlreadyClosed = false

  local file_path = path.join(__dirname, name..'.lua')
  test("pipe", function()
    local fp = fs.createReadStream(file_path)
    local null = fs.createWriteStream(tmp_file)
    null:on('error', function(err)
      p(err)
      if err.message:find('write after end') then
        streamEventAlreadyClosed = true
      end
    end)
    null:on('closed', function()
      p('closed')
      streamEventClosed = true
      null:write('after closed')
    end)
    fp:pipe(null)

    assert(true)
  end)
  test("remove all listeners", function(expect)
    local em = require('core').Emitter:new()
    assert(#em:listeners('data') == 0)

    em:on('data', function() end)
    em:removeAllListeners()

    em:on('data', expect(function() end))
    em:emit('data', 'Go Fish')

    em:on('event', function() end)
    em:on('event', function() end)

    assert(em:listenerCount('data') == 1)
    assert(em:listenerCount('event') == 2)
    assert(em:listenerCount('data')  == #em:listeners('data'))
    assert(em:listenerCount('event') == #em:listeners('event'))

    em:removeAllListeners('data')

    assert(em:listenerCount('data') == 0)
    assert(em:listenerCount('event') == 2)

    em:removeAllListeners('unused_listener')

    assert(em:listenerCount('data') == 0)
    assert(em:listenerCount('event') == 2)

    em:removeAllListeners()

    assert(em:listenerCount('data') == 0)
    assert(em:listenerCount('event') == 0)
    assert(em:listenerCount('data')  == #em:listeners('data'))
    assert(em:listenerCount('event') == #em:listeners('event'))
  end)
--  "F"
--  "NIL"
--  "_"
--  "_create_ts_parser"
--  "_create_ts_querycursor"
--  "_cs_remote"
--  "_defer_deprecated_module"
--  "_defer_require"
--  "_empty_dict_mt"
--  "_ensure_list"
--  "_expand_pat"
--  "_expand_pat_get_parts"
--  "_extra"
--  "_foldupdate"
--  "_getvar"
--  "_list_insert"
--  "_list_remove"
--  "_load_package"
--  "_on_key"
--  "_os_proc_children"
--  "_os_proc_info"
--  "_print"
--  "_resolve_bufnr"
--  "_setvar"
--  "_so_trails"
--  "_str_byteindex"
--  "_str_utfindex"
--  "_submodules"
--  "_truncated_echo_once"
--  "_ts_add_language_from_object"
--  "_ts_get_language_version"
--  "_ts_get_minimum_language_version"
--  "_ts_has_language"
--  "_ts_inspect_language"
--  "_ts_parse_query"
--  "_ts_remove_language"
--  "_with"
--  "_with_c"
--  "api"
--  "b"
--  "base64"
--  "bo"
--  "call"
--  "cmd"
--  "dbg"
--  "dbgbuf"
--  "dbglog"
--  "dbgout"
--  "dbgtime"
--  "deep_equal"
--  "deepcopy"
--  "defaulttable"
--  "defer_fn"
--  "deprecate"
--  "diagnostic"
--  "diff"
--  "empty_dict"
--  "endswith"
--  "env"
--  "filetype"
--  "fn"
--  "fs"
--  "func"
--  "funcref"
--  "g"
--  "go"
--  "gsplit"
--  "health"
--  "highlight"
--  "hl"
--  "iconv"
--  "import"
--  "in_fast_event"
--  "inspect"
--  "is_callable"
--  "is_thread"
--  "isarray"
--  "islist"
--  "iter"
--  "json"
--  "keycode"
--  "keymap"
--  "list_contains"
--  "list_extend"
--  "list_slice"
--  "loader"
--  "log"
--  "loop"
--  "lpeg"
--  "lsp"
--  "lua_omnifunc"
--  "mpack"
--  "notify"
--  "notify_once"
--  "o"
--  "on_key"
--  "opt"
--  "opt_global"
--  "opt_local"
--  "paste"
--  "pesc"
--  "print"
--  "regex"
--  "region"
--  "reload"
--  "ringbuf"
--  "rpcnotify"
--  "rpcrequest"
--  "schedule"
--  "schedule_wrap"
--  "snippet"
--  "spairs"
--  "spell"
--  "split"
--  "startswith"
--  "str_byteindex"
--  "str_utf_end"
--  "str_utf_pos"
--  "str_utf_start"
--  "str_utfindex"
--  "stricmp"
--  "system"
--  "t"
--  "tbl_add_reverse_lookup"
--  "tbl_contains"
--  "tbl_count"
--  "tbl_deep_extend"
--  "tbl_extend"
--  "tbl_filter"
--  "tbl_flatten"
--  "tbl_get"
--  "tbl_isempty"
--  "tbl_islist"
--  "tbl_keys"
--  "tbl_map"
--  "tbl_values"
--  "text"
--  "treesitter"
--  "trim"
--  "type_idx"
--  "types"
--  "ui"
--  "ui_attach"
--  "ui_detach"
--  "uri_encode"
--  "uri_from_bufnr"
--  "uri_from_fname"
--  "uri_to_bufnr"
--  "uri_to_fname"
--  "uv"
--  "v"
--  "val_idx"
--  "validate"
--  "version"
--  "w"
--  "wait"
--  "wo"
--- - [Constants][]
--- - [Error Handling][]
--- - [Version Checking][]
--- - [`uv_loop_t`][] — Event loop
--- - [`uv_req_t`][] — Base request
--- - [`uv_handle_t`][] — Base handle
---   - [`uv_timer_t`][] — Timer handle
---   - [`uv_prepare_t`][] — Prepare handle
---   - [`uv_check_t`][] — Check handle
---   - [`uv_idle_t`][] — Idle handle
---   - [`uv_async_t`][] — Async handle
---   - [`uv_poll_t`][] — Poll handle
---   - [`uv_signal_t`][] — Signal handle
---   - [`uv_process_t`][] — Process handle
---   - [`uv_stream_t`][] — Stream handle
---     - [`uv_tcp_t`][] — TCP handle
---     - [`uv_pipe_t`][] — Pipe handle
---     - [`uv_tty_t`][] — TTY handle
---   - [`uv_udp_t`][] — UDP handle
---   - [`uv_fs_event_t`][] — FS Event handle
---   - [`uv_fs_poll_t`][] — FS Poll handle
--- - [File system operations][]
--- - [Thread pool work scheduling][]
--- - [DNS utility functions][]
--- - [Threading and synchronization utilities][]
--- - [Miscellaneous utilities][]
--- - [Metrics operations][]

--- # Metrics operations

--- Retrieve the amount of time the event loop has been idle in the kernel’s event
--- provider (e.g. `epoll_wait`). The call is thread safe.
---
--- The return value is the accumulated time spent idle in the kernel’s event
--- provider starting from when the [`uv_loop_t`][] was configured to collect the idle time.
---
--- **Note:** The event loop will not begin accumulating the event provider’s idle
--- time until calling `loop_configure` with `"metrics_idle_time"`.
--- @return number
function uv.metrics_idle_time() end

--- @class uv.metrics_info.info
--- @field loop_count number
--- @field events integer
--- @field events_waiting number

--- Get the metrics table from current set of event loop metrics. It is recommended
--- to retrieve these metrics in a `prepare` callback (see `uv.new_prepare`,
--- `uv.prepare_start`) in order to make sure there are no inconsistencies with the
--- metrics counters.
--- @return uv.metrics_info.info info
function uv.metrics_info() end

--- Returns all environmental variables as a dynamic table of names associated with
--- their corresponding values.
--- **Warning**:
--- This function is not thread-safe.
--- @return table
function uv.os_environ() end
--- Returns the load average as a triad. Not supported on Windows.
--- @return number, number, number
function uv.loadavg() end

--- @class uv.os_uname.info
--- @field sysname string
--- @field release string
--- @field version string
--- @field machine string

--- Returns system information.
--- @return uv.os_uname.info info
function uv.os_uname() end

--- Returns the hostname.
--- @return string
function uv.os_gethostname() end
-- Prints all handles associated with the main loop to stderr. The format is
--- `[flags] handle-type handle-address`. Flags are `R` for referenced, `A` for
--- active and `I` for internal.
--- **Note**:
--- This is not available on Windows.
--- **Warning**:
--- This function is meant for ad hoc debugging, there are no API/ABI
--- stability guarantees.
function uv.print_all_handles() end

--- The same as `uv.print_all_handles()` except only active handles are printed.
--- **Note**:
--- This is not available on Windows.
--- **Warning**:
--- This function is meant for ad hoc debugging, there are no API/ABI
--- stability guarantees.
function uv.print_active_handles() end

--- Used to detect what type of stream should be used with a given file
--- descriptor `fd`. Usually this will be used during initialization to guess the
--- type of the stdio streams.
--- @param fd integer
--- @return string
function uv.guess_handle(fd) end

--- Gets the resource usage measures for the calling thread.
---
--- **Note** Not supported on all platforms. May return `ENOTSUP`.
--- On macOS and Windows not all fields are set (the unsupported fields are filled
--- with zeroes).
--- @return uv.getrusage.result? rusage
--- @return string? err
--- @return uv.error_name? err_name
function uv.getrusage_thread() end
--- @class uv.getrusage.result
---
--- (user CPU time used)
--- @field utime uv.getrusage.result.time
---
--- (system CPU time used)
--- @field stime uv.getrusage.result.time
---
--- (maximum resident set size)
--- @field maxrss integer
---
--- (integral shared memory size)
--- @field ixrss integer
---
--- (integral unshared data size)
--- @field idrss integer
---
--- (integral unshared stack size)
--- @field isrss integer
---
--- (page reclaims (soft page faults))
--- @field minflt integer
---
--- (page faults (hard page faults))
--- @field majflt integer
---
--- (swaps)
--- @field nswap integer
---
--- (block input operations)
--- @field inblock integer
---
--- (block output operations)
--- @field oublock integer
---
--- (IPC messages sent)
--- @field msgsnd integer
---
--- (IPC messages received)
--- @field msgrcv integer
---
--- (signals received)
--- @field nsignals integer
---
--- (voluntary context switches)
--- @field nvcsw integer
---
--- (involuntary context switches)
--- @field nivcsw integer

--- @class uv.getrusage.result.time
--- @field sec integer
--- @field usec integer

--- Returns the resource usage.
--- @return uv.getrusage.result? rusage
--- @return string? err
--- @return uv.error_name? err_name
--- Returns the resource usage.
--- @return uv.getrusage.result? rusage
--- @return string? err
--- @return uv.error_name? err_name
function uv.getrusage() end

--- Gets the resource usage measures for the calling thread.
---
--- **Note** Not supported on all platforms. May return `ENOTSUP`.
--- On macOS and Windows not all fields are set (the unsupported fields are filled
--- with zeroes).
--- @return uv.getrusage.result? rusage
--- @return string? err
--- @return uv.error_name? err_name
function uv.getrusage_thread() end
--- Returns the current total system memory in bytes.
--- @return number
function uv.get_total_memory() end

--- Returns the current free system memory in bytes.
--- @return number
function uv.get_free_memory() end

--- Gets the amount of memory available to the process in bytes based on limits
--- imposed by the OS. If there is no such constraint, or the constraint is unknown,
--- 0 is returned. Note that it is not unusual for this value to be less than or
--- greater than the total system memory.
--- @return number
function uv.get_constrained_memory() end

--- Gets the amount of free memory that is still available to the process (in
--- bytes). This differs from `uv.get_free_memory()` in that it takes into account
--- any limits imposed by the OS. If there is no such constraint, or the constraint
--- is unknown, the amount returned will be identical to `uv.get_free_memory()`.
--- @return number
function uv.get_available_memory() end

--- Creates a new semaphore with the specified initial value. A semaphore is safe to
--- share across threads. It represents an unsigned integer value that can incremented
--- and decremented atomically but any attempt to make it negative will "wait" until
--- the value can be decremented by another thread incrementing it.
---
--- # Threading and synchronization utilities
---
--- Libuv provides cross-platform implementations for multiple threading and
---  synchronization primitives. The API largely follows the pthreads API.

--- Creates and initializes a `luv_thread_t` (not `uv_thread_t`). Returns the Lua
--- userdata wrapping it and asynchronously executes `entry`, which can be either
--- a Lua function or a string containing Lua code or bytecode dumped from a function. Additional arguments `...`
--- are passed to the `entry` function and an optional `options` table may be
--- provided. Currently accepted `option` fields are `stack_size`.
-- # Thread pool work scheduling
---
--- Libuv provides a threadpool which can be used to run user code and get notified
--- in the loop thread. This threadpool is internally used to run all file system
--- operations, as well as `getaddrinfo` and `getnameinfo` requests.
---
--- ```lua
--- local function work_callback(a, b)
---   return a + b
--- end
---
--- local function after_work_callback(c)
---   print("The result is: " .. c)
--- end
---
--- local work = uv.new_work(work_callback, after_work_callback)
---
--- work:queue(1, 2)
---
--- -- output: "The result is: 3"
--- # `uv_fs_event_t` - FS Event handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- FS Event handles allow the user to monitor a given path for changes, for
--- example, if the file was renamed or there was a generic change in it. This
--- handle uses the best backend for the job on each platform.
-- - it. The actual socket is created lazily.
---
--- See [Constants][] for supported address `family` input values.
---
--- When specified, `mmsgs` determines the number of messages able to be received
--- at one time via `recvmmsg(2)` (the allocated buffer will be sized to be able
--- to fit the specified number of max size dgrams). Only has an effect on
--- platforms that support `recvmmsg(2)`.

--- # `uv_tty_t` - TTY handle
---
--- > [`uv_handle_t`][] and [`uv_stream_t`][] functions also apply.
---
--- TTY handles represent a stream for the console.
---
--- ```lua
--- -- Simple echo program
--- local stdin = uv.new_tty(0, true)
--- local stdout = uv.new_tty(1, false)
---
--- stdin:read_start(function (err, data)
---   assert(not err, err)
---   if data then
---     stdout:write(data)
---   else
---     stdin:close()
---     stdout:close()
---   end
--- end)

--- # `uv_pipe_t` - Pipe handle
---
--- > [`uv_handle_t`][] and [`uv_stream_t`][] functions also apply.
---
--- Pipe handles provide an abstraction over local domain sockets on Unix and named pipes on Windows.
---
--- ```lua
--- local pipe = uv.new_pipe(false)
---
--- pipe:bind('/tmp/sock.test')
---
--- pipe:listen(128, function()
---   local client = uv.new_pipe(false)
---   pipe:accept(client)
---   client:write("hello!\n")
---   client:close()
--- end)
--- ```

--- # `uv_tcp_t` - TCP handle
---
--- > [`uv_handle_t`][] and [`uv_stream_t`][] functions also apply.
---
--- TCP handles are used to represent both TCP streams and servers.
--- @class uv.uv_tcp_t : uv.uv_stream_t
local uv_tcp_t = {}

--- # `uv_stream_t` - Stream handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- Stream handles provide an abstraction of a duplex communication channel.
--- [`uv_stream_t`][] is an abstract type, libuv provides 3 stream implementations
--- in the form of [`uv_tcp_t`][], [`uv_pipe_t`][] and [`uv_tty_t`][].
--- @class uv.uv_stream_t : uv.uv_handle_t
local uv_stream_t = {}

--- # `uv_process_t` - Process handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- Process handles will spawn a new process and allow the user to control it and
--- establish communication channels with it using streams.

--- # `uv_signal_t` - Signal handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- Signal handles implement Unix style signal handling on a per-event loop bases.
---
--- **Windows Notes:**
---
--- Reception of some signals is emulated on Windows:
---   - SIGINT is normally delivered when the user presses CTRL+C. However, like on
---   Unix, it is not generated when terminal raw mode is enabled.
---   - SIGBREAK is delivered when the user pressed CTRL + BREAK.
---   - SIGHUP is generated when the user closes the console window. On SIGHUP the
---   program is given approximately 10 seconds to perform cleanup. After that
---   Windows will unconditionally terminate it.
---   - SIGWINCH is raised whenever libuv detects that the console has been resized.
---   SIGWINCH is emulated by libuv when the program uses a uv_tty_t handle to write
---   to the console. SIGWINCH may not always be delivered in a timely manner; libuv
---   will only detect size changes when the cursor is being moved. When a readable
---   [`uv_tty_t`][] handle is used in raw mode, resizing the console buffer will
---   also trigger a SIGWINCH signal.
---   - Watchers for other signals can be successfully created, but these signals
---   are never received. These signals are: SIGILL, SIGABRT, SIGFPE, SIGSEGV,
---   SIGTERM and SIGKILL.
---   - Calls to raise() or abort() to programmatically raise a signal are not
---   detected by libuv; these will not trigger a signal watcher.
---
--- **Unix Notes:**
---
---   - SIGKILL and SIGSTOP are impossible to catch.
---   - Handling SIGBUS, SIGFPE, SIGILL or SIGSEGV via libuv results into undefined
---   behavior.
---   - SIGABRT will not be caught by libuv if generated by abort(), e.g. through
---   assert().
---   - On Linux SIGRT0 and SIGRT1 (signals 32 and 33) are used by the NPTL pthreads
---   library to manage threads. Installing watchers for those signals will lead to
---   unpredictable behavior and is strongly discouraged. Future versions of libuv
---   may simply reject them.
---
--- ```lua
--- -- Create a new signal handler
--- local signal = uv.new_signal()
--- -- Define a handler function
--- uv.signal_start(signal, "sigint", function(signame)
---   print("got " .. signame .. ", shutting down")
---   os.exit(1)
--- end)
--- Starts polling the file descriptor. `events` are: `"r"`, `"w"`, `"rw"`, `"d"`,
--- `"rd"`, `"wd"`, `"rwd"`, `"p"`, `"rp"`, `"wp"`, `"rwp"`, `"dp"`, `"rdp"`,
--- `"wdp"`, or `"rwdp"` where `r` is `READABLE`, `w` is `WRITABLE`, `d` is
--- `DISCONNECT`, and `p` is `PRIORITIZED`. As soon as an event is detected
--- the callback will be called with status set to 0, and the detected events set on
--- the events field.
---
--- The user should not close the socket while the handle is active. If the user
--- does that anyway, the callback may be called reporting an error status, but this
--- is not guaranteed.
--- **Note**:
--- Calling `uv.poll_start()` on a handle that is already active is fine.
--- Doing so will update the events mask that is being watched for.
--- @param poll uv.uv_poll_t
--- @param events string?
--- @param callback fun(err: string?, events: string?)
--- @return 0? success
--- @return string? err
--- @return uv.error_name? err_name
function uv.poll_start(poll, events, callback) end
-- # `uv_poll_t` - Poll handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- Poll handles are used to watch file descriptors for readability and writability,
--- similar to the purpose of [poll(2)](http://linux.die.net/man/2/poll).
---
--- The purpose of poll handles is to enable integrating external libraries that
--- rely on the event loop to signal it about the socket status changes, like c-ares
--- or libssh2. Using `uv_poll_t` for any other purpose is not recommended;
--- `uv_tcp_t`, `uv_udp_t`, etc. provide an implementation that is faster and more
--- scalable than what can be achieved with `uv_poll_t`, especially on Windows.
---
--- It is possible that poll handles occasionally signal that a file descriptor is
--- readable or writable even when it isn't. The user should therefore always be
--- prepared to handle EAGAIN or equivalent when it attempts to read from or write
--- to the fd.
---
--- It is not okay to have multiple active poll handles for the same socket, this
--- can cause libuv to busyloop or otherwise malfunction.
---
--- The user should not close a file descriptor while it is being polled by an
--- active poll handle. This can cause the handle to report an error, but it might
--- also start polling another socket. However the fd can be safely closed
--- immediately after a call to `uv.poll_stop()` or `uv.close()`.
---
--- # `uv_async_t` - Async handle
---
--- > [`uv_handle_t`][] functions also apply.
---
--- Async handles allow the user to "wakeup" the event loop and get a callback
--- called from another thread.
---
--- ```lua
--- local async
--- async = uv.new_async(function()
---   print("async operation ran")
---   async:close()
--- end)
--- Idle handles will run the given callback once per loop iteration, right before
--- the [`uv_prepare_t`][] handles.
---
--- **Note**: The notable difference with prepare handles is that when there are
--- active idle handles, the loop will perform a zero timeout poll instead of
--- blocking for I/O.
---
--- **Warning**: Despite the name, idle handles will get their callbacks called on
--- every loop iteration, not when the loop is actually "idle".
---
--- ```lua
--- local idle = uv.new_idle()
--- idle:start(function()
---   print("Before I/O polling, no blocking")
--- end)
--- ```
--- > [`uv_handle_t`][] functions also apply.
---
--- Check handles will run the given callback once per loop iteration, right after
--- polling for I/O.
---
--- ```lua
--- local check = uv.new_check()
--- check:start(function()
---   print("After I/O polling")
--- end)

--- Prepare handles will run the given callback once per loop iteration, right
--- before polling for I/O.
---
--- ```lua
--- local prepare = uv.new_prepare()
--- prepare:start(function()
---   print("Before I/O polling")
--- end)
--- ```

--- Returns the name of the struct for a given handle (e.g. `"pipe"` for `uv_pipe_t`)
--- and the libuv enum integer for the handle's type (`uv_handle_type`).
--- @param handle uv.uv_handle_t
--- @return string type
--- @return integer enum
function uv.handle_get_type(handle) end
-   - `"metrics_idle_time"`: Accumulate the amount of idle time the event loop spends
---   in the event provider. This option is necessary to use `metrics_idle_time()`.
---
--- An example of a valid call to this function is:
---
--- ```lua
--- uv.loop_configure("block_signal", "sigprof")
--- ```
--- **Note**:
--- Be prepared to handle the `ENOSYS` error; it means the loop option is
--- not supported by the platform.
--- @param option string
--- @param ... any depends on `option`
--- @return 0? success
--- @return string? err
--- @return uv.error_name? err_name
function uv.loop_configure(option, ...) end

--- If the loop is running, returns a string indicating the mode in use. If the loop
--- is not running, `nil` is returned instead.
--- @return string?
function uv.loop_mode() end

--- Returns `true` if there are referenced active handles, active requests, or
--- closing handles in the loop; otherwise, `false`.
--- @return boolean? alive
--- @return string? err
--- @return uv.error_name? err_name
function uv.loop_alive() end
-- This function runs the event loop. It will act differently depending on the
--- specified mode:
---
---   - `"default"`: Runs the event loop until there are no more active and
---   referenced handles or requests. Returns `true` if `uv.stop()` was called and
---   there are still active handles or requests. Returns `false` in all other
---   cases.
---
---   - `"once"`: Poll for I/O once. Note that this function blocks if there are no
---   pending callbacks. Returns `false` when done (no active handles or requests
---   left), or `true` if more callbacks are expected (meaning you should run the
---   event loop again sometime in the future).
---
---   - `"nowait"`: Poll for I/O once but don't block if there are no pending
---   callbacks. Returns `false` if done (no active handles or requests left),
---   or `true` if more callbacks are expected (meaning you should run the event
---   loop again sometime in the future).
--- **Note**:
--- Luvit will implicitly call `uv.run()` after loading user code, but if
--- you use the luv bindings directly, you need to call this after registering
--- your initial set of event callbacks to start the event loop.
--- @param mode string?
--- @return boolean? running
--- @return string? err
--- @return uv.error_name? err_name
-- function uv.run(mode) end
--
--- This can be used in conjunction with `uv.run("nowait")` to poll in one thread
--- and run the event loop's callbacks in another
--- **Note**:
--- Embedding a kqueue fd in another kqueue pollset doesn't work on all
--- platforms. It's not an error to add the fd but it never generates events.
--- @return integer?
function uv.backend_fd() end

--- Get the poll timeout. The return value is in milliseconds, or -1 for no timeout.
--- @return integer
function uv.backend_timeout() end

--- Gets the platform dependent file descriptor equivalent.
---
--- The following handles are supported: TCP, pipes, TTY, UDP and poll. Passing any
--- other handle type will fail with `EINVAL`.
---
--- If a handle doesn't have an attached file descriptor yet or the handle itself
--- has been closed, this function will return `EBADF`.
--- **Warning**:
--- Be very careful when using this function. libuv assumes it's in
--- control of the file descriptor so any change to it may lead to malfunction.
--- @param handle uv.uv_handle_t
--- @return integer? fileno
--- @return string? err
--- @return uv.error_name? err_name
function uv.fileno(handle) end
--- Returns the name of the struct for a given handle (e.g. `"pipe"` for `uv_pipe_t`)
--- and the libuv enum integer for the handle's type (`uv_handle_type`).
--- @param handle uv.uv_handle_t
--- @return string type
--- @return integer enum
function uv.handle_get_type(handle) end

--- Returns the name of the struct for a given request (e.g. `"fs"` for `uv_fs_t`)
--- and the libuv enum integer for the request's type (`uv_req_type`).
--- @param req uv.uv_req_t
--- @return string type
--- @return integer enum
function uv.req_get_type(req) end
-- ---   - A [`uv_async_t`][] handle is always active and cannot be deactivated, except
-- ---   by closing it with `uv.close()`.
-- ---
-- ---   - A [`uv_pipe_t`][], [`uv_tcp_t`][], [`uv_udp_t`][], etc. handle - basically
-- ---   any handle that deals with I/O - is active when it is doing something that
-- ---   involves I/O, like reading, writing, connecting, accepting new connections,
-- ---   etc.
-- ---
-- ---   - A [`uv_check_t`][], [`uv_idle_t`][], [`uv_timer_t`][], etc. handle is active
-- ---   when it has been started with a call to `uv.check_start()`, `uv.idle_start()`,
-- ---   `uv.timer_start()` etc. until it has been stopped with a call to its
-- ---   respective stop function.

