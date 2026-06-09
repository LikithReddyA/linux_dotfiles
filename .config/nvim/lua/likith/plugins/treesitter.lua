return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    local ensure_installed = {
      "lua",
      "javascript",
      "typescript",
      "html",
      "css",
      "bash",
      "vim",
      "json",
      "java",
      "python",
      "http",
    }

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyDone",
      once = true,
      callback = function()
        ts.install(ensure_installed)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        ts.install({ lang })
        pcall(vim.treesitter.start, event.buf, lang)
      end,
    })
  end,
}
