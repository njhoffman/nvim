-- jumpguard: relisting deleted file buffers and jump failure reports
local jumpguard = require("modules.jumpguard")

local tmpdir = vim.fn.tempname()
vim.fn.mkdir(tmpdir, "p")

local function file(name)
  local path = tmpdir .. "/" .. name
  vim.fn.writefile({ "1", "2", "3", "4", "5" }, path)
  return path
end

local function read_log()
  if vim.fn.filereadable(jumpguard.log_path) == 0 then
    return ""
  end
  return table.concat(vim.fn.readfile(jumpguard.log_path), "\n")
end

describe("jumpguard", function()
  local saved_notify, saved_jumpoptions, notes

  before_each(function()
    -- The config sets "stack"; the default "clean" drops jumps to unloaded (deleted) buffers
    saved_jumpoptions = vim.o.jumpoptions
    vim.o.jumpoptions = "stack"
    jumpguard.log_path = tmpdir .. "/jumpguard.log"
    vim.fn.delete(jumpguard.log_path)
    jumpguard.clear()
    jumpguard.setup()
    notes = {}
    saved_notify = vim.notify
    vim.notify = function(msg)
      table.insert(notes, msg)
    end
  end)

  after_each(function()
    vim.notify = saved_notify
    vim.o.jumpoptions = saved_jumpoptions
    vim.cmd("silent! %bwipeout!")
    vim.cmd("clearjumps")
  end)

  it("lists a deleted file buffer again when it is entered", function()
    vim.cmd("edit " .. file("a.txt"))
    local a = vim.api.nvim_get_current_buf()
    vim.cmd("edit " .. file("b.txt"))
    vim.cmd("bdelete " .. a)
    assert.is_false(vim.bo[a].buflisted)
    assert.are.equal(1, #jumpguard.deletions())

    vim.api.nvim_set_current_buf(a)
    assert.is_true(vim.bo[a].buflisted)
  end)

  it("leaves file buffers that were never deleted unlisted", function()
    local path = file("c.txt")
    local buf = vim.fn.bufadd(path)
    vim.bo[buf].buflisted = false
    vim.api.nvim_set_current_buf(buf)
    assert.is_false(vim.bo[buf].buflisted)
  end)

  it("ignores scratch buffers", function()
    local buf = vim.api.nvim_create_buf(false, true)
    jumpguard.record_deletion("BufDelete", buf)
    assert.is_false(jumpguard.relist(buf))
  end)

  it("keeps only the most recent deletions", function()
    local buf = vim.api.nvim_create_buf(true, false)
    for _ = 1, jumpguard.max_deletions + 5 do
      jumpguard.record_deletion("BufDelete", buf)
    end
    assert.are.equal(jumpguard.max_deletions, #jumpguard.deletions())
  end)

  it("snapshots the jumplist around the current position", function()
    vim.cmd("edit " .. file("d.txt"))
    vim.cmd("normal! 4G")
    local d = vim.api.nvim_get_current_buf()
    vim.cmd("edit " .. file("e.txt"))
    vim.cmd("normal! 3G")
    vim.cmd("bwipeout " .. d)
    local snap = table.concat(jumpguard.jumplist_snapshot(), "\n")
    assert.is_truthy(snap:find("e.txt", 1, true))
  end)

  it("reports and notifies when the jump command fails", function()
    local ok = jumpguard.jump("1\15", function()
      error("Vim:E92: Buffer 42 not found")
    end)
    assert.is_false(ok)
    assert.are.equal(1, #notes)
    assert.is_truthy(notes[1]:find("E92: Buffer 42 not found", 1, true))
    local log = read_log()
    assert.is_truthy(log:find("jump failed", 1, true))
    assert.is_truthy(log:find("jumplist:", 1, true))
  end)

  it("reports a jump that lands on a deleted buffer", function()
    vim.cmd("edit " .. file("f.txt"))
    vim.cmd("normal! 4G")
    local f = vim.api.nvim_get_current_buf()
    vim.cmd("edit " .. file("g.txt"))
    vim.cmd("normal! 2G")
    vim.cmd("bdelete " .. f)
    -- step back one jump at a time: the exact count to reach f.txt isn't the point here
    for _ = 1, 5 do
      if vim.api.nvim_get_current_buf() == f then
        break
      end
      assert.is_true(jumpguard.jump("1\15"))
    end
    assert.are.equal(f, vim.api.nvim_get_current_buf())
    assert.is_true(vim.bo[f].buflisted)
    vim.wait(1000, function()
      return read_log():find("returned to deleted buffer", 1, true) ~= nil
    end)
    assert.is_truthy(read_log():find("recent deletions:", 1, true))
  end)

  it("logs a return through :buffer, not only through the jumplist", function()
    vim.cmd("edit " .. file("h.txt"))
    local h = vim.api.nvim_get_current_buf()
    vim.cmd("edit " .. file("i.txt"))
    vim.cmd("bdelete " .. h)
    vim.cmd("keepjumps buffer " .. h)
    assert.is_true(vim.bo[h].buflisted)
    vim.wait(1000, function()
      return read_log():find("entered deleted buffer " .. h, 1, true) ~= nil
    end)
    assert.is_truthy(read_log():find("entered deleted buffer " .. h, 1, true))
    assert.are.equal(0, #jumpguard.deletions())
  end)
end)
