local M = {}
local validator = require('perforce.commands.validation')

function M.revert_single(file)
    local file_to_add = validator.check_file(file)

    vim.api.nvim_command('p4 revert ' .. file_to_add)
end

function M.revert_multiple(files)
    for _, file in ipairs(files) do
        M.revert_single(file)
    end
end

return M
