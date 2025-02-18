local cmd = { 'clangd' }

if string.find(vim.fn.getcwd(), 'pigweed') then
  local home = os.getenv('HOME')
  local clangd = home .. '/code/pigweed/environment/cipd/packages/pigweed/bin/clangd'
  cmd = {
    clangd,
    '--compile-commands-dir=' .. home .. '/code/pigweed/.pw_ide/.stable',
    '--background-index',
    '--clang-tidy',
    '--query-driver='
      .. home
      .. '/code/pigweed/environment/cipd/packages/pigweed/bin/*,'
      .. home
      .. '/code/pigweed/environment/cipd/packages/arm/bin/*',
  }
end

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {
          cmd = cmd,
          keys = {
            { '<leader>ce', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Toggle source/header' },
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
