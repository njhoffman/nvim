-- rest.nvim v3: no setup(), options are read from vim.g.rest_nvim
-- Commands: :Rest run|last|open|logs|cookies|env, accept modifiers (:vert Rest run)
vim.g.rest_nvim = {
  request = {
    skip_ssl_verification = false,
  },
  response = {
    hooks = {
      decode_url = true,
      format = true,
    },
  },
}

-- run the request under the cursor, result in a vertical split
vim.api.nvim_create_user_command("RESTRun", "vertical Rest run", {})
-- re-run the last request
vim.api.nvim_create_user_command("RESTRunLast", "vertical Rest last", {})
-- yank the curl command for the request under the cursor
vim.api.nvim_create_user_command("RESTPreview", "Rest curl yank", {})
