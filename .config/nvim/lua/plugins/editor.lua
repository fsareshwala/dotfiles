return {
  -- ctrl+a and ctrl+x on dates
  { 'tpope/vim-speeddating' },

  -- better word motions through long strings
  { 'chaoren/vim-wordmotion' },

  -- completion
  {
    'saghen/blink.cmp',
    opts = {
      keymap = {
        preset = 'enter',
        ['tab'] = { 'accept', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
        ['<c-k>'] = { 'select_prev', 'fallback' },
      },
    },
  },

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      highlight = {
        -- due to https://github.com/nvim-treesitter/nvim-treesitter/issues/2916
        disable = { 'markdown' },
      },
    },
  },
}
