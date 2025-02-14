-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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
  pattern = { 'c', 'cpp' },
  group = general_settings,
  callback = function()
    vim.opt_local.commentstring = '// %s'
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

-- format code on save
-- use vim-codefmt while working, otherwise lsp formatting
vim.g.rustfmt_autosave = 1
if working then
  vim.cmd([[
    let g:gn_path = systemlist('source ~/code/fuchsia/tools/devshell/lib/vars.sh && echo $PREBUILT_GN')[0]

    augroup formatting
    autocmd!
    autocmd FileType gn ++once execute ':Glaive codefmt gn_executable=' . g:gn_path
    autocmd FileType bzl AutoFormatBuffer buildifier
    autocmd FileType c,cpp AutoFormatBuffer clang-format
    autocmd FileType gn AutoFormatBuffer gn
    autocmd FileType go AutoFormatBuffer gofmt
    autocmd FileType markdown AutoFormatBuffer mdformat
    autocmd FileType proto AutoFormatBuffer protofmt
    autocmd FileType python AutoFormatBuffer pyformat
    autocmd FileType rust AutoFormatBuffer rustfmt
    autocmd FileType sh AutoFormatBuffer shfmt
    augroup end
    ]])
else
  vim.cmd([[
    augroup formatting
    autocmd!
    autocmd BufWritePre *.h,*.cc,*.go lua vim.lsp.buf.format()
    augroup end
    ]])
end
