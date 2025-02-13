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
  },
}
