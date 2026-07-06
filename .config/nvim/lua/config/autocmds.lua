-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local util = require('util')
local working = util.at_work()

-- auto open snacks explorer on startup
if vim.fn.argc(-1) == 0 then
  Snacks.explorer()
end

local general_settings = vim.api.nvim_create_augroup('general_settings', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { 'README' },
  group = general_settings,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.filetype = 'markdown'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'gitcommit', 'hgcommit' },
  group = general_settings,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown' },
  group = general_settings,
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.comments:append('b:>')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  group = general_settings,
  callback = function()
    vim.opt_local.list = false
  end,
})

vim.api.nvim_create_autocmd('BufRead', {
  pattern = { '*.gn', '*.gni' },
  group = general_settings,
  callback = function()
    vim.opt_local.filetype = 'gn'
    vim.opt_local.commentstring = '# %s'
  end,
})

-- automatically delete all trailing whitespace and newlines at end of file on save
local trailing_whitespace = vim.api.nvim_create_augroup('trailing_whitespace', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = trailing_whitespace,
  callback = function()
    if vim.bo.filetype ~= 'diff' then
      vim.cmd('%s/\\s\\+$//e')
      vim.cmd('%s/\\n\\+\\%$//e')
    end
  end,
})

-- apply xresources file on save
vim.cmd([[
  augroup xresources
  autocmd!
  autocmd BufWritePost .Xresources !xrdb %
  augroup end
  ]])

-- automatically compile writings on save
local autocompile_writings = vim.api.nvim_create_augroup("AutoCompileWritings", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = autocompile_writings,
  pattern = {"*.md", "*.yaml"},
  callback = function()
    local path = vim.fn.expand('%:p')
    if string.find(path, 'personal/writings') then
      vim.fn.jobstart({ "pandoc", "-d", "config.yaml" })
    end
  end,
})

-- add formats for speeddating plugin
vim.cmd([[
  augroup speeddating
  autocmd!
  autocmd VimEnter * SpeedDatingFormat %A, %B %d, %Y
  autocmd VimEnter * SpeedDatingFormat %B %d, %Y
  augroup end
  ]])

if working then
  local work_settings = vim.api.nvim_create_augroup('work_settings', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'emboss', 'markdown' },
    group = work_settings,
    callback = function()
      local path = vim.fn.expand('%:p')
      if string.find(path, 'pigweed') then
        vim.opt_local.textwidth = 80
      end

      if string.find(path, 'google3') then
        vim.opt_local.textwidth = 80
      end
    end,
  })
end
