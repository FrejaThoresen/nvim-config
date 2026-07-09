return {
    {
      "benlubas/molten-nvim",
      version = "^1.0.0",
      build = ":UpdateRemotePlugins",
      ft = { "python", "markdown" },
      dependencies = {
        "GCBallesteros/jupytext.nvim",
        "3rd/image.nvim",
      },
      init = function()
        -- molten is configured via vim.g globals, not setup()/opts
        vim.g.molten_image_provider = "image.nvim"
        vim.g.molten_output_win_max_height = 20
      end,
    },
  }