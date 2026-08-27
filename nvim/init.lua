vim.g.mapleader = " "
vim.g.maplocalleader = " "

--  ============================================================
--  DEBUG
--  ============================================================
-- Press a key and it prints the string representation
vim.keymap.set("n", "<F5>", function()
	print(vim.fn.keytrans(vim.fn.getcharstr()))
end, { noremap = true })

--  ============================================================
--  Unmap
--  ============================================================

-- Disable Shift+Arrow completely
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v" }, "<S-Right>", "<Nop>", opts)

-- Treat empty buffers as markdown. (for example when doing: nvim )
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		if vim.bo.buftype == "" and vim.bo.filetype == "" then
			vim.bo.filetype = "markdown"
		end
	end,
})

-- jk or kj to escape insert mode
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true })

--  ============================================================
--  VSCODE LIKE
--  ============================================================
-- MOVE LINE: ALT UP DOWN
vim.keymap.set("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Toggle line wrap: ALT Z
vim.api.nvim_set_keymap("n", "<M-z>", ":set wrap! linebreak!<CR>", { noremap = true, silent = true })
			-- Format buffer using LSP (CTLR+Alt+f)
vim.keymap.set("n", "<M-C-f>", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "LSP format buffer" })

--  ============================================================
--  Comment
--  ============================================================
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

