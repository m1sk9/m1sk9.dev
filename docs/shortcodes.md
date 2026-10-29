# Shortcodes

記事（`content/**/*.md`）で使える shortcode の一覧．実装は `templates/shortcodes/` にある．

Zola の shortcode には 2 種類の書き方がある．

- **Body 付き**: `{% name(args) %}本文{% end %}` — 本文を受け取るもの
- **インライン**: `{{ name(args) }}` — 引数だけで完結するもの

引数の文字列はダブルクォートで囲む．真偽値は `true` / `false`．

## 一覧

| Shortcode | 種類 | 用途 |
| --- | --- | --- |
| [`note` / `tip` / `important` / `warning` / `caution`](#callout) | Body | 注釈ボックス |
| [`caption`](#caption) | Body | 画像下のキャプション |
| [`figure`](#figure) | インライン | `<figure>` + `<figcaption>` 付きの画像 |
| [`detail`](#detail) | Body | 折りたたみ（`<details>`） |
| [`quote`](#quote) | Body | 出典付きの引用 |
| [`mermaid`](#mermaid) | Body | Mermaid 図 |
| [`collection`](#collection) | インライン | カード等の一覧（section 専用．`/projects/` で使用） |

## Callout

`note` / `tip` / `important` / `warning` / `caution` の 5 種．見た目（アイコン・色）だけが異なる．

```md
{% note() %}
本文．**Markdown** が使える．
{% end %}

{% warning(title="注意") %}
タイトル付きにするとアイコンとタイトルが見出し行に並ぶ．
{% end %}
```

| 引数 | 必須 | 説明 |
| --- | --- | --- |
| `title` | — | 見出し．省略するとアイコンのみ |

アイコンは `static/icon/<name>.svg`．

## caption

画像の下に小さく中央寄せの説明文を付ける．

```md
![](screenshot.png)

{% caption() %}パッと見は SSH Remote と同じ{% end %}
```

出力:

```html
<div style="text-align: center; font-size: 0.80em; color: #888; margin-top: 8px;">
    パッと見は SSH Remote と同じ
</div>
```

- **画像と shortcode の間には必ず空行を入れる．** 空行がないと出力が画像の `<p>` の内側に入り，HTML が崩れる（生の `<div>` と違い，shortcode の出力は段落を中断できないため）．
- 本文はインライン Markdown として描画される（リンク・`code`・強調は可，段落やリストは不可）．

## figure

`<figure>` 要素で画像とキャプションを出力する．キャプションは `figcaption` のスタイル（`sass/main.scss`）になる．

```md
{{ figure(src="diagram.png", alt="構成図", caption="全体の構成", width=600) }}
```

| 引数 | 必須 | 説明 |
| --- | --- | --- |
| `src` | ✓ | 画像パス．page bundle 内の画像はファイル名だけで参照できる |
| `alt` | — | 代替テキスト |
| `caption` | — | キャプション（Markdown 可） |
| `width` / `height` | — | `<img>` の属性としてそのまま出力 |

`caption` との違い: `figure` はセマンティックな `<figure>` / `<figcaption>` を使い，Markdown の `![]()` は使わない．既存記事は `![]()` + `caption` で統一している．

## detail

折りたたみブロック．

```md
{% detail(title="ログ全文") %}
本文．**Markdown** が使える．
{% end %}
```

| 引数 | 必須 | 説明 |
| --- | --- | --- |
| `title` | ✓ | `<summary>` に表示する文字列 |
| `default_open` | — | `true` で最初から開いた状態にする |

## quote

出典付きの引用．通常の `>` 引用とは別のスタイル（`blockquote.quote`）になる．

```md
{% quote(cite="[Zola Documentation](https://www.getzola.org/documentation/)") %}
引用本文．
{% end %}
```

| 引数 | 必須 | 説明 |
| --- | --- | --- |
| `cite` | — | 出典．`— ` が前置される．Markdown 可 |

## mermaid

Mermaid の図を描画する．描画は [pele](https://github.com/obsidianmd/pele) が行う．

```md
{% mermaid() %}
flowchart LR
  a["コミットを作成"] --> b["秘密鍵で署名"]
{% end %}
```

- **front matter に `mermaid = true` が必要**（`[extra]` 内）．ないとスクリプトが読み込まれず，ソースがそのまま表示される．
- 本文は Markdown として処理されないので，Mermaid の記法をそのまま書ける．`%%{init: ...}%%` による設定も可．

## collection

TOML ファイルからカード等の一覧を描画する．

```md
{{ collection(file="data.toml") }}
```

```toml
[[collection]]
type = "card"   # card / card_simple / entry / box / art / art_simple / br
title = "Project"
link = "https://example.com"
content = "説明（Markdown 可）"
```

- **section（`_index.md`）専用．** パスを `content` + `section.path` + `file` で解決するため，記事ページで使うと `section.path` が未定義でビルドが失敗する．
- `type` ごとに使えるフィールドは `templates/macros/collection.html` を参照．
- `/projects/` のプロジェクト一覧で使っている．プロジェクトを追加するときは `content/projects/projects.toml` に `[[collection]]` を足す．

`card` で使えるフィールド:

| フィールド | 説明 |
| --- | --- |
| `title` | 必須．プロジェクト名 |
| `link` | タイトルのリンク先（新しいタブで開く） |
| `subtitle` | タイトル下の補足（言語など） |
| `content` | 説明文（Markdown 可） |
| `tags` | 文字列の配列．`#` 付きで並ぶ |
| `date` | タイトル行の右端に表示 |
| `icon` | 16px のアイコン画像パス |
| `featured` | `true` で左に `*` が付く |
