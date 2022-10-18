local M = {}

function M.show_result(command)
    print(M.execute(command))
end

function M.execute(command)
    return vim.fn.system(command)
end

return M
