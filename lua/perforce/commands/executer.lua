local M = {}

function M.execute(command)
    local result = vim.api.nvim_command('!' .. command)
    print(result)
end

return M
