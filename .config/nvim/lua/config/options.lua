-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = '\\'

vim.g.snacks_animate = false

vim.opt.colorcolumn = '+1'
vim.opt.exrc = true
vim.opt.formatoptions:append('1p]')
vim.opt.gdefault = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = '|-', trail = '-', extends = '>', precedes = '<' }
vim.opt.nrformats:append({ 'alpha', 'octal' })
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.shell = '/bin/bash'
vim.opt.signcolumn = 'number'
vim.opt.spellfile:append(vim.fn.glob('~/.config/nvim/spell/en.utf-8.add'))
vim.opt.spellfile:append(vim.fn.glob('~/personal/vim/en.utf-8.add'))
vim.opt.swapfile = false
vim.opt.textwidth = 100
vim.opt.title = true
vim.opt.undodir = vim.fn.glob('~/.config/nvim/tmp/undo')
vim.opt.wildignore:append({ '*.so', '*.o' })
vim.opt.wrap = true

-- no transparency on completion windows
vim.opt.pumblend = 0
