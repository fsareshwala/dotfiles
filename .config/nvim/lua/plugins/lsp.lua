return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {},
        bashls = {},
        gopls = {},
        rust_analyzer = {},
        taplo = {},
      },
    },
    keys = {
      { '<leader>ce', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Toggle source/header' },
      { 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', desc = 'Diagnostic help' },
    },
  },
}
