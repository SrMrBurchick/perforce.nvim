local M = {}
local validator = require('perforce.commands.validation')

function M.checkout_single(file)
    local file_to_add = validator.check_file(file)

    vim.api.nvim_command('p4 edit ' .. file_to_add)
end

function M.checkout_multiple(files)
    for _, file in ipairs(files) do
        M.checkout_single(file)
    end
end

return M
