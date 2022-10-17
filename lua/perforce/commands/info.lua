local M = {}
local executer = require('perforce.commands.executer')

function M.info()
    executer.execute('p4 info')
end

return M
