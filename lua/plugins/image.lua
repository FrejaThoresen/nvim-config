return {
  {
    "3rd/image.nvim",
    version = "1.1.0", -- pin version for reliability with molten (see molten Not-So-Quick-Start-Guide)
    opts = {
      backend = "kitty", -- or "ueberzug" or "sixel"
      processor = "magick_cli", -- or "magick_rock"
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup", -- or "inline"
          floating_windows = false, -- if true, images will be rendered in floating markdown windows
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        asciidoc = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          only_render_image_at_cursor_mode = "popup",
          floating_windows = false,
          filetypes = { "asciidoc", "adoc" },
        },
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
        rst = {
          enabled = true,
        },
        typst = {
          enabled = true,
          filetypes = { "typst" },
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = 100, -- required by molten to avoid terminal crashes on large images
      max_height = 12, -- required by molten to avoid terminal crashes on large images
      max_width_window_percentage = math.huge, -- necessary for molten to render output windows correctly
      max_height_window_percentage = math.huge, -- necessary for molten to render output windows correctly
      scale_factor = 1.0,
      kitty_direct_chunk_size = 4096, -- chunk size for direct Kitty graphics protocol transmission
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },
}