--  ------------------------------------------------------------
--  rename
--  ------------------------------------------------------------
-- Lua version for init.lua
-- vim.api.nvim_set_keymap('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap = true, silent = false })
-- vim.api.nvim_set_keymap('n', '<F2>', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { noremap = true, silent = false })

vim.api.nvim_set_keymap(
	"n",
	"<F2>",
	[[:lua
  local cur = vim.api.nvim_win_get_cursor(0)
  local word = vim.fn.expand('<cword>')
  local new = vim.fn.input('Rename '..word..' to: ')
  if new ~= '' then
    vim.cmd('keepjumps %s/\\<'..word..'\\>/'..new..'/g')
  end
  vim.api.nvim_win_set_cursor(0, cur)
<CR>]],
	{ noremap = true, silent = false }
)

-- vim.keymap.set('n', '<C-l>', ':tabnext<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-h>', ':tabprev<CR>', { noremap = true, silent = true })
-- Move to the next tab
vim.keymap.set("n", "<leader><Tab>", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>", { noremap = true, silent = true })
-- Move to the previous tab
vim.keymap.set("n", "<C-S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true })
-- vim.keymap.set({'n','v'}, 'd', '"_d', { noremap = true, silent = true })

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

--  ============================================================
--  Auto-Completion
--  ============================================================
-- Trigger omni-completion or keyword completion with Ctrl+.
vim.keymap.set("i", "<C-.>", "<C-n>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-.>", "<C-n>", { noremap = true, silent = true })

-- Smart Tab for insert mode completion
vim.keymap.set("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)
	else
		return "\t"
	end
end, { expr = true, noremap = true })

vim.keymap.set("i", "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)
	else
		return "\b"
	end
end, { expr = true, noremap = true })

--  ============================================================
--  Persistence
--  ============================================================
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

--  ============================================================
--  TAB LINES
--  ============================================================
-- make tabs wider
vim.o.tabline = "%!v:lua.MyTabLine()" -- custom tabline function

-- example custom tabline function
function _G.MyTabLine()
	local s = ""
	for i = 1, vim.fn.tabpagenr("$") do
		local buflist = vim.fn.tabpagebuflist(i)
		local winnr = vim.fn.tabpagewinnr(i)
		local bufname = vim.fn.bufname(buflist[winnr])
		if bufname == "" then
			bufname = "[No Name]"
		end
		-- pad the name to make the tab "longer"
		bufname = " " .. bufname .. " "
		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#" .. i .. ":" .. bufname
		else
			s = s .. "%#TabLine#" .. i .. ":" .. bufname
		end
	end
	s = s .. "%#TabLineFill#"
	return s
end

--  ============================================================
--  Terminal
--  ============================================================
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { silent = true })
-- Terminal toggle with Ctrl-J
local term_buf = nil
local term_win = nil

local function toggle_terminal()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)
		term_win = nil
		return
	end
	vim.cmd("botright split")
	vim.cmd("resize 15")

	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.api.nvim_win_set_buf(0, term_buf)
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
	end

	term_win = vim.api.nvim_get_current_win()
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<C-j>", toggle_terminal, { silent = true, desc = "Toggle terminal" })
vim.keymap.set("t", "<C-j>", toggle_terminal, { silent = true, desc = "Toggle terminal" })

--  ============================================================
--  Macros
--  ============================================================
-- qa
-- I-- <Esc>60a=<Esc>
-- o-- Core UI
-- o-- <Esc>60a=<Esc>
-- q
--

--  ============================================================
--  Custom code
--  ============================================================

--  ============================================================
--  VIM WIKI
--  ============================================================
local function smart_gf()
  local api = vim.api
  local fn = vim.fn

  -- Get current line info
  local row = api.nvim_win_get_cursor(0)[1]
  local line = api.nvim_get_current_line()
  local col = fn.col(".")

  -- Get word under cursor
  local word_start = col
  local word_end = col
  while word_start > 1 and line:sub(word_start - 1, word_start - 1):match("[%w_-]") do
    word_start = word_start - 1
  end
  while word_end <= #line and line:sub(word_end, word_end):match("[%w_-]") do
    word_end = word_end + 1
  end
  local word = line:sub(word_start, word_end - 1)

  if word == "" then
    print("No word under cursor")
    return
  end

  -- Determine folder path from nearest preceding headers
  local headers = {}
  for i = row, 1, -1 do
    local l = api.nvim_buf_get_lines(0, i-1, i, false)[1]
    local h = l:match("^(#+)%s*(.-)%s*$")
    if h then
      local level = #h
      local name = l:match("^#+%s*(.-)%s*$"):gsub("%s+", "_"):gsub("[^%w_%-]", ""):lower()
      -- only set if not already set, so we get the closest one
      if not headers[level] then
        headers[level] = name
        -- clear deeper headers
        for j = level + 1, 6 do headers[j] = nil end
      end
    end
  end

  local path_parts = {}
  for i = 1, 6 do
    if headers[i] then
      table.insert(path_parts, headers[i])
    end
  end
  table.insert(path_parts, word:lower() .. ".md")
  local path = table.concat(path_parts, "/")

  -- Create directories if needed
  local dir = fn.fnamemodify(path, ":h")
  if fn.isdirectory(dir) == 0 then
    fn.mkdir(dir, "p")
  end

  -- Create file if it doesn't exist
  if fn.filereadable(path) == 0 then
    fn.writefile({}, path)
    -- Add first line as "# filename" where filename is just the base name without extension
    local filename = word
		fn.writefile({ "# " .. filename, "", "" }, path)
  end

  -- Replace word with Markdown link
  local new_line = line:sub(1, word_start - 1)
            .. "[" .. word .. "](" .. "./" .. path .. ")"
            .. line:sub(word_end)
  api.nvim_set_current_line(new_line)

  -- Open file
  vim.cmd("edit " .. fn.fnameescape(path))
	api.nvim_win_set_cursor(0, {3, 0})
end


local function markdown_gf()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".")
  -- If the line is empty or only spaces, insert a new line
  if line:match("^%s*$") then
    vim.cmd("normal! o")
    return
  end

  -- Search for markdown link [text](path)
  for start_pos, text, path in line:gmatch("()%[([^%]]+)%]%(([^%)]+)%)") do
    local end_pos = start_pos + #("[" .. text .. "](" .. path .. ")") - 1
    if col >= start_pos and col <= end_pos then
      -- Open the file relative to current file
      local current_file = vim.fn.expand("%:p:h")
      local target = vim.fn.fnamemodify(current_file .. "/" .. path, ":p")
      vim.cmd("edit " .. vim.fn.fnameescape(target))
      return
    end
  end

  -- Fallback to normal gf
  vim.cmd("normal! gf")
end


