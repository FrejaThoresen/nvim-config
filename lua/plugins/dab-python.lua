return {
  {
    "mfussenegger/nvim-dap-python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      -- Point this to the debugpy in your venv
      require("dap-python").setup("python3")
    end,
  },
}
