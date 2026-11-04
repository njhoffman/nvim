-- Log files: filetype detection and the tree-sitter captures of parser/log.so
local buf

local function captures_of(line)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line })
  local parser = vim.treesitter.get_parser(buf, "log")
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.get("log", "highlights")
  local out = {}
  for id, node in query:iter_captures(root, buf, 0, -1) do
    local text = vim.treesitter.get_node_text(node, buf)
    out[text] = query.captures[id]
  end
  return out, root
end

describe("log highlighting", function()
  before_each(function()
    buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
  end)

  after_each(function()
    vim.cmd("enew!")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end)

  describe("detection", function()
    dofile(vim.fn.getcwd() .. "/filetype.lua")
    for name, ft in pairs({
      ["app.log"] = "log",
      ["/tmp/error_log"] = "log",
      ["/var/log/syslog"] = "syslog",
      ["/var/log/syslog.1"] = "syslog",
    }) do
      it(name .. " is " .. ft, function()
        assert.are.equal(ft, vim.filetype.match({ filename = name }))
      end)
    end

    it("leaves other files alone", function()
      assert.is_nil(vim.filetype.match({ filename = "my_logs" }))
    end)
  end)

  describe("captures", function()
    local cases = {
      {
        "2018-03-12T12:09:38Z started",
        { ["2018-03-12T"] = "log.date", ["12:09:38Z"] = "log.time" },
      },
      {
        "12/Mar/2018 Fri Jan 9",
        { ["12/Mar/2018"] = "log.date", ["Fri"] = "log.date", ["Jan 9"] = "log.date" },
      },
      { "20240229 x", { ["20240229"] = "log.date" } },
      {
        "01:32:12.102938 +0700 UTC",
        { ["01:32:12.102938 +0700"] = "log.time", ["UTC"] = "log.timezone" },
      },
      { "12:09:38 myhost sshd[123]: hi", { ["myhost sshd[123]:"] = "log.syslog" } },
      { "took 1h2m3s and 10ms", { ["1h2m3s"] = "log.duration", ["10ms"] = "log.duration" } },
      {
        "ERROR error Error LOG_ERROR SEVERE",
        {
          ["ERROR"] = "log.level.error",
          ["error"] = "log.level.error",
          ["Error"] = "log.level.error",
          ["LOG_ERROR"] = "log.level.error",
          ["SEVERE"] = "log.level.error",
        },
      },
      {
        "WARN INFO DEBUG TRACE PASSED",
        {
          ["WARN"] = "log.level.warning",
          ["INFO"] = "log.level.info",
          ["DEBUG"] = "log.level.debug",
          ["TRACE"] = "log.level.trace",
          ["PASSED"] = "log.level.success",
        },
      },
      {
        "\u{f06a} \u{f071} \u{f05a} \u{f188} \u{270e}",
        {
          ["\u{f06a}"] = "log.level.error",
          ["\u{f071}"] = "log.level.warning",
          ["\u{f05a}"] = "log.level.info",
          ["\u{f188}"] = "log.level.debug",
          ["\u{270e}"] = "log.level.trace",
        },
      },
      {
        "msg=\"a b\" `c` 'd'",
        { ['"a b"'] = "log.string", ["`c`"] = "log.string", ["'d'"] = "log.string" },
      },
      {
        "12 1.5 0xff true nil",
        {
          ["12"] = "log.number",
          ["1.5"] = "log.float",
          ["0xff"] = "log.number",
          ["true"] = "log.boolean",
          ["nil"] = "log.null",
        },
      },
      {
        "see https://a.io/x?y=1 from 10.0.0.1/24",
        {
          ["https://a.io/x?y=1"] = "log.url",
          ["10.0.0.1/24"] = "log.url",
        },
      },
      { "00:1a:2b:3c:4d:5e", { ["00:1a:2b:3c:4d:5e"] = "log.url" } },
      {
        "123e4567-e89b-12d3-a456-426614174000",
        { ["123e4567-e89b-12d3-a456-426614174000"] = "log.hash" },
      },
      { "d41d8cd98f00b204e9800998ecf8427e", { ["d41d8cd98f00b204e9800998ecf8427e"] = "log.hash" } },
      {
        "in /usr/lib/x.so and ~/a/b and ./c and src/main.lua",
        {
          ["/usr/lib/x.so"] = "log.path",
          ["~/a/b"] = "log.path",
          ["./c"] = "log.path",
          ["src/main.lua"] = "log.path",
        },
      },
      { "host example.com up", { ["example.com"] = "log.domain" } },
      {
        "<function 2> <table 3> metatable",
        {
          ["function 2"] = "log.reference",
          ["table 3"] = "log.reference",
          ["metatable"] = "log.reference",
        },
      },
      {
        '<?xml version="1.0"?> <a:b c="d"/> <!-- e --> &amp;',
        {
          ['<?xml version="1.0"?>'] = "log.xml.header",
          ['<a:b c="d"/>'] = "log.xml.tag",
          ["<!-- e -->"] = "log.xml.comment",
          ["&amp;"] = "log.xml.entity",
        },
      },
      {
        "--- === - - x",
        { ["---"] = "log.separator", ["==="] = "log.separator", ["- -"] = "log.separator" },
      },
      { "[a] (b)", { ["["] = "log.bracket", ["]"] = "log.bracket", ["("] = "log.operator" } },
    }

    for _, case in ipairs(cases) do
      it(case[1], function()
        local got = captures_of(case[1])
        for text, capture in pairs(case[2]) do
          assert.are.equal(capture, got[text], text)
        end
      end)
    end

    it("keeps words whole: no number, level or string inside them", function()
      local got = captures_of("abc123 ERRORS_x don't plurals' elements face 3/4 terror")
      assert.is_nil(got["123"])
      assert.is_nil(got["ERRORS"])
      assert.is_nil(got["'t plurals'"])
      assert.is_nil(got["face"])
      assert.is_nil(got["terror"])
      assert.are.equal("log.number", got["3"])
    end)

    it("does not take syslog columns without a time before them", function()
      assert.is_nil(captures_of("myhost sshd[123]: hi")["myhost sshd[123]:"])
    end)

    it("never produces a parse error", function()
      local line = "a " .. "\27[31m" .. " \\ \" ' ` é 日本 < > & <!-- <? " .. string.char(1)
      local _, root = captures_of(line)
      assert.is_false(root:has_error())
    end)
  end)

  describe("ftplugin", function()
    it("starts tree-sitter and links the capture groups", function()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "ERROR x" })
      vim.bo[buf].filetype = "log"
      dofile(vim.fn.getcwd() .. "/after/ftplugin/log.lua")
      assert.is_not_nil(vim.treesitter.highlighter.active[buf])
      assert.are.equal("ErrorMsg", vim.api.nvim_get_hl(0, { name = "@log.level.error" }).link)
      assert.are.equal("Function", vim.api.nvim_get_hl(0, { name = "@log.time" }).link)
    end)

    it("keeps the colors of nord-nick instead of linking over them", function()
      local p = require("colorschemes.nord-nick.palette")
      require("colorschemes.nord-nick.syntax").apply(p)
      dofile(vim.fn.getcwd() .. "/after/ftplugin/log.lua")
      local hl = vim.api.nvim_get_hl(0, { name = "@log.level.info" })
      assert.is_nil(hl.link)
      assert.are.equal(tonumber("0d81bc", 16), hl.fg)
      local url = vim.api.nvim_get_hl(0, { name = "@log.url" })
      assert.are.equal(tonumber("0f86a6", 16), url.fg)
      assert.is_true(url.italic)
    end)

    it("colors every capture of the query in nord-nick", function()
      local p = require("colorschemes.nord-nick.palette")
      vim.cmd("highlight clear")
      require("colorschemes.nord-nick.syntax").apply(p)
      for _, capture in ipairs(vim.treesitter.query.get("log", "highlights").captures) do
        local hl = vim.api.nvim_get_hl(0, { name = "@" .. capture })
        assert.is_not_nil(hl.fg, capture)
      end
    end)
  end)
end)
