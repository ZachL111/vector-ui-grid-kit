package.path = "src/?.lua;" .. package.path
local policy = require("policy")

local signal_case_1 = { demand = 74, capacity = 75, latency = 11, risk = 5, weight = 10 }
assert(policy.score(signal_case_1) == 189)
assert(policy.classify(signal_case_1) == "accept")
local signal_case_2 = { demand = 90, capacity = 82, latency = 9, risk = 5, weight = 12 }
assert(policy.score(signal_case_2) == 244)
assert(policy.classify(signal_case_2) == "accept")
local signal_case_3 = { demand = 101, capacity = 100, latency = 27, risk = 19, weight = 13 }
assert(policy.score(signal_case_3) == 132)
assert(policy.classify(signal_case_3) == "review")
