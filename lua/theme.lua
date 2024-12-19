-- ==============================
--            Theme
-- ==============================
-- the theme and transparency can be specified for the available
-- themes in ~/.config/nvim/theme.conf
-- e.g.
-- theme = catppuccin
-- transparent = false

available_themes = {
  "ayu",
  "catppuccin",
  "rose-pine",
  "gruvbox",
  "nord"
}

default_theme = "catppuccin"
default_transparency = false
theme_file = "~/.config/nvim/theme.conf"

local function in_table(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local function expand_tilde(path)
  local home = os.getenv("HOME")
  if home then
    return path:gsub("^~", home)
  else
    return path
  end
end

local file = io.open(expand_tilde(theme_file), "r")
local theme_ok = true
if not file then
  theme_ok = false
else
  local theme_conf_ops = { "theme", "transparent" }
  for line in file:lines() do
    local key, value = line:match("(%a+)%s*=%s*(.*)")
    if in_table(theme_conf_ops, key) then
      if key == "theme" then
        if in_table(available_themes, value) then
          theme_tmp = value
        else
          theme_ok = false
        end
      elseif key == "transparent" then
        if value == "true" then
          transparent_tmp = true
        elseif value == "false" then
          transparent_tmp = false
        else
          theme_ok = false
        end
      else
        theme_ok = false
      end
    end
  end
end

if theme_ok then
  theme = theme_tmp
  transparent = transparent_tmp
else
  print("Invalid theme file")
  theme = default_theme
  transparent = default_transparency
end

-- set theme
if theme == "catppuccin" then
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = transparent
  })
  vim.cmd.colorscheme "catppuccin"
elseif theme == "ayu" then
  if transparent then
    require('ayu').setup({
      mirage = false,
      overrides = {
        Normal = { bg = "None" },
        ColorColumn = { bg = "None" },
        SignColumn = { bg = "None" },
        Folded = { bg = "None" },
        FoldColumn = { bg = "None" },
        CursorLine = { bg = "None" },
        CursorColumn = { bg = "None" },
        WhichKeyFloat = { bg = "None" },
        VertSplit = { bg = "None" },
      },
    })
  else
    require('ayu').setup({
      mirage = false,
    })
  end
  vim.cmd.colorscheme "ayu-dark"
elseif theme == "rose-pine" then
  require("rose-pine").setup({
    styles = {
      italic = false,
      transparency = transparent,
    },

  })
  vim.cmd.colorscheme "rose-pine"
elseif theme == "nord" then
  vim.cmd.colorscheme "nord"
elseif theme == "gruvbox" then
  require("gruvbox").setup({
      transparent_mode = transparent,
  })
    vim.cmd("colorscheme gruvbox")
end
