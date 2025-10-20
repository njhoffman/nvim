# Task: Update deprecated code

Run the command 'checkhealth vim.deprecated'

Go through the deprecated code warnings, and if the location is in ~/.config/nvim update to the
newer solution.  Add tests if it makes sense (more than a simple syntax change).  Do not address the
warnings about the lspconfig framework (from 'help lspconfig-nvim-0.11'), those require larger
changes we will do separate

# Task: QuickClose command

Create a new user command 'QuickClose' that will either delete a buffer or close a window depending
on the following criteria:
- If current window is floating, close the window.
- If current window is not floating, and viewport has a split window:
    - use `vim.fn.tabpagewinnr(1, '$')` to determine if there are splits
    - if current window matches any of the items in special_slits close the current window
    - if current window doesn't match but any of the splits do, close the window of that matching split
    - allow regular expression matching of filetype or buftype 
- If current window has no splits and is not the last buffer, delete the buffer 
- If it is the last buffer and last window, run the command 'Alpha' to show startup screen.

```lua
local special_splits = {
   { buftype  = 'quickfix' },
   { buftype = 'help' },
   { filetype = 'neo-tree' },
   { filetype  = 'CodeCompanion' },
   { filetype  = 'Avante.*' },
}

```
