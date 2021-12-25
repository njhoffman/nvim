

local dir_files = fzflua.files({ cwd: expand("%:h") })
print(vim.inspect(dir_files))

-- local old_files = fzflua.oldfiles()


-- local current_project = require('project_nvim.project').get_project_root()
-- local project_files = fzflua.files({ cwd: current_project })
