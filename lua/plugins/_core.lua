local utils = require("utils.lazy")

local plugins = {
  { "folke/lazy.nvim", lazy = false },
  -- colorscheme components should load first
  {
    "OXY2DEV/ui.nvim",
    enabled = false,
    lazy = false,
    config = function()
      require("ui").setup({
        popupmenu = {
          enable = true,

          winconfig = {},
          tooltip = nil,

          styles = {
            default = {
              padding_left = " ",
              padding_right = " ",

              icon = nil,
              text = nil,

              normal_hl = nil,
              select_hl = "CursorLine",
              icon_hl = nil,
            },

            example = {
              condition = function()
                return true
              end,

              icon = "I ",
            },
          },
        },

        cmdline = {
          enable = true,

          styles = {
            default = {
              cursor = "Cursor",
              filetype = "vim",

              icon = { { "I ", "@comment" } },
              offset = 0,

              title = nil,
              winhl = "",
            },

            example = {
              condition = function()
                return true
              end,

              cursor = "@comment",
            },
          },
        },

        message = {
          enable = true,
          wrap_notify = true,
          respect_replace_last = true,

          message_winconfig = {},
          list_winconfig = {},
          confirm_winconfig = {},
          history_winconfig = {},

          ignore = function()
            return false
          end,

          showcmd = {
            max_width = 10,
            modifier = nil,
          },

          msg_styles = {
            default = {
              duration = 500,

              modifier = nil,
              decorations = {
                icon = { { "I " } },
              },
            },

            example = {
              condition = function()
                return true
              end,

              decorations = {
                icon = { { "B " } },
              },
            },
          },

          is_list = function()
            return false
          end,

          list_styles = {
            default = {
              modifier = nil,

              row = nil,
              col = nil,

              width = nil,
              height = nil,

              winhl = nil,
            },

            example = {
              condition = function()
                return true
              end,

              border = "rounded",
            },
          },
          confirm_styles = {
            default = {
              modifier = nil,

              row = nil,
              col = nil,

              width = nil,
              height = nil,

              winhl = nil,
            },

            example = {
              condition = function()
                return true
              end,

              border = "rounded",
            },
          },
        },
      })
    end,
  },
  { "folke/noice.nvim", event = "VeryLazy", enabled = true },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          -- vim.print = _G.dd -- Override print to use snacks for `:=` command
          Snacks.toggle({
            name = "Mini Animate",
            get = function()
              return not vim.g.minianimate_disable
            end,
            set = function(state)
              vim.g.minianimate_disable = not state
            end,
          }):map("<leader>ua")

          -- -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>_s")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>_w")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>_L")
          Snacks.toggle.diagnostics():map("<leader>_d")
          Snacks.toggle.line_number():map("<leader>_l")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>_c")
          Snacks.toggle.treesitter():map("<leader>_T")
          Snacks.toggle
            .option("background", { off = "light", on = "dark", name = "Dark Background" })
            :map("<leader>_b")
          Snacks.toggle.inlay_hints():map("<leader>_h")
        end,
      })
    end,
  },
  {
    "rktjmp/lush.nvim",
    dependencies = { "Iron-E/nvim-highlite" },
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<Leader>cs",
        function()
          vim.api.nvim_exec_autocmds("User", { pattern = "ColorSchemeLoad" })
          require("telescope.builtin").colorscheme()
        end,
        noremap = true,
      },
    },
  },
  {
    "TaDaa/vimade",
    event = { "VimEnter" },
    enabled = true,
  },
  {
    "uhs-robert/sshfs.nvim",
    config = function()
      -- Refer to the configuration section below
      -- or leave empty for defaults
      local defaults = {
        connections = {
          ssh_configs = { -- Table of ssh config file locations to use
            "~/.ssh/config",
            "/etc/ssh/ssh_config",
          },
          -- SSHFS mount options (table of key-value pairs converted to sshfs -o arguments)
          -- Boolean flags: set to true to include, false/nil to omit
          -- String/number values: converted to key=value format
          sshfs_options = {
            reconnect = true, -- Auto-reconnect on connection loss
            ConnectTimeout = 5, -- Connection timeout in seconds
            compression = "yes", -- Enable compression
            ServerAliveInterval = 15, -- Keep-alive interval (15s × 3 = 45s timeout)
            ServerAliveCountMax = 3, -- Keep-alive message count
            dir_cache = "yes", -- Enable directory caching
            dcache_timeout = 300, -- Cache timeout in seconds
            dcache_max_size = 10000, -- Max cache size
            -- allow_other = true,        -- Allow other users to access mount
            -- uid = "1000,gid=1000",     -- Set file ownership (use string for complex values)
            -- follow_symlinks = true,    -- Follow symbolic links
          },
          control_persist = "10m", -- How long to keep ControlMaster connection alive after last use
          socket_dir = vim.fn.expand("$HOME/.ssh/sockets"), -- Directory for ControlMaster sockets
        },
        mounts = {
          base_dir = vim.fn.expand("$HOME") .. "/mnt", -- where remote mounts are created
        },
        global_paths = {
          -- Optionally define default mount paths for ALL hosts
          -- These appear as options when connecting to any host
          -- Examples:
          -- "~/.config",
          -- "/var/www",
          -- "/srv",
          -- "/opt",
          -- "/var/log",
          -- "/etc",
          -- "/tmp",
          -- "/usr/local",
          -- "/data",
          -- "/var/lib",
        },
        host_paths = {
          -- Optionally define default mount paths for specific hosts
          -- These are shown in addition to global_paths
          -- Single path (string):
          -- ["my-server"] = "/var/www/html"
          --
          -- Multiple paths (array):
          -- ["dev-server"] = { "/var/www", "~/projects", "/opt/app" }
        },
        hooks = {
          on_exit = {
            auto_unmount = true, -- auto-disconnect all mounts on :q or exit
            clean_mount_folders = true, -- optionally clean up mount folders after disconnect
          },
          on_mount = {
            auto_change_to_dir = false, -- auto-change current directory to mount point
            auto_run = "find", -- "find" (default), "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
          },
        },
        ui = {
          file_picker = {
            preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
            fallback_to_netrw = true, -- fallback to netrw if no picker is available
            netrw_command = "Explore", -- netrw command: "Explore", "Lexplore", "Sexplore", "Vexplore", "Texplore"
          },
          remote_picker = {
            preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "telescope", "mini"
          },
        },
        lead_prefix = "<leader>m", -- change keymap prefix (default: <leader>m)
        keymaps = {
          mount = "<leader>mm", -- creates an ssh connection and mounts via sshfs
          unmount = "<leader>mu", -- disconnects an ssh connection and unmounts via sshfs
          unmount_all = "<leader>mU", -- disconnects all ssh connections and unmounts via sshfs
          explore = "<leader>me", -- explore an sshfs mount using your native editor
          change_dir = "<leader>md", -- change dir to mount
          command = "<leader>mo", -- run command on mount
          config = "<leader>mc", -- edit ssh config
          reload = "<leader>mr", -- manually reload ssh config
          files = "<leader>mf", -- browse files using chosen picker
          grep = "<leader>mg", -- grep files using chosen picker
          terminal = "<leader>mt", -- open ssh terminal session
        },
      }
      require("sshfs").setup(defaults)
      -- 🔧 Commands
      -- :checkhealth sshfs - Verify dependencies and configuration
      -- :SSHConnect [host] - Mount a remote host
      -- :SSHDisconnect - Unmount current host
      -- :SSHDisconnectAll - Unmount all hosts
      -- :SSHConfig - Edit SSH config files
      -- :SSHReload - Reload SSH configuration
      -- :SSHFiles - Find files with auto-detected picker
      -- :SSHGrep [pattern] - Search files with auto-detected tool
      -- :SSHLiveFind [pattern] - Stream remote find/fd results over SSH (snacks/fzf-lua/telescope/mini)
      -- :SSHLiveGrep [pattern] - Stream remote rg/grep results over SSH (snacks/fzf-lua/telescope/mini)
      -- :SSHExplore - Open file browser on mount
      -- :SSHChangeDir - Change directory to mount (tcd)
      -- :SSHCommand [cmd] - Run custom command (e.g. Oil, Telescope)
      -- :SSHTerminal - Open terminal session (reuses auth)
      -- 🎹 Key Mapping
      -- Default keybindings under <leader>m (fully customizable):
      --
      -- Mapping	Description
      -- <leader>mm	Mount an SSH host
      -- <leader>mu	Unmount an active session
      -- <leader>mU	Unmount all active sessions
      -- <leader>me	Explore SSH mount via native edit
      -- <leader>md	Change dir to mount
      -- <leader>mo	Run command on mount
      -- <leader>mc	Edit SSH config
      -- <leader>mr	Reload SSH configuration
      -- <leader>mf	Find files
      -- <leader>mg	Grep files
      -- <leader>mF	Live find (remote)
      -- <leader>mG	Live grep (remote)
      -- <leader>mt	Open SSH terminal session
      -- If which-key.nvim is installed, the <leader>m group will be labeled with a custom icon (󰌘).
      --
      -- 🚀 Usage
      -- :SSHConnect — pick a host and mount path (home/root/custom/global_paths/host_paths).
      -- Work from the mount:
      -- :SSHFiles, :SSHGrep, or :SSHChangeDir
      -- Live remote search: :SSHLiveFind / :SSHLiveGrep (streams over SSH, still mounted)
      -- Terminals/commands: :SSHTerminal, :SSHCommand
      -- Disconnect with :SSHDisconnect (or let hooks.on_exit.auto_unmount handle it).
      -- Auth flow: keys first, then floating terminal for passphrases/passwords/2FA; ControlMaster keeps the session alive across operations.
      --
      -- 💡 Tips
      -- Use SSH keys for faster connections (no password prompts)
      -- Configure global_paths with common directories (/var/www, /var/log, ~/.config) to have them available across all hosts
      -- Configure host_paths for frequently-used hosts to skip path selection
      -- Set preferred_picker for local/remote pickers to force specific file picker(s) instead of auto-detection
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  },
  -- https://github.com/VonHeikemen/searchbox.nvim
  {
    "njhoffman/nvim-notify.nvim",
    name = "nvim-notify",
    dir = "~/git/nvim-notify",
    event = { "VeryLazy" },
    -- "rcarriga/nvim-notify",
    -- lazy = false,
  },
  { "famiu/bufdelete.nvim" },
  { "nvim-tree/nvim-web-devicons", dependencies = { "DaikyXendo/nvim-material-icon" } },
  {
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
  },
  { "b0o/incline.nvim", enabled = false, event = "VeryLazy" },
  {
    -- https://github.com/tamton-aquib/keys.nvim
    "njhoffman/what-key.nvim",
    dir = "~/git/what-key.nvim",
    -- name = "what-key",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  -- { 'freddiehaddad/feline.nvim', branch = 'main', event = 'VimEnter', lazy = false, },
}

utils.apply_configs(plugins)

return plugins
