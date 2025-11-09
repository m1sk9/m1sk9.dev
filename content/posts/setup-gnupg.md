+++
title = "GnuPGのセットアップ"
date = 2025-11-08
# updated =
description = "GnuPG のセットアップについての備忘録"
[taxonomies]
categories = ["Dev"]
tags = ["yubikey", "gnupg", "security"]
[extra]
lang = "ja"
toc = true
math = true
mermaid = true
+++

初期化したときや新しい Laptop を迎えたときに行う GnuPG のセットアップについての備忘録．

## GnuPG と pinentry-mac のインストール

GnuPG と pinentry-mac をインストールする．

```bash
brew install gnupg pinentry-mac
```

## GnuPG の設定

Apple Silicon では Homebrew が配置する pinentry-mac のパスが異なるため， GnuPG の設定ファイルに pinentry-mac のパスを指定する必要がある．

```sh
echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
gpgconf --kill gpg-agent
```

## 鍵のインポート

YubiKey に保存してある鍵サーバから副鍵をインポートする．

```sh
gpg --card-edit
gpg> fetch
```

## SSH の疎通確認

鍵をインポートすると自動で SSH 鍵もインポートされるため，SSH の疎通確認を行う．

```sh
ssh-add -L # 鍵が表示されることを確認
ssh -T git@github.com
```

```
Hi m1sk9! You've successfully authenticated, but GitHub does not provide shell access.
```

## 署名テスト

最後に署名テストを行う．

```sh
echo "TEST" | gpg --clearsign
```
