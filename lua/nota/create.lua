local M = {}

---@param subject string
---@return string
local function sanitize(subject)
	local cfg = require("nota").config
	local sep = cfg.separator or "_"
	local s = subject:gsub("%s+", sep)
	s = s:gsub("[^%w" .. sep .. "%-]", "")
	return s
end

---@param date_str string e.g. "2026-04-15"
---@param sanitized_subject string e.g. "meeting_notes"
---@return string dir, string filepath
local function build_path(date_str, sanitized_subject)
	local cfg = require("nota").config
	local year = date_str:sub(1, 4)
	local month = date_str:sub(6, 7)
	local day = date_str:sub(9, 10)

	local dir = cfg.notes_path .. "/" .. year .. "/" .. month .. "/" .. day
	local filename = date_str .. "-" .. sanitized_subject .. ".md"
	return dir, dir .. "/" .. filename
end

---@param date_str string
---@param sanitized_subject string
---@param original_subject string
---@return string
local function template(date_str, sanitized_subject, original_subject)
	local cfg = require("nota").config
	local formatted_date = os.date(cfg.date_format, os.time())
	return table.concat({
		"---",
		"Date: " .. formatted_date,
		"Subject: " .. original_subject,
		"Description: ",
		"---",
		"",
		"### Note1",
		"",
		"- ",
	}, "\n")
end

---@param subject string raw subject as typed by the user
---@param date_str string|nil optional date override (defaults to today)
function M.create(subject, date_str)
	date_str = date_str or (
		os.date(require("nota").config.date_format) --[[@as string]]
	)
	local sanitized = sanitize(subject)

	if sanitized == "" then
		vim.notify("[nota] Subject cannot be empty", vim.log.levels.WARN)
		return
	end

	local dir, filepath = build_path(date_str, sanitized)

	-- If file already exists, ask the user what to do
	if vim.fn.filereadable(filepath) == 1 then
		vim.ui.select({ "Open existing", "Cancel" }, {
			prompt = "[nota] Note already exists: ",
		}, function(choice)
			if choice == "Open existing" then
				vim.cmd("edit " .. vim.fn.fnameescape(filepath))
			end
		end)
		return
	end

	vim.fn.mkdir(dir, "p")

	local content = template(date_str, sanitized, subject)
	local lines = vim.split(content, "\n")
	vim.fn.writefile(lines, filepath)

	vim.cmd("edit " .. vim.fn.fnameescape(filepath))

	local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local last_line = #buf_lines
	vim.api.nvim_win_set_cursor(0, { last_line, 2 })
end

function M.prompt()
	vim.ui.input({ prompt = "Subject: " }, function(subject)
		if not subject or subject == "" then
			return
		end
		M.create(subject)
	end)
end

return M
