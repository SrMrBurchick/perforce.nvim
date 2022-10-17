local api = vim.api
local commands = require('perforce.commands')

vim.g.preforce_nvim_version = '0.0.1'

api.nvim_create_user_command('Perforce', function(args)
  commands.load_command(unpack(args.fargs))
end, {
  range = true,
  nargs = '+',
  complete = function(arg)
    local list = require('perforce.commands').commands_list()
    return vim.tbl_filter(function(s)
      return string.match(s, '^' .. arg)
    end, list)
  end,
})
