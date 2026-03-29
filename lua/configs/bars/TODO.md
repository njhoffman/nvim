- Work on setting up stastusline:
  - <https://github.com/OXY2DEV/bars.nvim>
  - <https://github.com/OXY2DEV/bars.nvim/wiki/Statusline>
  - try to augment the bars.nvim module through available configuration
  - if needed override the bars.nvim module locally (/lua/bars/init.lua) or whatever file needs to be modified

- Other statusline resources:
  - heirline: <https://github.com/rebelot/heirline.nvim>
  - lualine: <https://github.com/nvim-lualine/lualine.nvim>
  - slimline: <https://github.com/sschleemilch/slimline.nvim>
  - feline: <https://github.com/rafamadriz/statusline>

  - explore the other statusline repositores and components that are not included in bars.nvim or add configuration to
    existing bars.nvim modules

  - add pre-defined theme/styles based on the slimline themes:
    - stealth
    - bubble
    - slashed
    - minimal
    - rainbow
    - pure

- look for timing and benchmarking resources from the other statusline modules to test the performance of bars.nvim
- add any tests/documentation changes resulting from these changes
- overwrite bars.nvim files in lua/bars if necessary, not opposed to forking bars.nvim and adding changes there

- replicate the existing setup and layout of local statusline config
  - uses modified feline.nvim repo: `nvim/lua/feline` configured from `nvim/lua/configs/feline`
  - write tests to ensure that bars.nvim can replicate the feline.nvim statusline
  - by default load the current statusline on neovim startup until it can be replicated by bars.nvim
  - here is an example output of the statusline from my current neovim instance:

```
▊  nvim   TODO.md ●  1.15k   31:1   NUL 31                                      󰣺   49:8  markdown   main   31 Bot ██
```
