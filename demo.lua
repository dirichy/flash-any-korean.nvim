local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:append(root)
local source = require("flash-any.sources.korean")()
return {
	file = "lua/flash-any/tables/" .. source.codetable .. ".tsv",
	matcher = source.matcher,
	text_name = "Korean",
	text = "한",
	mixed_text = "한글 with flash",
	comment = "Type gks for 한, then choose a label to jump.",
	mixed_comment = "Type gksrmf with flash to mix Korean keys and ASCII.",
	title = "Korean Dubeolsik + ASCII",
}
