local perforce_opts = require('perforce.opts')
local perforce_telescope = require('perforce.telescope')
local env = require('perforce.commands.env')
local api = vim.api
local M = {
    opts = perforce_opts,
    telescope = perforce_telescope
}

M.perforece_augroup = api.nvim_create_augroup('Perforce', { clear = true })

function M.setup(opts)
    vim.env.P4CONFIG = env.get_p4config()
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'pf', '<CMD>lua require("perforce.telescope").files()<CR>', opts)
    vim.keymap.set('n', 'po', '<CMD>lua require("perforce.telescope").opened()<CR>', opts)
    vim.keymap.set('n', 'pl', '<CMD>lua require("perforce.telescope").file_log()<CR>', opts)
    vim.keymap.set('n', 'pa', '<CMD>Perforce  Add<CR>', opts)
    vim.keymap.set('n', 'pd', '<CMD>Perforce  Delete<CR>', opts)
    vim.keymap.set('n', 'pi', '<CMD>Perforce  Info<CR>', opts)
    vim.keymap.set('n', 'pc', '<CMD>Perforce  Checkout<CR>', opts)
    vim.keymap.set('n', 'pr', '<CMD>Perforce  Revert<CR>', opts)
    if nil == opts then
        return
    end
end

return M
