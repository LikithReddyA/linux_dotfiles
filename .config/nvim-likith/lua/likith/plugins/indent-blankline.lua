return {
  "lukas-reineke/indent-blankline.nvim",
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { char = "┊" },
  },
  -- Uncomment this code for rainbow indentaion
  -- config = function()
  --   local highlight = {
  --     "RainbowRed",
  --     "RainbowYellow",
  --     "RainbowBlue",
  --     "RainbowOrange",
  --     "RainbowGreen",
  --     "RainbowViolet",
  --     "RainbowCyan",
  --   }
  --
  --   local hooks = require("ibl.hooks")
  --   -- create the highlight groups in the highlight setup hook, so they are reset
  --   -- every time the colorscheme changes
  --
  --   hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#B3595E" }) -- dulled #E06C75
  --     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#BCA262" }) -- dulled #E5C07B
  --     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#4D89C4" }) -- dulled #61AFEF
  --     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#AD7F51" }) -- dulled #D19A66
  --     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#7FA766" }) -- dulled #98C379
  --     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#A05DAE" }) -- dulled #C678DD
  --     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#4695A2" }) -- dulled #56B6C2
  --   end)
  --
  --   require("ibl").setup({ indent = { highlight = highlight } })
  -- end,
  --
  --
  -- For rainbow delimiters
  config = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset
    -- every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    vim.g.rainbow_delimiters = { highlight = highlight }
    require("ibl").setup({ scope = { highlight = highlight } })

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
