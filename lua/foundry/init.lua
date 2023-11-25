local config = require("foundry.config")
local anvil = require("foundry.anvil")
local chisel = require("foundry.chisel")


local M = {}


M.setup = function(opts)
    config.setup(opts or {})
end

M.anvil = anvil
M.chisel = chisel


return M
