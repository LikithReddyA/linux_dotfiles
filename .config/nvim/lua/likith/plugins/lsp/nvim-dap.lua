return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- ui plugins to make debugging simplier
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
  },
  config = function()
    -- gain access to the dap plugin and its functions
    local dap = require("dap")
    -- gain access to the dap ui plugin and its functions
    local dapui = require("dapui")

    -- Setup the dap ui with default configuration
    dapui.setup()
    require("nvim-dap-virtual-text").setup()
    -- setup an event listener for when the debugger is launched
    dap.listeners.before.launch.dapui_config = function()
      -- when the debugger is launched open up the debug ui
      dapui.open()
    end

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- Custom DAP signs (icons)
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DiagnosticError", linehl = "", numhl = "" })
    -- ─────────────────────────────────────────────
    -- 🔑 KEYMAPS
    -- ─────────────────────────────────────────────
    local opts = { noremap = true, silent = true, desc = "" }

    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug: [T]oggle Breakpoint" })
    vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug: [S]tart/Continue" })
    vim.keymap.set("n", "<leader>dc", dapui.close, { desc = "[D]ebug: [C]lose UI" })

    -- 🧭 Step controls
    vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "[D]ebug: Step [O]ver" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]ebug: Step [I]nto" })
    vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "[D]ebug: Step [U]p/Out" })
    vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "[D]ebug: [R]estart" })
    vim.keymap.set("n", "<leader>dq", function()
      dap.terminate()
      dapui.close()
    end, { desc = "[D]ebug: [Q]uit/Terminate" })

    -- 🧠 Evaluate expressions (hover)
    vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "[D]ebug: [E]valuate" })

    -- 💥 Conditional breakpoint
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "[D]ebug: Set Conditional [B]reakpoint" })

    -- 🪟 Toggle dap-ui manually
    vim.keymap.set("n", "<leader>dui", dapui.toggle, { desc = "[D]ebug: Toggle [UI]" })

    -- Optional: repl
    vim.keymap.set("n", "<leader>drp", dap.repl.open, { desc = "[D]ebug: Open [R]E[P]L" })
  end,
}
