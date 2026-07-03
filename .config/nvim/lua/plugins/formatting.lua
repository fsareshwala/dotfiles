local util = require('util')
local working = util.at_work()

local gn_path = ''
if working then
  local lines =
    vim.fn.systemlist('source ~/code/fuchsia/tools/devshell/lib/vars.sh && echo $PREBUILT_GN')
  if vim.v.shell_error == 0 and lines[1] then
    gn_path = lines[1]
  end
end

vim.g.rustfmt_autosave = 1

return {
  {
    'stevearc/conform.nvim',
    opts = function()
      local formatters_by_ft = {
        go = { 'gofmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        markdown = { 'prettier' },
        python = { 'pyformat' },
      }

      if working then
        formatters_by_ft.gn = { 'gn' }
        formatters_by_ft.bzl = { 'buildifier' }
        formatters_by_ft.proto = { 'protofmt' }
      end

      return {
        formatters_by_ft = formatters_by_ft,

        formatters = {
          gn = {
            command = gn_path ~= '' and gn_path or 'gn',
            args = { 'format', '--stdin' },
          },
        },

        default_format_opts = {
          timeout_ms = 1000,
          lsp_fallback = true,
        },
      }
    end,
  },
}
