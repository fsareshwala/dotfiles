return {
  -- extended increment and decrement
  {
    'monaqa/dial.nvim',
    opts = function(_, opts)
      local augend = require('dial.augend')
      opts.groups = opts.groups or {}
      opts.groups.default = opts.groups.default or {}
      table.insert(opts.groups.default, augend.date.new({
        pattern = '%A, %B %d, %Y',
        default_kind = 'day',
      }))
      table.insert(opts.groups.default, augend.date.new({
        pattern = '%B %d, %Y',
        default_kind = 'day',
      }))
    end,
  },

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
