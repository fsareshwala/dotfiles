return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            follow_file = false,
            win = {
              list = {
                keys = {
                  ["<c-b>"] = "list_scroll_up",
                  ["<c-f>"] = "list_scroll_down",
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>l",
        function()
          local path = vim.api.nvim_buf_get_name(0)
          Snacks.explorer.reveal({ file = path })
        end,
        desc = "Reveal file in explorer",
      },
    },
  },
}
