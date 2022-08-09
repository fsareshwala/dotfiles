function string.starts(haystack, needle)
   return string.sub(haystack, 0, string.len(needle)) == needle
end

local function get_hostname()
  local f = io.popen ('/bin/hostname')
  if f == nil then
    return 'unknown'
  end

  local value = f:read('*a')
  f:close()
  return string.gsub(value, '\n$', '')
end

local function at_work()
  local hostname = get_hostname()

  if string.starts(hostname, 'fsareshwala-laptop') then
    return true
  elseif string.starts(hostname, 'fsareshwala-cloudtop') then
    return true
  end

  return false
end

local function set_options()
  vim.opt.autoindent = true
  vim.opt.autoread = true
  vim.opt.autowriteall = true
  vim.opt.background = 'dark'
  vim.opt.backspace = {'eol', 'start', 'indent'}
  vim.opt.backup = false
  vim.opt.clipboard = 'unnamedplus'
  vim.opt.colorcolumn = '+1'
  vim.opt.copyindent = true
  vim.opt.expandtab = true
  vim.opt.exrc = true
  vim.opt.formatoptions = 'cjlnqrt'
  vim.opt.gdefault = true
  vim.opt.hlsearch = true
  vim.opt.ignorecase = true
  vim.opt.inccommand = 'split'
  vim.opt.incsearch = true
  vim.opt.iskeyword:append('-')
  vim.opt.joinspaces = false
  vim.opt.laststatus = 3 -- enable global status line
  vim.opt.linebreak = true
  vim.opt.list = true
  vim.opt.listchars = {tab = '|-', trail = '-', extends = '>', precedes = '<'}
  vim.opt.matchtime = 3
  vim.opt.modeline = true
  vim.opt.mouse = ''
  vim.opt.nrformats:append({'alpha', 'octal'})
  vim.opt.number = true
  vim.opt.preserveindent = true
  vim.opt.pumheight = 10
  vim.opt.shell = '/bin/bash'
  vim.opt.shiftround = true
  vim.opt.shiftwidth = 2
  vim.opt.shortmess:append('c')
  vim.opt.showmatch = true
  vim.opt.showmode = false
  vim.opt.showtabline = 1
  vim.opt.signcolumn = 'yes'
  vim.opt.smartcase = true
  vim.opt.smarttab = true
  vim.opt.softtabstop = 2
  vim.opt.spellfile:append(vim.fn.glob('~/.config/nvim/spell/en.utf-8.add'))
  vim.opt.spellfile:append(vim.fn.glob('~/personal/vim/en.utf-8.add'))
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.startofline = false
  vim.opt.swapfile = false
  vim.opt.tabstop = 2
  vim.opt.tags = 'tags;'
  vim.opt.textwidth = 100
  vim.opt.timeoutlen = 500
  vim.opt.title = true
  vim.opt.undodir = vim.fn.glob('~/.config/nvim/tmp/undo')
  vim.opt.undofile = true
  vim.opt.updatetime = 300
  vim.opt.virtualedit:append('block')
  vim.opt.wildignore:append({'*.so', '*.o'})
  vim.opt.wildmenu = true
  vim.opt.wildmode = 'list:longest,full'
  vim.opt.wrap = true
  vim.opt.wrapscan = true
  vim.opt.writebackup = false

  vim.g.markdown_fenced_languages = {'python', 'vim', 'cpp', 'java'}
  vim.g.tex_flavor = 'latex'
end

