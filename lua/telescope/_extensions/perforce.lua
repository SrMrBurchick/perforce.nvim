local p4_telescope = require('perforce.telescope')
local telescope = require('telescope')

return telescope.register_extension {
    exports = {
        files = p4_telescope.files,
        opened = p4_telescope.opened,
        file_log = p4_telescope.file_log
    }
}
