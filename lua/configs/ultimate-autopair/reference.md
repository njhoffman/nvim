
`({[*] })    )    ({[] })* `
`({[*] })`

Ultimate Autopairs

```
start-pair-insertion         *ultimate-autopair-workings-start-pair-insertion*
When inserting start pair, then if there is not already a corresponding end
pair in the line, then insert an end pair.
Example (`*` is cursor):
 | before | keys | after |
 | *      | (    | (*)   |
 | *      | ((   | ((*)) |
 | *)     | (    | (*)   |
 | (*))   | (    | ((*)) |

------------------------------------------------------------------------------
end-pair-insertion             *ultimate-autopair-workings-end-pair-insertion*
When inserting end pair and next is end pair, then if there is a corresponding
start pair in the line, then hop over the end pair.
Example (`*` is cursor):
 | before | keys | after |
 | (*)    | )    | ()*   |
 | (*     | )    | ()*   |
 | ((*)   | )    | (()*) |
 | (*))   | )    | ()*)  |

------------------------------------------------------------------------------
ambiguous-pair-insertion *ultimate-autopair-workings-ambiguous-pair-insertion*
When inserting ambiguous pair, if the next is ambiguous pair which has a
corresponding pair then hop over, otherwise if there's not already a
corresponding pair on the line then insert the ambiguous pair double
Example (`*` is cursor):
 | before | keys | after   |
 | *      | '    | '*'     |
 | '*     | '    | ''*     |
 | *'     | '    | '*'     |
 | '*'    | '    | ''*     |
 | ' * '  | '    | ' '*' ' |
 | ''*''  | '    | '''*''' |

------------------------------------------------------------------------------
filter                                              *ultimate-autopair-filter*
Filter is used for filtering pairs/other characters, it will run for every
pair to check conditions, like if prev char is not `\\`.
------------------------------------------------------------------------------
multiline                                        *ultimate-autopair-multiline*
Multiline works pretty simply, it gets the whole buffer (to a maximum of 1000
lines) and that is used for the plugin.
==============================================================================
MAP                                                    *ultimate-autopair-map*
------------------------------------------------------------------------------
backspace                                    *ultimate-autopair-map-backspace*
Behaves like you would expect an autopair backspace to behave.
For configuration options see: |ultimate-autopair-map-backspace-config|
Example (`*` is cursor):
 | before    | after    | config             |
 |-----------+----------+--------------------|
 | (*)       | *        |                    |
 | ((*)      | (*)      |                    |
 | {\n*\n}   | {*}      |                    |
 | (*foo)    | *foo     | overjum            |
 | ( * )     | (*)      | space              |
 | ( *foo )  | (*foo)   | space              |
 | (  *foo ) | ( *foo ) | space              |
 | ( *foo  ) | ( *foo ) | space='balance'    |
 | <!--*-->  | <!-*     | single_delete=true |
 | {\n\t*\n} | {*}      |indent_ignore=true  |

------------------------------------------------------------------------------
newline                                        *ultimate-autopair-map-newline*
Behaves like you would expect an autopair newline to behave.
For configuration options see: |ultimate-autopair-map-newline-config|
Example (`*` is cursor and `\t` is tab):
 | before | after  | config    |
 |--------+--------+-----------|
 | {*}    | {      |           |
 |        | \t*    |           |
 |        | }      |           |
 |--------+--------+-----------|
 | {*     | {      | autoclose |
 |        | \t*    |           |
 |        | }      |           |
 |--------+--------+-----------|
 | {foo*} | {foo   |           |
 |        | \t*    |           |
 |        | }      |           |
 |--------+--------+-----------|
 | {*foo} | {      |           |
 |        | \t*foo |           |
 |        | }      |           |

------------------------------------------------------------------------------
space                                            *ultimate-autopair-map-space*
Behaves like you would expect an autopair space to behave.
For configuration options see: |ultimate-autopair-map-space-config|
Example (`*` is cursor):
 | before | after    | config                |
 |--------+----------+-----------------------|
 | (*)    | ( * )    |                       |
 | ( * )  | (  *  )  |                       |
 | (*foo) | ( *foo ) |                       |
 | + [*]  | + [ *]   | check_box_ft={'text'} |

------------------------------------------------------------------------------
space2                                          *ultimate-autopair-map-space2*
Auto balances spaces when input char matches `match`.
For configuration options see: |ultimate-autopair-map-space2-config|
Example (`*` is cursor):
 | before | inp | after    |
 |--------+-----+----------|
 | ( *)   | f   | ( f* )   |
 | (  *)  | f   | (  f*  ) |
 | ( * )  | f   | ( f* )   |
 | ( *oo) | f   | ( f*oo ) |

------------------------------------------------------------------------------
fastwarp                                      *ultimate-autopair-map-fastwarp*
The fastwarp mapping fast warp (not wraps) the next end pair.
For configuration options see: |ultimate-autopair-map-fastwarp-config|
Example (`*` is cursor):
 | before     | after      |
 |------------+------------|
 | (*){}      | ({}*)      |
 | (*){foo}   | ({foo}*)   |
 | (*)foo     | (foo*)     |
 | (foo*),bar | (foo,bar*) |
  Example (`*` is cursor)(nocursormove=true):
 | before     | after      |
 |------------+------------|
 | (*){}      | (*{})      |
 | (*){foo}   | (*{foo})   |
 | (*)foo     | (*foo)     |
 | (foo*),bar | (foo,bar*) | (fallback to cursormove)

------------------------------------------------------------------------------
rfastwarp                                    *ultimate-autopair-map-rfastwarp*
The rfastwarp mapping is designed to do the opposite of fastwarp.
For configuration options see: |ultimate-autopair-map-fastwarp-config|
------------------------------------------------------------------------------
close                                            *ultimate-autopair-map-close*
The close mapping closes opened pairs.
For configuration options see: |ultimate-autopair-map-close-config|
Example (`*` is cursor):
 | before | after |
 |--------+-------|
 | (*     | (*)   |
 | ({*    | ({*}) |
 | (*)    | (*)   |
 | "*     | "*"   |

------------------------------------------------------------------------------
tabout                                          *ultimate-autopair-map-tabout*
The tabout mapping allows you to jump to end (or out) of pairs.
For configuration options see: |ultimate-autopair-map-tabout-config|
Example (`*` is cursor):
 | before | after  | config |
 |--------+--------+--------|
 | (f*oo) | (foo*) |        |
 | (*[])  | ([]*)  |        |
 | (*)    | ()*    | hopout |

------------------------------------------------------------------------------
map-multi-config                          *ultimate-autopair-map-multi-config*
In each map, you can set `multi` to `true` to have multiple configs at the
same time. Each indexed item (`ipairs`) in the config gets extended with the
root config, and passed to respective module.
Example: >lua
 {
     fastwarp={
         multi=true,
         p=20, --all sub-configs get default value p=20, unless specified
         {map='<A-e>',nocursormove=true},
         {map='<A-f>',nocursormove=false},
     }
 }
<
==============================================================================
EXTENSIONS                                      *ultimate-autopair-extensions*
All extensions should be in the `extensions` directory.
For default configuration see: |ultimate-autopair-extensions-default-config|
Every extension has a `p` flag which denotes its priority.
Note that almost every option may also be a function.
------------------------------------------------------------------------------
ext-alpha                                        *ultimate-autopair-ext-alpha*
This extension allows for disabling pairs before and after alpha
Extension config:
{alpha} `string[]|boolean`: Weather to check for alpha before
  and if `string[]` then for which filetypes.
{after} `string[]|boolean`: Weather to check for alpha after
  and if `string[]` then for which filetypes.
{filter} `boolean`: Weather to filter (|ultimate-autopair-filter|)
{all} `boolean`: Weather to check for all in-characters, not just start pairs.
{no_python}: Weather to disable f-string detection.
Extension pair-config:
{alpha} `string[]|boolean`: Weather to check for alpha before
  and if `string[]` then for which filetypes.
{alpha_after} `string[]|boolean`: Weather to check for alpha after
  and if `string[]` then for which filetypes.
------------------------------------------------------------------------------
ext-cmdtype                                    *ultimate-autopair-ext-cmdtype*
This extension allows for disabling in specific cmdline-types
Extension config:
{skip} `string[]`: Which cmdtypes to skip `:h getcmdtype()`
Extension pair-config:
{skipcmdtype} `string[]`: Which cmdtypes to skip `:h getcmdtype()`
------------------------------------------------------------------------------
ext-cond                                          *ultimate-autopair-ext-cond*
This extension allows for creating conditions
Extension config:
{cond} `function|function[]`: List of functions to run
{filter} `boolean`: Weather to filter (|ultimate-autopair-filter|)
Extension pair-config:
{cond} `function|function[]`: List of functions to run
For the arguments of the function, pleas refer to source code
`lua/ultimate-autopair/extension/cond.lua` for info (until doc is written).
------------------------------------------------------------------------------
ext-escape                                      *ultimate-autopair-ext-escape*
This extension allows for checking for escaped pairs
Extension config:
{filter} `boolean`: Weather to filter (|ultimate-autopair-filter|)
Extension pair-config:
{noescape} `boolean`: Weather to disable escape
------------------------------------------------------------------------------
ext-filetype                                  *ultimate-autopair-ext-filetype*
This extensions allows fire filetype checking (including injected langs).
Extension config:
{ft} `string[]`: Which filetypes to enable
{nft} `string[]`: Which filetypes to disable
{tree} `boolean`: Weather to use treesitter injected lang detection
Extension pair-config:
{ft} `string[]`: Which filetypes to enable
{nft} `string[]`: Which filetypes to disable
------------------------------------------------------------------------------
ext-fly                                            *ultimate-autopair-ext-fly*
This extensions allows for hopping list of end-pairs (+ other chars)
Example (`*` is cursor) (default config):
 | before   | key | after    | config                   |
 |----------+-----+----------+--------------------------|
 | ({[*] }) | )   | ({[] })* |                          |
 | *()      | )   | ()*      | only_jump_end_pair=false |

Extension config:
{nofilter} `boolean`: Weather to disable filtering (for string quote)
{only_jump_end_pair} `boolean`: Weather to only jump end pair
{other_char} `string[]`: What other chars to jump
{undomap} `string|string[]`: Create an undo map
{undocmap} `string|string[]`: Create an undo map for cmdline
{undomapconf} `table`: Undo map conf
Extension pair-config:
{fly} `boolean`: Weather a pair can fly/be flown over
------------------------------------------------------------------------------
ultimate-autopair-ext-suround                  *ultimate-autopair-ext-suround*
This extension allows for to surround pairs
Example (`*` is cursor):
 | before | key | after  |
 |--------+-----+--------|
 | *'a'   | (   | (*'a') |

Extension pair-config:
{dosurround} `boolean`: Weather to do surround
{surround} `boolean`: Weather to be allowed to be surrounded
------------------------------------------------------------------------------
ultimate-autopair-ext-tsnode                    *ultimate-autopair-ext-tsnode*
This extension allows for to filers tsnodes (|ultimate-autopair-filter|)
If in a specified tsnode, then filter outside the node
and if outside of any specified tsnode, then filter inside tsnodes
Extension config:
{separate} `string[]`: List of node types to separate
------------------------------------------------------------------------------
ultimate-autopair-ext-utf8                        *ultimate-autopair-ext-utf8*
This extension replaces UTF-8 chars with ASCII counterparts.
Extension config:
{map} `table<string|true,string>`: A regex map for defining which utf8 chars
  go to which char, or `true` to denotes default value
==============================================================================
OTHER                                                *ultimate-autopair-other*
------------------------------------------------------------------------------
debug                                                *ultimate-autopair-debug*
Ultimate-autopair has a few scripts to run debug. The first one is `ua._list`
which will allow you to select wanted pair and see information about sed pair.
The second one is `debug` which automatically activates when a mapping throws
an error.
------------------------------------------------------------------------------
test                                                  *ultimate-autopair-test*
The test file sits in the `test` directory. You can run the test by sourcing
it with neovim or by running `:checkhealth ultimate-autopair`. Set values
`_G.UA_DEV=true` for dev testing (and `_G.UA_DEV='ok'` to also report OKs).
------------------------------------------------------------------------------
notes                                                *ultimate-autopair-notes*
The root directory `notes` contains notes and scribbles about the plugin.
------------------------------------------------------------------------------
use-with-npairs                            *ultimate-autopair-use-with-npairs*
This is about how to use UA with https://github.com/windwp/nvim-autopairs
Currently, there's not yet a profile for npairs, so you'll have to do with
using one or the other with no fallback to other.
So the only way to use them side by side is to disable specific features.
Most disables are self explanatory, but disabling npairs pair insert is
complicated: the only way is to set all `rules.key_map` to `nil`: >lua
 for _,i in ipairs(npairs.config.rules) do
   i.key_map=nil
 end
<
Note that if you add rules after this, then they won't be disabled.
```

