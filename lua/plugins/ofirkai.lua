return {
  {
    'ofirgall/ofirkai.nvim',
    priority = 1000,
    config = function()
      require('ofirkai').setup {}
      vim.cmd.colorscheme 'ofirkai'
    end,
  },
}

