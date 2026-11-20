# Maintenance / 维护

Ordinary users only install this source before flash-any's setup. There is no
source build hook or download. Contributor tools and internal data live here,
separate from the installation README.
普通用户无需安装维护或录制工具；source 必须在核心 setup 前加载。

## Layout and data / 结构与数据

- `lua/flash-any/sources/korean.lua`: factory, `codetable = "korean"`, `full_code`.
- `lua/flash-any/tables/korean.tsv`: complete shipped table used by installation and recording.
- `scripts/generate.lua`: the single owner of keyboard mappings and table generation.
- `data.json`, `THIRD_PARTY.md`: provenance, hashes and counts.
- `demo.lua`, `.github/workflows/demo.yml`: shared recorder configuration and publication workflow.
- `minimal.lua`, `sample.txt`, `tests/`: isolated setup and matching/jump checks.

Unicode order, composition formula, Shift distinctions and exclusions are documented
in [coverage](coverage.md) and [provenance](../THIRD_PARTY.md). No upstream dictionary
needs downloading. The generator writes 22,462 sorted text/code rows. A Lua table is
not loaded at installation; the core reads the shipped TSV and owns binary caching.
Unicode 排序、组合公式、Shift 区别和限制见上述文档；安装和录制读取同一份完整 TSV。

From the source checkout / 在 source 根目录执行:

```sh
nvim --clean -l scripts/generate.lua
nvim --clean -l scripts/generate.lua /tmp/korean-regenerated.tsv
cmp lua/flash-any/tables/korean.tsv /tmp/korean-regenerated.tsv
```

The first command updates TSV and data.json; an explicit output writes only TSV.
Keep the generator, output and metadata together when reviewing a table change.
第一条同时更新 TSV 和元数据；显式输出仅写 TSV。改码表时一起审核脚本、产物和哈希。

## Local installation and verification / 本地验证

Set paths to existing checkouts. Neovim 0.11+, make and a C compiler are required.
`FLASH_NVIM_PATH` points to folke/flash.nvim, not the core or this source.
路径指向已有 checkout；测试不加载个人配置。

```sh
export FLASH_ANY_ROOT=/path/to/flash-any.nvim
export FLASH_NVIM_PATH=/path/to/flash.nvim
export FLASH_ANY_SOURCE_ROOT=/path/to/flash-any-korean.nvim
make -C "$FLASH_ANY_ROOT"
nvim --clean -l "$FLASH_ANY_SOURCE_ROOT/minimal.lua"
nvim --clean -l "$FLASH_ANY_SOURCE_ROOT/tests/korean.lua"
nvim --clean -l "$FLASH_ANY_SOURCE_ROOT/tests/jump.lua"
nvim --clean -u "$FLASH_ANY_SOURCE_ROOT/minimal.lua" "$FLASH_ANY_SOURCE_ROOT/sample.txt"
```

The table test exercises every modern syllable in precomposed and decomposed forms,
known Dubeolsik words, compound vowels/finals, jamo and case distinctions. The jump
test uses the named source, real Flash labels and its original input loop to choose
both a syllable and a mixed Korean/ASCII phrase, asserting cursor positions and an
unchanged buffer. The preview loop is temporarily disabled only while inspecting
labels; the actual selection uses the original loop.
测试覆盖全部现代音节、真实标签选择、实际落点和样本未修改，不只验证 Lua 文件能加载。

Interactively press `s`, type `gksrmf`, then choose a label; repeat with
`gksrmf with ASCII`. Restart Neovim after updating installed source files.
手动验证单字和混输跳转；更新 source 后重启 Neovim。

For local lazy.nvim development, replace the Korean dependency with
`{ dir = "/absolute/path/to/flash-any-korean.nvim" }`. When testing unpublished
core changes, use its local checkout too. Public READMEs use remote dependencies.
本地开发与远端安装配置分开，不把作者目录写进公开 README。

## Recording / 录制

From the **core checkout**, follow its [recording guide](https://github.com/dirichy/flash-any.nvim/blob/main/demos/README.md).
The recorder requires VHS, ttyd, Chromium/Chrome, FFmpeg/ffprobe, Python 3,
fontconfig, JetBrainsMono Nerd Font Mono, Noto CJK and Noto Color Emoji, plus
Tokyo Night and flash.nvim checkouts. Missing tools must be installed before recording.
录制从核心根目录执行；缺依赖先安装，不替换录制工具或绕过验证。

```sh
export TOKYONIGHT_PATH=/path/to/tokyonight.nvim
nvim --clean -l demos/prepare-table.lua "$FLASH_ANY_SOURCE_ROOT/demo.lua"
sh demos/record.sh table "$FLASH_ANY_SOURCE_ROOT/demo.lua"
```

Expect `Prepared 2 jumps for table`. The first scene selects `한` using `gks`
among multiple labels; the second selects `한글 with flash` using `gksrmf with flash`.
Queries/labels are inferred from the real table and default matcher. All relative
paths resolve against demo.lua. Outputs stay in the core's ignored `demos/output/`:
`table.gif`, `table.mp4`, `table.png`, verification/media reports and README.local.md.
Check `verified: true`, both actual cursor positions, fixture invariants, actual
codec/dimensions/fps, and key frames for fonts/cropping. Inspect the full clip when
judging timing. Never commit generated media.
检查报告、真实落点、视频编码和实际画面；媒体留在被忽略的核心 output 目录。

## CI and publication / CI 与发布

`tests.yml` checks deterministic generation, table matching and named jumps against
core main. `demo.yml` reuses the core's recording workflow, with both workflow and
core following main by default. If pinning, pin both references to the **same tested,
published core commit**. The source revision is `${{ github.sha }}`. Local core edits
do not affect remote runs; after updating the core or workflow, start a new run.
核心版本需要包含实际使用的能力；不把本地验证当成远端版本验证。

The reusable workflow installs Nerd Fonts v3.4.0, Noto CJK and Noto Color Emoji.
Before publication check the final sample against those actual font files/fallbacks,
including narration and UI text. Its preparation fails on uncovered explicit text;
inspect rendered Hangul too. A local extra font must not hide missing CI coverage.
发布前检查实际 CI 字体覆盖，不依赖本机额外字体。

Push to main or run demo.yml manually after publishing the source repository.
Recording has read permission; only the dependent publishing job has contents:write.
It checks verified:true, replaces the dedicated `demos` prerelease assets and
compares authenticated downloads. Outdated runs skip publication if main moved.
Do not commit or push without the owner's authorization.
不未经授权提交或推送；本地成功、artifact 成功和 Release 发布成功分别验证。

Before the first successful release, every README links to the demo workflow.
After publication replace that temporary link in **all three READMEs** with:

```markdown
![Search and jump](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table.gif)

[MP4](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table.mp4) · [Verification report](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table-verification.json)
```

Open all three URLs, inspect verified:true and the video, then install using only
README remote dependencies from a fresh checkout and verify a syllable and mixed
input. Completion requires named installation/jumps, verified playback, accessible
release assets and inline demos in every language README. Local tests alone do not
establish publication.
发布完成标准：新用户按名安装能跳、回放通过、附件可访问、各语言 README 可直接看 demo。