*auto-pairs*
<https://github.com/jiangmiao/auto-pairs>

```
Insert in pair

input: [
output: [|]
Delete in pair

input: foo[<BS>]
output: foo
Insert new indented line after Return

input: {|} (press <CR> at |)
output: {
    |
}          (press } to close the pair)
output: {
}|         (the inserted blank line will be deleted)
Insert spaces before closing characters, only for [], (), {}

input: {|} (press <SPACE> at |)
output: { | }

input: {|} (press <SPACE>foo} at |)
output: { foo }|

input: '|' (press <SPACE> at |)
output: ' |'
Skip ' when inside a word

input: foo| (press ' at |)
output: foo'
Skip closed bracket.

input: []
output: []
Ignore auto pair when previous character is \

input: "\'
output: "\'"
Fast Wrap

input: |[foo, bar()] (press (<M-e> at |)
output: ([foo, bar()])
Quick move char to closed pair

input: (|){["foo"]} (press <M-}> at |)
output: ({["foo"]}|)

input: |[foo, bar()] (press (<M-]> at |)
output: ([foo, bar()]|)
Quick jump to closed pair.

input:
{
    something;|
}

(press } at |)

output:
{

}|
Fly Mode

 input: if(a[3)
 output: if(a[3])| (In Fly Mode)
 output: if(a[3)]) (Without Fly Mode)

 input:
 {
     hello();|
     world();
 }

 (press } at |)

 output:
 {
     hello();
     world();
 }|

 (then press <M-b> at | to do backinsert)
 output:
 {
     hello();}|
     world();
 }

 See Fly Mode section for details
Multibyte Pairs

 Support any multibyte pairs such as <!-- -->, <% %>, """ """
 See multibyte pairs section for details

```

nvim-autopairs
<https://github.com/windwp/nvim-autopairs>
