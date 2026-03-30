return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- main branch API: install() instead of opts.ensure_installed
    config = function()
      require("nvim-treesitter").install({ "lua", "typescript", "tsx", "javascript", "c_sharp", "python" })
    end,
  },
}
