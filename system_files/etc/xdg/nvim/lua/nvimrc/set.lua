-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Wrap long lines to next one
vim.opt.wrap = false

-- Search highlighting
vim.api.nvim_command('highlight Search guifg=#0D0C0C guibg=#8BA4B0 gui=none')
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Colors
vim.opt.termguicolors = true

-- Scrolling
vim.opt.scrolloff = 10

-- Updatetime
vim.opt.updatetime = 100

-- Helping lines
vim.opt.colorcolumn = "80"

-- Clipboard support
-- vim.opt.clipboard:append('unnamedplus')

-- Undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Dont continue comments automatically
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "FileType"}, {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions - 'r' - 'o' - 'c'
    end
})

