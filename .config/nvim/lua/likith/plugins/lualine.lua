return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    lualine.setup({
      options = {
        -- Use web devicons if you have a nerdfont installed
        icons_enabled = true,
        -- Separate components of lua line with chevrons
        component_separators = { left = "", right = "" },
        -- Separate sections with solid triangles
        section_separators = { left = "", right = "" },
        -- disable the status line and winbar
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        -- Don't focus lualine on NvimTree
        ignore_focus = { "NvimTree" },
        -- Always divide lualine in the middle
        always_divide_middle = true,
        -- Disable global status
        globalstatus = false,
        -- Refresh every 1000 miliseconds
        -- refresh = {
        --   statusline = 1000,
        --   tabline = 1000,
        --   winbar = 1000,
        -- },
      },
      sections = {
        -- display the current mode in section a
        lualine_a = { "mode" },
        -- display the current git branch, git differences, and any code diagnostics in section b
        lualine_b = { "branch", "diff", "diagnostics" },
        -- display the filename in section c
        lualine_c = { "filename" },
        -- display the lazy updates, file encoding type, os, and filetype in section x
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
        -- display where you are at in the file in section y
        lualine_y = { "location" },
        -- display exact location of the cursor in section z
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },

      -- Setup what each section will contain in inactive buffers
      inactive_sections = {
        -- display nothing in sections a and b
        lualine_a = {},
        lualine_b = {},
        -- display the file name in section c
        lualine_c = { "filename" },
        -- display the exact location of the cursor in section x
        lualine_x = { "location" },
        -- display nothing in sections y and z
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
