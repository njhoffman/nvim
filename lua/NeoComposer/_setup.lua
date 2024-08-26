-- :EditMacros
-- :ClearNeoComposer
-- :Telescope macros

local config = {
  status_bg = "#000000", -- Background color of status line component
  preview_fg = "#ff9e64", -- Foreground color of macro preview text
  notify = true,
  delay_timer = "150",
  keymaps = {
    play_macro = "qq",
    yank_macro = "yq",
    stop_macro = "cq",
    toggle_record = "Q",
    cycle_next = "<leader>Qn",
    cycle_prev = "<leader>Qp",
    toggle_macro_menu = "<m-q>",
  },
  --   -- Named registers where macros are saved. The first register is the default register/macro-slot used after startup.
  --   slots = { "a", "b" },
  --   -- default keymaps, see README for description what the commands do
  --   mapping = {
  --     startStopRecording = "Q",
  --     playMacro = "qq",
  --     editMacro = "cq",
  --     yankMacro = "yq", -- also decodes it for turning macros to mappings
  --     switchSlot = "<M-C-Q>",
  --     addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
  --   },
  --
  --   -- clears all macros-slots on startup
  --   clear = false,
  -- -- startStopRecording: Starts recording to the current macro slot (so you do not need to specify a register). Press again to end the recording.
  -- -- playMacro: Plays the macro in the current slot (without the need to specify a register).
  -- -- switchSlot: Cycles through the registers you specified in the configuration. Also show a notification with the slot and its content. (The currently selected slot can be seen in the status line component. )
  -- -- editMacro: Lets you modify the macro recorded in the active slot. (Be aware that these are the keystrokes in "encoded" form.)
  -- -- yankMacro: Copies the current macro in decoded form that can be used to create a mapping from it. Breakpoints are removed from the macro -- bulb For recursive macros (playing a macro inside a macro), you can still use the default command @a.
  -- --
  -- -- Macro Breakpoints
  -- -- nvim-recorder allows you to set breakpoints in your macros which can be helpful for debugging macros. Breakpoints are automatically ignored when you trigger the macro with a count.
  -- --
  -- -- During a recording, press the addBreakPoint key (default: ##) in normal mode.
  -- -- After a recording, use editMacro and add or remove the ## manually.
  -- --
  -- -- Using the playMacro key, the macro automatically stops at the next breakpoint. The next time you press playMacro, the next segment of the macro is played.
  -- -- Starting a new recording, editing a macro, yanking a macro, or switching macro slot all reset the sequence, meaning that playMacro starts from the beginning again.
  -- -- bulb You can do other things in between playing segments of the macro, like moving a few characters to the left or right. That way you can also use breakpoints to manually correct irregularities.
  -- --
  -- -- Ignoring Breakpoints
  -- -- When you play the macro with a count (for example 50Q), breakpoints are automatically ignored.
  -- -- bulb Add a count of 1 (1Q) to play a macro once and still ignore breakpoints.
}

require("NeoComposer").setup(config)
require("NeoComposer.state").set_delay(true)
require("telescope").load_extension("macros")
-- -- require("recorder").recordingStatus()
-- -- require("recorder").displaySlots()

vim.api.nvim_create_autocmd("User", {
  pattern = {
    "NeoComposerRecordingSet",
    "NeoComposerPlayingSet",
    "NeoComposerDelaySet",
  },
  callback = function(ev)
    vim.dbglog("NeoComposer", ev)
    -- require("neocomposer.ui").status_recording()
  end,
})