local function set_keymaps()
  local opts = {noremap = true, silent = true}

  -- local command = 'c'
  -- local insert = 'i'
  local normal = 'n'
  -- local term = 't'
  local visual = 'v'
  -- local visual_block = 'x'

  -- better window/tab/split controls
  vim.keymap.set(normal, '<c-h>', '<c-w>h', opts)
  vim.keymap.set(normal, '<c-j>', '<c-w>j', opts)
  vim.keymap.set(normal, '<c-k>', '<c-w>k', opts)
  vim.keymap.set(normal, '<c-l>', '<c-w>l', opts)
  vim.keymap.set(normal, '<leader>s', ':vsplit<cr>', opts)
  vim.keymap.set(normal, '<leader>t', ':tabnew<cr>', opts)
  vim.keymap.set(normal, 'H', ':tabprev<cr>', opts)
  vim.keymap.set(normal, 'L', ':tabnext<cr>', opts)

  -- resize with arrows
  vim.keymap.set(normal, '<up>', ':resize +2<cr>', opts)
  vim.keymap.set(normal, '<down>', ':resize -2<cr>', opts)
  vim.keymap.set(normal, '<left>', ':vertical resize -2<cr>', opts)
  vim.keymap.set(normal, '<right>', ':vertical resize +2<cr>', opts)

  -- movement across virtually wrapped lines
  vim.keymap.set(normal, '0', 'g0', opts)
  vim.keymap.set(normal, '$', 'g$', opts)
  vim.keymap.set(normal, 'j', 'gj', opts)
  vim.keymap.set(normal, 'k', 'gk', opts)

  -- hold onto indent mode when indenting
  vim.keymap.set(visual, '<', '<gv', opts)
  vim.keymap.set(visual, '>', '>gv', opts)

  -- insert an empty line
  vim.keymap.set(normal, '<c-o>', 'i<cr><esc>0', opts)

  -- replace current word with contents of paste buffer
  vim.keymap.set(normal, '<c-p>', '"_cw"<esc>', opts)

  -- file shortcuts
  vim.keymap.set(normal, '<leader>a', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
  vim.keymap.set(normal, '<leader>v', '<cmd>e  ~/.config/nvim/init.lua<cr>', opts)
  vim.keymap.set(normal, '<leader>wk', '<cmd>e ~/personal/career/google.md<cr>', opts)

  -- stay at current word when using star search
  vim.keymap.set(normal, '*', '*<c-o>', opts)

  -- underline current line when only in normal mode
  vim.keymap.set(normal, 'U', 'YpVr-', opts)

  -- telescope keymaps
  vim.keymap.set(normal, '<leader>e', '<cmd>Telescope find_files<cr>', opts)
  vim.keymap.set(normal, '<leader>f', '<cmd>Telescope live_grep<cr>', opts)
  vim.keymap.set(normal, '<leader>g', '<cmd>Telescope grep_string<cr>', opts)
  vim.keymap.set(normal, '<leader>z', '<cmd>Telescope spell_suggest<cr>', opts)
  vim.keymap.set(normal, '<leader>x', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', opts)

  vim.keymap.set(normal, 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
  vim.keymap.set(normal, 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
  vim.keymap.set(normal, 'gr', '<cmd>Telescope lsp_references<cr>', opts)
  vim.keymap.set(normal, 'gf', '<cmd>Telescope lsp_incoming_calls<cr>', opts)

  -- file tree keymaps
  vim.keymap.set(normal, '<leader>n', '<cmd>NvimTreeToggle<cr>', opts)
  vim.keymap.set(normal, '<leader>l', '<cmd>NvimTreeFindFile<cr>', opts)

  -- git keymaps
  vim.keymap.set(normal, '<leader>b', '<cmd>lua require("git.blame").blame()<cr>')
end

local function install_plugins(working)
  local data_path = vim.fn.stdpath('data')
  local packer_subfile = '/site/pack/packer/start/packer.nvim'
  local install_path = data_path .. packer_subfile
  local packer_repo = 'https://github.com/wbthomason/packer.nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) then
    vim.fn.system({'git', 'clone', packer_repo, install_path})
    vim.cmd('packadd packer.nvim')
  end

  local packer = require('packer')

  return packer.startup(function(use)
    use 'wbthomason/packer.nvim'    -- let packer manage itself

    use 'chriskempson/base16-vim'   -- colorscheme
    use 'rust-lang/rust.vim'        -- rust vim integration
    use 'tpope/vim-speeddating'     -- ctrl+a and ctrl+x on dates
    use 'ray-x/lsp_signature.nvim'  -- show function signature when you type
    use 'ojroques/nvim-osc52'       -- osc52 location independent clipboard
    use 'chaoren/vim-wordmotion'    -- better word motions through long strings
    vim.g.wordmotion_spaces = {'_', '-', '.'}

    -- basic git integration, no crazy bells and whistles
    use { 'dinhhuy258/git.nvim', config = function() require('git').setup() end }

    -- motions to comment lines out
    use { 'terrortylor/nvim-comment', config = function() require('nvim_comment').setup() end }

    -- automatically insert/delete parenthesis, brackets, quotes
    use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup() end }

    -- motions to surround text with other text
    use { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end }

    use {
      'saecki/crates.nvim',
      event = { 'BufRead Cargo.toml' },
      requires = { 'nvim-lua/plenary.nvim' },
      config = function() require('crates').setup() end
    }

    -- fuzzy finder over files, commands, lists, etc
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        {'nvim-telescope/telescope-ui-select.nvim'},
      }
    }

    -- Better syntax highlighting
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
    }

    -- completion engine
    use {'hrsh7th/cmp-nvim-lua', requires = 'hrsh7th/nvim-cmp'} -- neovim lua api
    use {'hrsh7th/cmp-path', requires = 'hrsh7th/nvim-cmp'}     -- filesystem paths
    use {'hrsh7th/cmp-nvim-lsp', requires = 'hrsh7th/nvim-cmp'} -- lsp based completions
    use {'saadparwaiz1/cmp_luasnip', -- completion source for luasnip
      requires = {
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip' -- nvim-cmp requires a snippet engine for expansion
      }
    }

    -- language server protocol
    use {
      'neovim/nvim-lspconfig',
      requires = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      }
    }

    -- file tree
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- work plugins
    if working then
      use '~/code/fuchsia/tools/fidl/editors/vim'
      use '~/code/emboss/integration/vim/ft-emboss'

      -- fuchsia build system
      use {
        'https://gn.googlesource.com/gn',
        rtp = 'misc/vim'
      }

      -- code formatting
      use {
        'google/vim-codefmt',
        requires = {
          'google/vim-glaive',
          'google/vim-maktaba'
        },
        config = function()
          vim.cmd('call glaive#Install()')
        end
      }
    end
  end)
