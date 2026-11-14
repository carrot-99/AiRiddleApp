# 開発ガイド

## 1. 開発環境

| 項目 | バージョン |
| --- | --- |
| Xcode | 27.2 で動作確認（iOS 15 以上をビルドできるもの） |
| CocoaPods | 1.14.3 |
| 最低対応 OS | iOS 15.0 |
| Swift | 5（Swift 5 言語モード） |

## 2. セットアップ

```bash
pod install
```

```bash
open AiRiddleApp.xcworkspace
```

- `Pods/` と `Podfile.lock` は Git 管理外です。クローン後は必ず `pod install` を実行してください。
- `pod install` が `Unicode Normalization not appropriate for ASCII-8BIT` で失敗する場合は、ターミナルの文字コードを UTF-8 にしてから実行します。

```bash
LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 pod install
```

## 3. ビルドとテスト

Xcode ではスキーム `AiRiddleApp` を選び、実行は ⌘R、テストは ⌘U です。

```bash
xcodebuild test -workspace AiRiddleApp.xcworkspace -scheme AiRiddleApp -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

### テストの構成（`AiRiddleAppTests/`）

| ファイル | 対象 |
| --- | --- |
| `AnswerMatcherTests.swift` | 答えの判定ルール、答えと解説の分割 |
| `CSVReaderTests.swift` | CSV パーサ、**同梱の Riddle.csv の内容チェック** |
| `RiddleRepositoryTests.swift` | CSV と DB の同期（追加・更新・削除・重複） |
| `GameViewModelTests.swift` | ゲーム進行（自動判定・自己判定・スキップ・次へ・タイマー） |
| `RiddleViewModelTests.swift` | 出題の選び方、プレイ記録・ベストスコアの保存 |

テストはアプリをホストにして実行します。DB は一時ファイル、記録は専用の UserDefaults を使うため、シミュレータ上のアプリのデータには影響しません。

## 4. よくある作業

### なぞなぞを追加・修正する

1. `AiRiddleApp/Data/Riddle.csv` を編集（書式は [data.md](data.md)）
2. ⌘U でテストを実行。`BundledRiddleCSVTests` が次をチェックします
   - すべての行が 3 列か（カンマを含む欄を `"` で囲み忘れていないか）
   - 答えが空でないか
   - 問題文が重複していないか
   - 正解をそのまま入力したときに正解と判定されるか
3. アプリを起動すると、DB に自動で反映されます

### コースを追加する

`Models/Course.swift` に case を追加し、`questionCount`・`title`・`subtitle`・`iconName`・`color` を埋めます。コース選択画面とベストスコアの保存は自動で対応します。

### 制限時間を変える

`GameViewModel.timeLimit` を変更します。コース選択画面の案内文も自動で変わります。

### 見た目を変える

色・ボタン・カードの共通スタイルは `Components/AppStyle.swift` にあります。

## 5. 広告（AdMob）

広告ユニットIDはビルド設定 `ADMOB_BANNER_UNIT_ID` で切り替えています（`Info.plist` の `AdUnitID` が `$(ADMOB_BANNER_UNIT_ID)` を参照）。

| 構成 | 広告ユニットID |
| --- | --- |
| Debug | Google 公式のテスト用バナー `ca-app-pub-3940256099942544/2934735716` |
| Release | 本番のバナー |

開発中に本番の広告を表示・タップすると AdMob のポリシー違反になるおそれがあるため、**Debug では必ずテスト用IDを使います**。シミュレータでは「Test mode」と書かれた広告が表示されます。

`AdUnitID` が空の場合、広告バナーは表示されません（アプリは落ちません）。

## 6. リリース前チェックリスト

- [ ] `xcodebuild test` がすべて成功する
- [ ] Release 構成でビルドし、本番の広告ユニットIDになっていることを確認
- [ ] `MARKETING_VERSION`（表示バージョン）と `CURRENT_PROJECT_VERSION`（ビルド番号）を上げた
- [ ] 実機で、初回起動（利用規約の同意）〜 1ゲーム 〜 結果画面まで通しで確認した
- [ ] 利用規約・プライバシーポリシーの内容が最新

## 7. 注意点

- **Pod の対応バージョン**：新しい Xcode は iOS 15 未満を対象にしたビルドを受け付けません。`Podfile` の `post_install` で全 Pod を iOS 15.0 にそろえているので、この処理は消さないでください。
- **Xcode プロジェクトのファイル追加**：このプロジェクトはフォルダ同期ではなく、ファイルを個別に登録する形式です。新しい `.swift` ファイルは Xcode からターゲットに追加してください（Finder で置いただけではビルド対象になりません）。
- **シミュレータで日本語を入力するとき**：キーボードのかなキーをタップして入力します（Mac から日本語の文字列を貼り付けることはできません）。
