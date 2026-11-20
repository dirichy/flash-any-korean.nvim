# flash-any-korean.nvim

[한국어](README.md) · [中文](README.zh-CN.md)

Korean Dubeolsik keyboard matching for [flash-any.nvim](https://github.com/dirichy/flash-any.nvim).

Requires Neovim 0.11+, make and a C compiler.

Install with lazy.nvim (the repository must be published before remote installation):

```lua
{
  "dirichy/flash-any.nvim",
  branch = "main",
  version = false,
  build = "make",
  dependencies = {
    "folke/flash.nvim",
    "dirichy/flash-any-korean.nvim",
  },
  opts = { sources = { "korean" } },
  keys = {
    { "s", function() require("flash-any").jump() end, mode = { "n", "x", "o" } },
  },
}
```

Keep English input active: `gksrmf → 한글`, `dkssud → 안녕`.
These are Dubeolsik key positions, not romanization. Codes are case-sensitive:
`rk → 가`, `Rk → 까`, regardless of `ignorecase` / `smartcase`.
Search requires no Korean input method; normal Korean text entry still does.
The source needs no build hook, downloads or runtime matcher of its own.
See [coverage and limitations](docs/coverage.md).

Press `s`, enter a code, then choose a displayed label. Keep typing to match a
longer phrase, mixing Korean codes and ordinary ASCII.

No source-specific options. The shared `matcher` option is a string: `full_code`
(default, complete syllable), `initial` (first key or complete code), `prefix`
(any nonempty prefix), or `letter` (complete code with case options).
Use `full_code` to preserve Shift distinctions. Other modes broaden matches;
`letter` with `ignorecase` can conflate distinct Korean letters.

```lua
opts = { sources = { { name = "korean", matcher = "prefix" } } }
```

[Demo workflow](https://github.com/dirichy/flash-any-korean.nvim/actions/workflows/demo.yml)
(first release pending).

[Maintenance and local testing](docs/maintenance.md) · [Data provenance](THIRD_PARTY.md)

Code and generated table: [MIT](LICENSE). No upstream dictionary is bundled.
