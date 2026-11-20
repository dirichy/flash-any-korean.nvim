# flash-any-korean.nvim

[한국어](README.md) · [English](README.en.md)

为 [flash-any.nvim](https://github.com/dirichy/flash-any.nvim) 提供独立的韩文 source，采用 두벌식（两套式）键位。

需要 Neovim 0.11+、make 和 C 编译器。

lazy.nvim 配置（远程安装需要先发布仓库）：

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

保持英文输入：`gksrmf → 한글`、`dkssud → 안녕`。这是韩文键位，不是罗马音。
严格区分大小写：`rk → 가`、`Rk → 까`，不受 `ignorecase` / `smartcase` 影响。
搜索无需韩文输入法；日常输入韩文文本仍需输入法。
本 source 无需构建钩子、下载词典或独立运行时 matcher。
详见[覆盖范围与限制](docs/coverage.md)。

按 `s` 输入编码，再选择标签跳转；继续输入可匹配韩文与 ASCII 混合文本。

无专属配置项。通用 `matcher` 为字符串：`full_code`（默认，完整音节编码）、
`initial`（首键或完整编码）、`prefix`（任意非空前缀）、`letter`（完整编码并遵循大小写选项）。
建议保留 `full_code` 以区分 Shift。其他模式会扩大匹配范围；
`letter` 配合 `ignorecase` 会混淆不同韩文字母。

```lua
opts = { sources = { { name = "korean", matcher = "prefix" } } }
```

[演示工作流](https://github.com/dirichy/flash-any-korean.nvim/actions/workflows/demo.yml)（尚未首次发布）。

[维护与本地验证](docs/maintenance.md) · [数据来源](THIRD_PARTY.md)

代码和生成码表使用 [MIT](LICENSE)，未分发上游词典。
