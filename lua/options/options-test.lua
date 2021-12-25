local options = require("options")

options.register_option({
    name = "clstrailingwhitespace",
    default = true,
    type_info = "boolean",
    source = "buffers",
    buffer_local = true,
})
options.register_option({
    name = "lsp_tagfunc_enabled",
    default = true,
    type_info = "boolean",
    source = "vimrc",
    global = true,
})
options.register_option({
    name = "clstrailingspacelimit",
    default = 0,
    type_info = "number",
    source = "buffers",
    buffer_local = true,
    description = "If the number of trailing white spaces below this number, they will be cleared automatically. Otherwise you will be prompted for each one.",
})
options.register_option({
    name = "trailingwhitespacehighlight",
    default = true,
    type_info = "boolean",
    source = "buffers",
    buffer_local = true,
})
options.register_option({
    name = "indentsize",
    default = 4,
    type_info = "number",
    source = "buffers",
    buffer_local = true,
})
options.register_option({
    name = "shell",
    default = "pwsh",
    type_info = "string",
    source = "options",
    global = true,
})
options.register_option({
    name = "scratchpad",
    default = false,
    type_info = "boolean",
    source = "options",
    buffer_local = true,
})
options.register_option({
    name = "markdownfenced",
    default = {},
    type_info = "table",
    source = "buffers",
    buffer_local = true,
})
options.register_option({
    name = "todofenced",
    default = {},
    type_info = "table",
    source = "todo",
    buffer_local = true,
})


options.set("shell", vim.opt.shell:get())

-- cmd([[augroup vimrc_options_plugin]])
-- cmd(
--     [[autocmd BufReadPost *.md,todo.txt :lua require"options".set_modeline(vim.api.nvim_get_current_buf())]]
-- )
-- cmd([[augroup END]])
