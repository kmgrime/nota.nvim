local M = {}

M.config = {
	notes_path = nil, -- path to directory of your notes
	date_format = "%Y-%m-%d",
	separator = "_",
}

---@param opts table|nil
function M.setup(opts)
	opts = opts or {}

	if opts.notes_path then
		opts.notes_path = vim.fn.expand(opts.notes_path)
	end

	M.config = vim.tbl_deep_extend("force", M.config, opts)

	if not M.config.notes_path or M.config.notes_path == "" then
		vim.notify("[nota] notes_path is required in setup()", vim.log.levels.ERROR)
		return
	end

	-- Register user commands (Neovim requires uppercase for user commands)
	vim.api.nvim_create_user_command("Nota", function()
		require("nota.create").prompt()
	end, { desc = "Create a new note" })

	vim.api.nvim_create_user_command("NotaSearch", function()
		require("nota.search").open()
	end, { desc = "Search notes" })

	-- Lowercase aliases so :nota and :notasearch work
	vim.cmd([[cabbrev nota Nota]])
	vim.cmd([[cabbrev notasearch NotaSearch]])
end

return M
