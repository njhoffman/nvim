Continue working on the vim-smoothie project (read docs in lua/smoothie) folder.  I want these fixes and updates to be
apapplied to both the lua and VimL version.

- Move the VimL code into the lua/smoothie folder for consistency, I will load the lua version of smoothie from init.lua
    bbut I still want the option to switch to VimL for testing.

- Combine the commands so 'SBEnable' enables benchmarking regardless if it's VimL or lua, and so on for the rest of
    them.  Keep the two 'SmoothieUseLua' and 'SmoothieUseVimL' functions, but the others should be combined.

The stats currently look like below:
- fix the alignment of the table borders
- add highlights to make labels and numbers easier to read

```
╔═══════════════════════════════════════════════════╗
║         SMOOTHIE BENCHMARK STATISTICS (Lua)       ║
╠═══════════════════════════════════════════════════╣
║ Operations:                                 3 ║
║ Total Lines Scrolled:                     860 ║
║ Total Time:                        2311.98 ms ║
╠═══════════════════════════════════════════════════╣
║                 SPEED METRICS                     ║
╠═══════════════════════════════════════════════════╣
║ Avg Lines/Minute:                    22318.48 ║
║ Avg Speed:                          305.46 l/s ║
║ Min Speed:                           47.12 l/s ║
║ Max Speed:                          450.91 l/s ║
║ Speed StdDev:                       183.15 l/s ║
╠═══════════════════════════════════════════════════╣
║              SMOOTHNESS METRICS                   ║
╠═══════════════════════════════════════════════════╣
║ Turbulence Events:                         10 ║
║ Avg Turbulence Score:                 3.22 ms ║
║ Consistency Score:                    40.04% ║
╚═══════════════════════════════════════════════════╝

Turbulence: Frame timing deviations from expected interval
Consistency: 100% = perfectly consistent speed
```

- look at <https://github.com/karb94/neoscroll.nvim> for the following two objectives
  - sometimes when performing the 'G' or 'gg' commands close to the top or bottom, it freezes and I have to press ctrl+c
      to unfreeze it
  - create a config option (something like 'use_visual_lines') that allows the paging functions (SmoothieDownwards,
      SmoothieUpwards, etc) to take into account skipped lines from page wrappiing or visual decorations (like markdown
      codeblocks).  if different methods of scrolling need to be employed for this that is fine

- make sure you include tests to ensure there are no regressions introduced.  update the changelog and smoothie
    documents with relevant information
