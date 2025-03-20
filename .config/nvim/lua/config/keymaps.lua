-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- movement across virtually wrapped lines
vim.keymap.set('n', '0', 'g0')
vim.keymap.set('n', '$', 'g$')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- insert an empty line
vim.keymap.set('n', '<c-o>', 'i<cr><esc>0')

-- stay at current word when using star search
vim.keymap.set('n', '*', function()
  vim.fn.setreg('/', vim.fn.expand('<cword>'))
end)

-- replace current word with the contents of the paste buffer
vim.keymap.set('n', '<c-p>', 've"_xP')

-- underline current line
vim.keymap.set('n', 'U', 'YpVr-')

-- better window/tab/split controls
vim.keymap.set('n', '<leader>t', '<cmd>tabnew<cr>')

-- clear search register
vim.keymap.set('n', '<c-n>', '<cmd>let @/=""<cr>')

-- insert a hardcoded breakpoint under the current line
vim.keymap.set('n', '<leader>id', function()
  local get_architecture = function()
    local cmd = 'uname -m'
    local arch = ''

    local file = io.popen(cmd, 'r')
    if file then
      arch = string.trim(file:read('*a'))
      file:close()
    else
      return 'error'
    end

    arch = arch:lower()
    if arch == 'x86_64' or arch == 'amd64' then
      arch = 'x86_64'
    elseif arch == 'i386' or arch == 'i686' or arch == 'x86' then
      arch = 'x86'
    elseif arch == 'arm64' or arch == 'aarch64' then
      arch = 'arm64'
    end

    return arch
  end

  local arch = get_architecture()
  if string.startswith(arch, 'x86') then
    vim.cmd('normal o__asm__("int3");')
  elseif string.startswith(arch, 'arm') then
    vim.cmd('normal o__asm__("brk #0xF000");')
  else
    vim.cmd('normal oerror: unable to determine architecture')
  end
end, { desc = 'Insert hardcoded breakpoint' })

vim.keymap.set('n', '<leader>;', function()
  local path = '~/.config/nvim/init.lua'
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 then
    vim.cmd('edit ' .. path)
  else
    vim.cmd('buffer ' .. bufnr)
  end
  Snacks.explorer.reveal({ file = path })
end, { desc = 'Open configuration' })
