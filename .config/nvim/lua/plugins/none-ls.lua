return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
      }
    })
    vim.keymmap.set('n', '<leader>gf', vim.lsp.but.format, {})
  end
}
