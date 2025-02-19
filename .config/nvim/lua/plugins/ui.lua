return {
  {
    'folke/noice.nvim',
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    opts = {
      options = {
        mode = 'tabs',
      },
    },
  },
  {
    'folke/snacks.nvim',
    opts = {
      dashboard = {
        enabled = false,
      },
      picker = {
        sources = {
          explorer = {
            follow_file = false,
            win = {
              list = {
                keys = {
                  ['<c-b>'] = 'list_scroll_up',
                  ['<c-f>'] = 'list_scroll_down',
                  ['<c-t>'] = 'tab',
                  ['<esc>'] = 'explorer_update',
                },
              },
            },
          },
        },
      },
    },
    keys = {
      { '<leader>e', '<leader>ff', desc = 'Find files (Root dir)', remap = true },
      {
        '<leader>l',
        function()
          local path = vim.api.nvim_buf_get_name(0)
          Snacks.explorer.reveal({ file = path })
        end,
        desc = 'Reveal file in explorer',
      },
    },
  },
}
