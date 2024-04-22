# 認証構成

## ユーザーの種類

CycleCloudでは、以下の2種類のユーザーを区別して管理します。

+ CycleCloud ユーザー
  + CycleCloud のアプリケーション サーバーに存在
  + Web インターフェイス、コマンド ライン、およびさまざまな API へのアクセスを許可
+ クラスター ユーザー
  + CycleCloud によって管理される各ノードのオペレーティング システムに存在

## CycleCloudにおける認証構成

規定では、これら2種類のユーザーはCycleCloudのビルトイン認証を使用して認証され、両者の同期が行われます。
その他、CycleCloudは認証を行う際のユーザーレジストリとして以下の4つの方法をサポートしています。

+ ビルトイン：CycleCloud が保持するデータベース内にユーザー/パスワードを保持し、ユーザーはこのユーザー名とパスワードを用いて認証します。
+ Active Directory：Active Directory サーバーを使用してユーザーを認証します。
+ LDAP：LDAP サーバーを使用してユーザーを認証します。
+ Entra ID（Preview）：Entra ID サービスを使用してユーザーを認証します。

ここでは、Active DirectoryとEntra IDの連携について説明します。


## 認証の構成

以下のドキュメントを元に、AD連携（実際にはAADDSとの連携）、Previewの Entra ID連携を確認します。

+ [[ユーザー管理] - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/concepts/user-management?view=cyclecloud-8)
+ [ユーザー認証 - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/how-to/user-authentication?view=cyclecloud-8)
+ [クラスター ユーザー管理 - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/how-to/user-access?view=cyclecloud-8)

### Active Directoryとの連携

### Entra IDとの連携

+ [ユーザー認証 - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/how-to/user-authentication?view=cyclecloud-8)
+ [CycleCloud で使用する Entra アプリ登録を作成する (プレビュー) - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/how-to/create-app-registration?view=cyclecloud-8#creating-the-cyclecloud-app-registration)