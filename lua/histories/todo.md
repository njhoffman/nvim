# Future plans for this

local

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
    visual_ops = {
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
