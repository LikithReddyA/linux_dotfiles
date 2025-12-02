return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  config = function()
    local rest = require("rest-nvim")

    -- Setup rest.nvim
    rest.setup({
      result_split_horizontal = false, -- open response in vertical split
      skip_ssl_verification = false,
      encode_url = true, -- encode URL before sending request
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        show_url = true,
        show_http_info = true,
        show_headers = true,
      },
      jump_to_request = false, -- disables jumping to next request
      env_file = ".env", -- path to environment file
      custom_dynamic_variables = nil,
    })

    local opts = { noremap = true, silent = true }

    -- Run the request under the cursor
    vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<CR>", opts)
    -- Open the recent Rest
    vim.keymap.set("n", "<leader>ro", "<cmd>Rest open<CR>", opts)
  end,
}