end

local function setup_completions()
  local cmp = require('cmp')

  local kind_icons = {
    Class = '',
    Color = '',
    Constant = '',
    Constructor = '',
    Enum = '',
    EnumMember = '',
    Event = '',
    Field = '',
    File = '',
    Folder = '',
    Function = '',
    Interface = '',
    Keyword = '',
    Method = 'm',
    Module = '',
    Operator = '',
    Property = '',
    Reference = '',
    Snippet = '',
    Struct = '',
    Text = '',
    TypeParameter = '',
    Unit = '',
    Value = '',
    Variable = '',
  }

  cmp.setup({
    snippet = {
      expand = function(args)
        local luasnip = require('luasnip')
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = {
      ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), {'i', 'c'}),
      ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(1), {'i', 'c'}),
      ['<c-k>'] = cmp.mapping.select_prev_item(),
      ['<c-j>'] = cmp.mapping.select_next_item(),
      ['<c-space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<cr>'] = cmp.mapping.confirm {select = true},
    },
    formatting = {
      fields = {'abbr', 'kind', 'menu'},
      format = function(entry, item)
        item.kind = string.format('[%s', kind_icons[item.kind], item.kind)
        item.menu = string.format('%s]', entry.source.name)
        return item
      end
    },
    sources = {
      {name = 'nvim_lsp'},
      {name = 'nvim_lua'},
      {name = 'path'},
      {name = 'crates'},
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }
  })

  -- insert '()' after function or method item selection
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

local function setup_lsp_keymaps(bufnr)
  local opts = {noremap = true, silent = true}

  -- local command = 'c'
  -- local insert = 'i'
  local normal = 'n'
  -- local term = 't'
  -- local visual = 'v'
  -- local visual_block = 'x'

  vim.api.nvim_buf_set_keymap(bufnr, normal, '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, normal, '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, normal, 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, normal, 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
end

local function setup_lsp()
  local mason = require('mason')
  mason.setup()

  local mason_lspconfig = require('mason-lspconfig')
  mason_lspconfig.setup()

  local lsp_signature = require('lsp_signature')
  lsp_signature.setup({
    floating_window = false,
    hint_prefix = '',
    select_signature_key = '<c-j>',
    toggle_key = '<c-s>',
  })

  local lspconfig = require('lspconfig')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local servers = {
    'bashls',
    'clangd',
    'rust_analyzer',
    'sumneko_lua',
    'taplo',
  }

  for _, server in pairs(servers) do
    local options = {
      on_attach = function(_, bufnr) setup_lsp_keymaps(bufnr) end,
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    }

    if server == 'sumneko_lua' then
      local additional_options = {
        settings = {
          Lua = {
            diagnostics = {
              globals = {'vim'}
            }
          }
        }
      }

      options = vim.tbl_deep_extend('force', additional_options, options)
    end

    if server == 'rust_analyzer' then
      local additional_options = {
        settings = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy'
            }
          }
        }
      }

      options = vim.tbl_deep_extend('force', additional_options, options)
    end

    lspconfig[server].setup(options)
  end

  -- integrate builtin lsp with tags
  vim.cmd('set tagfunc=v:lua.vim.lsp.tagfunc')
end

local function setup_telescope()
  local telescope = require('telescope')
  local actions = require('telescope.actions')

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ['<c-b>'] = actions.preview_scrolling_up,
          ['<c-f>'] = actions.preview_scrolling_down,
          ['<c-j>'] = actions.move_selection_next,
          ['<c-k>'] = actions.move_selection_previous,
        }
      },
      layout_strategy = 'bottom_pane',
    },
  })

  telescope.load_extension('fzf')
  telescope.load_extension('ui-select')
end

local function setup_treesitter()
  local configs = require('nvim-treesitter.configs')

  configs.setup({
    ensure_installed = 'all',
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,

      -- due to https://github.com/nvim-treesitter/nvim-treesitter/issues/2916
      disable = {'markdown'},
    }
  })
end

