-- project_nvim reads its history when asked, even before the startup read has finished.
describe("project_nvim history", function()
  local history = require("project_nvim.utils.history")
  local path = require("project_nvim.utils.path")
  local state = require("project_nvim.state")
  local old_historyfile, tmp, project_dir

  before_each(function()
    require("project_nvim.config").init({})
    old_historyfile = path.historyfile
    tmp = vim.fn.tempname()
    vim.fn.mkdir(tmp, "p")
    project_dir = tmp .. "/project"
    vim.fn.mkdir(project_dir, "p")
    path.historyfile = tmp .. "/project_history"
    state.recent_projects = nil
    state.session_projects = {}
    state.projects_meta = {}
  end)

  after_each(function()
    path.historyfile = old_historyfile
    state.recent_projects = nil
    vim.fn.delete(tmp, "rf")
  end)

  it("loads projects when the startup read has not finished", function()
    vim.fn.writefile({ project_dir .. "|num=3,method=pattern" }, path.historyfile)

    local projects, meta = history.get_recent_projects()

    assert.are.same({ project_dir }, projects)
    assert.are.equal("3", meta[project_dir].num)
  end)

  it("returns nothing when there is no history file yet", function()
    assert.are.same({}, (history.get_recent_projects()))
  end)

  it("keeps what is already loaded without reading again", function()
    vim.fn.writefile({ project_dir }, path.historyfile)
    state.recent_projects = {}

    assert.are.same({}, (history.get_recent_projects()))
  end)
end)
