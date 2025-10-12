return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = {"~/","~/Downloads"},
    })

    local keymap = vim.keymap

    keymap.set("n","<leader>wr","<cmd>AutoSession restore<CR>", {desc = "Restore session for cwd"})
    keymap.set("n","<leader>ws","<cmd>AutoSession save<CR>", {desc = "Save session for auto session root dir"})
  end,

  -- lazy = false,
  --
  -- ---enables autocomplete for opts
  -- ---@module "auto-session"
  -- ---@type AutoSession.Config
  -- opts = {
  --   suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --   -- log_level = 'debug',
  -- },
}
