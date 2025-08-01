return {
  -- ctrl+a and ctrl+x on dates
  { 'tpope/vim-speeddating' },

  -- better word motions through long strings
  { 'chaoren/vim-wordmotion' },

  -- completion
  {
    'saghen/blink.cmp',
    opts = {
      completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' } },
      },
      signature = { window = { border = 'single' } },
      keymap = {
        preset = 'super-tab',
        -- ['<c-j>'] = { 'select_next', 'fallback' },
        -- ['<c-k>'] = { 'select_prev', 'fallback' },
      },
    },
  },
}
