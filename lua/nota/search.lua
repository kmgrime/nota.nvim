local M = {}

---@return string[]
local function collect_notes()
	local cfg = require("nota").config
	local path = cfg.notes_path
	local files = vim.fn.globpath(path, "**/*.md", false, true)

	table.sort(files, function(a, b)
		return a > b
	end)

	return files
end

---@param files string[]
---@return string[] relative paths
---@return table<string,string> map from relative to absolute
local function make_relative(files)
	local cfg = require("nota").config
	local base = cfg.notes_path .. "/"
	local relative = {}
	local map = {}
	for _, f in ipairs(files) do
		local rel = f:sub(#base + 1)
		table.insert(relative, rel)
		map[rel] = f
	end
	return relative, map
end

--- Try to open notes via Telescope.
---@return boolean true if Telescope was available and used
local function try_telescope()
	local ok, builtin = pcall(require, "telescope.builtin")
	if not ok then
		return false
	end

	local cfg = require("nota").config
	builtin.find_files({
		prompt_title = "Nota - Search Notes",
		cwd = cfg.notes_path,
		find_command = { "find", ".", "-name", "*.md", "-type", "f" },
		sorting_strategy = "ascending",
	})
	return true
end

--- Try to open notes via fzf-lua.
---@return boolean true if fzf-lua was available and used
local function try_fzf_lua()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		return false
	end

	local cfg = require("nota").config
	fzf.files({
		prompt = "Nota - Search Notes> ",
		cwd = cfg.notes_path,
	})
	return true
end

--- Fallback: use vim.ui.select to pick a note.
local function fallback_select()
	local files = collect_notes()

	if #files == 0 then
		vim.notify("[nota] No notes found", vim.log.levels.INFO)
		return
	end

	local relative, map = make_relative(files)

	vim.ui.select(relative, {
		prompt = "Nota - Select a note:",
	}, function(choice)
		if not choice then
			return
		end
		local abs = map[choice]
		if abs then
			vim.cmd("edit " .. vim.fn.fnameescape(abs))
		end
	end)
end

function M.open()
	local cfg = require("nota").config
	if not cfg.notes_path then
		vim.notify("[nota] notes_path is not configured", vim.log.levels.ERROR)
		return
	end

	if try_telescope() then
		return
	end

	if try_fzf_lua() then
		return
	end

	fallback_select()
end

return M
