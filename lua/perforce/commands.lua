local p4_add = require('perforce.commands.add')
local p4_delete = require('perforce.commands.delete')
local p4_edit = require('perforce.commands.checkout')
local p4_info = require('perforce.commands.info')
local p4_revert = require('perforce.commands.revert')
local p4_shelve = require('perforce.commands.shelve')
local p4_submit = require('perforce.commands.submit')
local p4_sync = require('perforce.commands.sync')
local p4_diff = require('perforce.commands.diff')
local p4_changelists = require('perforce.commands.changelists')
-- local p4_permissions = require('perforce.commands.file_permissions')
local p4_telescope = require('perforce.telescope')

local M = {}

local commands = {
    Add = function()
        local file = vim.fn.expand('%:p')
        p4_add.add_single(file)
    end,
    Delete = function ()
        local file = vim.fn.expand('%:p')
        p4_delete.delete_single(file)
    end,
    Checkout = function()
        local file = vim.fn.expand('%:p')
        p4_edit.checkout_single(file)
    end,
    Info = function ()
        p4_info.info()
    end,
    Revert = function ()
        local file = vim.fn.expand('%:p')
        p4_revert.revert_single(file)
    end,
    Shelve = function ()
        p4_shelve.shelve()
    end,
    Submit = function ()
        p4_submit.submit()
    end,
    Sync = function ()
        p4_sync.sync()
    end,
    Diff = function ()
        p4_diff.diff_all()
    end,
    MakeWritable = function ()
        local file = vim.fn.expand('%:p')
        -- p4_permissions.make_writable(file)
    end,
    Blame = function ()
        -- TODO
    end,
    CheckoutOnChangelist = function ()
        local p4telescope_perforece = require('telescope').extensions.perforce
        local file = vim.fn.expand('%:p')
        function p4_telescope.on_change_list_picked(changelist)
            if nil ~= changelist then
                p4_edit.checkout_on_changelists(file, changelist)
            end
        end

        p4telescope_perforece.pending_changes()
    end,
}

function M.commands_list()
    return vim.tbl_keys(commands)
end

function M.load_command(cmd, ...)
  local args = { ... }
  if next(args) ~= nil then
    commands[cmd](args[1])
  else
    commands[cmd]()
  end
end

return M
