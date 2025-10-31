return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- recommended settings from nvim-tree documentation
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup { -- BEGIN_DEFAULT_OPTS
      view = {
        number = false,
        relativenumber = false,
        side = "left",
        signcolumn = "yes",
        width = 30,
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 30,
            height = 30,
            row = 1,
            col = 1,
          },
        },
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },
    } -- END_DEFAULT_OPTS

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", {desc= "Toggle file explorer"})
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", {desc= "Toggle file explorer with the current file"})
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", {desc= "Collapse file explorer"})
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", {desc= "Refresh file explorer"})
  end,
}
