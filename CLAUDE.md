# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

はてなブログエントリーの自動投稿ツール。CSVファイルからブログエントリーを生成し、Hatena Blog AtomAPI経由で投稿する。

## 開発コマンド

### セットアップ
```bash
bundle install
cp .env.sample .env
# .envファイルにHatena BlogのUSERNAME、BLOG_DOMAIN、API_KEYを設定
```

### テスト実行
```bash
bundle exec rspec                    # 全テスト実行
bundle exec rspec spec/path/to/file  # 特定ファイルのテスト実行
```

### リント・フォーマット
```bash
bundle exec rubocop                  # コードスタイルチェック
bundle exec rubocop -a              # 自動修正可能な問題を修正
```

### アプリケーション実行
```bash
ruby main.rb  # CSVファイル(sample.csv)からブログエントリーを投稿
```

## アーキテクチャ

### 主要モジュール

- **HatenaBlog::Config**: 環境変数からの設定管理とバリデーション
- **HatenaBlog::EntryGenerator**: CSVファイルの読み込みとAtomエントリー生成
- **HatenaBlog::Client**: Hatena Blog AtomAPIクライアント（atomutil gemを使用）
- **HatenaBlog::EntryData**: ブログエントリーのデータ構造とコンテンツ生成

### データフロー

1. `EntryGenerator`がCSVファイルを読み込み、`EntryData`に変換
2. `EntryData`からAtomエントリーを生成
3. `Client`がAtomAPIを使用してHatena Blogに投稿

### 設定

- `.env`ファイルで認証情報を管理
- `DRAFT_MODE`環境変数で下書き投稿を制御（デフォルト: yes）
- CSVフォーマット: `title,doc_url`の2列構造

### エラー処理

- カスタム例外クラス（ConfigurationError、AuthenticationError、PostError、CSVError）
- バッチ処理時は個別エントリーの失敗を記録して継続