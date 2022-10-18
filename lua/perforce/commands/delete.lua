local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')

function M.delete_single(file)
    local file_to_delete = validator.check_file(file)
    executer.show_result('p4 delete ' .. file_to_delete)
end

function M.delete_multiple(files)
    for _, file in ipairs(files) do
        M.delete_single(file)
    end
end

return M
