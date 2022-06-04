local _M = {}

_M.trim_empty_lines = require("vim.lsp.util").trim_empty_lines
_M.open_floating_preview = require("vim.lsp.util").open_floating_preview
_M.convert_input_to_markdown =require("vim.lsp.util").convert_input_to_markdown_lines

_M.powerline = {
    circle = {
        left = "",
        right = "",
    },
    arrow = {
        left = "",
        right = "",
    },
    triangle = {
        left = "",
        right = "",
    },
    none = {
        left = "",
        right = "",
    },
}

_M.signs = { Error = "", Warn = "", Hint = "", Info = "" }

_M.setSpacesSize = function(filetypes)
    for filetype, size in pairs(filetypes) do
        vim.api.nvim_create_autocmd("FileType", {
            pattern = filetype,
            callback = function()
                vim.opt.shiftwidth = size
                vim.opt.tabstop = size
            end,
        })
    end
end

_M.buf_command = function(bufnr, name, fn, opts)
    vim.api.nvim_buf_create_user_command(bufnr, name, fn, opts or {})
end

_M.table = {
    some = function(tbl, cb)
        for k, v in pairs(tbl) do
            if cb(k, v) then
                return true
            end
        end
        return false
    end,
}

return _M
