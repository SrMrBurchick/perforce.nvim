local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')

function M.checkout_single(file)
    local file_to_checkout = validator.check_file(file)
    executer.execute('p4 edit ' .. file_to_checkout)
end

function M.checkout_multiple(files)
    for _, file in ipairs(files) do
        M.checkout_single(file)
    end
end

return M
