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

      dap.defaults.fallback.terminate_afterwards = false

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

      local function workspace_root()
        return vim.fs.root(0, { "pyproject.toml", ".git" }) or vim.fn.getcwd()
      end

      dap_python.setup(venv_python())

      -- Replace nvim-dap-python's defaults so only our configs are available
      dap.configurations.python = {
        {
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
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "launch",
          name = "Launch module",
          module = function()
            return vim.fn.input("Module: ")
          end,
          cwd = workspace_root,
          pythonPath = venv_python,
          env = {
            PYTHONPATH = workspace_root(),
            VIRTUAL_ENV = vim.env.VIRTUAL_ENV or "",
          },
          justMyCode = false,
          console = "integratedTerminal",
        },
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    opts = function(_, opts)
      local dap = require("dap")
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
      dap.listeners.after.event_exited["keep_open"] = function() end
      return opts
    end,
  },
}
