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

return M
