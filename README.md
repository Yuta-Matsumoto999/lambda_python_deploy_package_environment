## 説明

AWS lambda で実行するpythonコードのdeployment packageを作成するLinux 環境を作成します。
AWS lambdaでは、pythonの関数を実行できますが、pip installなどが使用できないため、モジュールを利用するためには、あらかじめ実行ファイルとモジュール群をdeployment packageとして作成し、zip形式でマネジメントコンソールからアップロードする必要があります。

ローカルで作成することも可能ですが、OSによっては、互換性が衝突するライブラリなどが存在するため、Dockerで作成された amazon linux 2 上で、pythonの deployment package を作成する手順を記載します。

## 環境

・amazon linux 2 <br />
・python 3.9

## ディレクトリ構成
```
.
├── docker-compose.yml
├── Dockerfile
└── src/
    └── test.py
```

## 利用方法

### git clone

```
git clone https://github.com/Yuta-Matsumoto999/lambda_python_deployment_package_environment.git
```

・任意のディレクトリへリポジトリをclone

### ソースコード配置
.src/ 以下にソースコードを配置


### コンテナ起動

```
make up
```

### コンテナ起動確認

```
make ps
```

### コンテナに入る

```
make app
```

### コンテナ内で作業
・home ディレクトリへ移動
```
cd home
```

・venvで仮想環境構築(初回のみ)
```
python3.9 -m venv venv

※ /home/にvenvディレクトリが作成される。
```

・仮想環境を有効化
```
source venv/bin/activate


※ 仮想環境に入れていればOK
(venv) bash-4.2#
```

・pipを更新(初回のみ)
```
python -m pip install --upgrade pip
```

・必要なモジュールをインストール (必要なものをインストールする)
```
# paramiko

pip install paramiko

# dulwich

pip install --no-binary dulwich dulwich --config-settings "--build-option=--pure"

# boto3

pip install boto3

```

## zip作成

・仮想環境を無効化

```
deactivate
```

・対象のディレクトリへ移動
```
cd /home/venv/lib/python3.9/site-packages
```

・site-packagesをzip化する
```
zip -r ../../../../test_package.zip .

※ ファイル名はお好みで
```

・home/ 以下にtest_package.zipの作成を確認

・ソースコードをzipへ追加する

```
cd /home

zip test_package.zip test.py
```

・.sshディレクトリをzipへ追加(必要な場合)
```
zip test_package.zip ssh/*

※ development packageへ秘密鍵を含める場合には、sshディレクトリを作成し、その配下に必要なkeyファイルをおいてください。

```

## zipのアップロード

・マネジメントコンソール > lambda <br/>
・対象の関数を選択 <br/>
・コンソールからzipのアップロード<br/>
・ハンドラの設定を変更する <br/>
　-> site-packages/test.lambda_handler

```
ハンドラの設定が間違っていると下記のエラーとなるため注意

Runtime.ImportModuleError: Unable to import module ‘lambda_function’: No module named ‘lambda_function’ Traceback
```