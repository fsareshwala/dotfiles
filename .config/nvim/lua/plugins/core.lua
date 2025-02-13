local util = require("util")
local working = util.at_work()

return {
  -- ctrl+a and ctrl+x on dates
  { "tpope/vim-speeddating" },

  -- colorschemes
  { "chriskempson/base16-vim" },

  -- better word motions through long strings
  { "chaoren/vim-wordmotion" },

  -- golang integration
  { "fatih/vim-go", ft = "go" },

  -- rust integration
  { "rust-lang/rust.vim", ft = "rust" },
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
  },

  -- git blame integration
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

  {
    "neovim/nvim-lspconfig",
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
      { "<leader>ce", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Toggle source/header" },
      { "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "Diagnostic help" },
    },
  },

  -- work plugins
  { dir = "~/code/fuchsia/tools/fidl/editors/vim", enabled = working },
  { dir = "~/code/emboss/integration/vim/ft-emboss", enabled = working },

  {
    url = "https://gn.googlesource.com/gn",
    enabled = working,
    init = function()
      vim.opt.rtp:prepend("misc/vim")
    end,
  },

  {
    "google/vim-codefmt",
    enabled = working,
    dependencies = {
      "google/vim-maktaba",
      {
        "google/vim-glaive",
        config = function()
          vim.cmd("call glaive#Install()")
        end,
      },
    },
  },
}
