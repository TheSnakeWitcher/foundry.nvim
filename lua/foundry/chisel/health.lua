local util = require("foundry.util")

local M = {}

M.check = function()
    vim.health.report_start("chisel report")
    util.check_executable("chisel")
end

return M
