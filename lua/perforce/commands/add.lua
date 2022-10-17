local M = {}
local validator = require('perforce.commands.validation')

function M.add_single(file)
    local file_to_add = validator.check_file(file)

    vim.api.nvim_command('p4 add ' .. file_to_add)
end

function M.add_multiple(files)
    for _, file in ipairs(files) do
        M.add_single(file)
    end
end

return M
