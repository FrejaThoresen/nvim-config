return {
    {
      "benlubas/molten-nvim",
      version = "^1.0.0",
      build = ":UpdateRemotePlugins",
      ft = { "python", "markdown" },
      dependencies = { "GCBallesteros/jupytext.nvim" },
      opts = {
        output_window_max_height = 20,
      },
    },
  }