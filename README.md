# はてなブログ エントリー投稿ツール

CSVファイルからブログエントリーを生成し、はてなブログに自動投稿するRubyツールです。

## 機能

- CSVファイルからブログエントリーの一括生成
- はてなブログ AtomAPI を使用した自動投稿
- 投稿結果の詳細レポート
- 下書きモードでの投稿
- エラーハンドリングとログ出力

## 必要環境

- Ruby 3.4.0以上
- Bundler

## セットアップ

1. リポジトリをクローン
```bash
git clone <repository-url>
cd hatena-blog-entry-post
```

2. 依存関係をインストール
```bash
bundle install
```

3. 環境変数を設定
```bash
cp .env.sample .env
```

`.env`ファイルを編集して以下の情報を設定：
```
USERNAME=あなたのはてなID
BLOG_DOMAIN=あなたのブログドメイン（例：example.hatenablog.com）
API_KEY=はてなブログのAPIキー
DRAFT_MODE=yes  # 下書きで投稿する場合はyes、公開する場合はno
```

## 使用方法

1. CSVファイルを準備

`entry.csv.sample`を参考に、投稿したいエントリー情報をCSVファイルに記載：

```csv
title,doc_url
"サンプルタイトル","https://example.com/sample"
"別のタイトル","https://example.com/another"
```

2. 投稿を実行

```bash
ruby main.rb
```

## CSVファイル形式

| カラム名 | 説明 | 必須 |
|---------|------|------|
| title | ブログエントリーのタイトル | ✓ |
| doc_url | 参照するドキュメントのURL | ✓ |

## 出力例

```
Processing entry 1/2
Creating entry: サンプルタイトル
Successfully created entry: https://example.hatenablog.com/entry/2023/12/01/120000
Processing entry 2/2
Creating entry: 別のタイトル
Successfully created entry: https://example.hatenablog.com/entry/2023/12/01/120001
Completed: 2/2 entries successfully created
✓ Entry 1: https://example.hatenablog.com/entry/2023/12/01/120000
✓ Entry 2: https://example.hatenablog.com/entry/2023/12/01/120001
```

## 開発

### テストの実行

```bash
# 全テスト実行
bundle exec rspec

# 特定のテストファイル実行
bundle exec rspec spec/hatena_blog/config_spec.rb
```

### コードスタイルチェック

```bash
# チェック実行
bundle exec rubocop

# 自動修正
bundle exec rubocop -a
```

## エラーの対処

### 認証エラー
- `USERNAME`、`BLOG_DOMAIN`、`API_KEY`が正しく設定されているか確認
- はてなブログの設定でAtomPub APIが有効になっているか確認

### CSVエラー
- CSVファイルのフォーマットが正しいか確認
- 必須カラム（title、doc_url）が空でないか確認

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。
