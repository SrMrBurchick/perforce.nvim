# perforce.nvim

Neovim plugin for Perforce (Helix Core) version control integration. Provides seamless P4 operations directly from your editor with Telescope-powered pickers and intuitive keybindings.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-no-action.svg)](https://stand-with-ukraine.pp.ua/)

## Features

- **Telescope integration** - Browse depot files, opened files, file history, and pending changelists
- **File operations** - Add, delete, checkout (edit), revert files
- **Changelist management** - View and work with pending changelists, checkout files on specific changelists
- **Diff previews** - See diffs for opened files and file revisions
- **Automatic config detection** - Auto-discovers `.p4config.txt` files in project hierarchy
- **Minimal keymap defaults** - Ready-to-use shortcuts out of the box

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'SrMrBurchick/perforce.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'SrMrBurchick/perforce.nvim',
  requires = { 'nvim-telescope/telescope.nvim' }
}
```

## Configuration

```lua
require('perforce').setup({
  -- Perforce connection settings (optional)
  p4user = "",     -- Your P4USER
  p4port = "",     -- Your P4PORT (e.g., "perforce:1666")
  p4root = "",     -- Your P4ROOT
  p4client = "",   -- Your P4CLIENT
  p4stream = "",   -- Your P4STREAM (for streaming projects)
})
```

> **Note:** The plugin automatically sets `P4CONFIG` to point to your project's `.p4config.txt` file if found in the directory hierarchy.

## Usage

### Default Keymaps

The plugin sets up the following keymaps in normal mode:

| Keymap | Command | Description |
|--------|---------|-------------|
| `pf` | `:lua require('perforce.telescope').files()` | Browse depot files |
| `po` | `:lua require('perforce.telescope').opened()` | List opened files with diff preview |
| `pl` | `:lua require('perforce.telescope').file_log()` | Show file revision history |
| `pa` | `:Perforce Add` | Add current file to depot |
| `pd` | `:Perforce Delete` | Delete current file from depot |
| `pi` | `:Perforce Info` | Show Perforce server info |
| `pc` | `:Perforce Checkout` | Checkout (edit) current file |
| `pr` | `:Perforce Revert` | Revert changes to current file |

### Telescope Extensions

All Telescope pickers are also available via the `:Telescope perforce` prefix:

```vim
:Telescope perforce files          " Browse all depot files
:Telescope perforce opened         " View opened files with diffs
:Telescope perforce file_log       " File revision history
:Telescope perforce pending_changes " List pending changelists
```

### Commands

The plugin exposes a `:Perforce` command with autocompletion:

```vim
:Perforce Add                       " Add file to depot
:Perforce Delete                    " Delete file from depot
:Perforce Checkout                  " Checkout (p4 edit) file
:Perforce Info                      " Show P4 info
:Perforce Revert                    " Revert file to head revision
:Perforce Shelve                    " Shelve changes (TODO)
:Perforce Submit                    " Submit changelist (TODO)
:Perforce Sync                      " Sync workspace (TODO)
:Perforce Diff                      " Show diff of all opened files
:Perforce CheckoutOnChangelist      " Checkout file to specific pending changelist
```

### Changelist Workflow

1. Press `pc` or run `:Perforce Checkout` to edit a file
2. Use `:Perforce CheckoutOnChangelist` to assign the file to a specific pending changelist
3. Browse pending changelists via `po` or `:Telescope perforce pending_changes`
4. Submit will be available when implemented

## Dependencies

- [Neovim](https://neovim.io/) >= 0.7.0
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (telescope dependency)
- Perforce command-line client (`p4`) in PATH

## Notes

- The plugin expects the `p4` CLI executable to be available in your PATH
- `.p4config.txt` files are auto-discovered from the current file's directory upward
- Some features (shelve, submit, sync) are marked as TODO and not yet implemented
- The `diff` preview in opened files picker shows `p4 diff` output for each file
- File paths from P4 are parsed relative to your workspace stream/root