-- Function to set Markdown-specific keymaps
local function set_markdown_keymaps()
  local local_opts = { noremap = true, silent = true, buffer = true }  -- buffer-local
  vim.keymap.set("n", "<CR>", markdown_gf, local_opts)
  vim.keymap.set("n", "<leader><CR>", smart_gf, local_opts)
	vim.keymap.set("n", "<BS>", "<C-o>", local_opts)
	vim.keymap.set("n", "<leader>cf", smart_gf, { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>gf", smart_gf, { noremap = true, silent = true })
end

-- Autocmd to trigger only for Markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = set_markdown_keymaps,
})
vim.keymap.set("n", "<CR>", markdown_gf, { noremap = true, silent = true })

-- Autosave Markdown files on BufLeave and TextChanged
vim.api.nvim_create_autocmd({"BufLeave", "TextChanged", "TextChangedI"}, {
    pattern = "*.md",
    callback = function()
        if vim.bo.modified then
            vim.cmd("silent write")
        end
    end,
})







-- vim.keymap.set('n', '<leader>cf', function()
--     local word = vim.fn.expand('<cWORD>')
--     local path = word:match("%((.-)%)") or word  -- extract text inside parentheses, fallback to word
--     local buf_dir = vim.fn.expand('%:p:h')
--     local abs_path = vim.fn.fnamemodify(path, ':p')  -- try absolute path
--
--     -- if path is not readable, treat as relative to current buffer
--     if vim.fn.filereadable(abs_path) == 0 then
--         abs_path = vim.fn.fnamemodify(buf_dir .. '/' .. path, ':p')
--     end
--
--     if vim.fn.filereadable(abs_path) == 1 then
--         vim.cmd('edit ' .. vim.fn.fnameescape(abs_path))
--     else
--         vim.api.nvim_err_writeln('File not found: ' .. abs_path)
--     end
-- end, { noremap = true, silent = true })

-- Smart gf: prompt to create file if it doesn't exist
-- local function smart_gf()
--   -- Word under cursor (same thing gf uses)
--   local cfile = vim.fn.expand("<cfile>")
--   if cfile == "" then
--     return
--   end
--
--   -- Resolve path relative to current buffer
--   local base_dir = vim.fn.expand("%:p:h")
--   local target = vim.fn.fnamemodify(cfile, ":p", base_dir)
--
--   -- If file exists, just do normal gf
--   if vim.loop.fs_stat(target) then
--     vim.cmd("normal! gf")
--     return
--   end
--
--   -- Prompt user
--   local choice = vim.fn.confirm(
--     ("File does not exist:\n%s\n\nCreate it?"):format(target),
--     "&Yes\n&No",
--     2
--   )
--
--   if choice ~= 1 then
--     return
--   end
--
--   -- Create parent directories if needed
--   local dir = vim.fn.fnamemodify(target, ":h")
--   if vim.fn.isdirectory(dir) == 0 then
--     vim.fn.mkdir(dir, "p")
--   end
--
--   -- Create empty file
--   local fd = io.open(target, "w")
--   if fd then
--     fd:close()
--   end
--
--   -- Open the file
--   vim.cmd("edit " .. vim.fn.fnameescape(target))
-- end
--
-- -- Override gf in normal mode
-- vim.keymap.set("n", "gf", smart_gf, { noremap = true, silent = true })
--

--  ============================================================
--  comments
--  ============================================================
-- ===========================
-- Header Inserter
-- ===========================

--  ============================================================
--  Calculate
--  ============================================================

vim.keymap.set("n", "<leader>cm", function()
	local line = vim.api.nvim_get_current_line()

	if line:sub(1, 1) == "=" then
		local expr = line:sub(2)

		-- Evaluate with Lua
		local ok, result = pcall(load("return " .. expr))
		if ok and result ~= nil then
			vim.api.nvim_set_current_line(line .. " = " .. result)
		else
			vim.api.nvim_echo({ { "Error calculating expression", "ErrorMsg" } }, false, {})
		end
	else
		vim.api.nvim_echo({ { "Line does not start with '='", "WarningMsg" } }, false, {})
	end
end, { noremap = true, silent = true })

local function comment_string()
	local cs = vim.bo.commentstring
	return cs:match("^(.*)%%s") or "--"
end

