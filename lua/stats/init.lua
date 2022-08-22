vim.import('stats.autocommands', function(austats)
  vim.import('stats.environment', function(envstats)
    vim.import('stats.keystats', function(keystats)
      function reformatInt(i)
        return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
      end

      local M = {}
      M.get_items = function()
        local env_counts = envstats.get_counts()
        local au_counts = austats.get_counts()
        local key_counts = keystats.get_counts()

        local items = {
          string.format("Filetype         %8s", env_counts.filetype),
          string.format("Startup Time     %8s", env_counts.startup_time),
          string.format("Memory (RSS)     %8s", reformatInt(env_counts.memory)),
          string.format("Memory (VSZ)     %8s", reformatInt(env_counts.virtual_memory)),
          string.format("Plugins Size     %8s", env_counts.plugins_size),
          string.format("Packer Lines     %8s", reformatInt(env_counts.packer_lines)),
          string.format("AuGroups         %8s", reformatInt(au_counts.groups)),
          string.format("AuCommands       %8s", reformatInt(au_counts.commands)),
          string.format("Commands         %8s", reformatInt(env_counts.commands)),
          string.format("History          %8s", reformatInt(env_counts.history_commands)),
          string.format("Functions        %8s", reformatInt(env_counts.functions)),
          string.format("Highlights       %8s", reformatInt(env_counts.highlights)),
          string.format("Scriptnames      %8s", reformatInt(env_counts.scriptnames)),
          string.format("Syntax Items     %8s", reformatInt(env_counts.syntax_items)),
          string.format("Variables        %8s", reformatInt(env_counts.variables)),
          string.format("Messages         %8s", reformatInt(env_counts.messages)),
          string.format("Changes          %8s", reformatInt(env_counts.changes)),
          string.format("NvimMapper Keys  %8s", reformatInt(key_counts.mapper.total)),
          string.format("WhichKey         %8s", reformatInt(key_counts.whichkey.total)),
          string.format("Total Mapped     %8s", reformatInt(key_counts.neovim.total))
        }
        return items
      end

      -- string.format('Menus                %4d', env_counts.menus),
      -- string.format('Options              %4d', env_counts.options),
      -- string.format('Lazy Plugins Size %4d', env_counts.plugins_size),

      local nui_options = {
        position = "50%",
        size = nil,
        relative = "editor",
        border = {
          style = "rounded"
        },
        max_width = 120,
        max_height = 40
      }

      local stats_select = function(items, opts, cb)
        opts.prompt = opts.prompt or "Title Test"
        vim.ui.select(items, opts, cb)
      end

      local fetch_stats = function()
        local stat_items = M.get_items()
        stats_select(stat_items, {
          prompt = "Stats",
          format_item = function(item)
            return item
          end
        },
          function(choice)
            print(choice)
          end)
      end

      -- Stats
      --   stats:   print popup notify select
      --   watch:   print popup notify
      --   changes: print popup notify
      vim.api.nvim_create_user_command(
        "Stats", fetch_stats,
        { desc = "Internal stats output and monitoring" }
      )

      return M
    end)
  end)
end)
