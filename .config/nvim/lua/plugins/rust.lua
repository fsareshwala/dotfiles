-- rust integration
return {
  { "rust-lang/rust.vim", ft = "rust" },
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
  },
}
