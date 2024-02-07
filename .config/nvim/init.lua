function string.startswith(haystack, needle)
  return string.sub(haystack, 0, string.len(needle)) == needle
end

function string.endswith(haystack, suffix)
  return string.sub(haystack, -#suffix) == suffix
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

  if string.startswith(hostname, 'fsareshwala-office') then
    return true
  elseif string.startswith(hostname, 'fsareshwala-cloudtop') then
    return true
  end

  return false
end

local function set_options()
  vim.opt.clipboard = 'unnamedplus'
  vim.opt.colorcolumn = '+1'
  vim.opt.copyindent = true
  vim.opt.expandtab = true
  vim.opt.exrc = true
  vim.opt.formatoptions = 'cjlnqrtp]'
  vim.opt.gdefault = true
  vim.opt.ignorecase = true
  vim.opt.inccommand = 'split'
  vim.opt.iskeyword:append('-')
  vim.opt.laststatus = 3 -- enable global status line
  vim.opt.linebreak = true
  vim.opt.list = true
  vim.opt.listchars = {tab = '|-', trail = '-', extends = '>', precedes = '<'}
  vim.opt.matchtime = 3
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
  vim.opt.signcolumn = 'number'
  vim.opt.smartcase = true
  vim.opt.softtabstop = 2
  vim.opt.spellfile:append(vim.fn.glob('~/.config/nvim/spell/en.utf-8.add'))
  vim.opt.spellfile:append(vim.fn.glob('~/personal/vim/en.utf-8.add'))
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.swapfile = false
  vim.opt.tabstop = 2
  vim.opt.textwidth = 100
  vim.opt.timeoutlen = 500
  vim.opt.title = true
  vim.opt.undodir = vim.fn.glob('~/.config/nvim/tmp/undo')
  vim.opt.undofile = true
  vim.opt.updatetime = 300
  vim.opt.virtualedit:append('block')
  vim.opt.wildignore:append({'*.so', '*.o'})
  vim.opt.wildmode = 'list:longest,full'
  vim.opt.writebackup = false

  vim.g.left_sidebar_width = 35
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

  -- navigate splits
  vim.keymap.set(normal, '<c-h>', '<c-w>h', opts)
  vim.keymap.set(normal, '<c-j>', '<c-w>j', opts)
  vim.keymap.set(normal, '<c-k>', '<c-w>k', opts)
  vim.keymap.set(normal, '<c-l>', '<c-w>l', opts)

  -- better window/tab/split controls
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

  -- join paragraph lines together to form a one-lined paragraph
  vim.keymap.set(normal, '<leader>j', 'vap:join<cr>', opts)

  -- file shortcuts
  vim.keymap.set(normal, '<leader>a', '<cmd>ClangdSwitchSourceHeader<cr>', opts)
  vim.keymap.set(normal, '<leader>v', '<cmd>e  ~/.config/nvim/init.lua<cr>', opts)
  vim.keymap.set(normal, '<leader>wk', '<cmd>e ~/personal/career/google.md<cr>', opts)
  vim.keymap.set(normal, '<leader>wj', '<cmd>e ~/personal/journal.md<cr>', opts)

  -- stay at current word when using star search
  vim.keymap.set(normal, '*', function() vim.fn.setreg('/', vim.fn.expand('<cword>')) end, opts)

  -- underline current line when only in normal mode
  vim.keymap.set(normal, 'U', 'YpVr-', opts)
end

local function install_plugins(working)
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  local opts = {noremap = true, silent = true}
  local normal = 'n'
  local visual = 'v'

  require('lazy').setup({
    'kylechui/nvim-surround',   -- motions to surround text with other text
    'ojroques/nvim-osc52',      -- osc52 location independent clipboard
    'tpope/vim-speeddating',    -- ctrl+a and ctrl+x on dates
    'RRethy/nvim-base16',

    -- automatically insert/delete parenthesis, brackets, quotes, etc
    {'windwp/nvim-autopairs', event = "InsertEnter", config = true},

    -- better word motions through long strings
    {'chaoren/vim-wordmotion', init = function() vim.g.wordmotion_spaces = {'_', '-', '.'} end},

    -- motions to comment lines out -- have to do this dance because nvim-comment uses nvim_comment
    -- (underscore) as the main module
    {'terrortylor/nvim-comment', config = true, main = 'nvim_comment'},

    -- better syntax highlighting
    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},

    -- file tree
    {
      'kyazdani42/nvim-tree.lua',
      dependencies = {'kyazdani42/nvim-web-devicons'},
      init = function()
        vim.keymap.set(normal, '<leader>n', '<cmd>AerialClose<cr> | <cmd>NvimTreeToggle<cr>', opts)
        vim.keymap.set(normal, '<leader>l', '<cmd>AerialClose<cr> | <cmd>NvimTreeFindFile<cr>', opts)
      end
    },

    -- file outline
    {
      'stevearc/aerial.nvim',
      opts = {
        layout = {
          width = vim.g.left_sidebar_width,
          default_direction = 'left',
        },
      },
      init = function()
        vim.keymap.set(normal, '<leader>o', '<cmd>NvimTreeClose<cr> | <cmd>AerialToggle!<cr>', opts)
      end
    },

    -- git blame integration
    {
      'FabijanZulj/blame.nvim',
      init = function()
        vim.keymap.set(normal, '<leader>b', '<cmd>ToggleBlame virtual<cr>', opts)
      end
    },

    -- align line content
    {
      'Vonr/align.nvim',
      init = function()
        vim.keymap.set(visual, 'a', function() require('align').align_to_char(1, true) end, opts)
      end
    },

    -- add a debug print line in the code
    {
      'andrewferrier/debugprint.nvim',
      init = function()
        vim.keymap.set(normal, '<leader>d', function()
          return require('debugprint').debugprint({variable = true})
        end, {expr = true})
      end
    },

    -- telescope: fuzzy finder over files, commands, lists, etc
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
        'nvim-telescope/telescope-ui-select.nvim',
      },
      init = function()
        vim.keymap.set(normal, '<leader>e', '<cmd>Telescope find_files<cr>', opts)
        vim.keymap.set(normal, '<leader>f', '<cmd>Telescope live_grep<cr>', opts)
        vim.keymap.set(normal, '<leader>g', '<cmd>Telescope grep_string<cr>', opts)
        vim.keymap.set(normal, '<leader>z', '<cmd>Telescope spell_suggest<cr>', opts)
        vim.keymap.set(normal, '<leader>x', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', opts)
      end
    },

    -- completion engine
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp', -- lsp based completions
        'hrsh7th/cmp-nvim-lua', -- neovim lua api
        'hrsh7th/cmp-path', -- filesystem paths
        'hrsh7th/cmp-nvim-lsp-signature-help', -- function signatures
        'L3MON4D3/LuaSnip', -- nvim-cmp requires a snippet engine for expansion
        'saadparwaiz1/cmp_luasnip', -- completion source for luasnip
      },
    },

    -- language server protocol
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
      init = function()
        vim.keymap.set(normal, 'gd', '<cmd>Telescope lsp_definitions<cr>', opts)
        vim.keymap.set(normal, 'gi', '<cmd>Telescope lsp_implementations<cr>', opts)
        vim.keymap.set(normal, 'gr', '<cmd>Telescope lsp_references<cr>', opts)
        vim.keymap.set(normal, 'gf', '<cmd>Telescope lsp_incoming_calls<cr>', opts)
      end
    },

    -- golang integration
    {'fatih/vim-go', ft = 'go'},

    -- rust integration
    {'rust-lang/rust.vim', ft = 'rust'},
    {
      'saecki/crates.nvim',
      event = 'BufRead Cargo.toml',
      dependencies = {'nvim-lua/plenary.nvim'}
    },

    -- work plugins
    {dir = '~/code/fuchsia/tools/fidl/editors/vim', enabled = working},
    {dir = '~/code/emboss/integration/vim/ft-emboss', enabled = working},

    -- fuchsia build system
    {
      url = 'https://gn.googlesource.com/gn',
      enabled = working,
      init = function()
        vim.opt.rtp:prepend('misc/vim')
      end
    },

    -- code formatting
    {
      'google/vim-codefmt',
      enabled = working,
      dependencies = {
        'google/vim-maktaba',
        {'google/vim-glaive', config = function() vim.cmd('call glaive#Install()') end},
      },
    },
  })
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
      {name = 'nvim_lsp_signature_help'},
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

