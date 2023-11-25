local Terminal = require("toggleterm.terminal").Terminal
local Job = require("plenary.job")
local config = require("foundry.config").chisel


local M = {}


-- launch chisel REPL
function M.open()
    Terminal:new({
        cmd = "chisel" ,
        direction = config.open_direction,
        close_on_exit = true,
    }):toggle()
end

-- launches the REPL and loads the cached session with {id} in case it exists
function M.load(id)
    Terminal:new({
        cmd = "chisel load " .. id ,
        direction = config.load_direction,
        close_on_exit = false,
    }):toggle()
end

-- list cached sessions stored in ~/.foundry/cache/chisel
function M.list()
    local results = {}

    Job:new({
        command = "chisel" ,
        args = {"list"},
        on_exit = function(job,_)
            local sessions = {}
            local dates = {}

            for _,output in ipairs(job:result()) do
                local data = vim.split(output,"- ")
                local date = data[1]
                local session = data[2]

                table.insert(dates,date)
                table.insert(sessions,session)
            end

            for idx,session in ipairs(sessions) do
                local text , extension =  "chisel" , ".json"
                local extension_starts,_ = string.find(session,extension)
                local _,text_ends = string.find(session,text)
                local id = string.sub(session,text_ends+2,extension_starts-1)

                table.insert(results,{
                    date = dates[idx],
                    id=id
                })
            end

        end
    }):sync()

    return results
end

-- displays the source code of the sessions's REPL contract with {id} in case it exists
function M.view(id)
    Terminal:new({
        cmd = "chisel view " .. id ,
        direction = config.view_direction,
        close_on_exit = false ,
    }):toggle()
end

-- deletes all cache sessions within ~/.foundry/cache/chisel directory.
-- NOTE: These sessions are unrecoverable, so use this function with care.
function M.clear_cache()
    Job:new({
        command = "chisel" ,
        args = {"clear-cache"},
        on_exit = vim.notify("chisel cached cleaned")
    }):start()
end


return M
