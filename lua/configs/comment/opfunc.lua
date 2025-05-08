local U = require("Comment.utils")
local Config = require("Comment.config")
local A = vim.api

local patch = function(Op)
  ---Common operatorfunc callback
  ---This function contains the core logic for comment/uncomment
  ---@param motion? OpMotion
  ---If given 'nil', it'll only (un)comment
  ---the current line
  ---@param cfg CommentConfig
  ---@param cmode integer See |comment.utils.cmode|
  ---@param ctype integer See |comment.utils.ctype|
  Op.opfunc = function(motion, cfg, cmode, ctype)
    local range = U.get_region(motion)
    local cmotion = motion == nil and U.cmotion.line or U.cmotion[motion]

    -- If we are doing char or visual motion on the same line
    -- then we would probably want block comment instead of line comment
    local is_partial = cmotion == U.cmotion.char or cmotion == U.cmotion.v
    local is_blockx = is_partial and range.srow == range.erow

    local lines = U.get_lines(range)

    -- sometimes there might be a case when there are no lines
    -- like, executing a text object returns nothing
    if U.is_empty(lines) then
      return
    end

    ---@type CommentCtx
    local ctx = {
      cmode = cmode,
      cmotion = cmotion,
      -- ctype = is_blockx and U.ctype.blockwise or ctype,
      ctype = ctype,
      range = range,
    }

    local lcs, rcs = U.parse_cstr(cfg, ctx)

    ---@type OpFnParams
    local params = {
      cfg = cfg,
      lines = lines,
      lcs = lcs,
      rcs = rcs,
      cmode = cmode,
      range = range,
    }

    -- if motion ~= nil and (is_blockx or ctype == U.ctype.blockwise) then
    if motion ~= nil and ctype == U.ctype.blockwise then
      ctx.cmode = Op.blockwise(params, is_partial)
    else
      ctx.cmode = Op.linewise(params)
    end

    -- We only need to restore cursor if both sticky and position are available
    -- As this function is also called for visual mapping where we are not storing the position
    --
    -- And I found out that if someone presses `gc` but doesn't provide operators and
    -- does visual comments then cursor jumps to previous stored position. Thus the check for visual modes
    if cfg.sticky and Config.position and cmotion ~= U.cmotion.v and cmotion ~= U.cmotion.V then
      A.nvim_win_set_cursor(0, Config.position)
      Config.position = nil
    end

    U.is_fn(cfg.post_hook, ctx)
  end
end
return { patch = patch }
