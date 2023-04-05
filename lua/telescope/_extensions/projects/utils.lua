local function time_ago(time)
  local function round(num)
    return math.floor(num + 0.5)
  end

  local now = os.time()
  local diff_seconds = os.difftime(now, time)

  if diff_seconds < 90 then
    return round(diff_seconds) .. " secs"
  end
  local diff_minutes = diff_seconds / 60
  if diff_minutes < 59.5 then
    return round(diff_minutes) .. " mins"
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 23.5 then
    return round(diff_hours) .. " hours"
  end

  local diff_days = diff_hours / 24
  if diff_days < 7.5 then
    return round(diff_days) .. " days"
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 4.5 then
    return round(diff_weeks) .. " weeks"
  end

  local diff_months = diff_days / 30
  if diff_months < 11.5 then
    return round(diff_months) .. " months"
  end

  local diff_years = diff_days / 365.25
  return round(diff_years) .. " years"
end

return {
  time_ago = time_ago,
}
