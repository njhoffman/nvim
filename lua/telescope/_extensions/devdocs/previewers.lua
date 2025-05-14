local previewers = require("telescope.previewers")
local transpiler = require("devdocs.transpiler")
local operations = require("devdocs.operations")
local plugin_config = require("devdocs.config")
local plugin_state = require("devdocs.state")
local log = require("devdocs.log")
local utils = require("telescope._extensions.devdocs.utils")

local metadata_previewer = previewers.new_buffer_previewer({
  title = "Metadata",
  define_preview = function(self, entry)
    local bufnr = self.state.bufnr
    local transpiled = transpiler.to_yaml(entry.value)
    local lines = vim.split(transpiled, "\n")

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].ft = "yaml"
  end,
})

local log_entry = function(entry, time_diff, lines)
  log.trace(
    string.format(
      "%5dms : %4d %3d %3d -%s %s (%s %s)",
      time_diff / 1000000,
      #lines,
      #vim.fn.split(entry.value.path, "\n"),
      #vim.fn.split(entry.value.next_path, "\n"),
      entry.value.alias,
      entry.value.link,
      entry.value.type,
      entry.value.name
    )
  )
end
local doc_previewer = previewers.new_buffer_previewer({
  title = "Preview",
  keep_last_buf = true,
  define_preview = function(self, entry)
    local time_start = vim.loop.hrtime()
    local read_async = utils.debounce(operations.read_entry_async, 10)
    read_async(entry.value, function(filtered_lines)
      local time_diff = vim.loop.hrtime() - time_start
      log_entry(entry, time_diff, filtered_lines)
      local bufnr = self.state.bufnr
      local winid = self.state.winid
      if type(bufnr) ~= "number" or not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, filtered_lines)
      if plugin_config.options.previewer_cmd and plugin_config.options.picker_cmd then
        plugin_state.set("preview_lines", filtered_lines)
        operations.render_cmd(bufnr, true)
      else
        vim.bo[bufnr].ft = "markdown"
        vim.bo[bufnr].syntax = "pandoc"
        vim.wo[winid].conceallevel = 3
      end
    end)
  end,
})

return {
  doc_previewer = doc_previewer,
  metadata_previewer = metadata_previewer,
}
