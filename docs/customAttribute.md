# Entra ID および Entra Domain Serviceでのカスタム属性

Entra ID および Entra Domain Service では、ユーザやグループに対してカスタム属性を追加することができます。

## Entra ID でのカスタム属性

Entra IDでは、カスタム属性として以下のものを追加することができます。

- カスタムセキュリティ属性
- 拡張機能

両者の位置づけは[ドキュメント](https://learn.microsoft.com/ja-jp/entra/fundamentals/custom-security-attributes-overview#how-do-custom-security-attributes-compare-with-extensions)で以下の様に説明されています。

機能 | Extensions | カスタム セキュリティ属性
--- | --- | ---
Microsoft Entra ID と Microsoft 365 オブジェクトを拡張する | はい | はい
サポート対象のオブジェクト | 拡張機能の種類によって異なる | ユーザーとサービス プリンシパル
制限付きアクセス | いいえ。 オブジェクトを読み取るアクセス許可を持つすべてのユーザーは、拡張機能データを読み取ることができます。 | はい。 読み取りおよび書き込みアクセスは、別のアクセス許可とロールベースのアクセス制御 (RBAC) のセットによって制限されます。
使用する場合 | アプリケーションで使用されるデータを保存する。機密以外のデータを保存する | 機密データを保存する。認可シナリオに使用する
ライセンスの要件 | Microsoft Entra ID のすべてのエディションで利用可能 | Microsoft Entra ID のすべてのエディションで利用可能

さらに、`拡張機能`については、以下の4種が提供されています。

- 拡張属性
  - **定義済みの名前**を持つ 15 個の拡張属性のセット
  - onPremisesExtensionAttributes プロパティと extensionAttributes プロパティを通じて、ユーザーまたはデバイスのリソース インスタンスに文字列値を格納するために使用
  - 15 個の拡張属性は Microsoft Graph で既に定義済み（extensionAttribute1 ～ extensionAttribute15 で固定）であり、**プロパティ名は変更不可**
  - よって、どの属性がどの目的で使用されているかを明確にするために、拡張属性の使用目的を文書化することが重要
- [ディレクトリ (Microsoft Entra ID) 拡張](https://learn.microsoft.com/ja-jp/graph/api/resources/extensionproperty?view=graph-rest-1.0)
  - アプリケーションに対して、ディレクトリ拡張機能の定義を行い、その定義を使用してディレクトリ オブジェクトにカスタム データを格納する
- スキーマ拡張
  - こちらもアプリに対してスキーマ拡張の定義を行い、その定義を使用してディレクトリ オブジェクトにカスタム データを格納する
- オープン拡張
  - 型指定されていないデータを直接リソース インスタンスに追加するためのシンプルで柔軟な方法

それぞれの差異については[ドキュメント：拡張機能の種類の比較](https://learn.microsoft.com/ja-jp/graph/extensibility-overview?tabs=http#comparison-of-extension-types)にまとめられています。

## Entra Domain Service でのカスタム属性

Entra Domain Service は、Azure が管理するドメインサービスで、自動的にEntra IDから一方向での同期が行われます。
先に見た4つの拡張機能のうち、Entra Domain Service では以下の2つの拡張機能を利用可能です。

- 拡張属性（onPremisesExtensionAttributes）
- ディレクトリ拡張

[以下](https://learn.microsoft.com/ja-jp/entra/identity/domain-services/concepts-custom-attributes)にある通り、その他の拡張はサポートされていません。
![Entra DSでサポートされない拡張](/docs/images/customattribute/entrads_unsupportedextension.png)

また、カスタム属性を利用するためには、Enterprise SKUが必要です。

## 検証：Entra IDからEntra DSへのディレクトリ拡張 の同期を確認する

以下の手順を参考に、Entra IDからEntra DSへのディレクトリ拡張の同期を確認してみます。
https://learn.microsoft.com/ja-jp/graph/api/resources/extensionproperty?view=graph-rest-1.0
https://learn.microsoft.com/ja-jp/entra/identity/domain-services/concepts-custom-attributes

### ディレクトリ拡張属性を定義する

ディレクトリ拡張を利用するには、まずはそれを所有するアプリケーションを作成する必要があります。
以下の手順で、ディレクトリ拡張属性を定義するアプリケーションを作成します。

- [CycleCloud で使用する Entra アプリ登録を作成する (プレビュー)](https://learn.microsoft.com/ja-jp/azure/cyclecloud/how-to/create-app-registration?view=cyclecloud-8#creating-the-cyclecloud-app-registration)

#### プロパティを作成

以下のAPIをコールして、ディレクトリ拡張属性を定義します。
APIは、graph Explorerから呼び出します。

APIコールの際には、予め 「Consent to permissions」からコール対象のAPIに対してConsentしておく必要があります。

![consenttopermissions](/docs/images/customattribute/consenttopermissions.png)

「Consent」をクリックして、同意します。
![Consent](/docs/images/customattribute/2024-05-28-18-27-24.png)


以下のリクエストを送信し、HomeDir 拡張プロパティを作成します。


```http
POST https://graph.microsoft.com/v1.0/applications/367d5529-40f9-4d7d-a4b5-b1409b56f62b/extensionProperties

{
    "name": "HomeDir",
    "dataType": "String",
    "targetObjects": [
        "User"
    ]
}
```

![](/docs/images/customattribute/2024-05-24-17-38-07.png)

以下の様な応答が返ります。

```json
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#applications('367d5529-40f9-4d7d-a4b5-b1409b56f62b')/extensionProperties/$entity",
    "id": "9ce1ad00-506f-4fab-ab4a-9f527342ef44",
    "deletedDateTime": null,
    "appDisplayName": "cyclecloud",
    "dataType": "String",
    "isMultiValued": false,
    "isSyncedFromOnPremises": false,
    "name": "extension_0d733bca93ac496b9de7f1921f5a69c0_homeDir",
    "targetObjects": [
        "User"
    ]
}
```
正常に作成されたようです。

![](/docs/images/customattribute/2024-05-24-17-38-38.png)


#### プロパティ登録の確認

以下のAPIをコールして、作成したプロパティが登録されていることを確認します。

```http
GET https://graph.microsoft.com/v1.0/applications/367d5529-40f9-4d7d-a4b5-b1409b56f62b/extensionProperties
```

以下の応答が返り、作成されていることが確認できました。

```json
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#applications('367d5529-40f9-4d7d-a4b5-b1409b56f62b')/extensionProperties",
    "@microsoft.graph.tips": "Use $select to choose only the properties your app needs, as this can lead to performance improvements. For example: GET applications('<guid>')/extensionProperties?$select=appDisplayName,dataType",
    "value": [
        {
            "id": "4bf0652f-48de-410c-a244-11282ecb5799",
            "deletedDateTime": null,
            "appDisplayName": "",
            "dataType": "String",
            "isMultiValued": false,
            "isSyncedFromOnPremises": false,
            "name": "extension_0d733bca93ac496b9de7f1921f5a69c0_shell",
            "targetObjects": [
                "User"
            ]
        },
        {
            "id": "9ce1ad00-506f-4fab-ab4a-9f527342ef44",
            "deletedDateTime": null,
            "appDisplayName": "",
            "dataType": "String",
            "isMultiValued": false,
            "isSyncedFromOnPremises": false,
            "name": "extension_0d733bca93ac496b9de7f1921f5a69c0_homeDir",
            "targetObjects": [
                "User"
            ]
        }
    ]
}
```
![](/docs/images/customattribute/2024-05-24-18-10-12.png)


### ターゲットオブジェクト（ユーザー）に拡張プロパティを追加する

作成したプロパティは、そのプロパティを付与するオブジェクトに関連付けて初めて利用できるようになります。以下のAPIをコールして、ユーザーオブジェクトに拡張プロパティを追加します。

```http
PATCH https://graph.microsoft.com/v1.0/users/b36e25f1-371a-4688-bfb5-78d811742bc2
{
    "extension_0d733bca93ac496b9de7f1921f5a69c0_homeDir": "/shared/home/",
    "extension_0d733bca93ac496b9de7f1921f5a69c0_shell": "/bin/bash"
}

```
![](/docs/images/customattribute/2024-05-24-18-14-42.png)

![](/docs/images/customattribute/2024-05-24-18-01-40.png)

### 確認する

```http
GET https://graph.microsoft.com/v1.0/users/b36e25f1-371a-4688-bfb5-78d811742bc2
```

Userの指定だけだと、既定のプロパティしか取得できないので、`$select`を使って取得するプロパティを指定します。
![](/docs/images/customattribute/2024-05-24-18-05-59.png)

```http
GET https://graph.microsoft.com/v1.0/users/b36e25f1-371a-4688-bfb5-78d811742bc2?$select=id,displayName,extension_0d733bca93ac496b9de7f1921f5a69c0_homeDir,extension_0d733bca93ac496b9de7f1921f5a69c0_shell
```

以下の通り、ユーザーに追加したプロパティ2つが取得できました。
![](/docs/images/customattribute/2024-05-24-18-16-40.png)

```json
{
    "@odata.context": "https://graph.microsoft.com/v1.0/$metadata#users/$entity",
    "id": "b36e25f1-371a-4688-bfb5-78d811742bc2",
    "displayName": "Entra User",
    "extension_0d733bca93ac496b9de7f1921f5a69c0_homeDir": "/shared/home/",
    "extension_0d733bca93ac496b9de7f1921f5a69c0_shell": "/bin/bash"
}
```
これで、対象のオブジェクト（ユーザー）に、拡張プロパティを追加することができました。

### Entra DSへの同期を確認する

次に、Entra IDからEntra DSへの同期を確認します。

#### Entra DSの同期設定

Azure Portalにログインし、Entra DSへの同期対象になるプロパティを設定します。カスタム属性 から、追加 ボタンをクリックします。

![](/docs/images/customattribute/2024-05-24-18-19-26.png)

以下の画面が開きますので、先のステップで追加した属性を選択します。

![](/docs/images/customattribute/2024-05-24-18-19-54.png)

確認し、保存します。

![](/docs/images/customattribute/2024-05-24-18-21-55.png)

Entra DSへの同期を、Active Directory 管理ツールから確認してみます。

以下の通り、先ほど追加したプロパティが同期されていることが確認できました。

![](/docs/images/customattribute/2024-05-24-18-44-13.png)
![](/docs/images/customattribute/2024-05-24-18-44-52.png)


