
-- =========================================================
-- Clipboard & Mouse
-- =========================================================

vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Highlight Yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})



--- VSCODE LIKE
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })


-- Toggle comment on the current line using the filetype's commentstring
local function toggle_comment()
	local cs = vim.bo.commentstring
	if cs == "" then
		return
	end -- exit if no commentstring defined

	-- extract the actual comment marker (e.g., "%s" -> remove it)
	local marker = cs:gsub("%%s", ""):gsub("^%s*(.-)%s*$", "%1")

	local row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- 0-indexed
	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

	-- Toggle comment
	if line:match("^%s*" .. vim.pesc(marker)) then
		-- Uncomment
		line = line:gsub("^(%s*)" .. vim.pesc(marker) .. "%s?", "%1")
	else
		-- Comment
		line = marker .. " " .. line
	end

	vim.api.nvim_buf_set_lines(0, row, row + 1, false, { line })
end

vim.keymap.set("n", "<C-/>", toggle_comment, { silent = true, desc = "Toggle Comment" })
vim.keymap.set("n", "<C-_>", toggle_comment, { silent = true, desc = "Toggle Comment" }) -- when in tmux


-- VSCODE PASTE AND COPY: CTRL V and CTRL C
vim.keymap.set("i", "<C-v>", "<C-r>+", { silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { silent = true })
vim.keymap.set("v", "<C-v>", '"+p', { silent = true })
vim.keymap.set("v", "<C-z>", 'u', { silent = true })
-- Function to copy like VSCode
local function copy_like_vscode()
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" or mode == "\22" then
		-- If something is visually selected, yank it
		vim.cmd('normal! "+y')
	else
		-- If nothing is selected, yank the whole line
		vim.cmd('normal! "+yy')
	end
end
-- Map Ctrl-C in normal and visual mode
vim.keymap.set({ "n", "v" }, "<C-c>", copy_like_vscode, { silent = true })


-- Restore cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"') -- '"' is the last position mark
		local line = mark[1]
		local col = mark[2]
		local last_line = vim.api.nvim_buf_line_count(0)
		if line > 0 and line <= last_line then
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end,
})




-- Disable Shift+Arrow completely
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Right>", "<Nop>", opts)



-- =========================================================
-- Core UI
-- =========================================================
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
-- vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true
-- THEME TODO

-- =========================================================
-- Search
-- =========================================================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- =========================================================
-- Splits
-- =========================================================
vim.opt.splitbelow = true
vim.opt.splitright = true

-- =========================================================
-- Unified swap / undo / backup directories
-- =========================================================

-- Base data directory (cross-platform safe)
local data_dir = vim.fn.stdpath("data")

-- Ensure directory exists helper
local function ensure_dir(dir)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

-- === Undo ===
local undo_dir = data_dir .. "/undo"
ensure_dir(undo_dir)
vim.o.undofile = true
vim.o.undodir = undo_dir

-- === Swap ===
local swap_dir = data_dir .. "/swap"
ensure_dir(swap_dir)
vim.o.directory = swap_dir

-- === Backup ===
local backup_dir = data_dir .. "/backup"
ensure_dir(backup_dir)
vim.o.backup = true
vim.o.writebackup = true
vim.o.backupdir = backup_dir

-- Optional: more sane defaults
vim.o.undolevels = 1000
vim.o.undoreload = 10000
vim.o.backupcopy = "yes" -- avoid issues with some tools like git
--



------------


vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- THEMES(that-i-like): run, industry, unokai, slate, sorbet, . | torte, unokai, lunaperche, ron, slate, sorbet, industry
-- Set options before colorscheme
-- vim.g.unokai_transparent_background = 0  -- 0 for dark background
-- vim.g.unokai_saturation = 1.2            -- increase saturation
-- vim.g.unokai_contrast = "high"           -- sometimes "low", "medium", "high"
--vim.api.nvim_command('colorscheme unokai')


--vim.api.nvim_command('colorscheme unokai')
--vim.o.background = 'dark'

-- live theme preview with space + t + n
-- Store themes
local themes = vim.fn.getcompletion('', 'color')
local current_index = 1

