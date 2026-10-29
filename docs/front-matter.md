# Front matter

記事（`content/posts/<slug>/index.md`）の front matter は TOML（`+++`）．雛形は `_template.md` で，`./x <slug> [category]` で生成できる．

```toml
+++
title = "記事タイトル"
date = 2026-10-29
# updated = 2026-11-01
description = "記事の説明文"
[taxonomies]
categories = ["__05__Tooling"]
tags = ["zola"]
[extra]
lang = "ja"
toc = true
math = true
mermaid = true
+++
```

## トップレベル

| キー | 必須 | 説明 |
| --- | --- | --- |
| `title` | ✓ | 記事タイトル |
| `date` | ✓ | 公開日 |
| `updated` | — | 更新日．`date` と異なる場合に表示され，古い記事の警告（`outdate_alert`）の判定にも使われる |
| `description` | — | `<meta name="description">` と `/posts/` の Discord embed の抜粋に使われる（OGP には使われない） |

## `[taxonomies]`

| キー | 必須 | 説明 |
| --- | --- | --- |
| `categories` | ✓ | 1 つ指定する．記事一覧がカテゴリでグループ化されるため，省略するとビルドが失敗する |
| `tags` | — | タグ |

カテゴリ名は `__NN__Label` 形式で，`NN` が一覧での並び順になる．対応表は `x` の `category_label` 関数が正なので，新しいカテゴリはそこに追加すること．

| `./x` の引数 | カテゴリ名 |
| --- | --- |
| `minecraft` | `__01__Minecraft` |
| `security` | `__02__Security` |
| `infrastructure` | `__03__Infrastructure` |
| `firefox` | `__04__Firefox` |
| `tooling` | `__05__Tooling` |

## `[extra]`

省略時の値は `content/posts/_index.md` の `[extra]`（section 設定）から引き継がれる．

| キー | 既定値 | 説明 |
| --- | --- | --- |
| `lang` | `"ja"` | `<html lang>` |
| `toc` | `true` | 目次を表示する |
| `copy` | `true` | コードブロックにコピーボタンを表示する |
| `comment` | `false` | コメント欄を表示する |
| `reaction` | `false`（`config.toml`） | リアクションを表示する |
| `outdate_alert` | `true` | 一定日数更新のない記事に警告を出す |
| `outdate_alert_days` | `91` | 上記の日数 |
| `math` | — | `true` で KaTeX を読み込む．`$...$`（インライン）/ `$$...$$`（ブロック） |
| `mermaid` | — | `true` で pele を読み込む．[`mermaid`](shortcodes.md#mermaid) shortcode を使う記事では必須 |
