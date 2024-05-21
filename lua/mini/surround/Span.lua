-- NOTE: spans are end-exclusive to allow empty spans via `from == to`

--stylua: ignore

local is_point_inside_spans = function(point, spans)
  for _, span in ipairs(spans) do
    if span[1] <= point and point <= span[2] then
      return true
    end
  end
  return false
end

local Span = {}

Span.new = function(from, to)
  return { from = from, to = to == nil and from or (to + 1) }
end

Span.span_distance = {
  -- Other possible choices of distance between [a1, a2] and [b1, b2]:
  -- - Hausdorff distance: max(|a1 - b1|, |a2 - b2|).
  --   Source:
  --   https://math.stackexchange.com/questions/41269/distance-between-two-ranges
  -- - Minimum distance: min(|a1 - b1|, |a2 - b2|).

  -- Distance is chosen so that "next span" in certain direction is the closest
  next = function(span_1, span_2)
    return math.abs(span_1.from - span_2.from)
  end,
  prev = function(span_1, span_2)
    return math.abs(span_1.to - span_2.to)
  end,
  near = function(span_1, span_2)
    return math.min(math.abs(span_1.from - span_2.from), math.abs(span_1.to - span_2.to))
  end,
}

Span.is_better_covering_span = function(candidate, current, reference)
  local candidate_is_covering = Span.is_span_covering(candidate, reference)
  local current_is_covering = Span.is_span_covering(current, reference)

  if candidate_is_covering and current_is_covering then
    -- Covering candidate is better than covering current if it is narrower
    return (candidate.to - candidate.from) < (current.to - current.from)
  end
  if candidate_is_covering and not current_is_covering then
    return true
  end
  if not candidate_is_covering and current_is_covering then
    return false
  end

  -- Return `nil` if neither span is covering
  return nil
end

Span.is_span_equal = function(span_1, span_2)
  if span_1 == nil or span_2 == nil then
    return false
  end
  return (span_1.from == span_2.from) and (span_1.to == span_2.to)
end

Span.is_span_on_left = function(span_1, span_2)
  if span_1 == nil or span_2 == nil then
    return false
  end
  return (span_1.from <= span_2.from) and (span_1.to <= span_2.to)
end

Span.is_span_covering = function(span, span_to_cover)
  if span == nil or span_to_cover == nil then
    return false
  end
  if span.from == span.to then
    return (span.from == span_to_cover.from) and (span_to_cover.to == span.to)
  end
  if span_to_cover.from == span_to_cover.to then
    return (span.from <= span_to_cover.from) and (span_to_cover.to < span.to)
  end

  return (span.from <= span_to_cover.from) and (span_to_cover.to <= span.to)
end
Span.span_compare_methods = {
  cover = function(candidate, current, reference)
    local res = Span.is_better_covering_span(candidate, current, reference)
    if res ~= nil then
      return res
    end
    -- If both are not covering, `candidate` is not better (as it must cover)
    return false
  end,

  cover_or_next = function(candidate, current, reference)
    local res = Span.is_better_covering_span(candidate, current, reference)
    if res ~= nil then
      return res
    end

    -- If not covering, `candidate` must be "next" and closer to reference
    if not Span.is_span_on_left(reference, candidate) then
      return false
    end
    if current == nil then
      return true
    end

    local dist = Span.span_distance.next
    return dist(candidate, reference) < dist(current, reference)
  end,

  cover_or_prev = function(candidate, current, reference)
    local res = Span.is_better_covering_span(candidate, current, reference)
    if res ~= nil then
      return res
    end

    -- If not covering, `candidate` must be "previous" and closer to reference
    if not Span.is_span_on_left(candidate, reference) then
      return false
    end
    if current == nil then
      return true
    end

    local dist = Span.span_distance.prev
    return dist(candidate, reference) < dist(current, reference)
  end,

  cover_or_nearest = function(candidate, current, reference)
    local res = Span.is_better_covering_span(candidate, current, reference)
    if res ~= nil then
      return res
    end

    -- If not covering, `candidate` must be closer to reference
    if current == nil then
      return true
    end

    local dist = Span.span_distance.near
    return dist(candidate, reference) < dist(current, reference)
  end,

  next = function(candidate, current, reference)
    if Span.is_span_covering(candidate, reference) then
      return false
    end

    -- `candidate` must be "next" and closer to reference
    if not Span.is_span_on_left(reference, candidate) then
      return false
    end
    if current == nil then
      return true
    end

    local dist = Span.span_distance.next
    return dist(candidate, reference) < dist(current, reference)
  end,

  prev = function(candidate, current, reference)
    if Span.is_span_covering(candidate, reference) then
      return false
    end

    -- `candidate` must be "previous" and closer to reference
    if not Span.is_span_on_left(candidate, reference) then
      return false
    end
    if current == nil then
      return true
    end

    local dist = Span.span_distance.prev
    return dist(candidate, reference) < dist(current, reference)
  end,

  nearest = function(candidate, current, reference)
    if Span.is_span_covering(candidate, reference) then
      return false
    end

    -- `candidate` must be closer to reference
    if current == nil then
      return true
    end

    local dist = Span.span_distance.near
    return dist(candidate, reference) < dist(current, reference)
  end,
}

---@param candidate table Candidate span to test against `current`.
---@param current table|nil Current best span.
---@param reference table Reference span to cover.
---@param opts table Fields: <search_method>.
---@private
Span.is_better_span = function(candidate, current, reference, opts)
  -- Candidate should be never equal or nested inside reference
  if Span.is_span_covering(reference, candidate) or Span.is_span_equal(candidate, reference) then
    return false
  end

  return Span.span_compare_methods[opts.search_method](candidate, current, reference)
end

return Span
