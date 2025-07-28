-- user/codecompanion/adapters/copilot.lua
-- https://github.com/olimorris/codecompanion.nvim/discussions/420
handlers = {
  form_messages = function(adapter, messages)
    local obj = require("codecompanion.adapters.copilot").handlers.form_messages(adapter, messages)
    local _messages = utils.add_custom_instructions_message(obj.messages)
    _messages = utils.add_buffers_message(_messages, adapter)
    return {
      messages = _messages,
    }
  end,
}
