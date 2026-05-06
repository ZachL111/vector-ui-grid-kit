package.path = "src/?.lua;" .. package.path
local review = require("domain_review")

local item = { signal = 55, slack = 44, drag = 14, confidence = 72 }
assert(review.score(item) == 184)
assert(review.lane(item) == "ship")
