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
        "omnisharp",
        "csharpier",
        "basedpyright",
        "ruff",
        "typescript-language-server",
        "prettierd",
        "eslint-lsp",
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
      { "<leader>cy", function()
        local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diags == 0 then return end
        local msg = table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n")
        vim.fn.setreg("+", msg)
        vim.notify("Copied diagnostic to clipboard")
      end, desc = "Copy diagnostic" },
      { "<leader>cq", function() vim.diagnostic.setloclist() end, desc = "Diagnostic list" },
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

      vim.lsp.config("omnisharp", {})
      vim.lsp.enable("omnisharp")

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
            },
          },
        },
      })
      vim.lsp.enable("basedpyright")

      vim.lsp.config("ts_ls", {})
      vim.lsp.enable("ts_ls")

      vim.lsp.config("eslint", {})
      vim.lsp.enable("eslint")
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {},
  },
}
