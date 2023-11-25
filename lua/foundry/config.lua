local M = {}


local defaults = {

    chisel = {
        open_direction = "float",
        load_direction = "float",
        view_direction = "float",
    },

    anvil = {
        config_file_name = "anvil_conf.json",   -- file where to output anvil config when spawned 
        accounts = 10,                          -- number of accounts to generate and configure
        balance = 10000,                        -- balance of every account
        host = "127.0.0.1",
        port = "8545",
        tracing = true,
        timeout = 45000,                        -- timeout in ms for request to sent remote JSON-RPC
    }

}
M.values = {}



setmetatable(M,{
    __index = function(tbl, k)
        return M.values[k]
    end
})

M.setup = function(opts)
    M.values = vim.tbl_deep_extend("force",defaults,opts)
    -- M = vim.tbl_deep_extend("force",defaults,opts)
end


return M
