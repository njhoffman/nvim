---
date: '2021-08-02T20:11'
---
# Vim Mappings and Notes

<https://github.com/neovim/neovim/pull/16251>
<https://github.com/neovim/neovim/pull/16480>

## Live commands

```vim
:G:foo/d " delete all lines containing foo
:Norm wdaw " delete leading dashes
:Norm 0Ea =^[cs
:9Reg a " run macro stored in register a
:IncRename name " lsp_rename with cursor word
:Subs/one/two replacement
```

## New in 0.7

```lua
-- convenience function, default noremap
vim.keymap.set("n", "<leader>H", function() print("Hello world!") end)
-- Using a Lua function in a key mapping in 0.7
vim.api.nvim_set_keymap("n", "<leader>H", "", {
    noremap = true,
    callback = function()
        print("Hello world!")
    end,
})
-- Creating an autocommand in 0.7
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        print("Entered buffer " .. args.buf .. "!")
    end,
    desc = "Tell me when I enter a buffer",
})
-- Creating a custom user command in 0.7
vim.api.nvim_create_user_command("SayHello", function(args)
    print("Hello " .. args.args)
end, {
    nargs = "*",
    desc = "Say hi to someone",
})
```

```sh
  # In one shell session
  nvim --listen /tmp/nvim.sock
  # In another shell session, opens foo.txt in the first Nvim instance
  nvim --server /tmp/nvim.sock --remote foo.txt
```

## Search notes

- Ctrl-G/Ctrl-T

## Git within vim

- gD: Gdiffsplit, BCommits, :Gblame, ~ key
- Go to quickfix list, `<CR>` on the first version to diff - which opens up a fugitive split with that version.
- Go back to quickfix, yiw the hash of the version to diff against
- Navigate back to fugitive buffer of the first version, and `:Gvdiffsplit <C-r>0` (to paste the hash)

## Shortcut key mappings

:::{.ui .center .aligned}
|      VIM KEYS     |                                         |
|:-----------------:|:---------------------------------------:|
|  [gzi] [gzz] [gx] |       zettel index, search, launch      |
| [,tt] [,tm] [,tr] | box toggle , table mode toggle, realign |
|     [,gn] ,gp]    |            git hunk next/prev           |
|    [yaw] [daf]    |       yank/delete outer word/func       |
|    cs'  ds"  S"   |  surround change / delete / visual add  |
|   cs'<q>   cst"   |   change ' for <q> /  change tag to "   |
| ysiw' yss"  Vs<p> |       surround word / line / lines      |
|      ,a,A ,fx     |         swap / interactive swap         |
|  ctrl-g, ctrl-t   |         search results next/prev        |

```
space: ( [ { B S
close: ) ] } b s f ' "


`,tr`   => "realigns" table under cursor column (insert)
`gap`
`gaip*|` => aligns table (insert)


|     key     |            vim action            |
|:-----------:|:--------------------------------:|
| $m+h +  c/v | i3 center or reset middle window |
|    $m-spc   |        tmux cycle layouts        |
|  $m-s $m-w  |       window/session picker      |
:::

- Currently "lookup" consists of how2, cht.sh, then one liners with navi, then personal repository
 Need keys for ISwap

|      key     |           shell action           |
|:------------:|:--------------------------------:|
|   C-f  C-F   |        (insert) skip word        |
|   C-a C-U/F  |        highlight url/file        |
|     C-a f    |           butler search          |
|    $m-spc    |        tmux cycle layouts        |
| `$m+h` `c/v` | i3 center or reset middle window |
|  `$m-s $m-w` |       window/session picker      |

```

## Multiple Cursors

TODO: add notes for multiple cursors without multiple cursors

Two main modes: press Tab to switch between «cursor» and «extend» mode
in cursor mode commands work as they would in normal mode, in extend mode commands work as they would in visual mode

Most vim commands work as expected (motions, r to replace characters, ~ to change case, etc). Additionally you can:
  run macros/ex/normal commands at cursors
  align cursors
  transpose selections
  add patterns with regex, or from visual mode
  And more... of course, you can enter insert mode and autocomplete will work.

