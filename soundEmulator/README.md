# Abstract

soundEmulatorはBasys3に開発した音楽シーケンサのソフトウェアエミュレータです．
Block RAMに書き込むCOEファイルを入力すると音楽シーケンサとほぼ同じ音が聴けます．
回路を再合成しなくてもCOEファイルが期待する音楽を鳴らせるか確認することができます．

# Setup

## Ubuntu 18.04 LTS

```
$ sudo apt install openjdk-8-jdk gradle -y # JDKとGradleをインストール
$ gradle build # soundEmulatorをコンパイル
```

# How to Use

## gradleコマンドを使う場合

```
$ gradle run -Pargs="<coe-file-name>"
```

<coe-file-name>にはdata/coe/下にあるCOEファイルが3つあるディレクトリの名前を指定してください．
Carby, frog, mario, newMarioが利用できます．

## javaコマンドを使う場合

```
$ cd build/classes/java/main/
$ java soundEmulator <coe-file-1> <coe-file-2> <coe-file-3>
```

<coe-file-1>, <coe-file-2>, <coe-file-3>には聴きたい音源データのCOEファイルを直接指定して下さい．

# Original Author

新井 健太(2019年度修了)

# Special Thanks

大川猛先生
征矢あおいさん(2017年度卒)