local function setup_filetree()
  local filetree = require('nvim-tree')

  filetree.setup({
    hijack_cursor = true,
    open_on_setup = true,
    open_on_tab = true,
    reload_on_bufenter = true,
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    diagnostics = {
      enable = false,
    },
    filters = {
      dotfiles = true,
      custom = {'.git'},
    },
    git = {
      enable = false,
    },
    renderer = {
      group_empty = true,
      full_name = true,
    },
    view = {
      side = 'left',
      width = 35,
      signcolumn = 'no',
    },
  })
end

local function setup_autocmds(working)
  vim.cmd [[
    augroup general_settings
    autocmd!
    autocmd BufRead,BufNewFile README setlocal filetype=markdown
    autocmd FileType gitcommit,hgcommit setlocal spell textwidth=72
    autocmd FileType markdown,vimwiki setlocal spell comments+=b:>
    autocmd FileType c,cpp setlocal commentstring=//\ %s
    augroup end
  ]]

  -- resize buffesr on vim window resize
  vim.cmd [[
    augroup resize_buffers
    autocmd!
    autocmd VimResized * tabdo wincmd =
    augroup end
  ]]

  -- load vim configuration on file save
  vim.cmd [[
    augroup vim_configuration
    autocmd!
    autocmd BufWritePost init.lua source ~/.config/nvim/init.lua | PackerCompile
    augroup end
  ]]

  -- return to the same line when you reopen a file
  vim.cmd [[
    augroup line_return
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line('$') |
        \     execute 'normal! g`"zvzz' |
        \ endif
    augroup end
  ]]

  -- apply xresources file on save
  vim.cmd [[
    augroup xresources
    autocmd!
    autocmd BufWritePost *Xresources !xrdb %
    augroup end
  ]]

  -- automatically delete all trailing whitespace and newlines at end of file on save
  vim.cmd [[
    augroup trailing_whitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritepre * %s/\n\+\%$//e
    augroup end
  ]]

  -- add formats for speeddating plugin
  vim.cmd [[
    augroup speeddating
    autocmd!
    autocmd VimEnter * SpeedDatingFormat %A, %B %d, %Y
    autocmd VimEnter * SpeedDatingFormat %B %d, %Y
    augroup end
  ]]

  -- autoclose nvim-tree if it's the last buffer open
  vim.cmd [[
    augroup autoclose_nvim_tree
    autocmd!
    autocmd BufEnter * ++nested
      \ if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() |
      \   quit |
      \ endif
    augroup end
  ]]

  -- format code on save
  -- use vim-codefmt while working, otherwise lsp formatting
  vim.g.rustfmt_autosave = 1
  if working then
    vim.cmd [[
      let g:gn_path = systemlist('source ~/code/fuchsia/tools/devshell/lib/vars.sh && echo $PREBUILT_GN')[0]

      augroup formatting
      autocmd!
      autocmd FileType gn ++once execute ':Glaive codefmt gn_executable=' . g:gn_path
      autocmd FileType bzl AutoFormatBuffer buildifier
      autocmd FileType c,cpp AutoFormatBuffer clang-format
      autocmd FileType gn AutoFormatBuffer gn
      autocmd FileType go AutoFormatBuffer gofmt
      autocmd FileType markdown AutoFormatBuffer mdformat
      autocmd FileType proto AutoFormatBuffer protofmt
      autocmd FileType python AutoFormatBuffer pyformat
      autocmd FileType rust AutoFormatBuffer rustfmt
      autocmd FileType sh AutoFormatBuffer shfmt
      augroup end
    ]]
  else
    vim.cmd [[
      augroup formatting
      autocmd!
      autocmd BufWritePre *.h,*.cc lua vim.lsp.buf.formatting_sync()
      augroup end
    ]]
  end
end

local function setup_oscyank()
  local osc52 = require('osc52')
  osc52.setup({
    silent = true,
    trim = true,
  })

  local copy = function(lines, _)
    osc52.copy(table.concat(lines, '\n'))
  end

  local paste = function()
    return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
  end

  vim.g.clipboard = {
    name = 'osc52',
    copy = {['+'] = copy, ['*'] = copy},
    paste = {['+'] = paste, ['*'] = paste},
  }
end

local function main()
  local working = at_work()

  set_options()
  set_keymaps()
  install_plugins(working)
  setup_completions()
  setup_lsp()
  setup_telescope()
  setup_treesitter()
  setup_filetree()
  setup_autocmds(working)
  setup_oscyank()

  vim.cmd('colorscheme base16-default-dark')

  -- single pixel window separator lines
  vim.cmd('highlight WinSeparator guibg=None')

  if working then
    vim.cmd('source ~/code/fuchsia/scripts/vim/fuchsia.vim')
  end
end

main()