local function setup_lsp()
  local mason = require('mason')
  mason.setup()

  local mason_lspconfig = require('mason-lspconfig')
  mason_lspconfig.setup()

  local lspconfig = require('lspconfig')
  local lspconfig_util = require('lspconfig/util')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')

  local servers = {
    'bashls',
    'clangd',
    'gopls',
    'rust_analyzer',
    'lua_ls',
    'taplo',
  }

  local setup_lsp_keymaps = function(bufnr)
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

  for _, server in pairs(servers) do
    local options = {
      on_attach = function(_, bufnr)
        setup_lsp_keymaps(bufnr)
      end,
      on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = false
      end,
      capabilities = cmp_nvim_lsp.default_capabilities()
    }

    if server == 'clangd' then
      if string.endswith(vim.fn.getcwd(), 'pigweed') then
        local additional_options = {
          cmd = {
            '/usr/local/google/home/fsareshwala/code/pigweed/environment/cipd/packages/pigweed/bin/clangd',
            '--compile-commands-dir=/usr/local/google/home/fsareshwala/code/pigweed/.pw_ide/.stable',
            '--query-driver=/usr/local/google/home/fsareshwala/code/pigweed/environment/cipd/packages/pigweed/bin/*,/usr/local/google/home/fsareshwala/code/pigweed/environment/cipd/packages/arm/bin/*',
            '--background-index',
            '--clang-tidy',
          }
        }

        options = vim.tbl_deep_extend('force', additional_options, options)
      end
    end

    if server == 'lua_ls' then
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

    if server == 'gopls' then
      local additional_options = {
        cmd = {'gopls', 'serve'},
        filetypes = {'go', 'gomod'},
        root_dir = lspconfig_util.root_pattern('go.work', 'go.mod', '.git'),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },

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
      width = vim.g.left_sidebar_width,
      signcolumn = 'no',
    },
  })

  local filetree_api = require('nvim-tree.api')
  filetree_api.tree.open()
