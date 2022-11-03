local M = {}
local status, notify = pcall(require, 'notify')
if (status) then
    vim.notify = notify
end

function M.show_result(command)
    vim.notify(M.execute(command))
end

function M.execute(command)
    return vim.fn.system(command)
end

return M
