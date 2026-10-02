-- init.lua (Neovim 0.12+)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core.options')
require('plugins.colorscheme')
require('plugins.ui')
require('plugins.lsp')
require('plugins.tools')
