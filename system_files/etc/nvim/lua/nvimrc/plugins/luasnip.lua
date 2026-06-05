return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",

  dependencies = { "rafamadriz/friendly-snippets" },

  config = function()
    local ls = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Add custom snippets
    local snippet_paths = vim.fn.stdpath("config") .. "/lua/nvimrc/snippets/"
    for _, file in ipairs(vim.fn.glob(snippet_paths .. "*.lua", true, true)) do
      local ft = vim.fn.fnamemodify(file, ":t:r") -- Get filename without extension
      ls.add_snippets(ft, require("nvimrc.snippets." .. ft))
    end

    vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
  end
}
