local function notify_output(command, opts)
  local output = ""
  local notification

  local notify = function(msg)
    local notify_opts = vim.tbl_extend(
      "keep",
      opts or {},
      { title = table.concat(command, " "), replace = notification }
    )
    -- notification = vim.notify(msg, "task", notify_opts)
    notification = require("notify")(msg, "task", notify_opts)
  end

  local on_data = function(_, data)
    output = output .. table.concat(data, "\n")
    notify(output, "info")
  end

  vim.fn.jobstart(command, {
    on_stdout = on_data,
    on_stderr = on_data,
    on_exit = function(_, code)
      if #output == 0 then
        notify("No output of command, exit code: " .. code, "info")
      end
    end,
  })
end

notify_output({ "ls", "-alh" })
