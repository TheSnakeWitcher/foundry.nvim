local Path = require("plenary.path")
local Job = require("plenary.job")

local util = require("foundry.util")
local config = require("foundry.config").anvil


local M = {
    state = {},
    is_running = false,
}


--- @param opts table
function M.start(opts)
    vim.api.nvim_exec_autocmds("User", { pattern = "AnvilStartPre" })

    local args_tbl = {
        "--config-out",config.config_file_name,
        "--host",config.host,
        "--port",config.port,
        "--accounts",config.accounts,
        "--balance",config.balance,
    }
    args_tbl = util.insert_not_nil_opts(opts,args_tbl)

    Job:new({ command = "anvil", args = args_tbl }):start()
    M.is_running = true
    vim.notify("anvil started")

    vim.api.nvim_exec_autocmds("User",{
        pattern = "AnvilStartPost",
        data = { options = args_tbl }
    })
end

--- @return string|nil anvil_pid
local function get_pid()
    if not M.is_running then return nil end
    return vim.fn.systemlist({"pgrep","anvil"})[1]
end

--- Stop a running anvil instance
function M.stop()
    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStopPre"})

    local anvil_pid = get_pid()
    if not anvil_pid then return end

    Job:new({ command = "kill", args = { anvil_pid } }):start()
    M.is_running = false

    vim.api.nvim_exec_autocmds("User",{pattern = "AnvilStopPost"})
end


--- Get state of a current running anvil instance
local function get_state()
    if not M.is_running then return nil end
    local file_content = Path:new(config.config_file_name):read()
    M.state = vim.json.decode(file_content)
end

--- Check if there is a running anvil instance
local function check_state()
    if not vim.tbl_isempty(M.state) then
        return true
    end

    get_state()

    if vim.tbl_isempty(M.state) then
        return false
    else
        return true
    end
end

--- Get accounts addresses of a running anvil isntance
--- @param index number
function M.get_accounts(index)
    if not check_state() then return nil end
    if not index then
        return M.state.available_accounts
    else
        return M.state.available_accounts[index]
    end
end


--- Get index of an account addresses of a running anvil isntance
--- @param account_address string
--- @return number|nil account_index
local function get_account_index(account_address)
    if not account_address then return nil end

    if type(account_address) == "number" then
        return account_address
    end

    for index,account in ipairs(M.state.accounts) do
        if account == account_address then
            return index
        end
    end

    return nil
end

--- Get private key of an account addresses of a running anvil isntance
--- @param account string
--- @return string|nil account_key
function M.get_private_key(account)
    local index = get_account_index(account)

    if index then
        return M.state.private_keys[index]
    else
        return nil
    end
end

return M
