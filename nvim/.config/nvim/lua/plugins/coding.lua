return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      require("mini.pairs").setup({
        modes = { insert = true, command = true, terminal = false },
      })
    end,
  },
}
