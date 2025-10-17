return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  event = "VeryLazy",
  config = function() -- Set default fillchars if not already set
    vim.opt.fillchars:append({
      foldopen = "", -- You can change this to something else if preferred
      foldclose = "",
    })

    -- Get the current fillchars safely
    local fcs = vim.opt.fillchars:get()
    local foldopen = fcs.foldopen or ""
    local foldclose = fcs.foldclose or ""

    -- Function to get fold icon for a given line number
    local function get_fold(lnum)
      if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
        return " "
      end
      return vim.fn.foldclosed(lnum) == -1 and foldopen or foldclose
    end

    -- Global function to be called by statuscolumn
    _G.get_statuscol = function()
      return "%s%l " .. get_fold(vim.v.lnum) .. " "
    end

    -- Set the custom statuscolumn
    vim.o.statuscolumn = "%!v:lua.get_statuscol()"

    vim.o.foldcolumn = "0" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    -- vim.o.statuscolumn = "%!v:lua.get_statuscol()"

    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂 %d "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- str width returned from truncate() may less than 2nd argument, need padding
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end

    -- global handler
    -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
    -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.

    -- buffer scope handler
    -- will override global handler if it is existed
    -- local bufnr = vim.api.nvim_get_current_buf()
    -- require('ufo').setFoldVirtTextHandler(bufnr, handler)
    require("ufo").setup({
      fold_virt_text_handler = handler,
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { "imports", "comment" },
        json = { "array" },
        c = { "comment", "region" },
      },
      close_fold_current_line_for_ft = {
        default = true,
        c = false,
      },
      preview = {
        mappings = {
          switch = "zK",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
    })

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end)
  end,
}
