return {
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

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

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file (workspace)",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pythonPath = venv_python,
          env = { PYTHONPATH = "${workspaceFolder}" },
          justMyCode = false,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch module",
          module = function()
            return vim.fn.input("Module: ")
          end,
          cwd = "${workspaceFolder}",
          pythonPath = venv_python,
          env = { PYTHONPATH = "${workspaceFolder}" },
        },
      }

      -- UI
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
      vim.keymap.set("n", "<leader>du", dap.terminate, { desc = "Toggle DAP UI" })
    end,
  },
}
