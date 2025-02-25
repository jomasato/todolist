# `todolist`

1,はじめに

今回のwaveではシンプルなtodolistアプリを作成しました。
基本的な機能であるcreate,read,update and delete(CRUD)ができるバックエンドはICPで作成しました。
また，フロントエンドについては自動で生成されるcandidUIを活用しています。

今回はローカル環境で完結する仕様となっています。

＜参考資料＞
クイックスタート（https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally.）
SDK 開発ツール（https://internetcomputer.org/docs/current/developer-docs/setup/install）
Motoko プログラミング言語ガイド（https://internetcomputer.org/docs/current/motoko/main/motoko）
Motoko 言語クイックリファレンス（https://internetcomputer.org/docs/current/motoko/main/language-manual）

2,基本コマンド

bashCopycd todolist/
dfx help
dfx canister --help

3,ローカルでのプロジェクト実行

今回はローカル環境で完結する仕様で作成します。

まずはローカルにおいてInternet Computer（IC）の開発環境においてローカルシミュレーション環境を立ち上げる（レプリカの起動）します
'dfx start --background'

次にプロジェクトをデプロイ（# canister をレプリカにデプロイし、Candid インターフェースを生成）
'dfx deploy'

デプロイが完了すると、アプリケーションは http://localhost:4943?canisterId={asset_canister_id} でアクセス可能になります。


4,開発作業

バックエンド canister を変更した場合は、以下のコマンドで新しい Candid インターフェースを生成できます：
'npm run generate'

フロントエンドの変更を行う場合は、開発サーバーを起動できます：
'npm start'
これにより、http://localhost:8080 でサーバーが起動し、ポート 4943 のレプリカに API リクエストをプロキシします。

5,フロントエンド環境変数に関する注意

DFX を使用せずにフロントエンドコードをホスティングする場合は、以下のいずれかの調整が必要です：

Webpack を使用している場合は DFX_NETWORK を ic に設定
自前の方法で自動生成された宣言内の process.env.DFX_NETWORK を置換
独自の createActor コンストラクタを作成
