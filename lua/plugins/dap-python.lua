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

      -- Keep the debug session alive after the program exits.
      dap.defaults.fallback.terminate_afterwards = false

      -- Resolve python: prefer the activated venv ($VIRTUAL_ENV), then
      -- .venv in the project root, then system python3.
      local function venv_python()
        local venv = vim.env.VIRTUAL_ENV
        if venv and vim.fn.filereadable(venv .. "/bin/python") == 1 then
          return venv .. "/bin/python"
        end
        local root = vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()
        local local_venv = root .. "/.venv/bin/python"
        if vim.fn.filereadable(local_venv) == 1 then
          return local_venv
        end
        return "python3"
      end

      -- Resolve workspace root from the current buffer, so relative paths
      -- in your code work regardless of where nvim was launched from.
      local function workspace_root()
        return vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()
      end

      dap_python.setup(venv_python())

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch file (workspace, PYTHONPATH)",
        program = "${file}",
        cwd = workspace_root,
        pythonPath = venv_python,
        env = {
          PYTHONPATH = workspace_root,
          VIRTUAL_ENV = vim.env.VIRTUAL_ENV or "",
        },
        justMyCode = false,
      })
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Launch module",
        module = function()
          return vim.fn.input("Module: ")
        end,
        cwd = workspace_root,
        pythonPath = venv_python,
        env = {
          PYTHONPATH = workspace_root,
          VIRTUAL_ENV = vim.env.VIRTUAL_ENV or "",
        },
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      local dap = require("dap")
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
      return opts
    end,
  },
}
