local config = require "licenser.config"

local M = {}

function M.absolute_value(value)
  if type(value) == "function" then
    return value()
  end

  return value
end

function M.templates_path()
  local current_file = vim.fs.normalize(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h"))
  current_file, _ = current_file:gsub("utils", "templates")
  return current_file
end

function M.unique(list)
  local hash = {}
  for _, key in ipairs(list) do
    hash[key] = true
  end
  return vim.tbl_keys(hash)
end

function M.get_list()
  local plugin_path = M.templates_path()
  local user_path = config.opts.user_licenses

  local user_licenses = vim.fn.isdirectory(user_path) > 0 and vim.fn.readdir(user_path) or {}
  local plugin_licenses = vim.fn.isdirectory(plugin_path) > 0 and vim.fn.readdir(plugin_path) or {}

  local all_licenses = M.unique(vim.list_extend(plugin_licenses, user_licenses))

  if not vim.tbl_isempty(all_licenses) then
    return vim.tbl_map(function(file)
      return file:gsub("%.txt$", "")
    end, all_licenses)
  end

  return nil
end

function M.placeholders(text)
  for key, value in pairs(config.opts.placeholders) do
    key = "<" .. key .. ">"
    text = text:gsub(key, M.absolute_value(value))
  end

  return text
end

function M.get_license(name)
  local user_path = config.opts.user_licenses .. "/" .. name .. ".txt"
  local plugin_path = M.templates_path() .. "/" .. name .. ".txt"

  local path = vim.fn.filereadable(user_path) == 1 and user_path or plugin_path

  local f = io.open(path, "r")
  if f then
    return f:read "*all"
  end

  return nil
end

function M.gen_license(name)
  local license = M.get_license(name)

  if license then
    local lines = vim.split(M.placeholders(license), "\n")

    if vim.fn.empty(lines[#lines]) == 1 then
      lines[#lines] = nil
    end

    return lines
  end

  return nil
end

function M.insert(lines)
  if not vim.api.nvim_buf_get_option(0, "modifiable") then
    vim.notify("The current buffer cannot be modified.", vim.log.levels.WARN, { title = "Licenser" })
    return
  end

  local check_lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
  if check_lines[1] ~= "" and check_lines[2] then
    table.insert(lines, "")
  end

  vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

function M.major_line(lines)
  local major = 0
  for _, line in pairs(lines) do
    major = math.max(major, #line)
  end
  return major
end

function M.normalize(lines)
  local major = M.major_line(lines)

  for index, line in pairs(lines) do
    lines[index] = line .. (" "):rep(major - #line)
  end

  return lines
end

function M.gen_comment(lines)
  lines = M.normalize(lines)

  return vim.tbl_map(function(line)
    return vim.trim((vim.bo.commentstring):format(" " .. line .. " "))
  end, lines)
end

function M.license_insert(name)
  local license = M.gen_license(name)

  if vim.bo.commentstring ~= "" then
    license = M.gen_comment(license)
  end

  M.insert(license)
end

function M.test(name)
  M.license_insert(name)
end

return M
