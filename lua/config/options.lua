-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.clipboard = "unnamedplus"
vim.g.ai_cmp = false

-- Dedicated Python for Neovim's remote-plugin host (molten needs
-- pynvim + jupyter_client here). Created by install_script.sh.
-- This is separate from your project venv: code still runs in whatever
-- kernel you register from the project (see README workflow).
local nvim_py = vim.fn.expand("~/.venvs/neovim/bin/python3")
if vim.fn.executable(nvim_py) == 1 then
  vim.g.python3_host_prog = nvim_py
end
