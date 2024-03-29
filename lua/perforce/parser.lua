local Path = require('plenary.path')
local opts = require('perforce.opts')
local p4_info = require('perforce.commands.info')
local validator = require('perforce.commands.validation')

local M = {}


local function parse_info_string(info, keyword)
    local result = string.match(info, keyword .. '.+')
    if nil == result then
        return
    end

    local pos = string.find(result, '\n')
    result = string.sub(result, 0, pos)
    result = string.gsub(result, keyword, '')
    result = string.gsub(result, '\n', '')
    result = string.gsub(result, ' ', '')

    return result
end

function M.parse_info()
    local info = p4_info.get_info()

    -- Parse stream
    opts.p4stream = parse_info_string(info, 'stream:')

    -- Parse root
    opts.p4root = parse_info_string(info, 'root:')

end


local function parse_file_path(file_path)
    if nil == opts.p4stream then
        return
    end

    local result = string.match(file_path, opts.p4stream)
    local pwd = vim.fn.getcwd()
    local path_spliter = '/'
    local has = vim.fn.has
    local is_win = has "win32"

    if 0 ~= is_win then
        path_spliter = '\\'
    end
    local pos = string.find(pwd, path_spliter)

    if nil == result then
        result = string.match(file_path, string.lower(opts.p4stream))
    end
    while nil ~= pos do
        pwd = string.sub(pwd, pos + 1)
        pos = string.find(pwd, path_spliter)
    end


    file_path = string.gsub(file_path, result, '')
    pos = string.find(file_path, pwd)
    if nil ~= pos then
        file_path = string.sub(file_path, pos + string.len(pwd))
    end

    file_path = string.sub(file_path, 2)

    result = string.gsub(string.match(file_path, '.+#'), '#', '')

    return result
end

function M.parse_files(files_string)
    local files = {}
    if nil == files_string then
        return
    end

    -- Init opts: TODO: remove from here
    M.parse_info()

    local pos = string.find(files_string, '\n')

    while nil ~= pos do
        local file = string.sub(files_string, 0, pos)
        file = parse_file_path(file)
        if nil ~= file then
            table.insert(files, file)
        end

        files_string = string.sub(files_string, pos + 1)

        pos = string.find(files_string, '\n')
    end

    return files
end

local function is_table_contains_change(table, value)
    for _, v in ipairs(table) do
        if v.number == value.number then
            return true
        end
    end
    return false
end

local function parse_file_changes(changes_string)
    local changes = {}
    local pos = string.find(changes_string, '\n')

    while nil ~= pos do
        local change_data = {}
        local change = string.sub(changes_string, 0, pos)
        local change_description = string.match(change, '#.+')
        local change_id = string.match(change, '#%d+')

        if nil ~= change_description then
            change_description = string.sub(change_description, 0, string.find(change_description, '\n') - 1)
            change_description = string.match(change_description, '%(text%)%s*(.+)')

            change = string.match(change, 'change %d+')
            if nil ~= change then
                change = string.match(change, '%d+')
                change_data.number = change
                change_data.description = change_id .. ' Change ' .. change .. ' ' .. change_description
                if false == is_table_contains_change(changes, change_data) and validator.is_change_valid(change_data) then
                    table.insert(changes, change_data)
                end
            end
        end

        changes_string = string.sub(changes_string, pos + 1)

        pos = string.find(changes_string, '\n')
    end

    return changes
end

function M.parse_file_log(changes_string)
    local changes = parse_file_changes(changes_string)

    return changes
end

function M.parse_change_lists(change_lists_string)
    local change_lists = {}
    local pos = string.find(change_lists_string, '\n')

    while nil ~= pos do
        local change_data = {}
        local change = string.sub(change_lists_string, 0, pos)
        change_data.description = string.match(change, '*pending*.+')
        change_data.description = string.sub(change_data.description, 0, string.len(change_data.description) - 1)

        change = string.match(change, 'Change %d+')
        if nil ~= change then
            change = string.match(change, '%d+')
            change_data.number = change
        end

        if false == is_table_contains_change(change_lists, change_data) then
            table.insert(change_lists, change_data)
        end

        change_lists_string = string.sub(change_lists_string, pos + 1)

        pos = string.find(change_lists_string, '\n')
    end

    return change_lists
end

return M
