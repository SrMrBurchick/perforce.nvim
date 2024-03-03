local M = {}

function M.check_file(file)
    local process_file = {}
    local opened_file = vim.fn.expand('%:p')
    if nil == file then
        print("No file selected. Use current file " .. opened_file .. "?")
        local answer = string.lower(vim.fn.input("Yes/No(y/n): "))
        if answer == "y" or answer == "yes" then
            process_file = opened_file
        else
            return
        end
    else
        process_file = file
    end

    return process_file
end

function M.is_change_valid(change)
    local number = tonumber(string.match(change.number, '%d+'))
    if nil == number then
        return false
    end

    return number > 0 and (change.description ~= nil or change.description ~= '')
end

return M
