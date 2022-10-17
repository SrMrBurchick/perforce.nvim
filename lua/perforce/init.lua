local perforce_opts = require('perforce.opts')
local api = vim.api
local M = {
    opts = perforce_opts
}

M.perforece_augroup = api.nvim_create_augroup('Perforce', { clear = true })

function M.setup(opts)
    if nil == opts then
        return
    end
end

return M
