local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
vim.opt.runtimepath:prepend(assert(vim.env.FLASH_ANY_ROOT, "set FLASH_ANY_ROOT to the core checkout"))
vim.opt.runtimepath:append(root)
local registry, native = require("flash-any.source"), require("flash-any.native")
assert(vim.tbl_contains(registry.available(), "korean"))
assert(registry.load("korean").matcher == "full_code")
local path = vim.fn.tempname() .. ".bin"
require("flash-any.build").binary({ sources = { "korean" }, output = path })
local book = native.load(path)
local query = ""
local state = {
	pattern = function()
		return query
	end,
}
local range = { from = { 1, 0 }, to = { 1, 0 } }
local function find(text, input)
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { text })
	query = input
	return native.get(0, state, range, book)
end
for _, case in ipairs({
	{ "한글", "gksrmf" },
	{ "안녕", "dkssud" },
	{ "한국어", "gksrnrdj" },
	{ "값 닭 앉 왜 의", "rkqt ekfr dksw dho dml" },
	{ "까 따 빠 싸 짜 얘 예", "Rk Ek Qk Tk Wk dO dP" },
	{ "ㄱㄲㅘㅄ", "rRhkqt" },
	{ "한글", "gksrmf" },
	{ "한글 with ASCII", "gksrmf with ASCII" },
}) do
	local matches = find(case[1], case[2])
	assert(#matches == 1, vim.inspect(case))
	assert(
		matches[1].end_pos[2] == #case[1] - #vim.fn.strcharpart(case[1], vim.fn.strchars(case[1]) - 1, 1),
		"consume complete graphemes"
	)
end
for _, ignorecase in ipairs({ false, true }) do
	vim.go.ignorecase = ignorecase
	assert(#find("가", "Rk") == 0 and #find("까", "rk") == 0)
end
assert(find("한", "g")[1].next.k)
assert(find("한", "gk")[1].next.s)
assert(#find("한x", "gkx") == 0, "finish the syllable before continuing")
-- Exercise every modern syllable and its canonical decomposition through C.
local data = assert(registry.load("korean").data)
for cp = 0xAC00, 0xD7A3 do
	local text = vim.fn.nr2char(cp)
	local index = cp - 0xAC00
	local tail = index % 28
	local nfd = vim.fn.nr2char(0x1100 + math.floor(index / 588))
		.. vim.fn.nr2char(0x1161 + math.floor(index / 28) % 21)
		.. (tail == 0 and "" or vim.fn.nr2char(0x11A7 + tail))
	assert(#find(text, data[text][1]) == 1, text)
	assert(#find(nfd, data[text][1]) == 1, nfd)
end
assert(#find("🙂中", "rk") == 0)
vim.uv.fs_unlink(path)
print("Korean source tests passed (11,172 syllables)")
