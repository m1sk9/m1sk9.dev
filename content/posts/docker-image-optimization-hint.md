+++
title = "Rust における Docker Image の軽量化を考えてみる"
date = 2025-02-03
# updated =
description = "distroless 一択"
[taxonomies]
categories = ["Dev"]
tags = ["rust", "docker"]
[extra]
lang = "ja"
toc = true
math = true
mermaid = true
+++

ここ2年くらいずっと保守しているプロジェクトに babyrite というものがある．これはメッセージリンクからプレビューを生成しそれを埋め込みとして返す Discord Bot の一つ．

![](/assets/post/image/docker-image-optimization-hint/babyrite-using.png)

[m1sk9/babyrite: A lightweight, fast citation message Discord bot.](https://github.com/m1sk9/babyrite)

このような Bot は色んな人が開発してホストして外部公開してくれている[^1]．もちろんそれらの Bot を使っても構わないが，このようなメッセージ取得系の Bot は本来外部に公開されてはいけないデリケートなメッセージも取得することがあり，私のような捻くれオタクはこのような Bot を使うことに懐疑的．(だってソースコード公開されているわけでもないし)

そのようなオタク向けに babyrite は Docker Image を GitHub Container Registry (ghcr.io) 経由で公開している．[babyrite v0.13.0](https://github.com/m1sk9/babyrite/blob/main/CHANGELOG.md#0130-2024-10-23) ではこの Docker Image を大胆な軽量化に成功したのでメモ的に書いておこうと思う．

## Multi-stage builds を活用する

Docker Image ビルド時に [Multi-stage builds](https://docs.docker.com/build/building/multi-stage/) を使用する．実際これが一番手っ取り早い最適方法だったりする．

babyrite は Rust で書かれているため， Rust の公式イメージを使用してリリースビルドを行う．

速度を求めるならここのイメージも色々選定が必要そうだが，Rust を使ってる時点で遅すぎるコンパイルという十字架を背負うので私は考えていない． (そのコンパイルも結局はマシン側の性能に依存する)

```dockerfile
FROM rust:1.80.1-bookworm as Builder

WORKDIR /root/app
COPY --chown=root:root . .

RUN cargo build --release --bin babyrite
```

この成果物を後述の実行ステージのイメージに移動する．`COPY` に `--from` prefix で指定することで移動可能．

```dockerfile
COPY --from=builder --chown=root:root /root/app/target/release/babyrite /
```

この Multi-stage builds に関してはネット上に大量に記事があるためここで解説はしない．使い方等は公式ドキュメントを読むが一番だ．

[Multi-stage | Docker Docs](https://docs.docker.com/build/building/multi-stage/)

## 実行ステージのイメージに Distroless を使用する

さて，次はこのビルドした babyrite のバイナリをどこで実行しようという話になる．

babyrite は正直 Discord API とのやり取りしか行わず，他の Bot のようにログ記録機能を備えているわけでもない．

そのため，単純な Ubuntu や Debian のイメージを使っても問題はないのだが，このようなイメージは無駄なパッケージが含まれており，折角の成果物が数サイズなのに実行イメージだけで 100MB 近く埋まってしまう．

そこで軽量イメージとして主流になってる Distroless を採用してみようと考えた．

[GoogleContainerTools/distroless: 🥑 Language focused docker images, minus the operating system.](https://github.com/GoogleContainerTools/distroless/)

### Distroless とは

Google [^2] がメンテしているイメージ群で，最低限必要な設定や実行ファイルだけが含まれているため，コンテナイメージのサイズを小さくすることができる．

ベストプラクティスかどうかと問われると私はその線で詳しくはないので以下の記事に説明を丸投げしようと思う[^3]．

[セキュアで軽量なdistrolessコンテナを作成する #Docker - Qiita](https://qiita.com/t_katsumura/items/462e2ae6321a9b5e473e)

babyrite ではこのような形で最終的な実行形態にしている．

```dockerfile
FROM gcr.io/distroless/cc-debian12 AS runner

COPY --from=builder --chown=root:root /root/app/target/release/babyrite /

CMD ["./babyrite"]
```

非常にシンプルな最適化を加えることで 60MB ほどの減量に成功した．

![](/assets/post/image/docker-image-optimization-hint/docker-image-size.png)

## Alpine は？

**やめたほうがよさそう**．この話については inductor さんの記事が簡潔で分かりやすい．

[軽量Dockerイメージに安易にAlpineを使うのはやめたほうがいいという話 - inductor's blog](https://blog.inductor.me/entry/alpine-not-recommended)

## おまけ: コンパイルオプションを利用する

> この記事を書いてる最中に思いついたので追加で書いておこうと思う．ただリリースビルドの時間がバカにならないので babyrite には取り込んでいない．

バイナリのコンパイルに対しても最適化を行い，バイナリサイズを削減することも可能だ．

- [Profiles - The Cargo Book](https://doc.rust-lang.org/cargo/reference/profiles.html)
- [cargo build - The Cargo Book](https://doc.rust-lang.org/cargo/commands/cargo-build.html)

`Cargo.toml` に以下の設定を加えてコンパイルしてみる．

```toml
[profile.release]
lto = true
strip = false
codegen-units = 8
```

```sh
cargo build --release
```

上の設定を行うと Cargo は次のような挙動でリリースビルドを行うようになる:

- Link Time Optimization (lto): [^4]
  - リンク時間が長くなる (=総合的にはコンパイル時間が長くなる) 代償として，プログラム全体の解析を行い，より最適化されたコードを生成します．
- strip: [^5]
  - バイナリからシンボル，またはデバッグ情報を取り除くようになります．[^6]
- codegen-units: [^7]
  - Cargo がリリースビルド時に使用する並列コード生成ユニットの数を指定します．このユニット数が少なければ少ないほどバイナリサイズは最適化されるが，同時にコンパイル時間は長くなる．
結果はこんな感じ:

| オプション | サイズ | コンパイル時間 |
| ---- | ---- | ---- |
| あり | 14M | 4m 36s |
| なし | 17M | 2m 43s |

たかが数サイズ程度の削減で，コンパイル時間と天秤にかけると私的にはこれは無しかなとは思っている．

----

[^1]: イケBot とか
[^2]: Google は嫌いだけど Distroless は嫌いじゃない！
[^3]: Shell がないのでちょっとした処理を追加できないという指摘については賛同したい
[^4]: https://doc.rust-lang.org/cargo/reference/profiles.html#lto
[^5]: https://doc.rust-lang.org/cargo/reference/profiles.html#strip
[^6]: macOS 及び Linux でのお話．
[^7]: https://doc.rust-lang.org/cargo/reference/profiles.html#codegen-units
