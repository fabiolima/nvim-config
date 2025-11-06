-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<Leader>cp", ":let @+ = expand('%')<cr>")

-- See lua/utils/rspec.lua
vim.keymap.set("n", "<leader>rf", ":RSpecFile<CR>", { desc = "Run RSpec (file) in split" })
vim.keymap.set("n", "<leader>rl", ":RSpecLine<CR>", { desc = "Run RSpec (line) in split" })
vim.keymap.set("n", "<leader>rF", ":RSpecFloatFile<CR>", { desc = "Run RSpec (file) in floating window" })
vim.keymap.set("n", "<leader>rL", ":RSpecFloatLine<CR>", { desc = "Run RSpec (line) in floating window" })
