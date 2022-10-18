local M = {}
local executer = require('perforce.commands.executer')
local parser = require('perforce.parser')

function M.files()
    local files = executer.execute('p4 files ...') -- Returns string

    files = parser.parse_files(files) -- convert to array

    return files
end

return M
