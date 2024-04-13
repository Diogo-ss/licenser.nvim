local M = {}

M.opts = {
  placeholders = {
    name = "your name",
    author = "your name <your@mail.com>",
    year = function()
      return os.date "%Y"
    end,
  },
  user_licenses = vim.fn.stdpath "config" .. "/lua/templates",
}

function M.set(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

return M
