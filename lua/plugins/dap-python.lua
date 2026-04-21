return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local dap = require("dap")
      local dap_python = require("dap-python")

      -- Keep the debug session alive after the program exits so you can
      -- inspect variables, scroll the REPL, etc. Terminate manually with
      -- <leader>dt or :DapTerminate.
      dap.defaults.fallback.terminate_afterwards = false

      -- Resolve the venv python in the current workspace
      local function venv_python()
        local cwd = vim.fn.getcwd()
        local venv = cwd .. "/.venv/bin/python"
        if vim.fn.filereadable(venv) == 1 then
          return venv
        end
        return "python3"
      end

      dap_python.setup(venv_python())

      -- Custom launch configurations (merged with defaults from nvim-dap-python)
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file (workspace, PYTHONPATH)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        pythonPath = venv_python,
        env = { PYTHONPATH = "${workspaceFolder}" },
        justMyCode = false,
      })

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch module",
        module = function()
          return vim.fn.input("Module: ")
        end,
        cwd = "${workspaceFolder}",
        pythonPath = venv_python,
        env = { PYTHONPATH = "${workspaceFolder}" },
      })
    end,
  },
}
