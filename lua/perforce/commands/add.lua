local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')

function M.add_single(file)
    local file_to_add = validator.check_file(file)
    executer.show_result('p4 add "' .. file_to_add .. '"')
end

function M.add_multiple(files)
    for _, file in ipairs(files) do
        M.add_single(file)
    end
end

return M