--  ============================================================
--  Comment headers
--  ============================================================

local function insert_header(level, title)
	if title == "" then
		return
	end

	local comment = comment_string()
	local width = 60
	local symbols = { h1 = "#", h2 = "=", h3 = "-" }
	local sym = symbols[level] or "="

	-- Build the 3-line header
	local line = comment .. " " .. string.rep(sym, width)
	vim.api.nvim_put({ line, comment .. " " .. title, line }, "l", true, true)
end

-- Prompt version: asks for level and title
local function prompt_header()
	local level = vim.fn.input("Header level (h1/h2/h3): ")
	if level ~= "h1" and level ~= "h2" and level ~= "h3" then
		print("Invalid level")
		return
	end
	local title = vim.fn.input("Section: ")
	insert_header(level, title)
end

vim.keymap.set("n", "<leader>cp", prompt_header) -- prompt for level
vim.keymap.set("n", "<leader>cc", function()
	insert_header("h2", vim.fn.input("Comment_Header: "))
end)
vim.keymap.set("n", "<leader>c1", function()
	insert_header("h1", vim.fn.input("H1: "))
end)
vim.keymap.set("n", "<leader>c2", function()
	insert_header("h2", vim.fn.input("H2: "))
end)
vim.keymap.set("n", "<leader>c3", function()
	insert_header("h3", vim.fn.input("H3: "))
end)

-- I would rather do like insert_comment_header("#",30,3)
-- ##############################
--
-- I would rather do like insert_comment_header("comment2","#",5,1)  ----- comment2

-- local function comment_string()
--   local cs = vim.bo.commentstring
--   return cs:match("^(.*)%%s") or "--"
-- end
--
-- vim.keymap.set("n", "<leader>cc", function()
--   local width = 60
--   local comment = comment_string()
--   local title = vim.fn.input("Section: ")
--
--   if title == "" then return end
--
--   local line = comment .. " " .. string.rep("=", width)
--   vim.api.nvim_put({ line, comment .. " " .. title, line }, "l", true, true)
-- end)

-- =========================================================
-- Core UI
-- =========================================================
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
-- vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true

-- =========================================================
-- Clipboard & Mouse
-- =========================================================
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- =========================================================
-- Indentation (TS / React friendly, adjust to 4 for Python if needed)
-- =========================================================
-- vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
-- vim.opt.smartindent = true

-- =========================================================
-- Search
-- =========================================================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
-- # hi
-- ## nice
-- ### wow
-- #### nice

-- =========================================================
-- Splits
-- =========================================================
vim.opt.splitbelow = true
vim.opt.splitright = true

-- =========================================================
-- Scrolling & Navigation
-- =========================================================
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

-- =========================================================
-- Performance & Responsiveness
-- =========================================================
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 10

-- =========================================================
-- Text Rendering
-- =========================================================
vim.opt.wrap = false
vim.opt.linebreak = true

-- =========================================================
-- Completion UX
-- =========================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- =========================================================
-- File Handling
-- =========================================================
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.autoread = true

-- =========================================================
-- Whitespace Visualization
-- =========================================================
vim.opt.list = true
vim.opt.listchars = {
	tab = "→ ",
	trail = "·",
	nbsp = "␣",
}

-- =========================================================
-- Backspace Behavior
-- =========================================================
vim.opt.backspace = { "start", "eol", "indent" }

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

--- SURROUND WITH CODE TO REPLACE PLUGIN: SURROUNT WITH
local function surround_selection(left, right)
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

	-- Add left/right to first/last line
	lines[1] = string.rep(left, 1) .. lines[1]
	lines[#lines] = lines[#lines] .. string.rep(right, 1)

	vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, lines)
end

vim.keymap.set("v", "'", function()
	surround_selection("'", "'")
end, { desc = "Surround selection with '" })
vim.keymap.set("v", '"', function()
	surround_selection('"', '"')
end, { desc = 'Surround selection with "' })
vim.keymap.set("v", "`", function()
	surround_selection("`", "`")
end, { desc = "Surround selection with `" })
vim.keymap.set("v", "{", function()
	surround_selection("{", "}")
end, { desc = "Surround selection with {" })
vim.keymap.set("v", "[", function()
	surround_selection("[", "]")
end, { desc = "Surround selection with [" })
vim.keymap.set("v", "(", function()
	surround_selection("(", ")")
end, { desc = "Surround selection with (" })
vim.keymap.set("v", "<", function()
	surround_selection("<", ">")
end, { desc = "Surround selection with <" })

