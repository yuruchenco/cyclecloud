# CycleCloud の初期構成 を自動化する

CycleCloudは、MarketPlaceからVMとしてデプロイされます。デプロイ後インストールを完了するには、 [Web ベースのウィザード](/docs/configCCserver.md) でいくつかの設定を行う必要があります。

ほとんどの場合、手動デプロイは 1 回限りのプロセスであるため手動設定で十分ですが、場合によっては、グラフィカルインターフェイスを使用せずにインストールを自動化したい場合があります。

この様な場合、CycleCloud の構成ファイルを使用して、クラスターの設定や、各ノードの設定を自動化する事もできます。

[CycleServer 構成リファレンス - Azure CycleCloud](https://learn.microsoft.com/ja-jp/azure/cyclecloud/cycleserver-configuration-reference?view=cyclecloud-8)


## 構成ファイル

構成ファイルは、/opt/cycle_server/config 下に配置されています。主に以下のファイルがあります。

### cycle_server.properties

+ 管理用のWebサーバーに関する設定を格納するファイルです。
+ このファイルを編集するケースは、主にSSL証明書を設定する場合です。

### /opt/cycle_server/config/data ディレクトリ

+ このディレクトリ下に cyclecloud構成用のjsonファイルが配置されると、自動的にインポートされ、変更が適用されます。
+ 構成が正常にインポートされると、ファイルの名前が拡張子 .json.imported に変更されます。この機能を使用すると、インストールの自動化に必要なデータを提供できます。

参考：[Automate the deployment of your CycleCloud server with Bicep](https://techcommunity.microsoft.com/t5/azure-high-performance-computing/automate-the-deployment-of-your-cyclecloud-server-with-bicep/ba-p/3668769)


#### 設定してみる

ここでは、Active Directoryを統合して認証行うように変更する例を試してみます。

+ 管理者アカウントを構成するに、account_data.json という新しいファイルをそのディレクトリに作成します。名前は任意で、他の名前でもOKです。

```json:configure_ad.json
[
    {
        "AdType": "Application.Authenticator",
        "DefaultDomain": "@cc.com",
        "Disabled": false,
        "Label": "Active Directory",
        "Method": "active_directory",
        "Name": "active_directory",
        "Order": 100,
        "URL": "ldap://10.0.5.4"
    },
    {
        "AdType": "Application.Setting",
        "Name": "authorization.check_datastore_permissions",
        "Value": true
    }
]
```
ファイルを配置し、設定が正常に完了すると、以下の様に、.imported が付与されたファイルが作成されます。

```bash
[cycleadmin@vm-cyclecloud config]$ sudo ls -la data
total 20
drwxrwx---. 2 cycle_server cycle_server 151 Apr 19 02:38 .
drwxrwxr-x. 8 cycle_server cycle_server 153 Apr 22 01:40 ..
-rw-r--r--. 1 root         root         429 Apr 19 02:22 auth.json.failed
-rw-r--r--. 1 root         root         429 Apr 19 02:38 auth.json.imported
-rw-r--r--. 1 root         root          82 Apr  3 22:44 marketplace_site_id.txt.imported
-rw-rw----. 1 cycle_server cycle_server 179 Apr  3 22:43 settings.txt.imported
-rw-rw----. 1 cycle_server cycle_server  85 Apr  3 22:43 theme.txt.imported
```

