-- ==============================
--            Theme
-- ==============================
-- Theme can be set with environment variables

THEME_VAR = "NVIM_THEME"
TRANSPARENCY_VAR = "NVIM_TRANSPARENCY"

local function in_table(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local all_themes = vim.fn.getcompletion("", "color")
local theme = os.getenv(THEME_VAR)
local found = false
if in_table(all_themes, theme) then
    found = true
end

if not found then
    print(string.format("Theme %s not found", theme))
    return
end

local transparency_str = os.getenv(TRANSPARENCY_VAR)
if transparency_str ~= nil then
    transparency_str = string.lower(transparency_str)
end

-- defaults to non-transparent
local transparency = false
if transparency_str == "true" then
    transparency = true
end

-- Custom configuration for some themes
-- Transparency will probably only work with these
if theme == "rose-pine" then
    require("rose-pine").setup({
        styles = {
            italic = false,
            transparency = transparency,
        },
    })
elseif theme == "gruvbox" then
    require("gruvbox").setup({
        transparent_mode = transparency,
    })
elseif theme == "catppuccin" then
    require("catppuccin").setup({
        -- flavour = "mocha",
        transparent_background = transparency,
    })
elseif theme == "tokyonight" then
    require("tokyonight").setup({
        transparent = transparency
    })
elseif theme == "ayu" then
    require('ayu').setup({
        overrides = {
            Normal = { bg = "None" },
            NormalFloat = { bg = "none" },
            ColorColumn = { bg = "None" },
            SignColumn = { bg = "None" },
            Folded = { bg = "None" },
            FoldColumn = { bg = "None" },
            CursorLine = { bg = "None" },
            CursorColumn = { bg = "None" },
            VertSplit = { bg = "None" },
        },
    })
end

-- set the colorscheme
vim.cmd.colorscheme(theme)
