local M = {}
local executer = require('perforce.commands.executer')

function M.info()
    executer.show_result('p4 info')
end

function M.get_info()
    return executer.execute('p4 info')
end

return M
