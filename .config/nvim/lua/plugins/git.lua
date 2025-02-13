-- git blame integration
return {
  {
    "FabijanZulj/blame.nvim",
    opts = {
      date_format = "%B %-d, %Y",
      virtual_style = "float",
      blame_options = { "-w" },
    },
    keys = {
      { "<leader>gb", "<cmd>BlameToggle virtual<cr>", desc = "Git blame" },
    },
  },
}
