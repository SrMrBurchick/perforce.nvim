local M = {}

function M.info()
    vim.fn.nvim_command('p4 info')
end

return M
