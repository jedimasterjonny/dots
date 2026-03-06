return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_format = "fallback",
      },
      formatexpr = true, -- enables gq to use conform
    },
  },
}
