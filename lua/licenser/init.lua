local config = require "licenser.config"
local utils = require "licenser.utils"

local M = {}

function M.setup(opts)
  config.set(opts)

  vim.api.nvim_create_user_command("Licenser", function(infos)
    local name = infos.fargs[1]

    if vim.tbl_contains(utils.get_list() or {}, name) and #infos.fargs == 1 then
      utils.license_insert(name)
      return
    end

    vim.notify("Choose a valid license.", vim.log.levels.ERROR, { title = "Licenser" })
  end, {
    desc = "Generate license.",
    nargs = "+",
    complete = function(lead_arg, cmd)
      local args = vim.split(cmd, "%s+", { trimempty = true })
      local has_space = string.match(cmd, "%s$")

      if #args == 1 then
        return utils.get_list()
      elseif #args == 2 and not has_space then
        return vim.tbl_filter(function(val)
          return vim.startswith(val, lead_arg)
        end, utils.get_list() or {})
      end
    end,
  })
end

return M
