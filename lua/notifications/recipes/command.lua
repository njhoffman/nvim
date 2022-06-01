local function notify_output(command, opts)
  local output = ""
  local notification
  local notify = function(msg, level)
    local notify_opts =
    vim.tbl_extend(
      "keep",
      opts or {},
      { title = table.concat(command, " "), replace = notification }
    )
    msg = string.sub(msg, 0, -2)
    notification = vim.notify(msg, level, notify_opts)
  end

  local on_data = function(_, data)
    output = output .. table.concat(data, "\n")
    notify(output, "task")
  end

  local on_error = function(_, data)
    output = output .. table.concat(data, "\n")
    notify(output, "error")
  end

  vim.fn.jobstart(
    command,
    {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = on_data,
      -- on_stderr = on_error,
      on_exit = function(_, code)
        if #output == 0 then
          notify("No output of command, exit code: " .. code, "warn")
        end
      end
    }
  )
end

-- notify_output({ "echo", "hello world" })
-- notify_output("echo hello world")
-- notify_output({ "pidstat" })
-- /usr/bin/time -f "%E real\t%x exit"
notify_output({ "/usr/bin/zsh", "-c", ". ~/.aliases/audio.sh && eval mpc" }, { title = "mpc" })
