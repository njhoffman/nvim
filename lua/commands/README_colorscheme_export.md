# ColorschemeExport

Export Neovim colorschemes to [bat](https://github.com/sharkdp/bat) theme format (.tmTheme).

## Overview

The `ColorschemeExport` command extracts Neovim highlight group definitions and converts them to the tmTheme XML format used by bat for syntax highlighting. This allows you to use your favorite Neovim colorscheme in bat for consistent terminal theming.

## Usage

### Basic Usage

Export the current colorscheme:

```vim
:ColorschemeExport
```

This will:
1. Extract highlight groups from the current colorscheme
2. Convert them to tmTheme format
3. Open the result in a new split buffer

### Export a Specific Colorscheme

```vim
:ColorschemeExport nord-nick
:ColorschemeExport gruvbox
:ColorschemeExport tokyonight
```

The command supports tab completion for available colorschemes.

### Save the Theme

After running the command, save the buffer to a file:

```vim
:w ~/.config/bat/themes/my-theme.tmTheme
```

Then rebuild bat's cache:

```bash
bat cache --build
```

### Use the Theme

```bash
bat --theme=my-theme file.txt
```

Or set it as default in `~/.config/bat/config`:

```
--theme="my-theme"
```

## Features

- **Automatic conversion**: Maps Neovim highlight groups to tmTheme scopes
- **Style preservation**: Maintains bold, italic, and other text styles
- **UI colors**: Exports background, foreground, selection, and line highlight colors
- **Valid XML**: Generates well-formed tmTheme XML compatible with bat
- **Tab completion**: Suggests available colorschemes

## Implementation Details

### Module Location

- Command: `lua/commands/colorscheme_export.lua`
- Registration: `lua/commands/init.lua`
- Tests: `tests/unit/colorscheme_export_spec.lua`
- Manual test: `tests/manual/test_colorscheme_export.lua`

### Highlight Group Mapping

The module maps Neovim highlight groups to tmTheme scopes:

| Neovim Group | tmTheme Scope |
|--------------|---------------|
| Comment | `comment` |
| String | `string` |
| Function | `entity.name.function` |
| Keyword | `keyword` |
| Type | `storage.type` |
| ... | ... |

### API

```lua
local colorscheme_export = require("commands.colorscheme_export")

-- Generate tmTheme XML string
local xml = colorscheme_export.generate_tmtheme("theme-name")

-- Export to buffer
local bufnr = colorscheme_export.export({
  colorscheme = "theme-name",  -- optional, defaults to current
  filename = "custom.tmTheme"   -- optional, defaults to <theme>.tmTheme
})
```

## Testing

### Unit Tests

Run the Plenary test suite:

```bash
./scripts/run_tests.sh unit
```

Or specifically:

```bash
nvim --headless --noplugin -u tests/minimal_init.lua \
  -c "PlenaryBustedFile tests/unit/colorscheme_export_spec.lua"
```

### Manual Testing

```bash
nvim -l tests/manual/test_colorscheme_export.lua
```

This will:
- Test module loading
- Validate XML generation
- Check structure and formatting
- Display sample output

## Example Output

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>name</key>
  <string>nord-nick</string>
  <key>settings</key>
  <array>
    <dict>
      <key>settings</key>
      <dict>
        <key>background</key>
        <string>#2e3440</string>
        <key>foreground</key>
        <string>#d8dee9</string>
        ...
      </dict>
    </dict>
    ...
  </array>
</dict>
</plist>
```

## References

- [bat - A cat clone with wings](https://github.com/sharkdp/bat)
- [Sublime Text tmTheme Format](https://www.sublimetext.com/docs/color_schemes_tmtheme.html)
- [nvim-highlite](https://github.com/Iron-E/nvim-highlite) - Inspiration for this feature

## Troubleshooting

### Theme looks different in bat

- Not all Neovim highlight groups map perfectly to tmTheme scopes
- Some syntax highlighting rules are language-specific in Sublime/bat
- You may need to manually adjust colors in the generated .tmTheme file

### Missing colors

If some elements aren't colored:
1. Check if the corresponding highlight group exists in Neovim (`:hi GroupName`)
2. Verify the mapping exists in `map_hl_to_scope()` function
3. Consider adding custom mappings for your use case

### Invalid XML error in bat

If bat rejects the theme:
1. Validate the XML structure
2. Check for unescaped special characters
3. Ensure all hex colors are properly formatted (#RRGGBB)

## Contributing

To add new highlight group mappings, edit the `map_hl_to_scope()` function in `lua/commands/colorscheme_export.lua`.

To report issues or suggest improvements, see the project documentation.
