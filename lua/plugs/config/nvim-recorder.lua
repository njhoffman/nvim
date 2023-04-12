local defaultConfig = {
  -- Named registers where macros are saved. The first register is the default
  -- register/macro-slot used after startup.
  slots = { "a", "b" },

  -- default keymaps, see README for description what the commands do
  mapping = {
    startStopRecording = "q",
    playMacro = "Q",
    switchSlot = "<M-C-Q>",
    editMacro = "cq",
    yankMacro = "yq", -- also decodes it for turning macros to mappings
    addBreakPoint = "##", -- ⚠️ this should be a string you don't use in insert mode during a macro
  },

  -- clears all macros-slots on startup
  clear = false,

  -- log level used for any notification, mostly relevant for nvim-notify
  -- (note that by default, nvim-notify does not show the levels trace and debug.)
  logLevel = vim.log.levels.INFO,

  -- if enabled, only essential or critical notifications are sent.
  -- If you do not use a plugin like nvim-notify, set this to `true`
  -- to remove otherwise annoying notifications.
  lessNotifications = false,

  -- experimental, see README
  dapSharedKeymaps = false,
}
-- default values
require("recorder").setup(defaultConfig)
-- -- indicates whether you are currently recording. Useful if you are using
-- require("recorder").recordingStatus()
-- -- displays non-empty macro-slots (registers) and indicates the selected ones.
-- require("recorder").displaySlots()
-- -- 💡 put the components in different status line segments so they have a different color
-- Basics
-- startStopRecording: Starts recording to the current macro slot (so you do not need to specify a register). Press again to end the recording.
-- playMacro: Plays the macro in the current slot (without the need to specify a register).
-- switchSlot: Cycles through the registers you specified in the configuration. Also show a notification with the slot and its content. (The currently selected slot can be seen in the status line component. )
-- editMacro: Lets you modify the macro recorded in the active slot. (Be aware that these are the keystrokes in "encoded" form.)
-- yankMacro: Copies the current macro in decoded form that can be used to create a mapping from it. Breakpoints are removed from the macro
-- bulb For recursive macros (playing a macro inside a macro), you can still use the default command @a.
--
-- Macro Breakpoints
-- nvim-recorder allows you to set breakpoints in your macros which can be helpful for debugging macros. Breakpoints are automatically ignored when you trigger the macro with a count.
--
-- During a recording, press the addBreakPoint key (default: ##) in normal mode.
-- After a recording, use editMacro and add or remove the ## manually.
--
-- Using the playMacro key, the macro automatically stops at the next breakpoint. The next time you press playMacro, the next segment of the macro is played.
-- Starting a new recording, editing a macro, yanking a macro, or switching macro slot all reset the sequence, meaning that playMacro starts from the beginning again.
-- bulb You can do other things in between playing segments of the macro, like moving a few characters to the left or right. That way you can also use breakpoints to manually correct irregularities.
--
-- Ignoring Breakpoints
-- When you play the macro with a count (for example 50Q), breakpoints are automatically ignored.
-- bulb Add a count of 1 (1Q) to play a macro once and still ignore breakpoints.
--
-- Shared Keybindings with nvim-dap
-- If you are using nvim-dap, you can use dapSharedKeymaps = true to set up the following shared keybindings:
-- addBreakPoint maps to dap.toggle_breakpoint() outside a recording. During a recording, it adds a macro breakpoint instead.
-- playMacro maps to dap.continue() if there is at least one dap-breakpoint. If there is no dap-breakpoint, plays the current macro-slot instead.
-- Note that this feature is experimental, since the respective API from nvim-dap is non-public and can be changed without deprecation notice.
--
