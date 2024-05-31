local config = {
  -- Whether to delete an opened repository when nvim exits.
  -- If `true`, it will create an auto command for opened repositories
  -- to delete the local directory when nvim exists.
  ephemeral = false,
  -- Set buffers of opened repositories to be read-only and unmodifiable.
  read_only = true,
  -- Whether / how to CD into opened repository.
  -- Options: global|tab|window|none
  cd_type = 'global',
  -- The actual `open` behavior.
  ---@param dir string The path to the local repository.
  ---@param repo_uri string The URI that was used to clone this repository.
  ---@param selected_path? string A relative path to a file in this repository.
  opener = function(dir, repo_uri, selected_path)
    vim.print('Opening ' .. repo_uri)
    local dest = vim.fn.fnameescape(selected_path and dir .. '/' .. selected_path or dir)
    vim.cmd('edit ' .. dest)
  end,
  -- Location of cloned repositories. Should be dedicated for this purpose.
  repositories_dir = vim.fn.stdpath('cache') .. '/git-dev',
  -- Extend the builtin URL parsers.
  -- Should map domains to parse functions. See |parser.lua|.
  extra_domain_to_parser = nil,
  git = {
    -- Name / path of `git` command.
    command = 'git',
    -- Default organization if none is specified.
    -- If given repository name does not contain '/' and `default_org` is
    -- not `nil` nor empty, it will be prepended to the given name.
    default_org = nil,
    -- Base URI to use when given repository name is scheme-less.
    base_uri_format = 'https://github.com/%s.git',
    -- Arguments for `git clone`.
    -- Triggered when repository does not exist locally.
    -- It will clone submodules too, disable it if it is too slow.
    clone_args = '--jobs=2 --single-branch --recurse-submodules ' .. '--shallow-submodules',
    -- Arguments for `git fetch`.
    -- Triggered when repository is already exists locally to refresh the local
    -- copy.
    fetch_args = '--jobs=2 --no-all --update-shallow -f --prune --no-tags',
    -- Arguments for `git checkout`.
    -- Triggered when a branch, tag or commit is given.
    checkout_args = '-f --recurse-submodules',
  },
  -- Print command outputs.
  verbose = false,
}

require('git-dev').setup(config)
