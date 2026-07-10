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
      vim.g.molten_auto_open_output = false -- open with <leader>jo instead
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true -- show output as virtual text below the cell
      vim.g.molten_virt_lines_off_by_1 = true -- output appears below the ``` fence
    end,
    keys = {
      -- <leader>j = "jupyter". Shows up in which-key.
      { "<leader>ji", ":MoltenInit<CR>", desc = "Init kernel", silent = true },
      { "<leader>je", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator (e.g. je + ip)", silent = true },
      { "<leader>jl", ":MoltenEvaluateLine<CR>", desc = "Evaluate line", silent = true },
      { "<leader>jr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell", silent = true },
      { "<leader>jj", ":<C-u>MoltenEvaluateVisual<CR>gv", mode = "v", desc = "Evaluate selection", silent = true },
      { "<leader>jo", ":noautocmd MoltenEnterOutput<CR>", desc = "Enter/open output window", silent = true },
      { "<leader>jh", ":MoltenHideOutput<CR>", desc = "Hide output", silent = true },
      { "<leader>jd", ":MoltenDelete<CR>", desc = "Delete cell", silent = true },
      { "<leader>jn", ":MoltenNext<CR>", desc = "Next cell", silent = true },
      { "<leader>jp", ":MoltenPrev<CR>", desc = "Previous cell", silent = true },
      { "<leader>jx", ":MoltenInterrupt<CR>", desc = "Interrupt kernel", silent = true },
      { "<leader>jR", ":MoltenRestart!<CR>", desc = "Restart kernel", silent = true },
    },
    config = function()
      -- ── Auto import/export of .ipynb output chunks ─────────────
      -- (from molten's Notebook-Setup guide)

      -- Install ipykernel into the project .venv and register it as a
      -- Jupyter kernel named after the project directory. Handles uv-created
      -- venvs (which have no pip) via `uv pip --python`.
      local function register_kernel(root, name, on_done)
        local py = root .. "/.venv/bin/python"
        local install_cmd
        if vim.fn.executable(root .. "/.venv/bin/pip") == 1 then
          install_cmd = { py, "-m", "pip", "install", "ipykernel" }
        elseif vim.fn.executable("uv") == 1 then
          install_cmd = { "uv", "pip", "install", "--python", py, "ipykernel" }
        else
          vim.notify("Molten: .venv has no pip and 'uv' not found — install ipykernel manually.", vim.log.levels.ERROR)
          return
        end
        vim.notify("Molten: installing ipykernel and registering kernel '" .. name .. "'...", vim.log.levels.INFO)
        vim.system(install_cmd, {}, function(o1)
          if o1.code ~= 0 then
            vim.schedule(function()
              vim.notify("Molten: ipykernel install failed:\n" .. (o1.stderr or ""), vim.log.levels.ERROR)
            end)
            return
          end
          vim.system({ py, "-m", "ipykernel", "install", "--user", "--name", name }, {}, function(o2)
            vim.schedule(function()
              if o2.code ~= 0 then
                vim.notify("Molten: kernel registration failed:\n" .. (o2.stderr or ""), vim.log.levels.ERROR)
                return
              end
              vim.notify("Molten: kernel '" .. name .. "' registered.", vim.log.levels.INFO)
              if on_done then
                on_done()
              end
            end)
          end)
        end)
      end

      -- On opening an .ipynb: require a project .venv, then auto-start the
      -- matching kernel and import saved outputs.
      local imb = function(e)
        vim.schedule(function()
          -- Molten needs a Jupyter kernel from the project venv. Enforce it.
          local root = vim.fs.root(e.buf, { ".venv", "pyproject.toml", ".git" }) or vim.fn.getcwd()
          if vim.fn.isdirectory(root .. "/.venv") == 0 then
            vim.notify(
              "Molten: no .venv found in "
                .. root
                .. "\nA project .venv with ipykernel is required to run notebooks:"
                .. "\n  python3 -m venv .venv   (or: uv venv)"
                .. "\n  source .venv/bin/activate && pip install ipykernel"
                .. '\n  python -m ipykernel install --user --name "$(basename $PWD)"',
              vim.log.levels.WARN
            )
            return
          end

          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            -- fall back to a kernel named after the project directory,
            -- matching `ipykernel install --user --name $(basename <project dir>)`
            kernel_name = vim.fn.fnamemodify(root, ":t")
          end

          if not vim.tbl_contains(kernels, kernel_name) then
            local choice = vim.fn.confirm(
              "Molten: no kernel '" .. kernel_name .. "' registered for this project.\n"
                .. "Install ipykernel into .venv and register it now?",
              "&Yes\n&No",
              1
            )
            if choice == 1 then
              register_kernel(root, kernel_name, function()
                vim.cmd(("MoltenInit %s"):format(kernel_name))
                vim.cmd("MoltenImportOutput")
              end)
            end
            return
          end

          vim.cmd(("MoltenInit %s"):format(kernel_name))
          vim.cmd("MoltenImportOutput")
        end)
      end

      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = { "*.ipynb" },
        callback = imb,
      })

      -- catch files opened directly, e.g. `nvim notebook.ipynb`
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function(e)
          if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            imb(e)
          end
        end,
      })

      -- export output chunks back into the .ipynb on save
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })
    end,
  },
}