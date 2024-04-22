# クラスターのテスト

## ジョブの投入確認

簡単なサンプルスクリプトを用意してジョブの投入テストを行います。以下のHello Worldスクリプト(hello.sh)を用意します。

```bash
#!/bin/bash
echo "Hello World"
sleep 60
```

### ジョブの投入

次のコマンドを実行して、このスクリプトを計算ノードへジョブとして投入します。ここでは、executeという
（実行対象の計算ノードのQuotaが足りない場合は、ジョブがエラーとなります。）

ジョブ制御コマンドの詳細については以下を参照してください。
+ [qsub man | Linux Command Library](https://linuxcommandlibrary.com/man/qsub)
+ [ジョブスケジューラーOpenPBS/PBS Proの使い方 - Qiita](https://qiita.com/amasaki203/items/4c78d08a100a99cfc323)
+ [PBSジョブスケジューラのtips - Qiita](https://qiita.com/H1r0ak1Y0sh10ka/items/21b9a1a28bcbfbf1d8ab)

```bash
qsub -l select=1:slot_type=execute hello.sh
```

実行例

```bash [実行例]
[cycleadmin@ip-0A000304 demo]$ qsub -l select=1:slot_type=execute hello.sh
1.ip-0A000304
```

### ジョブのステータス確認

投入されたジョブを次のコマンドで確認します。
+ Job ID：PBSによって割り当てられるジョブの識別子
+ Username：ジョブの所有者のユーザー名
+ Queue：そのジョブが所属するキューの名前
+ SessID：セッションID。ジョブの実行中にのみ表示される
+ NDS：そのジョブが要求したchunkまたはvnodeの数
+ TSK：そのジョブが要求したCPUの数
+ Req'd Memory：そのジョブが要求したメモリの総量
+ Req'd Time：そのジョブが要求したwalltimeまたはCPU時間
+ S：ジョブの状態（State）を指す
  + Rならば、実行中、
  + Qならば、キューに入れられて待機中、
  + Eならば、終了処理中である。（その他はman qstatを参照）
+ Elap Time：実時間またはCPU時間での経過時間

```txt
[cycleadmin@ip-0A000304 demo]$ qstat -nas

ip-0A000304:
                                                            Req'd  Req'd   Elap
Job ID          Username Queue    Jobname    SessID NDS TSK Memory Time  S Time
--------------- -------- -------- ---------- ------ --- --- ------ ----- - -----
0.ip-0A000304   cyclead* workq    hello.sh      --    1   1    --    --  Q   --
    --
    --
```

ジョブを投入すると、以下の様にexecute にクラスタにジョブが投入され、VM
が起動します。

![ジョブ投入後のノードの状態](/docs/images/node_status_after_job_submit.png)

VMの状態は、「Show Detail」をクリックする事で詳細を確認できます。

![ノードの状態詳細](/docs/images/node_status_detail.png)


因みに、HB120rs_v2 にジョブを投入してみたところ、Quota不足により以下の様にエラーとなっている事が確認できます。

```bash
[cycleadmin@ip-0A000304 demo]$ qstat -nas

ip-0A000304:
                                                            Req'd  Req'd   Elap
Job ID          Username Queue    Jobname    SessID NDS TSK Memory Time  S Time
--------------- -------- -------- ---------- ------ --- --- ------ ----- - -----
0.ip-0A000304   cyclead* workq    hello.sh      --    1   1    --    --  Q   --
    --
   Can Never Run: Insufficient amount of resource: slot_type (HB120rs_v2 !...
   
```

更にステータス確認すると、ステータスを示す「S」が「R」となり、実行中であることが確認できます。

```bash
[cycleadmin@ip-0A000304 demo]$ qstat -ans

ip-0A000304:
                                                            Req'd  Req'd   Elap
Job ID          Username Queue    Jobname    SessID NDS TSK Memory Time  S Time
--------------- -------- -------- ---------- ------ --- --- ------ ----- - -----
0.ip-0A000304   cyclead* workq    hello.sh     5393   1   1    --    --  R 00:00
   ip-0A000306/0
   Job run at Tue Apr 16 at 05:03 on (ip-0A000306:ncpus=1)
1.ip-0A000304   cyclead* workq    hello.sh      --    1   1    --    --  Q   --
    --
   Can Never Run: Insufficient amount of resource: slot_type (HB120rs_v3 !...
2.ip-0A000304   cyclead* workq    hello.sh      --    1   1    --    --  Q   --
    --
   Not Running: Not enough free nodes available
```

ジョブ実行が終了すると、自動的にVMが削除されます。

![ノード停止中](/docs/images/node_stopping.png)


次にマルチノードのジョブのテストを行います。次のコマンドでexecute に対して4ノードのジョブを投入します。

```bash
[cycleadmin@ip-0A000304 demo]$ qsub -l select=4:ncpus=1:slot_type=execute hello.sh
4.ip-0A000304
[cycleadmin@ip-0A000304 demo]$ qstat -ans

ip-0A000304:
                                                            Req'd  Req'd   Elap
Job ID          Username Queue    Jobname    SessID NDS TSK Memory Time  S Time
--------------- -------- -------- ---------- ------ --- --- ------ ----- - -----
4.ip-0A000304   cyclead* workq    hello.sh      --    4   4    --    --  Q   --
    --
    --
```

4ノードが起動している事が確認できます。

![4ノード起動中](/docs/images/4nodes_starting.png)

Azure Portalから確認してみると、VMSSとして4台のVMが起動している事が確認できます。

![4ノード起動ポータルでの確認](/docs/images/4nodes_starting_on_portal.png)
