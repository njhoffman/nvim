return {
  ["Improve Copy"] = {
    strategy = "inline",
    description = "Improves the copy of the page",
    -- opts = {
    --   mapping = '<LocalLeader>ch',
    -- },
    prompts = {
      {
        role = "system",
        content = [[You are an experienced developer, designer and creator. Your build useful products that people love to use. Your task is to improve the copy of the content to bring more clarity and improve conversions.]],
      },
      {
        role = "user",
        content = "#buffer\n\nPlease improve the copy of the page.",
      },
    },
  },
  ["Review the code"] = {
    strategy = "inline",
    description = "Review the code in buffer",
    -- opts = {
    --   mapping = '<LocalLeader>ch',
    -- },
    prompts = {
      {
        role = "system",
        content = [[You are an experienced senior developer. You do code reviews.]],
      },
      {
        role = "user",
        content = "#buffer\n\nPlease review the code in the file and make the fixes if any.",
      },
    },
  },
  ["Test workflow"] = {
    strategy = "workflow",
    description = "Use a workflow to test the plugin",
    opts = {
      index = 4,
    },
    prompts = {
      {
        {
          role = "user",
          content = "Generate a Python class for managing a book library with methods for adding, removing, and searching books",
          opts = {
            auto_submit = false,
          },
        },
      },
      {
        {
          role = "user",
          content = "Write unit tests for the library class you just created",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Create a TypeScript interface for a complex e-commerce shopping cart system",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Write a recursive algorithm to balance a binary search tree in Java",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Generate a comprehensive regex pattern to validate email addresses with explanations",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Create a Rust struct and implementation for a thread-safe message queue",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Write a GitHub Actions workflow file for CI/CD with multiple stages",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Create SQL queries for a complex database schema with joins across 4 tables",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Write a Lua configuration for Neovim with custom keybindings and plugins",
          opts = {
            auto_submit = true,
          },
        },
      },
      {
        {
          role = "user",
          content = "Generate documentation in JSDoc format for a complex JavaScript API client",
          opts = {
            auto_submit = true,
          },
        },
      },
    },
  },
}
