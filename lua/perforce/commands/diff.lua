local M = {}
local executer = require('perforce.commands.executer')

function M.diff_all()
    executer.show_result('p4 diff')
end

return M
