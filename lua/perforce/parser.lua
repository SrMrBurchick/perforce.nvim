local Path = require('plenary.path')
local opts = require('perforce.opts')
local p4_info = require('perforce.commands.info')

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
    result = string.gsub(file_path, result, "")
    result = string.gsub(string.match(result, '.+#'), '#', '')
    -- Remove / symbol
    result = string.sub(result, 2)

    return Path:new(result):make_relative(opts.p4root)
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

return M
