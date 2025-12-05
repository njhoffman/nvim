
I want you to miggrate my statusline plugin which was based on feline ()<https://github.com/famiu/feline.nvim>) to
lualine (<https://github.com/nvim-lualine/lualine.nvim>).  I am not importing feline as a plugin, I have a customized
version of it in 'lua/feline'  (but I don't think there are any customizations that need to be moved over).  I would
like the functionality, symbols, and colors to remain thhe same.  Everything should be in the 'lua/configs/feline'
directory and highlights defined in 'lua/colorscheme/nord-nick'. put all the code into 'lua/configs/lualine', to disable
feline  comment out the  "configs.feline" line in init.lua.

Here is what is supposed to be output, along with unicode reference points (character right above that number should be
the given unicode character):

▊  nvim   scratch.md ●  646b   8:1   0x258A 22                                                       27:78   markdown  22 36% ▃▃
1 2 3      4            5 6       7     8                                                                                     9

1: 0x258a
2: 0xe26b
3: 0xe0ba
4: 0xf43a
5: 0x25cf
6: 0xe0bf
7: 0xe0bd
8: 0xf457
9: 0x2583

Here is what is currently being output, with additional notes:
▊  nvim    main.lua  59k    3:1   0x0 1546                                                                       7:12    lua  1546 0% ▁▁
1 1 1                   2    3       4       5     6                                                                            7   8   9

1: These should change depending on vim mode
2: Show dot if file is modified
3: Total bytes of buffer, refresh on buffer change
4: Current row:Current column, update on cursormoved
5: Hex of character under cursor
6: Total lines of buffer, refresh on buffer change
7: Percent through buffer
8: Percentage through buffer, refresh on curosor moved.

Please look through the old feline code, it's all in the config/feline directory. After fixing lualine, please duplicate
this configuration in windline.nvim <https://github.com/windwp/windline.nvim>.  Configuration should go in the
lua/configs/windline directory.  Please run tests to ensure there are no errors, lualine and windline can be toggled in
plugins/main.lua with the enabled attribute.

## ExportColorscheme

Next I would like you to resume the work on the colorschemeExport command to generate the bat theme file. First off fix
this error I get when I try to build the theme with bat:

`error: 'Dockerfile (with bash)' with scope 'source.dockerfile.bash' has unresolved context reference ByScope { scope:
<source.json>, sub_context: Some("arrays"), with_escape: false }`

Next, after the theme file is generated, I would like a report consisting of two lua tables created: one with the
highlights and scope map that was used to create the file, and another table with the highlights and scope map that
exist in a full theme file like 'catpuccin' (<https://github.com/catppuccin/nvim>) or 'tokyonight'
(<https://github.com/folke/tokyonight.nvim>).  Make an educated guess if I have a highlight that appears to match it
csomewhat closely, if not leave the mapped value as an empty string.  I would like to easily add new highlights to
the theme file.
