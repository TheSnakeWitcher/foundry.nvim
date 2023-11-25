local M = {}

M.check = function()
    vim.health.report_start("foundry.nvim report")
    require("foundry.anvil.health").check()
    require("foundry.chisel.health").check()
end

return M