-- Function to set the theme
local function set_theme(index)
    vim.cmd('colorscheme ' .. themes[index])
    print("Theme: " .. themes[index])
end

-- Cycle forward
_G.NextTheme = function()
    current_index = current_index + 1
    if current_index > #themes then current_index = 1 end
    set_theme(current_index)
end

-- Cycle backward
_G.PrevTheme = function()
    current_index = current_index - 1
    if current_index < 1 then current_index = #themes end
    set_theme(current_index)
end

vim.api.nvim_set_keymap('n', '<leader>tn', ':lua NextTheme()<CR>', { noremap = true, silent = true })

-- CUSTOM THEME

-- mycolors.lua
local vim = vim

-- Define colors
local colors = {
    bg        = "#000000", -- black background
    fg        = "#FFFFFF", -- normal text
    gray      = "#888888", -- special characters, comments, punctuation
    green     = "#A6E22E", -- strings
    blue      = "#66D9EF", -- keywords, for, while, if, etc.
    yellow    = "#fffb00", -- numbers, line numbers
    red       = "#F92672", -- errors, warnings
    purple    = "#AE81FF", -- functions, types
    orange    = "#ffffff", -- constants, special values
    cyan      = "#66D9EF", -- builtins, booleans, nil
    white_transparent = "#FFFFFF80", -- side bar, transparent-ish
}

-- Set general editor colors
vim.cmd("highlight Normal guifg="..colors.fg.." guibg="..colors.bg)
vim.cmd("highlight LineNr guifg="..colors.yellow.." guibg="..colors.bg)
vim.cmd("highlight CursorLineNr guifg="..colors.orange.." guibg="..colors.bg)
vim.cmd("highlight CursorLine guibg=#121212") -- subtle line highlight
-- Cursor colors
--vim.cmd("highlight VertSplit guifg="..colors.white_transparent.." guibg="..colors.bg)

-- Syntax highlighting
vim.cmd("highlight Comment guifg="..colors.gray.." gui=italic")
vim.cmd("highlight Constant guifg="..colors.orange)
vim.cmd("highlight String guifg="..colors.green)
vim.cmd("highlight Character guifg="..colors.green)
vim.cmd("highlight Number guifg="..colors.yellow)
vim.cmd("highlight Boolean guifg="..colors.cyan)
vim.cmd("highlight Identifier guifg="..colors.purple)
vim.cmd("highlight Function guifg="..colors.purple)
vim.cmd("highlight Statement guifg="..colors.blue.." gui=bold") -- for, if, else, return
vim.cmd("highlight Conditional guifg="..colors.blue)
vim.cmd("highlight Repeat guifg="..colors.blue)
vim.cmd("highlight Operator guifg="..colors.gray)
vim.cmd("highlight Type guifg="..colors.purple)
vim.cmd("highlight Keyword guifg="..colors.blue)
vim.cmd("highlight PreProc guifg="..colors.orange)
vim.cmd("highlight Special guifg="..colors.gray)
vim.cmd("highlight Error guifg="..colors.red.." guibg="..colors.bg.." gui=bold")
vim.cmd("highlight Todo guifg="..colors.red.." guibg="..colors.bg.." gui=bold")

-- Extra highlights for UI
vim.cmd("highlight Pmenu guibg=#111111 guifg="..colors.fg)
vim.cmd("highlight PmenuSel guibg=#222222 guifg="..colors.blue)
vim.cmd("highlight Search guibg=#333333 guifg="..colors.yellow)
vim.cmd("highlight Visual guibg=#222222")
vim.cmd("highlight StatusLine guibg=#111111 guifg="..colors.fg)
vim.cmd("highlight StatusLineNC guibg=#111111 guifg="..colors.gray)
vim.cmd("highlight TabLine guibg=#111111 guifg="..colors.gray)
vim.cmd("highlight TabLineSel guibg=#111111 guifg="..colors.blue)
vim.cmd("highlight LineNrAbove guifg="..colors.gray.." guibg="..colors.bg)
vim.cmd("highlight LineNrBelow guifg="..colors.gray.." guibg="..colors.bg)

--vim.o.guicursor = "n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-CursorIM,r-cr:hor20-CursorReplace"