## Remove everything except regex match (ClearAllButMatches)

```vim
" This effect can be accomplished by using sub-replace-special substitution and setreg() linewise
:let @a=""
:%s//\=setreg('A', submatch(0), 'l')/g
:%d _
:pu a
:0d _
 or all in one line as such:

:let @a=""|%s//\=setreg('A', submatch(0), 'l')/g|%d _|pu a|0d _
" Overview: Using a substitution to append each match into register "a" linewise then replace the entire buffer with the contents of register "a"

" Explanation:

" 1. let @a="" empty the "a" register that we will be appending into
" 2. %s//\=setreg('A', submatch(0), 'l')/g substitute globally using the last pattern
" 3. the \=expr will replace the pattern with the contents of the expression
" 4. submatch(0) get the entire string of what just matched
" 5. setreg('A', submatch(0), 'l') append (note: the capital "a") to @a the matched string, but linewise
" 6. %d _ delete every line into the black hole register (aka @_)
" 7. pu a put the contents of @a into the buffer
" 8. 0d _ delete the first line
"
" Concerns:
" This will trash one of your registers. This example trashed @a
" Uses the last search pattern. Although you can modify the substitute command with whatever pattern you want: %s/<pattern>/\=setreg('A', submatch(0), 'l')/g
```

### Yank and swap

```vim
yi[       " yank what's between the brackets
S         " delete line and start insert
<C-r>0    " insert last yanked text
```

### Non-greedy line replacing

Delete entire line and replace with matched subgroup
Assuming <ip> is your regex to match an IP address, I presume you could do something like:

```vim
:%s/.\{-}\(<ip>\).*/\1/g
:%s/\v.{-}(<ip>).*/\1/
```

### Using grep outside of vim

```vim
:1,$! grep --extended-regexp --only-matching --regexp="([0-9]{1,3}\.){3}[0-9]{1,3}"
:%!grep --only-matching --extended-regexp '".*"'
```

### Using macro with nowrapscan

```vim
:set nowrapscan
:let @a=""
gg0qac/\v(\d{1,3}\.){3}\d{1,3}<CR><CR><Esc>//e+1<CR>@aq@adG
```

1. set nowrapscan disables ability to seek «past the end of file».
2. let @a="": empty the a register.
3. gg0: go to the first column (0) of the first line (gg).
4. qa: start writing macros.
5. c/{pattern}<CR>: change until pattern.
6. c{motion}<CR><ESC>: replace text with newline (here {motion} is /{pat}<CR>).
7. //e+1<CR>: search for last pattern, go one character left past its end (wraps around a newline, but if your lines looks like this: IP<newline>IP, there may be problems).
8. @a: execute @a macros (it is empty when you are recording it, but when you are finished it will repeat steps 1-7 until it gets an error).
9. q: end recording @a.
10. @a: execute @a macros.
11. dG: delete to the end of file.

## Power of 'g'

