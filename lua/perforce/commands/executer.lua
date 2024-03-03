local M = {}
local status, notify = pcall(require, 'notify')
if (status) then
    vim.notify = notify
end


function M.make_writable(file)
    local has = vim.fn.has
    local is_win = has "win32"
    local is_linux = has "linux"

    if 0 ~= is_win then
        local command = ""
        M.execute(command)
    elseif 0 ~= is_linux then
        local command = "chmod +w " .. file
        M.execute(command)
    else
        print("Uknown system!")
    end
    vim.notify('Make file ' .. file .. ' writable!')
end

function M.show_result(command)
    vim.notify(M.execute(command))
end

function M.execute(command)
    local result = vim.fn.system(command)
    return result
end

return M
