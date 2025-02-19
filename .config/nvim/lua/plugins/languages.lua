return {
  -- golang integration
  { 'fatih/vim-go', ft = 'go' },

  -- rust integration
  { 'rust-lang/rust.vim', ft = 'rust' },
  {
    'saecki/crates.nvim',
    event = 'BufRead Cargo.toml',
  },
}
