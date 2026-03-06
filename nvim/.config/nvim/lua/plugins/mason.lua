return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    -- ensure_installed is not a mason option; we pass it through opts
    -- and use it in our custom :MasonInstallAll command below
    opts = {
      ensure_installed = {
        "stylua",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local packages = table.concat(opts.ensure_installed, " ")
        vim.cmd("MasonInstall " .. packages)
      end, {})
    end,
  },
}
