return {
  "nosduco/remote-sshfs.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {},
  keys = {
    { "<leader>rc", "<cmd>RemoteSSHFSConnect<cr>",    desc = "Remote Connect" },
    { "<leader>rd", "<cmd>RemoteSSHFSDisconnect<cr>", desc = "Remote Disconnect" },
    { "<leader>rf", "<cmd>RemoteSSHFSFindFiles<cr>",  desc = "Remote Find Files" },
    { "<leader>rg", "<cmd>RemoteSSHFSLiveGrep<cr>",   desc = "Remote Live Grep" },
  },
}
