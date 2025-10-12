return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      mode = "buffers",
      separator_style = "thin",
    },
  },
}
-- {
--   "akinsho/bufferline.nvim",
--   optional = true,
--   opts = function(_, opts)
--     if (vim.g.colors_name or ""):find("catppuccin") then
--       opts.highlights = require("catppuccin.special.bufferline").get_theme()
--     end
--   end,
-- }
