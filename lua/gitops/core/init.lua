-- stylua: ignore
return {
  -- files    = require('gitops.core.files').files,
  -- stash    = require('gitops.core.stash').stash,
  -- status   = require('gitops.core.status').status,
  commits  = require('gitops.core.commits').commits,
  commits_stats  = require('gitops.core.commits').commits_stats,
  bcommits = require('gitops.core.bcommits').bcommits,
  -- branches = require('gitops.core.branches').branches,
}
