+++
title = "Paper (Spigot) の EventPriority とは何か"
date = 2026-02-01
# updated =
description = "EventPriority を適当に設定するな"
[taxonomies]
categories = ["Dev"]
tags = ["minecraft", "papermc"]
[extra]
lang = "ja"
toc = true
math = true
mermaid = true
+++

EventPriority を適当に設定するな

## EventPriority とは

EventPriority は，`@EventHandler` annotation の引数として指定できる列挙型で，イベントリスナーの実行順序を制御するための優先度システム．

[EventHandler (paper-api 1.21.11-R0.1-SNAPSHOT API)](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventHandler.html)

[EventPriority (paper-api 1.21.11-R0.1-SNAPSHOT API)](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html)

例えば複数のプラグインが同じイベント (例えば `PlayerJoinEvent` ) を捕捉しようとしている場合，どのプラグインが先に実行されるかを決めるのが EventPriority である．

```kotlin
@EventHandler(priority = EventPriority.HIGHEST)
fun onChat(event: AsyncChatEvent) {
  val player = event.player
  // ...
```

この優先度は以下のようになっている．

| | 列挙型 | 優先度 |
|---|---|---|
| 1 | [`EventPriority.HIGHEST`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#HIGHEST) | 最も高い |
| 2 | [`EventPriority.HIGH`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#HIGH) | 高い |
| 3 | [`EventPriority.NORMAL`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#NORMAL) | 通常 (デフォルト) |
| 4 | [`EventPriority.LOW`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#LOW) | 低 |
| 5 | [`EventPriority.LOWEST`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#LOWEST) | 最も低い |
| 6 | [`EventPriority.MONITOR`](https://jd.papermc.io/paper/1.21.11/org/bukkit/event/EventPriority.html#MONITOR) | 監視用 (後述するイベントの結果を変更しない場合の優先度) |

## 使い分け

EventPriority の使い分けは次のように考えると良い

- `HIGHEST` / `HIGH` : 他のプラグインよりも先に処理・キャンセルしたい場合に使用する．例えば，チャットフィルターや権限管理など，ゲームプレイに直接影響を与える処理に適している．
- `NORMAL` : 特に優先度を指定しない場合に使用する．多くのプラグインはこの優先度で十分である．
- `LOW` / `LOWEST` : 他のプラグインの処理が完了した後に実行したい場合に使用する．例えば，ログ記録や通知など，ゲームプレイに直接影響を与えない処理に適している．

適当に設定すると不具合の原因になるので，特にサーバのメインプラグインなどを開発している場合は注意が必要である．

## MONITOR とは?

`MONITOR` は，イベントの結果を変更しない場合に使用する優先度である．例えば，ログ記録や通知など，イベントの結果に影響を与えない処理 ( `read-only` )に適している．優先度的には `LOWEST` の次に実行される．なので，イベントの最終結果を監視したい場合に適しているのだ．

ログ管理プラグインとして有名な CoreProtect では [`AsyncChatEvent` を `MONITOR` で捕捉し，チャット内容をログに記録している](https://github.com/PlayPro/CoreProtect/blob/b0856b51a565ff6bb1266a98633437aae580c507/src/main/java/net/coreprotect/paper/listener/PaperChatListener.java#L15-L20)．

```java
@EventHandler(priority = EventPriority.MONITOR)
public void onPlayerChat(AsyncChatEvent event) {
  String message = PlainTextComponentSerializer.plainText().serialize(event.message());
  if (message.isEmpty()) {
    return;
  }
  // ...
```

## `MONITOR` の特別な仕様

前述した通り， `MONITOR` は実行順序では最後になるが，単なる優先度ではなく，イベントの最終状態を観察するための専用列挙型として設計されている．

### キャンセル不可

`MONITOR` 以外の優先度 ( `HIGHEST` から `LOWEST` ) では，イベントをキャンセルすることが可能である．例えば， `PlayerJoinEvent` を `HIGHEST` で捕捉し，以下のようにイベントをキャンセルすることができる[^1]．

```java
@EventHandler(priority = EventPriority.HIGHEST)
public void onPlayerJoin(PlayerJoinEvent event) {
    event.setCancelled(true); // プレイヤーの参加をキャンセル
}
```

しかし， `MONITOR` では，イベントをキャンセルすることはできない． `MONITOR` で捕捉されたイベントは，すでに他の優先度で処理されており，その結果を変更することは許されていない．以下のコードは無効である．

```java
@EventHandler(priority = EventPriority.MONITOR)
public void onPlayerJoin(PlayerJoinEvent event) {
    if (event.isCancelled()) {
        // 他のプラグインがキャンセルしたかどうか判定できる
        plugin.log("Player join was cancelled");
    }
    // でもこのメソッドでは event.setCancelled(true) しても何も起こらない
}
```

### あくまでイベントの監視用

`MONITOR` は，あくまでイベントの最終状態を監視するために使用されるべきであり，イベントの結果を変更するために使用されるべきではない．例えば，ログ記録や通知など，イベントの結果に影響を与えない処理に適している．

イベントキャンセルができない = 別のプラグインの妨害を無効化できるという考えなので，以下の使い方ができる．

```java
@EventHandler(priority = EventPriority.MONITOR)
public void onPlayerJoinMonitor(PlayerJoinEvent event) {
    // ログや統計情報の記録
    logDatabase.recordJoin(event.getPlayer(), !event.isCancelled());
    
    // メトリクスの更新
    metrics.incrementPlayerJoinCount(event.isCancelled());
}
```

## Tickrate への影響

`MONITOR` は常に実行されるため，負荷のある処理 (例えばデータベースへのアクセスなど)を同期的に行うと，サーバの Tickrate に影響を及ぼしてしまう．そのため， `MONITOR` で重い処理を行う場合は，非同期に処理を行うか，別のスレッドで処理を行うことが推奨される．

```java
@EventHandler(priority = EventPriority.MONITOR)
public void onPlayerJoin(PlayerJoinEvent event) {
    Bukkit.getScheduler().runTaskAsynchronously(plugin, () -> {
        database.recordJoin(event.getPlayer());
    });
}
```

[^1]: `PlayerJoinEvent` は実際にはキャンセル不可なイベント
