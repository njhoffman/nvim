## TODO

- [ ] Add support for `:undo` and `:redo`

#### Configuration and setup

```lua

local config = {
  max_marks = 50,
  providers = {
    changes = {
      listeners = {
        "changes",
      },
    },
    jumps = {
      listeners = {
        "jumps",
      },
    },
    visual = {
      listeners = {
        "pastes",
        "yanks",
        "selections",
      },
    },
    saves = {
      listeners = {
        "writes",
      },
    },
  },
}

local listeners = {
  changes = { filter = function() end },
  jumps = { filter = function() end },
  pastes = { init = function() end },
  yanks = { init = function() end },
  selections = { init = function() end },
  writes = { init = function() end },
}
```
