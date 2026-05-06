local review = {}

function review.score(item)
  return item.signal * 2 + item.slack + item.confidence - item.drag * 3
end

function review.lane(item)
  local value = review.score(item)
  if value >= 140 then return "ship" end
  if value >= 105 then return "watch" end
  return "hold"
end

return review
