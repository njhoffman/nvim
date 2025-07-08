local M = {}

local fs = require("devdocs2.fs")
local log = require("devdocs2.log")
local transpiler = require("devdocs2.transpiler")

local write_lockfile = function(alias, entry) end

local get_sections = function(docs, section_map)
  local doc_sections = {}

  for key, doc in pairs(docs) do
    -- log.debug(string.format("Converting %s (%s/%s)", key, count, total))

    local sections = section_map[key]
    local success, result, md_sections =
      xpcall(transpiler.html_to_md, debug.traceback, doc, sections)

    if not success then
      local message = string.format(
        'Failed to convert "%s", please report this issue\n\n%s\n\nOriginal html document:\n\n%s',
        key,
        result,
        doc
      )
      log.error(message)
      return
    end
    table.insert(doc_sections, { key = key, result = result, md_sections = md_sections, doc = doc })
  end
  return doc_sections
end

local sort_docs = function(doc_sections, doc_dir)
  -- The entries need to be sorted in order to make spliting work
  local path_map = {}
  local sorted = {}

  local doc_files = {}
  local last_index = 1
  local count = 1

  for _, doc_section in ipairs(doc_sections) do
    local key = doc_section.key
    for _, md_section in ipairs(doc_section.md_sections) do
      path_map[key .. "#" .. md_section.id] = count .. "," .. md_section.md_path
      sorted[key .. "#" .. md_section.id] = last_index
      last_index = last_index + 1
    end

    -- Use number as filename instead of the entry name to avoid invalid filenames
    path_map[key] = tostring(count)

    local file_path = doc_dir:joinpath(tostring(count) .. ".md")
    doc_files[count] = { file_path = file_path, key = key, result = doc_section.result }
    count = count + 1
  end
  return doc_files, path_map, sorted
end

M.init_docs = function(alias, doc_index)
  local doc_dir = DOCS_DIR:joinpath(alias)

  if not DOCS_DIR:exists() then
    DOCS_DIR:mkdir()
  end
  if not doc_dir:exists() then
    doc_dir:mkdir()
  end

  local section_map = {}
  for _, index_entry in pairs(doc_index.entries) do
    local splited = vim.split(index_entry.path, "#")
    local main = splited[1]
    local id = splited[2]

    if not section_map[main] then
      section_map[main] = {}
    end
    if id then
      table.insert(section_map[main], id)
    end
  end

  return doc_dir, section_map
end

M.build_docs = function(doc_dir, doc_index, docs, section_map)
  local doc_sections = get_sections(docs, section_map)
  local doc_files, path_map, sorted = sort_docs(doc_sections, doc_dir)

  table.sort(doc_index.entries, function(a, b)
    local index_a = sorted[a.path] or -1
    local index_b = sorted[b.path] or -1
    return index_a < index_b
  end)

  log.debug("Filling docs links and path")
  for i, index_entry in ipairs(doc_index.entries) do
    local main = vim.split(index_entry.path, "#")[1]
    doc_index.entries[i].link = doc_index.entries[i].path
    doc_index.entries[i].path = path_map[index_entry.path] or path_map[main]
  end

  return doc_files
end

M.write_docs = function(alias, entry, doc_index, doc_files)
  local lockfile = fs.read_lockfile() or {}
  local index = fs.read_index() or {}

  lockfile[alias] = entry
  log.info("Writing lockfile: " .. alias .. "")
  fs.write_lockfile(lockfile)

  index[alias] = doc_index
  log.info("Writing " .. entry.slug .. " documentation index...")
  fs.write_index(index)

  for _, doc_file in pairs(doc_files) do
    local file_path = doc_file.file_path
    local result = doc_file.result
    log.debug(file_path .. " has been writen")
    file_path:write(result, "w")
  end
end

-- ---@param docs table<string, string>
-- M.build_docs = function(docs, path_map, section_map, sorted)
--   --- Used for extracting the markdown headers that will be used as breakpoints when spliting the docs

--   log.info("Build complete!")
-- end

return M
