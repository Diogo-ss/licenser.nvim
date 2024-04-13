## ⚖ Licenser

Create licenses for your projects and files

### Command

Type `Licenser` to show all available licenses.

Ex: `Licenser MIT`

### Setup

<details>
  <summary>📦 Packer.nvim</summary>

```lua
use {
  "Diogo-ss/licenser.nvim",
  cmd = { "Licenser" },
  config = function()
    require "licenser"setup {
    -- add other options.
    }
  end,
}
```

</details>

<details>
  <summary>💤 Lazy.nvim</summary>

```lua
{
  "Diogo-ss/licenser.nvim",
  cmd = { "Licenser" },
  opts = {
    -- add other options.
  },
  config = function(_, opts)
    require("licenser").setup(opts)
  end,
}
```

</details>

### Custom

Add your own licenses by creating a `license_name.txt` file in `~/.config/nvim/lua/templates/`.

If you want to change a standard license of the plugin, create a file with the same name as the license (ex: license_name.txt), so that your version will be prioritized.

### Options

```lua
{
  placeholders = {
    name = "your name",
    author = "your name <your@mail.com>",
    year = function()
      return os.date "%Y"
    end,
    -- add other placeholders
  },
  user_licenses = vim.fn.stdpath "config" .. "/lua/templates",
}
```
