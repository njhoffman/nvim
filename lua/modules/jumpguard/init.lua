-- jumpguard: lists deleted file buffers again when the jumplist reopens them, and records
-- failed or suspicious jumps (recent deletions, jumplist, new messages) to a log file.
-- commands.scroll's jump_scroll goes through M.jump; the BufEnter hook covers every other path
-- back to a deleted buffer (convey.nvim owns the global <C-o> / <C-i>).
local M = {}

M.max_deletions = 20
M.log_path = vim.fn.stdpath("state") .. "/jumpguard.log"

local deletions = {}

--- True for a buffer that holds a file on disk in a normal window.
--- @param bufnr integer
--- @return boolean
function M.is_file_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
    return false
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  return name ~= "" and vim.uv.fs_stat(name) ~= nil
end

--- @param bufnr integer
--- @return boolean
function M.was_deleted(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  for _, d in ipairs(deletions) do
    if d.bufnr == bufnr or (name ~= "" and d.name == name) then
      return true
    end
  end
  return false
end

--- List a file buffer again when it was deleted earlier and is now entered again, e.g.
--- reloaded through the jumplist after :bdelete. Buffers that plugins keep unlisted on
--- purpose are left alone because they were never deleted.
--- @param bufnr integer
--- @return boolean relisted
function M.relist(bufnr)
  if vim.bo[bufnr].buflisted or not M.is_file_buffer(bufnr) or not M.was_deleted(bufnr) then
    return false
  end
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return false
  end
  vim.bo[bufnr].buflisted = true
  return true
end

--- @param event string
--- @param bufnr integer
function M.record_deletion(event, bufnr)
  table.insert(deletions, 1, {
    time = os.date("%H:%M:%S"),
    event = event,
    bufnr = bufnr,
    name = vim.api.nvim_buf_get_name(bufnr),
  })
  deletions[M.max_deletions + 1] = nil
end

--- @return table[]
function M.deletions()
  return deletions
end

function M.clear()
  deletions = {}
end

--- Jumplist entries around the current position, with whether each buffer still exists.
--- @param radius? integer
--- @return string[]
function M.jumplist_snapshot(radius)
  radius = radius or 5
  local list, pos = unpack(vim.fn.getjumplist())
  local lines = {}
  local first = math.max(1, pos + 1 - radius)
  local last = math.min(#list, pos + 1 + radius)
  for i = first, last do
    local e = list[i]
    local valid = vim.api.nvim_buf_is_valid(e.bufnr)
    lines[#lines + 1] = ("%s %3d buf=%d %s:%d%s"):format(
      i == pos + 1 and ">" or " ",
      i,
      e.bufnr,
      valid and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(e.bufnr), ":~:.") or "<gone>",
      e.lnum,
      valid and (vim.bo[e.bufnr].buflisted and "" or " (unlisted)") or ""
    )
  end
  return lines
end

local function message_lines()
  return vim.split(vim.api.nvim_exec2("messages", { output = true }).output, "\n")
end

--- Append a report to the log file.
--- @param reason string
--- @param details string[]
function M.write_report(reason, details)
  local lines = { ("== %s %s"):format(os.date("%Y-%m-%d %H:%M:%S"), reason) }
  vim.list_extend(lines, details)
  lines[#lines + 1] = "jumplist:"
  vim.list_extend(lines, M.jumplist_snapshot())
  lines[#lines + 1] = "recent deletions:"
  for i = 1, math.min(5, #deletions) do
    local d = deletions[i]
    lines[#lines + 1] = ("  %s %s buf=%d %s"):format(d.time, d.event, d.bufnr, d.name)
  end
  vim.fn.mkdir(vim.fs.dirname(M.log_path), "p")
  vim.fn.writefile(lines, M.log_path, "a")
end

--- Run a jumplist motion (count plus <C-o> or <C-i>) and report if it errors, or if it lands
--- on a previously deleted buffer (with any messages that appear right after).
--- @param keys string termcoded keys, e.g. "1\x0f"
--- @param exec? fun(cmd: string) defaults to vim.cmd
--- @return boolean ok
function M.jump(keys, exec)
  exec = exec or vim.cmd
  local ok, err = pcall(exec, "normal! " .. keys)
  if not ok then
    M.write_report("jump failed", { "error: " .. tostring(err) })
    vim.notify(
      ("Jump failed: %s (details in %s)"):format(tostring(err):gsub("^Vim[^:]*:", ""), M.log_path),
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

--- Called on BufEnter: if the buffer was deleted earlier, list it again and log how it came
--- back (jumplist, recent deletions, the last messages). Works for any way back: the
--- jumplist, convey.nvim's <C-o>, :buffer, pickers.
--- @param bufnr integer
--- @return boolean handled
function M.on_enter(bufnr)
  if not M.was_deleted(bufnr) then
    return false
  end
  local was_listed = vim.bo[bufnr].buflisted
  local relisted = M.relist(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local removed = {}
  for i = #deletions, 1, -1 do
    if deletions[i].bufnr == bufnr or deletions[i].name == name then
      table.insert(removed, table.remove(deletions, i))
    end
  end
  vim.defer_fn(function()
    local msgs = vim.tbl_filter(function(l)
      return l ~= ""
    end, message_lines())
    local details = {
      ("entered deleted buffer %d %s listed=%s relisted=%s"):format(
        bufnr,
        name,
        tostring(was_listed),
        tostring(relisted)
      ),
    }
    for _, d in ipairs(removed) do
      details[#details + 1] = ("deleted at %s by %s"):format(d.time, d.event)
    end
    details[#details + 1] = "last messages:"
    vim.list_extend(details, vim.list_slice(msgs, math.max(1, #msgs - 4)))
    M.write_report("returned to deleted buffer", details)
  end, 300)
  return true
end

function M.setup()
  local group = vim.api.nvim_create_augroup("JumpGuard", { clear = true })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].buftype == "" and vim.api.nvim_buf_get_name(args.buf) ~= "" then
        M.record_deletion(args.event, args.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      M.on_enter(args.buf)
    end,
  })
end

return M
