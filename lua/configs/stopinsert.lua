local cfg = {
  idle_time_jms = 30000,
  show_popup_msg = false,
  clear_popup_msg = 5000,
  disabled_filetypes = {
    "TelescopePrompt",
    "checkhealth",
    "help",
    "lspinfo",
    "mason",
    "neo%-tree*",
  },
}
-- StopInsertPlug enable/disable/toggle/status
require("stopinsert").setup(cfg)
