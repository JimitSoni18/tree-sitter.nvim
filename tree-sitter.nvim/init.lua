--- @class Config
--- @field parser_path string|nil
--- @field enabled_languages string[]
--- @field textobjects table

local M = {}

--- @param opts Config
function M.setup(opts)
	if type(opts.parser_path) == "string" then
		vim.opt.runtimepath:prepend(opts.parser_path)
	end

	if type(opts.enabled_languages) == "table" and #opts.enabled_languages > 0 then
		for _, lang in ipairs(opts.enabled_languages) do
			if type(lang) == "string" then
				vim.treesitter.language.add(lang)
			end
		end
	end
end

return M

-- --- @class MyPluginConfig
-- --- @field parser_path string|nil Optional path to a local shared library for the parser
-- --- @field filetypes string[] Extensions to associate with this plugin
--
-- local M = {}
--
-- --- The internal state of the plugin
-- local state = {
-- 	parser_name = "my_lang",
-- }
--
-- --- Initialize the plugin using only built-in Neovim APIs
-- --- @param opts MyPluginConfig|nil
-- function M.setup(opts)
-- 	opts = opts or {}
-- 	local filetypes = opts.filetypes or { "mlang", "myl" }
--
-- 	-- 1. Associate extensions with the filetype
-- 	-- This ensures 'vim.treesitter.get_parser' knows which language to use
-- 	vim.filetype.add({
-- 		extension = {
-- 			[filetypes[1]] = state.parser_name,
-- 			[filetypes[2]] = state.parser_name,
-- 		},
-- 	})
--
-- 	-- 2. Register the parser manually if a path is provided
-- 	-- Neovim searches 'runtimepath/parser/', but you can manually add search paths
-- 	if opts.parser_path then
-- 		vim.opt.runtimepath:append(opts.parser_path)
-- 	end
--
-- 	-- 3. Enable Highlighting via Filetype Autocmd
-- 	-- Instead of a global setup, we enable treesitter per-buffer for our language
-- 	vim.api.nvim_create_autocmd("FileType", {
-- 		pattern = state.parser_name,
-- 		callback = function(args)
-- 			local bufnr = args.buf
--
-- 			-- Start the built-in Treesitter highlighter
-- 			-- This automatically looks for queries/<lang>/highlights.scm in your runtimepath
-- 			local ok, _ = pcall(vim.treesitter.start, bufnr, state.parser_name)
-- 			if not ok then
-- 				vim.notify("TS: Highlighting failed to start for " .. state.parser_name, vim.log.levels.WARN)
-- 			end
-- 		end,
-- 	})
--
-- 	-- 4. Textobjects (Pure Lua implementation)
-- 	-- Since we aren't using the nvim-treesitter-textobjects plugin,
-- 	-- we can create a simple keymap that uses the built-in query engine.
-- 	M.setup_textobjects()
-- end
--
-- --- Simple textobject implementation using core API
-- --- This maps 'af' to select the range defined in textobjects.scm
-- function M.setup_textobjects()
-- 	vim.keymap.set("x", "af", function()
-- 		local bufnr = vim.api.nvim_get_current_buf()
--
-- 		-- Get the query defined in your queries/<lang>/textobjects.scm
-- 		local query = vim.treesitter.query.get(state.parser_name, "textobjects")
-- 		if not query then return end
--
-- 		local parser = vim.treesitter.get_parser(bufnr, state.parser_name)
-- 		if not parser then return end
-- 		local tree = parser:parse()[1]
-- 		local root = tree:root()
--
-- 		-- Look for a capture named 'function.outer'
-- 		for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
-- 			local name = query.captures[id]
-- 			if name == "function.outer" then
-- 				local s_row, s_col, e_row, e_col = node:range()
-- 				vim.fn.setpos(".", { bufnr, s_row + 1, s_col + 1, 0 })
-- 				vim.cmd("normal! v")
-- 				vim.fn.setpos(".", { bufnr, e_row + 1, e_col, 0 })
-- 				break
-- 			end
-- 		end
-- 	end, { desc = "Select around function (Tree-sitter)" })
-- end
--
-- return M
