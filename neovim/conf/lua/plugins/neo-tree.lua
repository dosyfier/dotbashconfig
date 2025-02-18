return  {
  -- File Tree window
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["a"] = { "add", config = { show_path = "relative" }},
            ["c"] = { "copy", config = { show_path = "relative" }},
            ["m"] = { "move", config = { show_path = "relative" }},
          }
        },
        filesystem = {
          follow_current_file = { enable = true }
        }
      })
    end,
  },
}
