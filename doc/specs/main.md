# Neovim configuration manaagement 

This file should be always referenced before each task, it contains general guidelines and
procedures.  The file `scratch.md` will contain the current task information.  Configuration updates 
will be done directly to the config directory `~/.config/nvim` when approved, so it is important to 
not introduce errors that would preventg me from editing, and provide a quick way to undo changes 
if that happens.  

The end goal is to organize my code, cleanup deprecated or unused code, remove errors, refine and 
add features in a more procedural way that involve running tests.  I would like to eventually bundle
a lot of my customizeed code into plugins to simplify and declutter my configuration.  

## Important references

- ~/.config/nvim                      :  main configuration directory,  `nvim/init.lua` is the entry point
- ~/.local/share/nvim/runtime         :  neovim runtime library files
- ~/.local/share/nvim/lazy            :  plugin runtime files 
- github.com/neovim/neovim            :  source code for neovim build
- github.com/neovim/neovim.github.io  :  main neovim documentation (source code for https://neovim.io/doc/) 
- github.com/neovim/neovim/issues     :  neovim github issues


### Repository information

The `~/.config/nvim` files belong to a bare repository for all my dotfiles  that exists in ~/.cfg.  
The environment variables necessary to prefix git commnds with are:
`GIT_WORK_TREE="$HOME"` and  `GIT_DIR="$HOME/.cfg"`

When making commits, only add relevant neovim files as many other configuration files are tracked by
that repo.  Make succint commits, start using git version tags with semver style. Everytime a commit
is made bump the minor number unless otherwise indicated.  I will handle pushing and pulling.

Keep a CHANGELOG.md file in the root that tracks semver minor and major updates.  After each entry,
provide a table that contains the following stats: 

 - Total number of tests
 - Total number of plugins
 - Total lines of code all lua/vim files in `~/.config/nvim` directory recursively
 - Total lines of plugin code in `~/.local/share/nvim/lazy` recursively.  

Make sure before reporting these stats or running any tests is to update the plugins (the command
`LazySync` is one way to do this). 

The plugin manager I use is lazy.nvim: https://github.com/folke/lazy.nvim

### Testing

I do not have any testing solution implemented, but I would ideally like to have some unit tests and
some way to do integration tests (run neovim in an isolated environment with modified config for
testing). We will want to run these tests before every update.  It could involve but is not limited 
to virtualizing in a docker container, running neovim in headless mode, or using tools referenced 
below.  

Testing resources: 
- github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md 
- github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md
- https://github.com/neovim/neovim/blob/master/test/functional/api/extmark_spec.lua

Read the `scratch.mmd` file for the next task.


