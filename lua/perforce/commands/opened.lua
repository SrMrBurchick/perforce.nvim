local M = {}
local executer = require('perforce.commands.executer')
local parser = require('perforce.parser')

function M.opened()
    local files = executer.execute('p4 opened') -- Returns string

    files = parser.parse_files(files) -- convert to array

    return files
end

return M
