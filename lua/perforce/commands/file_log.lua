local M = {}
local executer = require('perforce.commands.executer')
local p4diff = require('perforce.commands.diff')
local parser = require('perforce.parser')

function M.get_changes_log(file)
    local changes = {}
    local changes_string = executer.execute('p4 filelog ' .. file)

    changes = parser.parse_file_log(changes_string)
    --
    -- for _ , change in ipairs(changes) do
    --     if p4diff ~= nil then
    --         change.diff = p4diff.file_diff(file, change.number)
    --     end
    -- end
    return changes
end

return M
