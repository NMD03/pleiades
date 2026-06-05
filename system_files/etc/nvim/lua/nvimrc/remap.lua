vim.g.mapleader = " "
vim.keymap.set("n", "<leader>q", vim.cmd.Ex)

-- Mapping <Leader>f to format the buffer
vim.keymap.set("n", "<Leader>f", function()
  vim.lsp.buf.format({ async = true })
end)

-- Mapping Ctrl-] to jump to definition
vim.api.nvim_buf_set_keymap(0, 'n', '<C-]>',
  '<cmd>lua vim.lsp.buf.definition()<CR>',
  { noremap = true, silent = true })

-- Mapping Ctrl-t to jump back from a definition
vim.api.nvim_buf_set_keymap(0, 'n', '<C-t>',
  '<cmd>lua vim.cmd("normal! <C-o>")<CR>',
  { noremap = true, silent = true })

-- Move highlighted text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- yank to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- nvim-comment
vim.keymap.set({ "n", "v" }, "<leader>kc", ":CommentToggle<cr>")

-- show error messages

local function copy_diag_on_line()
  local bufnr = 0
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(bufnr, { lnum = lnum })

  if #diags == 0 then
    vim.notify("No diagnostics on this line", vim.log.levels.INFO)
    return
  end

  table.sort(diags, function(a, b) return (a.severity or 999) < (b.severity or 999) end)
  local sev_level = { [1] = "Error", [2] = "WARN", [3] = "INFO", [4] = "HINT" }
  local parts = {}

  for _, d in ipairs(diags) do
    local sev = sev_level[d.severity] or tostring(d.severity)
    local msg = (d.message or ""):gsub("\r", ""):gsub("\n", " ")
    table.insert(parts, string.format("%s: %s", sev, msg))
  end

  local msgs = table.concat(parts, "\n")

  -- copy to system clipboard (+) and unnamed register (")
  vim.fn.setreg("+", msgs)
  vim.fn.setreg('"', msgs)
  vim.notify("Copied diagnostic to clipboard", vim.log.levels.INFO)
end

-- IMPORTANT: do NOT set nowait=true on "gl" or "glc"/"glg" won't work reliably.
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "glc", copy_diag_on_line, { desc = "Copy line diagnostic" })
vim.keymap.set("n", "glg", "<cmd>SignifyToggle<CR>", { desc = "Toggle Signify" })

-- clear highlighting with esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })
