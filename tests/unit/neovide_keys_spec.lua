-- Unit tests for core.neovide_keys: each Neovide chord reaches the key the
-- terminals send for it, in every mode, and no existing key is taken over

local function tc(keys)
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

describe("core.neovide_keys", function()
  local nk = require("core.neovide_keys")

  before_each(function()
    vim.cmd("mapclear | mapclear! | tmapclear")
    nk.setup()
  end)

  after_each(function()
    vim.cmd("mapclear | mapclear! | tmapclear")
    vim.cmd("stopinsert")
  end)

  it("maps each lhs once", function()
    local seen = {}
    for _, key in ipairs(nk.keys) do
      local code = tc(key[1])
      assert.is_nil(seen[code], key[1] .. " is listed twice")
      seen[code] = true
    end
  end)

  it("leaves the keys Neovide sends for unmappable chords alone", function()
    -- Ctrl+[ / Ctrl+Shift+[, Ctrl+M, Ctrl+Shift+], Ctrl+Shift+\, Ctrl+Shift+6
    for _, taken in ipairs({ "<Esc>", "<CR>", "<C-]>", "<C-\\>", "<C-^>", "<Tab>" }) do
      for _, key in ipairs(nk.keys) do
        assert.are_not.equal(tc(taken), tc(key[1]), key[1] .. " would take over " .. taken)
      end
    end
  end)

  it("sets every mapping in every mode, recursive", function()
    for _, key in ipairs(nk.keys) do
      for _, mode in ipairs(nk.modes) do
        local m = vim.fn.maparg(key[1], mode, false, true)
        assert.are.equal(key[2], m.rhs, key[1] .. " in mode " .. mode)
        assert.are.equal(0, m.noremap, key[1] .. " must remap")
      end
    end
  end)

  it("reaches the target's own mapping in normal mode", function()
    for _, key in ipairs(nk.keys) do
      local hit
      vim.keymap.set("n", key[2], function()
        hit = key[2]
      end)
      vim.api.nvim_feedkeys(tc(key[1]), "mx", false)
      assert.are.equal(key[2], hit, key[1] .. " should run " .. key[2])
    end
  end)

  it("reaches the target's own mapping in insert mode", function()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    for _, key in ipairs(nk.keys) do
      local hit
      vim.keymap.set("i", key[2], function()
        hit = key[2]
      end)
      vim.api.nvim_feedkeys("i" .. tc(key[1]) .. tc("<Esc>"), "mx", false)
      assert.are.equal(key[2], hit, key[1] .. " should run " .. key[2])
    end
    vim.api.nvim_buf_delete(buf, { force = true })
  end)
end)
