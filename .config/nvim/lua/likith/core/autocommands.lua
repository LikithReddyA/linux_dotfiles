vim.cmd([[
augroup jdtls_lsp
  autocmd!
  autocmd FileType java lua require'likith.core.jdtls'.setup_jdtls_safe()
augroup END
]])
