local M = {}
local executer = require('perforce.commands.executer')

function M.diff_all()
    executer.execute('p4 diff')
end

return M
