local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')

function M.revert_single(file)
    local file_to_revert = validator.check_file(file)
    executer.show_result('p4 revert ' .. file_to_revert)
end

function M.revert_multiple(files)
    for _, file in ipairs(files) do
        M.revert_single(file)
    end
end

return M
