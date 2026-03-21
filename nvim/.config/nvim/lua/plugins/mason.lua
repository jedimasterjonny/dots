return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "lua-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    keys = {
      { "<leader>cd", function() vim.diagnostic.open_float() end, desc = "Show diagnostic" },
      { "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc = "Next diagnostic" },
      { "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc = "Prev diagnostic" },
    },
    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })
      vim.lsp.enable("lua_ls")
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
  },
}
