local M = {};

local function find_p4config()
	-- Search for '.p4config.txt' starting from the current file's directory
	local config_file = vim.fs.find('.p4config.txt', {
		upward = true,
		stop = vim.uv.os_homedir(), -- Optional: stop at home dir to save time
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})[1]

	if config_file then
		print("Found config at: " .. config_file)
		return vim.fs.abspath(config_file)
	else
		print("No .p4config.txt found in parent directories.")
		return nil
	end
end

function M.get_p4config()
	return find_p4config();
end

return M;
