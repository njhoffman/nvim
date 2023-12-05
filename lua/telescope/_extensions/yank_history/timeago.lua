local language_long = {
  justnow = 'just now',
  second = { singular = 'a second ago', plural = 'seconds ago' },
  minute = { singular = 'a minute ago', plural = 'minutes ago' },
  hour = { singular = 'an hour ago', plural = 'hours ago' },
  day = { singular = 'a day ago', plural = 'days ago' },
  week = { singular = 'a week ago', plural = 'weeks ago' },
  month = { singular = 'a month ago', plural = 'months ago' },
  year = { singular = 'a year ago', plural = 'years ago' },
}

local language_medium = {
  justnow = 'now',
  second = { singular = 'a sec ago', plural = 'secs ago' },
  minute = { singular = 'a min ago', plural = 'mins ago' },
  hour = { singular = 'an hr ago', plural = 'hrs ago' },
  day = { singular = 'a day ago', plural = 'days ago' },
  week = { singular = 'a wk ago', plural = 'wks ago' },
  month = { singular = 'a mon ago', plural = 'mons ago' },
  year = { singular = 'a yr ago', plural = 'yrs ago' },
}

local language_short = {
  justnow = 'now',
  second = { singular = 'a s ago', plural = 's ago' },
  minute = { singular = 'a m ago', plural = 'm ago' },
  hour = { singular = 'an h ago', plural = 'h ago' },
  day = { singular = 'a d ago', plural = 'd ago' },
  week = { singular = 'a w ago', plural = 'w ago' },
  month = { singular = 'a M ago', plural = 'M ago' },
  year = { singular = 'a y ago', plural = 'y ago' },
}

local default_options = {
  language = language_medium,
  include_prefix = false,
  include_suffix = false,
}

local round = function(x, n)
  n = math.pow(10, n or 0)
  x = x * n
  if x >= 0 then
    x = math.floor(x + 0.5)
  else
    x = math.ceil(x - 0.5)
  end
  return x / n
end

local function parse_diff(time, unit, opts)
  if time == 1 then
    return opts.language[unit].singular
  else
    return time .. ' ' .. opts.language[unit].plural
  end
end

local function timeago(time, options)
  local opts = vim.tbl_extend('force', default_options, options or {})

  local now = os.time()
  local diff_seconds = os.difftime(now, time)
  if diff_seconds < 45 then
    return opts.language.justnow
  end

  local diff_minutes = diff_seconds / 60
  if diff_minutes < 1.5 then
    return parse_diff(1, 'minute', opts)
  end

  if diff_minutes < 59.5 then
    return parse_diff(round(diff_minutes), 'minute', opts)
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 1.5 then
    return opts.language.hour.singular
  end
  if diff_hours < 23.5 then
    return round(diff_hours) .. ' ' .. opts.language.hour.plural
  end

  local diff_days = diff_hours / 24
  if diff_days < 1.5 then
    return opts.language.day.singular
  end
  if diff_days < 7.5 then
    return round(diff_days) .. ' ' .. opts.language.day.plural
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 1.5 then
    return opts.language.week.singular
  end
  if diff_weeks < 4.5 then
    return round(diff_weeks) .. ' ' .. opts.language.week.plural
  end

  local diff_months = diff_days / 30
  if diff_months < 1.5 then
    return opts.language.month.singular
  end
  if diff_months < 11.5 then
    return round(diff_months) .. ' ' .. opts.language.month.plural
  end

  local diff_years = diff_days / 365.25
  if diff_years < 1.5 then
    return opts.language.year.singular
  end
  return round(diff_years) .. ' ' .. opts.language.year.plural
end

return timeago
