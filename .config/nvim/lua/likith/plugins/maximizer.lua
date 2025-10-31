return {
  "0x00-ketsu/maximizer.nvim",
  config = function()
    local keymap = vim.keymap
    keymap.set("n","<leader>sm",'<cmd>lua require("maximizer").toggle()<CR>',{desc="Maximize/minimize a split"})
    require("maximizer").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
}
