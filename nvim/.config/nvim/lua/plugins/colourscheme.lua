return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- load before other plugins so colours apply first
    opts = {
      flavour = "macchiato",
      integrations = {
        bufferline = true,
        mason = true,
        snacks = true,
        treesitter_context = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
