-- Parses and compares tmux versions.

local M = {}
function M.new(value)
    return require("modules.tmux.version.parse").from(value)
end

function M.compare(base, relative)
    return require("modules.tmux.version.compare").with(base, relative)
end

return M
