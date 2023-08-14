## 説明

AWS lambda で実行するpythonコードのdeployment packageを作成するLinux 環境を作成します。
AWS lambdaでは、pythonで作成された関数を実行できますが、pip installが使用できないため、モジュールを利用するためには、あらかじめ実行ファイルをzipへ圧縮し、マネジメントコンソールからアップロードする必要があります。

このリポジトリでは、amazon linux 2 上でpythonのdeployment package を作成する仮想環境を提供します。

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

・venvで仮想環境構築
```
python3.9 -m venv venv
```

・仮想環境を有効化
```
source venv/bin/activate


※ 仮想環境に入れていればOK
(venv) bash-4.2#

※ venv有効化により src/ 以下にvenvディレクトリが作成される。
```

・pipを更新
```
python -m pip install --upgrade pip
```

・必要なモジュールをインストール
```
# paramiko

pip install paramiko

# dulwich

pip install --no-binary dulwich dulwich --config-settings "--build-option=--pure"

```

## zip作成

・仮想環境を無効化

```
deactivate
```

・コンテナから出る
```
exit
```

・ソースコードをコピーする
```
cp -f test.py ./src/venv/lib/python3.9/site-packages/
```

・対象のディレクトリへ移動
```
cd /プロジェクトroot/src/venv/lib/python3.9/
```

・site-packagesをzip化する
```
zip -r test_function ./site-packages
```

・プロジェクトroot/venv/lib/python3.9/ 以下にtest_function.zipの作成を確認

## zipのアップロード

・マネジメントコンソール > lambda <br/>
・対象の関数を選択 <br/>
・コンソールからzipのアップロード
・関数の実行は、ハンドラの設定を変更する <br/>
　-> site-packages/test.lambda_handler

```
ハンドラの設定が間違っていると下記のエラーとなるため注意

Runtime.ImportModuleError: Unable to import module ‘lambda_function’: No module named ‘lambda_function’ Traceback
```