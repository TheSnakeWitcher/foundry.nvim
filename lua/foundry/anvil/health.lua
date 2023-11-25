local util = require("foundry.util")

local M = {}

M.check = function()
    vim.health.report_start("anvil report")
    util.check_executable("anvil")
    util.check_executable("pgrep")
end

return M