-- Backspace

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
	-- 'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

	-- TOKYONIGHT
	{ -- You can easily change to a different colorscheme.
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("tokyonight").setup({
				styles = {
					comments = { italic = false }, -- Disable italics in comments
				},
			})
			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
	-- FLUOROMACHINE
	{
		"maxmx03/fluoromachine.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local fm = require("fluoromachine")

			fm.setup({
				glow = false,
				theme = "fluoromachine",
				transparent = true,
			})
			-- vim.cmd.colorscheme 'fluoromachine'
		end,
	},
	-- {
	--     'tanvirtin/monokai.nvim',
	--     lazy = false,       -- load immediately
	--     priority = 1000,    -- load before other plugins
	--     config = function()
	--         local monokai = require('monokai')
	--         -- Optional: choose a palette
	--         local palette = monokai.classic
	--         -- Setup the colorscheme
	--         monokai.setup({
	--             palette = palette,  -- you can also use monokai.pro, monokai.soda, monokai.ristretto
	--             italics = false,    -- disable italics if you prefer
	--             custom_hlgroups = {
	--                 TSInclude = { fg = palette.aqua },
	--                 GitSignsAdd = { fg = palette.green, bg = palette.base2 },
	--                 GitSignsDelete = { fg = palette.pink, bg = palette.base2 },
	--                 GitSignsChange = { fg = palette.orange, bg = palette.base2 },
	--             },
	--         })
	--
	--         -- Apply the colorscheme
	--         -- vim.cmd.colorscheme 'monokai'
	--     end,
	-- },
	-- TREE SITTER


	-- TELESCOPE
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local b = require("telescope.builtin")
			-- local builtin = require 'telescope.builtin'
			-- local builtin = require 'telescope.builtin'
			-- vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
			vim.keymap.set("n", "<leader>fr", b.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>fb", b.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>rg", builtin.live_grep, { desc = "[R]ip [G]rep" })
			vim.keymap.set("n", "<leader>vk", b.keymaps, { desc = "Keymaps" })
			vim.keymap.set("n", "<leader>vo", b.vim_options, { desc = "Vim options" })
			vim.keymap.set("n", "<leader>vm", b.marks, { desc = "Marks" })
			vim.keymap.set("n", "<leader>vj", b.jumplist, { desc = "Jumplist" })
			vim.keymap.set("n", "<leader>vM", b.man_pages, { desc = "Man pages" })
			vim.keymap.set("n", "<leader>vh", b.help_tags, { desc = "Help" })
			vim.keymap.set("n", "<leader>vc", b.commands, { desc = "Commands" })

			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>spp", b.spell_suggest, { desc = "Spelling suggestions" })
			vim.keymap.set("n", "<leader>vr", b.registers, { desc = "Registers" })
			vim.keymap.set("n", "<leader>vH", b.highlights, { desc = "Highlights" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>vC", b.command_history, { desc = "Command history" })
			vim.keymap.set("n", "<leader>cs", builtin.colorscheme, { desc = "[C]olor [S]chemes" })
			vim.keymap.set("n", "<leader>fd", b.fd, { desc = "Find files (fd)" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

			vim.keymap.set("n", "<leader>vt", b.tagstack, { desc = "Tag stack" })
			vim.keymap.set("n", "<leader>vs", b.search_history, { desc = "Search history" })
			vim.keymap.set("n", "<leader>ts", b.treesitter, { desc = "Treesitter symbols" })
			vim.keymap.set("n", "<leader>va", b.autocommands, { desc = "Autocommands" })
			vim.keymap.set("n", "<leader>sb", b.current_buffer_fuzzy_find, { desc = "Search buffer" })
			vim.keymap.set("n", "<leader>st", b.tags, { desc = "Tags" })
			vim.keymap.set("n", "<leader>sT", b.current_buffer_tags, { desc = "Buffer tags" })
			vim.keymap.set("n", "<leader>sy", b.symbols, { desc = "Symbols" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>ftb", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>ss", b.builtin, { desc = "Telescope pickers" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sw", b.grep_string, { desc = "Search word under cursor" })
			vim.keymap.set("n", "<leader>sr", b.resume, { desc = "Resume last picker" })
			vim.keymap.set("n", "<leader>sp", b.pickers, { desc = "Active pickers" })
			vim.keymap.set("n", "<leader>rr", b.reloader, { desc = "Reload Lua modules" })
			vim.keymap.set("n", "<leader>ft", b.filetypes, { desc = "Filetypes" })

			-- LSP STUFF
			-- vim.keymap.set('n', 'gd', b.lsp_definitions, { desc = 'Goto definition' })
			-- vim.keymap.set('n', 'gr', b.lsp_references, { desc = 'References' })
			-- vim.keymap.set('n', 'gi', b.lsp_implementations, { desc = 'Implementations' })
			-- vim.keymap.set('n', 'gy', b.lsp_type_definitions, { desc = 'Type definitions' })
			-- vim.keymap.set('n', '<leader>ls', b.lsp_document_symbols, { desc = 'Document symbols' })
			-- vim.keymap.set('n', '<leader>lS', b.lsp_workspace_symbols, { desc = 'Workspace symbols' })
			-- vim.keymap.set('n', '<leader>ld', b.lsp_dynamic_workspace_symbols, { desc = 'Dynamic workspace symbols' })
			-- vim.keymap.set('n', '<leader>li', b.lsp_incoming_calls, { desc = 'Incoming calls' })
			-- vim.keymap.set('n', '<leader>lo', b.lsp_outgoing_calls, { desc = 'Outgoing calls' })
			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>sh", function()
				local action_state = require("telescope.actions.state") -- make sure this is required
				local actions = require("telescope.actions")
				builtin.help_tags({
					attach_mappings = function(prompt_bufnr, map)
						-- override default select action
						map("i", "<CR>", function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.cmd("tab help " .. selection.value)
						end)
						map("n", "<CR>", function()
							local selection = action_state.get_selected_entry()
							actions.close(prompt_bufnr)
							vim.cmd("tab help " .. selection.value)
						end)
						return true
					end,
				})
			end, { desc = "[S]earch [H]elp in new tab" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	-- {
	-- 	"MeanderingProgrammer/render-markdown.nvim",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	-- 	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
	-- 	-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
	-- 	---@module 'render-markdown'
	-- 	---@type render.md.UserConfig
	-- 	opts = {
	--
	-- 		render_modes = { "v", "V" }, --'n', 't'
	-- 		-- render_modes = {'v' },
	-- 	},
	-- },
	-- {
	--     "mason-org/mason.nvim",
	--     opts = {}
	-- },
	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			"saghen/blink.cmp",
		},
		config = function()
			-- Brief aside: **What is LSP?**
			--
			-- LSP is an initialism you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Find references for the word under your cursor.
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		-- Optional dependencies
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
		end,
	},

	-- {
	-- 	"nvimdev/dashboard-nvim",
	-- 	event = "VimEnter",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- 	config = function()
	-- 		local dashboard = require("dashboard")
	--
	-- 		dashboard.setup({
	-- 			theme = "doom",
	-- 			config = {
	-- 				header = { "", "", "", "", "", "", "", "", "", "", "" },
	-- 				-- week_header = {
	-- 				--   enable = true,
	-- 				-- },
	--
	-- 				center = {
	-- 					{
	-- 						icon = "󰏓 ",
	-- 						icon_hl = "Title",
	-- 						desc = "Projects",
	-- 						desc_hl = "String",
	-- 						key = "p",
	-- 						key_format = " %s",
	-- 						action = "Telescope projects",
	-- 					},
	-- 					{
	-- 						icon = "󰉓 ",
	-- 						desc = "Oil File Explorer",
	-- 						key = "e",
	-- 						key_hl = "Number",
	-- 						key_format = " %s",
	-- 						action = "Oil",
	-- 					},
	-- 					{
	-- 						icon = "󰈞 ",
	-- 						desc = "Find Files",
	-- 						key = "f",
	-- 						key_hl = "Number",
	-- 						key_format = " %s",
	-- 						action = "Telescope find_files",
	-- 					},
	-- 					{
	-- 						icon = "󰈢 ",
	-- 						desc = "Recent Files",
	-- 						key = "r",
	-- 						key_format = " %s",
	-- 						action = "Telescope oldfiles",
	-- 					},
	-- 					{
	-- 						icon = "󰓩 ",
	-- 						desc = "Buffers",
	-- 						key = "b",
	-- 						key_format = " %s",
	-- 						action = "Telescope buffers",
	-- 					},
	-- 					{
	-- 						icon = "󰈬 ",
	-- 						desc = "Live Grep",
	-- 						key = "g",
	-- 						key_format = " %s",
	-- 						action = "Telescope live_grep",
	-- 					},
	--
	-- 					{
	-- 						icon = "󰌌 ",
	-- 						desc = "Keymaps",
	-- 						key = "k",
	-- 						key_format = " %s",
	-- 						action = "Telescope keymaps",
	-- 					},
	-- 					{
	-- 						icon = "󰒓 ",
	-- 						desc = "Vim Options",
	-- 						key = "o",
	-- 						key_format = " %s",
	-- 						action = "Telescope vim_options",
	-- 					},
	-- 					{
	-- 						icon = "󰛢 ",
	-- 						desc = "Commands",
	-- 						key = "c",
	-- 						key_format = " %s",
	-- 						action = "Telescope commands",
	-- 					},
	-- 					{
	-- 						icon = "󰋚 ",
	-- 						desc = "Help",
	-- 						key = "h",
	-- 						key_format = " %s",
	-- 						action = "Telescope help_tags",
	-- 					},
	-- 					{
	-- 						icon = "󰏖 ",
	-- 						desc = "Mason",
	-- 						key = "m",
	-- 						key_hl = "Number",
	-- 						key_format = " %s",
	-- 						action = "Mason",
	-- 					},
	-- 					{
	-- 						icon = "󰒲 ",
	-- 						desc = "Plugins",
	-- 						key = "l",
	-- 						key_format = " %s",
	-- 						action = "Lazy",
	-- 					},
	-- 					{
	-- 						icon = " ",
	-- 						desc = "Edit Neovim Config",
	-- 						key = "n",
	-- 						key_hl = "Number",
	-- 						key_format = " %s",
	-- 						action = "edit $MYVIMRC",
	-- 					},
	-- 					-- {
	-- 					--   icon = '󰙅 ',
	-- 					--   desc = 'Quit',
	-- 					--   key = 'q',
	-- 					--   key_format = ' %s',
	-- 					--   action = 'qa',
	-- 					-- },
	-- 				},
	--
	-- 				footer = {
	-- 					--   '',
	-- 					--   'Arch • Neovim • Telescope • Fast fingers',
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself

		config = function()
			require("neo-tree").setup({})
		end,

	},


	{
		"ahmedkhalf/project.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		-- opts = {},
		opts = {
			manual_mode = false,
			detection_methods = { "lsp", "pattern" },
			patterns = { ".git", "package.json", "pyproject.toml", "Makefile" },
			silent_chdir = true,
		},
		config = function(_, opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = { -- set to setup table
		},
	},
})

-- init.lua
vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle RenderMarkdown" })

-- Toggle Markdown preview with <leader>m
vim.api.nvim_set_keymap(
	"n",
	"<leader>m",
	":lua require('render-markdown').toggle()<CR>",
	{ noremap = true, silent = true }
)



vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { desc = "Toggle Neotree (Ctrl+E)" })
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neotree (Leader+E)" })

-- vim.keymap.set("n", "<C-e>", ":tabnew | Oil<CR>", { desc = "Open Oil in new tab (Ctrl+E)" })
-- vim.keymap.set("n", "<leader><e>", ":tabnew | Oil<CR>", { desc = "Open Oil in new tab (Ctrl+E)" })