end

local function setup_autocmds(working)
  local general_settings = vim.api.nvim_create_augroup('general_settings', {clear = true})
  vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = {'README'},
    group = general_settings,
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.filetype = 'markdown'
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'gitcommit', 'hgcommit'},
    group = general_settings,
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.textwidth = 72
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'markdown'},
    group = general_settings,
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.comments:append('b:>')
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'c', 'cpp'},
    group = general_settings,
    callback = function()
      vim.opt_local.commentstring = '// %s'
    end
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = {'go'},
    group = general_settings,
    callback = function()
      vim.opt_local.nolist = true
    end
  })

  vim.api.nvim_create_autocmd('BufRead', {
    pattern = {'*.gn', '*.gni'},
    group = general_settings,
    callback = function()
      vim.opt_local.filetype = 'gn'
    end
  })

  if working then
    local work_settings = vim.api.nvim_create_augroup('work_settings', {clear = true})
    vim.api.nvim_create_autocmd('FileType', {
      pattern = {'c', 'cpp'},
      group = work_settings,
      callback = function()
        local path = vim.fn.expand('%:p')
        if string.find(path, 'pigweed') then
          vim.opt_local.textwidth = 80
        end
      end
    })
  end

  -- resize buffesr on vim window resize
  vim.cmd [[
  augroup resize_buffers
  autocmd!
  autocmd VimResized * tabdo wincmd =
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
  autocmd BufWritePost .Xresources !xrdb %
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
    autocmd BufWritePre *.h,*.cc,*.go lua vim.lsp.buf.formatting_sync()
    augroup end
    ]]
  end
end

local function setup_oscyank()
  local osc52 = require('osc52')
  osc52.setup({
    silent = true,
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

  -- single pixel window separator lines
  vim.cmd('highlight WinSeparator guibg=None')
  vim.cmd('colorscheme base16-onedark')

  if working then
    vim.cmd('source ~/code/fuchsia/scripts/vim/fuchsia.vim')
  end
end

main()
