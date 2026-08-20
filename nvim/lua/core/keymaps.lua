--Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local opts = { noremap = true, silent = true }

--Write
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", { desc = "Save file" })

-- Quit
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", { desc = "Quit" })

-- Find and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Resize
vim.keymap.set("n", "<leader>wk", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<leader>wj", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<leader>wh", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<leader>wl", ":vertical resize +2<CR>", { desc = "Increase width" })

-- Window management
vim.keymap.set("n", "<leader><Right>", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader><Down>", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })

-- Window navigation (arrow keys)
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Move to above window" })

--Neotree
vim.keymap.set("n", "\\", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

--Git
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { desc = "Git pull" })
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
