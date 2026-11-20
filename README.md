# flash-any-korean.nvim

[English](README.en.md) · [简体中文](README.zh-CN.md)

[flash-any.nvim](https://github.com/dirichy/flash-any.nvim)에서 두벌식 자판으로 한글을 검색하고 이동합니다.

## 설치

Neovim 0.11 이상, make, C 컴파일러가 필요합니다. lazy.nvim 설정:

```lua
{
  "dirichy/flash-any.nvim",
  branch = "main",
  version = false,
  build = "make",
  dependencies = { "folke/flash.nvim", "dirichy/flash-any-korean.nvim" },
  opts = { sources = { "korean" } },
  keys = {
    { "s", function() require("flash-any").jump() end, mode = { "n", "x", "o" } },
  },
}
```

이 source는 별도의 빌드나 사전 다운로드가 필요하지 않습니다.

## 사용법

영문 입력 상태에서 `s`를 누르고 키를 입력한 뒤 표시된 레이블을 선택합니다.

- `gksrmf` → `한글`
- `dkssud` → `안녕`
- `gksrmf with flash` → `한글 with flash`
- `rk` → `가`, `Rk` → `까`

로마자 표기가 아닌 두벌식 키 배열을 사용합니다. 기본 설정에서는 `ignorecase`와
`smartcase`에 관계없이 대소문자를 구분합니다. 검색에는 한글 입력기가 필요하지
않지만, 일반적인 한글 텍스트 입력에는 한글 입력기가 필요합니다.

현대 한글 11,172개 음절, 정규 분해형, 현대 조합 자모와 호환 자모를 지원합니다.
옛한글, 반각 자모, 완성형과 분해형이 섞인 음절, 로마자 및 다른 자판은 지원하지 않습니다.

## 설정

source 전용 옵션은 없습니다. 공통 `matcher` 문자열 옵션을 사용할 수 있습니다.

| 값 | 동작 |
| --- | --- |
| `full_code` | 기본값. 음절의 전체 키 입력 |
| `initial` | 첫 키 또는 전체 키 입력 |
| `prefix` | 비어 있지 않은 모든 접두 입력 |
| `letter` | 전체 키 입력, Neovim 대소문자 옵션 적용 |

Shift 구분을 유지하려면 기본값을 사용하세요. 다른 모드는 일치 범위를 넓히며,
`letter`와 `ignorecase`를 함께 사용하면 서로 다른 한글 자모가 같은 입력에 일치할 수 있습니다.

```lua
opts = { sources = { { name = "korean", matcher = "prefix" } } }
```

![Korean search and jump](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table.gif)

[MP4](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table.mp4) · [Verification report](https://github.com/dirichy/flash-any-korean.nvim/releases/download/demos/table-verification.json)

[유지 관리 및 로컬 테스트](docs/maintenance.md) · [데이터 출처](THIRD_PARTY.md)

코드와 생성된 표: [MIT](LICENSE). 외부 사전은 포함하지 않습니다.
