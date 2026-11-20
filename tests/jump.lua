-- Named-source integration with Flash's real input loop and label selection.
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(assert(vim.env.FLASH_ANY_ROOT, "set FLASH_ANY_ROOT"))
vim.opt.runtimepath:prepend(assert(vim.env.FLASH_NVIM_PATH, "set FLASH_NVIM_PATH"))
vim.opt.runtimepath:append(root)
vim.opt.swapfile = false
vim.opt.shadafile = "NONE"
vim.o.lines, vim.o.columns = 30, 100
local plugin = require("flash-any")
local binary = vim.fn.tempname() .. ".bin"
plugin.setup({ sources = { "korean" }, binary = binary })
local lines = { "| 한 글 한 |", "| 한글 with flash |" }
vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
vim.bo.modified = false
local State = require("flash.state")
local loop = State.loop
-- Inspect real labels without blocking; then use the unmodified input loop.
for _, case in ipairs({ { "gks", 1, 10, 3 }, { "gksrmf with flash", 2, 2, 1 } }) do
	State.loop = function() end
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
	local preview = plugin.jump()
	preview:update({ pattern = case[1], check_jump = false, force = true })
	assert(#preview.results == case[4], vim.inspect(preview.results))
	local label
	for _, match in ipairs(preview.results) do
		if match.pos[1] == case[2] and match.pos[2] == case[3] then
			label = assert(match.label)
		end
	end
	assert(label, "expected target must have a real label")
	preview:hide()
	State.loop = loop
	vim.api.nvim_feedkeys(case[1] .. label, "t", false)
	local state = plugin.jump()
	assert(state.pattern() == case[1], "query must finish before choosing a label")
	assert(vim.deep_equal(vim.api.nvim_win_get_cursor(0), { case[2], case[3] }), "wrong jump target")
end
assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), lines), "fixture changed")
assert(not vim.bo.modified, "buffer was modified")
assert(vim.v.errmsg == "", vim.v.errmsg)
vim.uv.fs_unlink(binary)
print("named Korean source: real input, labels, single syllable and mixed jump passed")
