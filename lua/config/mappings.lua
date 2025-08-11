local M = {}
local map = vim.keymap.set
local opts = {noremap = true, silent = true}


-- Movement --
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "df", "<C-t><C-t>")
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "<leader>y", "*y")
map("v", "K", ":m .-2<CR>==gv")
map("v", "J", ":m '>+1<CR>==gv")

-- NvimTree --
-- map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>")
-- map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>")
-- map("n", "<leader>a", "ggVG")
-- map("n", "<leader>p", "+p")
-- map("n", "<C-j>", "20j")
-- map("n", "<C-k>", "20k")
-- map("v", "p", "_dP")

-- Bufferline
map("n", "<C-w>", ":BufDel<CR>")
map("n", "<Tab>", ":BufferLineCycleNext<CR>")
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")

-- Telescope -- 
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>fb', ':Telescope current_buffer_fuzzy_find<CR>')
vim.keymap.set('n', '<leader>fy', 
    function()
        vim.cmd('normal! b')
        vim.cmd('normal! yw')
        local word = vim.fn.getreg('"'):gsub("%s+$", "")
        builtin.grep_string({search = word})
    end
)

-- Comments --
map("n", "<leader>/", 
    function()
        require("Comment.api").toggle.linewise.current()
    end)
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- Hop --
map("n", "f", ":HopWord<CR>")
vim.cmd("hi HopNextKey guifg=#ff9900")
vim.cmd("hi HopNextKey1 guifg=#ff9900")
vim.cmd("hi HopNextKey2 guifg=#ff9900")

-- LSP --

-- terminal mode --
map("t", "<Esc><Esc>", '<Cv-><C-n>')
vim.api.nvim_set_keymap("t", "<Esc><Esc>", [[<C-\><C-N>]], {noremap=true, silent=true})

-- oil --
map("n", "<C-n>", "<cmd>Oil<CR>")
