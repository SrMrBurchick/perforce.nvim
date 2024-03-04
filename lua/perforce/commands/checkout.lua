local M = {}
local validator = require('perforce.commands.validation')
local executer = require('perforce.commands.executer')

function M.checkout_single(file)
    local file_to_checkout = validator.check_file(file)
    executer.show_result('p4 edit ' .. file_to_checkout)
end

function M.checkout_multiple(files)
    for _, file in ipairs(files) do
        M.checkout_single(file)
    end
end

function M.checkout_on_changelists(file, changelist)
    local file_to_checkout = validator.check_file(file)
    if file_to_checkout ~= '' then
        executer.show_result('p4 edit' .. ' -c ' .. changelist .. ' ' .. file_to_checkout)
    else
        vim.notify("Error! Invalid file: " .. file, vim.log.levels.ERROR)
    end
end

return M
