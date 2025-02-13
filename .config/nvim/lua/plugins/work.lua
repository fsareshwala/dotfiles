local util = require("util")
local working = util.at_work()

return {
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
