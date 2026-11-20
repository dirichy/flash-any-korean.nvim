# Korean / 韩文

```lua
require("flash-any").setup({ sources = { "korean" } })
```

`korean` 使用 두벌식（两套式）键位，不需要外部词典或额外插件。
搜索时保持英文输入，用 `gksrmf` 匹配 `한글`、`dkssud` 匹配 `안녕`。
这是按键编码，不是罗马音：`hangul` 不是 `한글` 的编码。
日常在编辑器里输入韩文文本仍需韩文输入法；本 source 只提供搜索匹配。

The `korean` source uses Dubeolsik keyboard strokes, without an external
dictionary or plugin. Search in English input mode: `gksrmf` matches `한글`, and
`dkssud` matches `안녕`. These are keystrokes, not romanization: `hangul` is not
the code for `한글`. Entering Korean text normally still requires a Korean input
method; this source provides search matching only.

| 输入 / Input | 匹配 / Match |
| --- | --- |
| `rk` | 가 |
| `Rk` | 까 |
| `rhk` | 과 |
| `rkqt` | 값 |
| `gksrmf with ASCII` | 한글 with ASCII |

默认 `full_code`，严格区分大小写，不受 `ignorecase` / `smartcase` 影响。
Shift 用于 `R E Q T W O P`，分别表示 `ㄲ ㄸ ㅃ ㅆ ㅉ ㅒ ㅖ`。
部分输入仍可预览后续按键，但必须完成一个音节的编码后才能继续匹配后面的文本。

The default `full_code` matcher is case-sensitive regardless of `ignorecase` /
`smartcase`. Shift produces `R E Q T W O P`, corresponding to `ㄲ ㄸ ㅃ ㅆ ㅉ ㅒ ㅖ`.
Partial input previews subsequent keys; finish each syllable before matching the
following text.

覆盖全部 11,172 个现代韩文预组合音节（U+AC00–U+D7A3）、其规范分解形式、
现代组字字母及兼容字母。暂不覆盖古韩文、半角字母、混合预组合与分解形式、
罗马音或其他键盘布局。不是任意 Unicode 规范化器。

Covers all 11,172 modern precomposed syllables (U+AC00–U+D7A3), their canonical
decompositions, modern conjoining jamo and compatibility jamo. Archaic Hangul,
halfwidth forms, mixed precomposed/decomposed syllables, romanization and other
keyboard layouts are outside this source's scope. This is not a general Unicode
normalizer.

维护脚本按初声、中声、终声生成静态 TSV，安装时直接读表，运行时沿用原生 C matcher。
音节排序和分解公式见 [Unicode 标准 §3.12](https://www.unicode.org/versions/Unicode17.0.0/UnicodeStandard-17.0.pdf)。

The maintenance script generates a static TSV from initial, medial and final components;
runtime matching uses the existing C matcher. Syllable ordering and decomposition
follow [Unicode §3.12](https://www.unicode.org/versions/Unicode17.0.0/UnicodeStandard-17.0.pdf).
