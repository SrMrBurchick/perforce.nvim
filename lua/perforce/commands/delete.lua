local M = {}
local validator = require('perforce.commands.validation')

function M.delete_single(file)
    local file_to_add = validator.check_file(file)

    vim.api.nvim_command('p4 delete ' .. file_to_add)
end

function M.delete_multiple(files)
    for _, file in ipairs(files) do
        M.delete_single(file)
    end
end

return M
