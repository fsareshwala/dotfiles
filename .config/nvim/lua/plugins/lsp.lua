local util = require('util')

local clangd_cmd = nil

if string.find(vim.fn.getcwd(), 'pigweed') then
  local home = os.getenv('HOME')
  local pw_root = home .. '/code/pigweed'

  local clangd = pw_root .. '/external/+pw_cxx_toolchain+llvm_toolchain/bin/clangd'
  if not util.file_exists(clangd) then
    clangd = pw_root .. '/environment/cipd/packages/pigweed/bin/clangd'
  end

  local compile_commands_dir = pw_root .. '/.pw_ide/.stable'
  local candidates =
    vim.fn.glob(pw_root .. '/.compile_commands/*/compile_commands.json', false, true)
  local newest_mtime = -1
  for _, candidate in ipairs(candidates) do
    local mtime = vim.fn.getftime(candidate)
    local fsize = vim.fn.getfsize(candidate)
    if fsize > 10 and mtime > newest_mtime then
      newest_mtime = mtime
      compile_commands_dir = vim.fn.fnamemodify(candidate, ':h')
    end
  end

  clangd_cmd = {
    clangd,
    '--compile-commands-dir=' .. compile_commands_dir,
    '--background-index',
    '--clang-tidy',
    '--header-insertion=never',
    '--query-driver=/*',
  }
end

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        clangd = {
          mason = false,
          cmd = clangd_cmd,
          keys = {
            { '<leader>a', '<cmd>LspClangdSwitchSourceHeader<cr>', desc = 'Toggle source/header' },
          },
        },
        bashls = {},
        gopls = {},
        rust_analyzer = {},
        taplo = {},
      },
    },
  },
}
