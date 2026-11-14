# AIなぞなぞ

「AIに勝てるかな？」がテーマの iOS なぞなぞアプリです。
制限時間内になぞなぞに答え、同じ問題に対する **AIの答え** と正解数を競います。

- SwiftUI / iOS 15 以上 / iPhone・iPad 対応
- 問題データは CSV（`AiRiddleApp/Data/Riddle.csv`、現在 200 問）
- 広告：Google AdMob バナー

## クイックスタート

```bash
pod install
```

```bash
open AiRiddleApp.xcworkspace
```

`.xcodeproj` ではなく **`.xcworkspace`** を開いてください。スキーム `AiRiddleApp` を選んで実行（⌘R）、テストは ⌘U です。

コマンドラインでテストする場合：

```bash
xcodebuild test -workspace AiRiddleApp.xcworkspace -scheme AiRiddleApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## ドキュメント

| ドキュメント | 内容 |
| --- | --- |
| [docs/architecture.md](docs/architecture.md) | 全体構成、各レイヤーの責務、ゲーム進行の状態遷移 |
| [docs/screens.md](docs/screens.md) | 画面一覧と画面遷移、各画面の仕様 |
| [docs/data.md](docs/data.md) | CSV の書式、DB スキーマ、記録の保存形式、答え判定のルール |
| [docs/development.md](docs/development.md) | 開発環境、ビルド・テスト、問題の追加手順、リリース手順、注意点 |

## ディレクトリ構成

```
AiRiddleApp/
├── AiRiddleApp.swift        アプリのエントリポイント
├── Models/                  データ型（Riddle, RiddleResult, Course）
├── Services/                CSV 読み込み・DB・答え判定・記録保存
├── ViewModels/              画面の状態管理（RiddleViewModel, GameViewModel）
├── Views/                   SwiftUI の画面
├── Components/              共通のスタイル（ボタン、カード）
├── Common/                  広告バナー、触覚フィードバック
├── Data/Riddle.csv          問題データ
└── Info.plist
AiRiddleAppTests/            ユニットテスト
docs/                        設計書
```