```vim
# Display context (5 lines) for all occurrences of a pattern.
:g/pattern/z#.5
" Same, but with some beautification.
:g/pattern/z#.5|echo "=========="
# delete all lines matching a pattern
:g/pattern/d
# delete all lines NOT matching a pattern
:g!/pattern/d
:v/pattern/d
# Delete all blank lines (^ is start of line; \s* is zero or more whitespace characters; $ is end of line)
:g/^\s*$/d
# Double space the file (^ is start of line which matches each line).
:g/^/pu =\"\n\"
" Alternative (:put inserts nothing from the blackhole register)
:g/^/pu _
# Copy all lines matching a pattern to end of file.
:g/pattern/t$
# Move all lines matching a pattern to end of file.
:g/pattern/m$
# Yank all lines matching a pattern to register 'a'.
qaq:g/pattern/y A
# Explanation qaq is a trick to clear register a (qa starts recording a macro to register a, then q stops recording, leaving a empty). y A is an Ex command (:help :y). It yanks the current line into register A (append to register a).
# Increment each number at the start of a line, from the current line to end-of-file, by one (the exclamation mark in :normal! means this will work even if Ctrl-A has been mapped to perform a function other than its default of incrementing a number).
:.,$g/^\d/exe "normal! \<C-A>"
# Comment lines containing "DEBUG" statements in a C program.
" using :normal
g/^\s*DEBUG/exe "norm! I/* \<Esc>A */\<Esc>"
" using :substituting
g/^\s*DEBUG/s!.*!/* & */!
# Reverse lookup for records (say an address book, with Name at start-of-line and fields after a space).
:g/pattern/?^\w?p "if only name is interesting
:g/pattern/ka|?^\w?p|'ap "if name and the lookup-line is interesting
:g/pattern/?^\w?|+,/^[^ ]/-1p "if entire record is interesting
# Add text to the end of a line that begins with a certain string.
:g/^pattern/s/$/mytext
# Deleting many lines
# The command :g/pattern/d performs :d on all lines matching the pattern, see :help :delete. When a line is deleted, it is first copied to a register—since no register is specified, the default (unnamed) register is used. If many thousands of lines are deleted, the copy process can take a significant time. To avoid that waste of time, the blackhole register (_) can be specified because any copy or cut into the blackhole register performs no operation.
# Fast delete of all lines matching a pattern.
:g/pattern/d _
# Explanation See :help :range for the meaning of the constructs in the [cmd] portion of the :g commands.
# Reverse a file (just to show the power of g).
:g/^/m0
:2,8co15  "copy lines 2 through 8 after line 15
:4,15t$   "copy lines 4 through 15 to end of document (t == co)
:-t$      "copy previous line to end of document
:m0       "move current line to line 0 (i.e. the top of the document)
:.,+3m$-1 "current line through current+3 are moved to the lastLine-1 (i.e. next to last)
```

```

Perl    Vim     Explanation
---------------------------
x?      x\=     Match 0 or 1 of x
x+      x\+     Match 1 or more of x
(xyz)   \(xyz\) Use brackets to group matches
x{n,m}  x\{n,m} Match n to m of x
x*?     x\{-}   Match 0 or 1 of x, non-greedy
x+?     x\{-1,} Match 1 or more of x, non-greedy
\b      \< \>   Word boundaries
$n      \n      Backreferences for previously grouped matches

Character classes: */character-classes*
      magic    matches
|/\i| \i \i identifier character (see 'isident' option)
|/\I| \I \I like "\i", but excluding digits
|/\k| \k \k keyword character (see 'iskeyword' option)
|/\K| \K \K like "\k", but excluding digits
|/\f| \f \f file name character (see 'isfname' option)
|/\F| \F \F like "\f", but excluding digits
|/\p| \p \p printable character (see 'isprint' option)
|/\P| \P \P like "\p", but excluding digits
|/\s| \s \s whitespace character: <Space> and <Tab>
|/\S| \S \S non-whitespace character; opposite of \s
|/\d| \d \d digit:    [0-9]
|/\D| \D \D non-digit:   [^0-9]
|/\x| \x \x hex digit:   [0-9A-Fa-f]
|/\X| \X \X non-hex digit:   [^0-9A-Fa-f]
|/\o| \o \o octal digit:   [0-7]
|/\O| \O \O non-octal digit:  [^0-7]
|/\w| \w \w word character:   [0-9A-Za-z_]
|/\W| \W \W non-word character:  [^0-9A-Za-z_]
|/\h| \h \h head of word character:  [A-Za-z_]
|/\H| \H \H non-head of word character: [^A-Za-z_]
|/\a| \a \a alphabetic character:  [A-Za-z]
|/\A| \A \A non-alphabetic character: [^A-Za-z]
|/\l| \l \l lowercase character:  [a-z]
|/\L| \L \L non-lowercase character: [^a-z]
|/\u| \u \u uppercase character:  [A-Z]
|/\U| \U \U non-uppercase character  [^A-Z]
|/\_| \_x \_x where x is any of the characters above: character

        magic   matches ~
|/\e|  \e \e <Esc>
|/\t|  \t \t <Tab>
|/\r|  \r \r <CR>
|/\b|  \b \b <BS>
|/\n|  \n \n end-of-line
|/~|   ~   \~ last  given substitute string
|/\1|  \1 \1 same string as matched by first \(\)
|/\2|  \2 \2 Like "\1", but uses second \(\)
|/[]|  [] \[] any character specified inside the []
|/\%[]| \%[] \%[] a sequence of optionally matched atoms
|/\c|  \c \c ignore case, do not use the 'ignorecase' option
|/\C|  \C \C match case, do not use the 'ignorecase' option
|/\Z|  \Z \Z ignore differences in Unicode "combining characters".
|/\m|  \m \m 'magic' on for the following chars in the pattern
|/\M|  \M \M 'magic' off for the following chars in the pattern
|/\v|  \v \v the following chars in the pattern are "very magic"
|/\V|  \V \V the following chars in the pattern are "very nomagic"
|/\%d| \%d \%d match specified decimal character (eg \%d123)
|/\%x| \%x \%x match specified hex character (eg \%x2a)
|/\%o| \%o \%o match specified octal character (eg \%o040)
|/\%u| \%u \%u match specified multibyte character (eg \%u20ac)
|/\%U| \%U \%U match specified large multibyte character (eg \%U12345678)
|/\%C| \%C \%C match any composing characters
|/\%#=| \%#=1 \%#=1 select regexp engine |/zero-width|





```

