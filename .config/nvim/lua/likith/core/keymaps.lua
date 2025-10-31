-- Set our leader keybinding to space
-- Anywhere you see <leader> in a keymapping specifies the space key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap -- for conciseness


local opts = {silent = true}

-- Remove search highlights after searching
keymap.set("n","<ESC>",":nohl<CR>",{desc="clear search highlights"},opts)

-- Exit Vim's terminal mode
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" },opts)

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", {desc = "[S]plit window [v]ertically"},opts)
keymap.set("n", "<leader>sh", "<C-w>s", {desc = "[S]plit window [h]orizontally"},opts)
keymap.set("n", "<leader>se", "<C-w>=", {desc = "Make [s]plits [e]qual size"},opts)
keymap.set("n", "<leader>sx", "<cmd>close<CR>", {desc = "[s]plit window [c]lose"},opts)


-- OPTIONAL: Disable arrow keys in normal mode
-- keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Better window navigation
keymap.set("n", "<C-h>", ":wincmd h<cr>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", ":wincmd l<cr>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", ":wincmd j<cr>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", ":wincmd k<cr>", { desc = "Move focus to the upper window" })

-- tab navigation
keymap.set("n", "<leader>tc", ":tabnew<cr>", {desc = "[T]ab [C]reat New"})
keymap.set("n", "<leader>tn", ":tabnext<cr>", {desc = "[T]ab [N]ext"})
keymap.set("n", "<leader>tp", ":tabprevious<cr>", {desc = "[T]ab [P]revious"})
keymap.set("n", "<leader>tx", ":tabclose<cr>", {desc = "[T]ab close"})

-- buffer navigation
keymap.set("n", "<TAB>", ":bnext<cr>", {desc = "[B]uffer [N]ext"})
keymap.set("n", "<S-TAB>", ":bprevious<cr>", {desc = "[B]uffer [P]revious"})
keymap.set("n", "<leader>bx", "<cmd>bdelete<CR>", {desc = "[B]uffer delete"})

-- Stay in indent mode
keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode" })
