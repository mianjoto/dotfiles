-- `:Telescope colorscheme` lists available color schemes

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  init = function()
    require('catppuccin').setup {
      -- configuration goes here, refer to https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
    }
    vim.cmd.colorscheme 'catppuccin-mocha'
  end,
}
-- vim: ts=2 sts=2 sw=2 et
