return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        clangd = {
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
