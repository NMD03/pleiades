return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()

    -- Customize Theme to match kanagawa dragon theme
    local kanagawa_colors = {
      dragonBlack = '#0D0C0C',
      dragonGray = '#A6A69C',
      dragonLightGray = '#C5C9C5',
      dragonBackground = '#282727',
      dragonForeground = '#C8C093',
      dragonRed = '#C4746E',
      dragonGreen = '#87A987',
      dragonYellow = '#C4B28A',
      dragonBlue = '#8BA4B0',
      dragonOrange = '#B6927B',
      inactiveGray = '#625e5a',
    }
    local custom_kanagawa = require 'lualine.themes.wombat'
    custom_kanagawa.normal.a.bg = kanagawa_colors.dragonGray
    custom_kanagawa.normal.a.fg = kanagawa_colors.dragonBlack
    custom_kanagawa.normal.a.gui = 'bold'
    custom_kanagawa.insert.a.bg = kanagawa_colors.dragonRed
    custom_kanagawa.insert.a.fg = kanagawa_colors.dragonBlack
    custom_kanagawa.insert.a.gui = 'bold'
    custom_kanagawa.visual.a.bg = kanagawa_colors.dragonGreen
    custom_kanagawa.visual.a.fg = kanagawa_colors.dragonBlack
    custom_kanagawa.visual.a.gui = 'bold'
    custom_kanagawa.replace.a.bg = kanagawa_colors.dragonBlue
    custom_kanagawa.replace.a.fg = kanagawa_colors.dragonBlack
    custom_kanagawa.replace.a.gui = 'bold'
    -- custom_kanagawa.command.a.bg = kanagawa_colors.dragonGreen
    -- custom_kanagawa.command.a.fg = kanagawa_colors.dragonBlack
    -- custom_kanagawa.command.a.gui = 'bold'
    custom_kanagawa.inactive.a.bg = kanagawa_colors.inactiveGray
    custom_kanagawa.inactive.a.fg = kanagawa_colors.dragonGray
    custom_kanagawa.inactive.a.gui = 'bold'
    custom_kanagawa.inactive.b.bg = kanagawa_colors.inactiveGray
    custom_kanagawa.inactive.b.fg = kanagawa_colors.dragonGray
    custom_kanagawa.inactive.c.bg = kanagawa_colors.inactiveGray
    custom_kanagawa.inactive.c.fg = kanagawa_colors.dragonGray


    require('lualine').setup {
      options = {
        icons_enabled = false,
        -- theme = 'wombat',
        theme = custom_kanagawa,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }
  end
}
