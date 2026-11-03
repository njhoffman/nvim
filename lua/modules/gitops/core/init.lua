-- stylua: ignore
return {
  files          = require('modules.gitops.core.files').files,
  stash          = require('modules.gitops.core.stash').stash,
  status         = require('modules.gitops.core.status').status,
  commits        = require('modules.gitops.core.commits').commits,
  commits_stats  = require('modules.gitops.core.commits').stats,
  bcommits       = require('modules.gitops.core.bcommits').bcommits,
  bcommits_stats = require('modules.gitops.core.bcommits').stats,
  branches       = require('modules.gitops.core.branches').branches,
}
