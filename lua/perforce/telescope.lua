local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local entry_display = require('telescope.pickers.entry_display')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local p4files = require('perforce.commands.files')
local p4opened = require('perforce.commands.opened')
local p4diff = require('perforce.commands.diff')
local p4file_log = require('perforce.commands.file_log')
local p4parser = require('perforce.parser')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local putils = require('telescope.previewers.utils')
local popts = require('perforce.opts')
local p4changelists = require('perforce.commands.changelists')
local action_set = require("telescope.actions.set")


local M = {}

function M.on_change_list_picked(changelist)
end

function M.files(opts)
    local files = p4files.files()
    opts = opts or {}

    if nil == files then
        return
    end

    pickers.new(opts, {
        prompt_title = "Perforce files",
        finder = finders.new_table {
            results = files
        },
        previewer = conf.file_previewer(opts),
        sorter = conf.generic_sorter(opts),
    }):find()
end

function M.opened(opts)
    local files = p4opened.opened()
    opts = opts or {}

    if nil == files then
        return
    end

    pickers.new(opts, {
        prompt_title = "Perforce opened files",
        finder = finders.new_table {
            results = files
        },
        previewer = previewers.new_buffer_previewer({
            title = "Change Diff",

            get_buffer_by_name = function(_, entry)
                return entry.value
            end,

            define_preview = function(self, entry, _)
                local cmd = { 'p4', 'diff', entry.value }
                putils.job_maker(cmd, self.state.bufnr, {
                    value = entry.value,
                    bufname = self.state.bufname,
                })
            end,
        }),
        sorter = conf.generic_sorter(opts),
    }):find()
end

function M.file_log(opts)
    local file = vim.fn.expand('%:~:.')
    local changes = p4file_log.get_changes_log(file)
    local descriptions = {}
    -- TODO: remove from here
    p4parser.parse_info()
    opts = opts or {}
    opts.current_file = file

    if nil == changes then
        return
    end

    for _, change in ipairs(changes) do
        table.insert(descriptions, change.description)
    end

    pickers.new(opts, {
        prompt_title = "Perforce " .. file .. " log",
        finder = finders.new_table {
            results = descriptions
        },
        previewer = previewers.new_buffer_previewer({
            title = "Revision Diff",

            get_buffer_by_name = function(_, entry)
                return entry.value
            end,

            define_preview = function(self, entry, _)
                local change = string.match(entry.value, '#%d+')

                local pwd = vim.fn.getcwd()
                change = pwd .. '/' .. file .. change
                local cmd = { 'p4', 'diff', change }
                putils.job_maker(cmd, self.state.bufnr, {
                    value = entry.value,
                    bufname = self.state.bufname,
                    cwd = popts.p4root,
                })
            end,
        }),
        sorter = conf.generic_sorter(opts),
    }):find()
end

function M.pengidng_change_lists(opts)
    local changes = p4changelists.get_pending_change_lists()
    local descriptions = {}
    p4parser.parse_info()
    opts = opts or {}

    if nil == changes then
        return
    end

    for _, change in ipairs(changes) do
        table.insert(descriptions, 'Change ' .. change.number .. ' ' .. change.description)
    end

    pickers.new(opts, {
        prompt_title = "Perforce pending changelists",
        finder = finders.new_table {
            results = descriptions
        },
        previewer = previewers.new_buffer_previewer({
            title = "Changelist full info",

            get_buffer_by_name = function(_, entry)
                return entry.value
            end,

            define_preview = function(self, entry, _)
                local change_data = {}
                local change = entry.value
                change = string.match(change, 'Change %d+')
                if nil ~= change then
                    change = string.match(change, '%d+')
                    change_data.number = change
                end

                if nil ~= change_data.number then
                    local cmd = { 'p4', 'change', '-o', change_data.number }
                    putils.job_maker(cmd, self.state.bufnr, {
                        value = entry.value,
                        bufname = self.state.bufname,
                        cwd = popts.p4root,
                    })
                end
            end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            map('i', '<CR>', function()
                -- local selection = action_state.get_selected_entry()
                local picker = action_state.get_current_picker(prompt_bufnr)

                -- temporarily register a callback which keeps selection on refresh
                local selection = picker:get_selection_row()
                local entry = picker.manager:get_entry(picker:get_index(selection))
                if nil ~= entry then
                    M.selected_changelist = string.match(entry.value, "Change %d+")
                    M.selected_changelist = string.match(M.selected_changelist, "%d+")
                    M.on_change_list_picked(M.selected_changelist)
                end

                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()

    return M.selected_changelist
end

return M
