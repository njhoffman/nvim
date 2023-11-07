local opts = {
  grace_period = 60 * 15,
  excluded_filetypes = { 'java', 'markdown' },
  stop_invisible = false,
  notifications = true,
}

require('garbage-day').setup(opts)
