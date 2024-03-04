local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')
local parser = require('perforce.parser')

function M.describe_change_list(change)
    local description = executer.execute('p4 describe ' .. change)
    return description
end

function M.get_pending_change_lists()
    local change_lists_string = executer.execute('p4 changelists -s pending')
    local change_lists = parser.parse_change_lists(change_lists_string)
    --
    -- for _ , changelist in ipairs(change_lists) do
    --     changelist.description = M.describe_change_list(changelist.number)
    -- end

    return change_lists
end

return M
