return {
  {
    "GCBallesteros/jupytext.nvim",
    lazy = false, -- do NOT lazy load, otherwise notebooks open as JSON
    opts = {
      -- markdown representation: code cells become ```python fences,
      -- which is what molten + image.nvim render best
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    },
  },
}