### Vim Environment

:abbreviate   - list abbreviations
:args         - argument list
:augroup      - augroups
:autocmd      - list auto-commands
:buffers      - list buffers
:breaklist    - list current breakpoints
:cabbrev      - list command mode abbreviations
:changes      - changes
:cmap         - list command mode maps
:command      - list commands
:compiler     - list compiler scripts
:digraphs     - digraphs
:file         - print filename, cursor position and status (like Ctrl-G)
:filetype     - on/off settings for filetype detect/plugins/indent
:function     - list user-defined functions (names and argument lists but not the full code)
:function Foo - user-defined function Foo() (full code list)
:highlight    - highlight groups
:history c    - command history
:history =    - expression history
:history s    - search history
:history      - your commands
:iabbrev      - list insert mode abbreviations
:imap         - list insert mode maps
:intro        - the Vim splash screen, with summary version info
:jumps        - your movements
:language     - current language settings
:let          - all variables
:let FooBar   - variable FooBar
:let g:       - global variables
:let v:       - Vim variables
:list         - buffer lines (many similar commands)
:lmap         - language mappings (set by keymap or by lmap)
:ls           - buffers
:ls!          - buffers, including "unlisted" buffers
:map!         - Insert and Command-line mode maps (imap, cmap)
:map          - Normal and Visual mode maps (nmap, vmap, xmap, smap, omap)
:map<buffer>  - buffer local Normal and Visual mode maps
:map!<buffer> - buffer local Insert and Command-line mode maps
:marks        - marks
:menu         - menu items
:messages     - message history
:nmap         - Normal-mode mappings only
:omap         - Operator-pending mode mappings only
:print        - display buffer lines (useful after :g or with a range)
:reg          - registers
:scriptnames  - all scripts sourced so far
:set all      - all options, including defaults
:setglobal    - global option values
:setlocal     - local option values
:set          - options with non-default value
:set termcap  - list terminal codes and terminal keys
:smap         - Select-mode mappings only
:spellinfo    - spellfiles used
:syntax       - syntax items
:syn sync     - current syntax sync mode
:tabs         - tab pages
:tags         - tag stack contents
:undolist     - leaves of the undo tree
:verbose      - show info about where a map or autocmd or function is defined
:version      - list version and build options
:vmap         - Visual and Select mode mappings only
:winpos       - Vim window position (gui)
:xmap         - visual mode maps only
Notes
Additional information is available to a Vim script. For example, :help tabpagebuflist() shows how to list all buffers in all tabs.

A script called bugreport.vim is provided with Vim. When run, the script produces a file with information about
```
