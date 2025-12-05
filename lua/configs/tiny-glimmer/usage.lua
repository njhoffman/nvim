local usage_examples = function(glimmer)
  vim.keymap.set("n", "<leader>agt", function()
    glimmer.cursor_line("typewriter")
  end, { desc = "Animate cursor line with typewriter effect" })

  vim.keymap.set("n", "<leader>agf", function()
    glimmer.cursor_line("fire")
  end, { desc = "Animate cursor line with fire effect" })

  vim.keymap.set("v", "<leader>agn", function()
    glimmer.visual_selection("neon_glow")
  end, { desc = "Animate selection with neon glow" })

  -- Override registered effect settings at runtime
  -- Pass table with name and settings to customize behavior
  vim.keymap.set("n", "<leader>agc", function()
    glimmer.cursor_line({
      name = "neon_glow",
      settings = {
        base_color = "#FF00FF",
        intensity = 2.0,
        max_duration = 500,
      },
    })
  end, { desc = "Custom neon glow with purple color" })

  -- Alternative syntax: pass settings as second argument
  vim.keymap.set("n", "<leader>agc2", function()
    glimmer.cursor_line("neon_glow", {
      base_color = "#0000FF",
      intensity = 3.0,
    })
  end, { desc = "Another way to override settings" })

  -- Use custom effects in autocmds
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("CustomFireYank", { clear = true }),
    callback = function()
      local range = glimmer.get_yank_range()
      if range then
        glimmer.animate_range("fire", range)
      end
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = vim.api.nvim_create_augroup("CustomTypewriter", { clear = true }),
    callback = function()
      glimmer.cursor_line("typewriter")
    end,
  })

  -- Named animations with custom effects for manual control
  vim.keymap.set("n", "<leader>ans", function()
    local line = vim.fn.line(".")
    local range = {
      start_line = line - 1,
      start_col = 0,
      end_line = line,
      end_col = 0,
    }
    glimmer.named_animate_range("my_custom_anim", "neon_glow", range)
  end, { desc = "Start named neon glow animation" })

  vim.keymap.set("n", "<leader>anx", function()
    glimmer.stop_animation("my_custom_anim")
  end, { desc = "Stop named animation" })

  -- Advanced Usage Examples
  -- Complex animation scenarios using helper functions

  local glimmer = require("tiny-glimmer.lib")

  -- Animate multiple ranges simultaneously
  -- Creates animations for current line and 2 lines above/below
  vim.keymap.set("n", "<leader>amr", function()
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    for offset = -2, 2 do
      local line = current_line + offset
      local range = {
        start_line = line - 1,
        start_col = 0,
        end_line = line,
        end_col = 0,
      }
      glimmer.animate_range("fade", range)
    end
  end, { desc = "Animate multiple ranges" })

  -- Search and highlight all matches of word under cursor
  -- Iterates through buffer finding all occurrences
  vim.keymap.set("n", "<leader>ash", function()
    local word = vim.fn.expand("<cword>")
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for line_num, line_text in ipairs(lines) do
      local start_col = 1
      while true do
        local match_start, match_end = string.find(line_text, word, start_col, true)
        if not match_start then
          break
        end
        local range = {
          start_line = line_num - 1,
          start_col = match_start - 1,
          end_line = line_num - 1,
          end_col = match_end,
        }
        glimmer.animate_range("pulse", range)
        start_col = match_end + 1
      end
    end
  end, { desc = "Highlight all word matches" })

  -- Progress indicator based on line length percentage
  -- Animates portion of current line corresponding to progress
  local function animate_progress(percent)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local line_content = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1] or ""
    local total_length = #line_content
    local progress_length = math.floor(total_length * percent / 100)
    if progress_length > 0 then
      local range = {
        start_line = line - 1,
        start_col = 0,
        end_line = line - 1,
        end_col = progress_length,
      }
      glimmer.animate_range("fade", range)
    end
  end

  vim.keymap.set("n", "<leader>ap1", function()
    animate_progress(25)
  end, { desc = "Show 25% progress" })
  vim.keymap.set("n", "<leader>ap2", function()
    animate_progress(50)
  end, { desc = "Show 50% progress" })
  vim.keymap.set("n", "<leader>ap3", function()
    animate_progress(75)
  end, { desc = "Show 75% progress" })
  vim.keymap.set("n", "<leader>ap4", function()
    animate_progress(100)
  end, { desc = "Show 100% progress" })

  -- Diff-style highlighting for added/changed/deleted lines
  vim.keymap.set("n", "<leader>ada", function()
    glimmer.cursor_line("fade")
  end, { desc = "Highlight as added" })

  vim.keymap.set("n", "<leader>adc", function()
    glimmer.cursor_line("fade")
  end, { desc = "Highlight as changed" })

  vim.keymap.set("n", "<leader>add", function()
    glimmer.cursor_line("fade")
  end, { desc = "Highlight as deleted" })

  -- Example 1: Infinite loop animation on current line
  -- Animation will loop forever until stopped manually
  vim.keymap.set("n", "<leader>li", function()
    glimmer.named_animate_range("infinite_pulse", "pulse", glimmer.get_line_range(0), {
      loop = true,
      loop_count = 0, -- 0 = infinite
    })
  end)

  -- Stop the infinite animation
  vim.keymap.set("n", "<leader>ls", function()
    glimmer.stop_animation("infinite_pulse")
  end)

  -- Example 2: Loop animation 3 times on cursor line
  vim.keymap.set("n", "<leader>l3", function()
    glimmer.cursor_line("bounce", {
      loop = true,
      loop_count = 3,
    })
  end)

  -- Example 3: Loop animation 5 times on visual selection
  vim.keymap.set("v", "<leader>l5", function()
    glimmer.visual_selection("fade", {
      loop = true,
      loop_count = 5,
    })
  end)

  -- Example 4: Create an infinite rainbow effect that can be stopped
  vim.keymap.set("n", "<leader>lr", function()
    glimmer.named_animate_range("rainbow_loop", "rainbow", glimmer.get_line_range(0), {
      loop = true,
      loop_count = 0,
    })
  end)

  -- Example 5: Create multiple looping animations on different lines
  vim.keymap.set("n", "<leader>lm", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]

    -- First line loops 2 times
    glimmer.animate_range("pulse", glimmer.get_line_range(line), {
      loop = true,
      loop_count = 2,
    })

    -- Second line loops 3 times
    glimmer.animate_range("pulse", glimmer.get_line_range(line + 1), {
      loop = true,
      loop_count = 3,
    })

    -- Third line loops 4 times
    glimmer.animate_range("pulse", glimmer.get_line_range(line + 2), {
      loop = true,
      loop_count = 4,
    })
  end)

  -- Example 6: Use loop with create_animation for precise control
  vim.keymap.set("n", "<leader>lc", function()
    glimmer.create_animation({
      range = glimmer.get_line_range(0),
      duration = 500,
      from_color = "#ff0000",
      to_color = "#00ff00",
      effect = "fade",
      easing = "inOutQuad",
      loop = true,
      loop_count = 2,
      on_complete = function()
        print("Loop animation completed!")
      end,
    })
  end)

  -- Example 7: Create a pulsing search highlight effect
  vim.keymap.set("n", "<leader>lh", function()
    local word = vim.fn.expand("<cword>")
    local matches = {}

    -- Find all occurrences of word in current buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for i, line in ipairs(lines) do
      local col = 1
      while true do
        local start, finish = string.find(line, word, col, true)
        if not start then
          break
        end
        table.insert(matches, {
          start_line = i - 1,
          start_col = start - 1,
          end_line = i - 1,
          end_col = finish,
        })
        col = finish + 1
      end
    end

    -- Animate each match with infinite loop
    for idx, range in ipairs(matches) do
      glimmer.named_animate_range("search_" .. idx, "pulse", range, {
        loop = true,
        loop_count = 0, -- infinite
      })
    end
  end)

  -- Stop all search highlights
  vim.keymap.set("n", "<leader>lH", function()
    for i = 1, 100 do
      glimmer.stop_animation("search_" .. i)
    end
  end)
end
