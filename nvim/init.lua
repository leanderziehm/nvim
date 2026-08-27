-- ====================================================================
-- MAIN CONFIG (Baked into container: plugins, keybinds, LSPs, themes)
-- ====================================================================
require("lazy").setup(...)
vim.opt.number = true

-- ====================================================================
-- OPTIONAL LOCAL OVERRIDES
-- ====================================================================
local overrides_path = "/home/editor/.config/nvim/overrides.lua"

if vim.fn.filereadable(overrides_path) == 1 then
  -- Load local settings to override baked defaults
  dofile(overrides_path)
end
