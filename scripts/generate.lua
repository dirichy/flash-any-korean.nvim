-- Modern Hangul in Unicode L/V/T order, using Dubeolsik keyboard strokes.
local initials = vim.split("r R s e E f a q Q t T d w W c z x v g", " ")
local vowels = vim.split("k o i O j p u P h hk ho hl y n nj np nl b m ml l", " ")
local finals = vim.split("r R rt s sw sg e f fr fa fq ft fx fv fg a q qt t T d w c z x v g", " ")
---@type table<string, string>
local data = {}
for i, code in ipairs(initials) do
	data[vim.fn.nr2char(0x1100 + i - 1)] = code
end
for i, code in ipairs(vowels) do
	data[vim.fn.nr2char(0x1161 + i - 1)] = code
	data[vim.fn.nr2char(0x314F + i - 1)] = code
end
for i, code in ipairs(finals) do
	data[vim.fn.nr2char(0x11A7 + i)] = code
end
local consonants = vim.split("r R rt s sw sg e E f fr fa fq ft fx fv fg a q Q qt t T d w W c z x v g", " ")
for i, code in ipairs(consonants) do
	data[vim.fn.nr2char(0x3131 + i - 1)] = code
end
-- Store exact decomposed graphemes too; runtime matching needs no normalization.
for l, initial in ipairs(initials) do
	for v, vowel in ipairs(vowels) do
		local head = vim.fn.nr2char(0x1100 + l - 1) .. vim.fn.nr2char(0x1161 + v - 1)
		for t = 0, 27 do
			local code = initial .. vowel .. (finals[t] or "")
			data[vim.fn.nr2char(0xAC00 + ((l - 1) * 21 + v - 1) * 28 + t)] = code
			data[head .. (t == 0 and "" or vim.fn.nr2char(0x11A7 + t))] = code
		end
	end
end
local keys = vim.tbl_keys(data)
table.sort(keys)
assert(#keys == 22462, "expected 22,344 syllable forms and 118 jamo")
local lines = {}
for _, text in ipairs(keys) do
	lines[#lines + 1] = text .. "\t" .. data[text]
end
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local output = arg[1] or root .. "/lua/flash-any/tables/korean.tsv"
vim.fn.writefile(lines, output)
print("Generated " .. #lines .. " entries: " .. output)
if not arg[1] then
	local script = debug.getinfo(1, "S").source:sub(2)
	local metadata = {
		unicode_version = "17.0.0",
		layout = "Dubeolsik (two-set, QWERTY key positions)",
		external_inputs = {}, -- No downloaded dictionary or Unicode data file is consumed.
		generator = {
			path = "scripts/generate.lua",
			sha256 = vim.fn.sha256(table.concat(vim.fn.readfile(script, "b"), "\n")),
		},
		table = {
			path = "lua/flash-any/tables/korean.tsv",
			sha256 = vim.fn.sha256(table.concat(lines, "\n") .. "\n"),
			entries = #lines,
			precomposed_syllables = 11172,
			decomposed_syllables = 11172,
			jamo = 118,
		},
	}
	vim.fn.writefile({ vim.json.encode(metadata) }, root .. "/data.json")
end
