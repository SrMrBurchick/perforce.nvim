local M = {}
local executer = require('perforce.commands.executer')
local parser = require('perforce.parser')

function M.diff_all()
    executer.show_result('p4 diff')
end

function M.file_diff(file, change)
    return executer.execute('p4 diff "' .. file .. '"' .. change)
end

function M.diff_parent(file)
    local changes = {}
    local changes_string = executer.execute('p4 filelog "' .. file .. '"')

    changes = parser.parse_file_log(changes_string)

    for _ , change in ipairs(changes) do
        change.diff = file_diff(file, change.number)
    end

    return changes
end

return M
