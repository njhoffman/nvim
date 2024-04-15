      vim.keymap.set("n", "<leader>b", "<Cmd>Telescope buffers<CR>",
        { desc = "search buffers" })
      vim.keymap.set("n", "<leader>c", "<Cmd>Telescope colorscheme<CR>",
        { desc = "search colorschemes" })
      vim.keymap.set("n", "<leader>d", "<Cmd>TodoTelescope<CR>",
        { desc = "search TODOs across all files" })
      vim.keymap.set("n", "<leader>e", "<Cmd>Telescope commands<CR>",
        { desc = "search Ex commands" })
      vim.keymap.set("n", "<leader>f",
        "<Cmd>Telescope find_files hidden=true<CR>",
        { desc = "search files" })
      vim.keymap.set("n", "<leader>F",
        "<Cmd>Telescope find_files hidden=true cwd=%:h<CR>",
        { desc = "search files in current directory" })
      vim.keymap.set("n", "<leader>g", "<Cmd>Telescope changed_files<CR>",
        { desc = "search changed files" })
      vim.keymap.set("n", "<leader>h", "<Cmd>Telescope help_tags<CR>",
        { desc = "search help" })
      vim.keymap.set("n", "<leader>i", "<Cmd>Telescope builtin<CR>",
        { desc = "search builtins" })
      vim.keymap.set("n", "<leader>j", "<Cmd>Telescope emoji<CR>",
        { desc = "search emojis" })
      vim.keymap.set("n", "<leader>k", "<Cmd>Telescope keymaps<CR>",
        { desc = "search key mappings" })
      vim.keymap.set("n", "<leader>ld", "<Cmd>Telescope diagnostics<CR>",
        { desc = "search lsp diagnostics" })
      vim.keymap.set("n", "<leader>li",
        "<Cmd>Telescope lsp_incoming_calls<CR>",
        { desc = "search lsp incoming calls" })
      vim.keymap.set("n", "<leader>lo",
        "<Cmd>Telescope lsp_outgoing_calls<CR>",
        { desc = "search lsp outgoing calls" })
      vim.keymap.set("n", "<leader>lr",
        "<Cmd>Telescope lsp_references<CR>",
        { desc = "search lsp code reference" })
      vim.keymap.set("n", "<leader>ls",
        "<Cmd>lua require('telescope.builtin').lsp_document_symbols({show_line = true})<CR>",
        { desc = "search lsp document tree" })
      vim.keymap.set("n", "<leader>m", "<Cmd>Telescope heading<CR>",
        { desc = "search markdown headings" })
      vim.keymap.set("n", "<leader>p", "<Cmd>Telescope grep_string<CR>",
        { desc = "search for keyword under cursor" })
      vim.keymap.set("n", "<leader>q", "<Cmd>Telescope quickfix<CR>",
        { desc = "search quickfix list" })
      vim.keymap.set("n", "<leader>r",
        "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
        { desc = "search current buffer text" })
      vim.keymap.set("n", "<leader>s", "<Cmd>Telescope treesitter<CR>",
        { desc = "search treesitter symbols" }) -- similar to lsp_document_symbols but treesitter doesn't know what a 'struct' is, just that it's a 'type'.
      -- vim.keymap.set("n", "<leader>u", "<Cmd>Noice telescope<CR>",
      --   { desc = "search messages handled by Noice plugin" })
      vim.keymap.set("n", "<leader>w", "<Cmd>Telescope windows<CR>",
        { desc = "search windows" })
      vim.keymap.set("n", "<leader>x", "<Cmd>Telescope live_grep<CR>",
        { desc = "search text" })

      -- Remove the Vim builtin colorschemes so they don't show in Telescope.
      vim.cmd("silent !rm $VIMRUNTIME/colors/*.vim &> /dev/null")

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopeResults",
        callback = function()
          vim.cmd([[setlocal nofoldenable]])
          vim.api.nvim_set_hl(0, "TelescopePromptCounter", { link = "TelescopePromptPrefix" })
        end
      })
    end
