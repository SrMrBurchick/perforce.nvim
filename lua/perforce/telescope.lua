local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local entry_display = require "telescope.pickers.entry_display"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local p4files = require "perforce.commands.files"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local utils = require "telescope.utils"

local M = {}

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

return M
