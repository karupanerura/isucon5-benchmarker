# isucon5-benchmarker

ビルド済の公式ベンチマーカーとテストデータを同梱した、当日のベンチマーカーの動きをなんとなくエミュレートするスクリプトです。
perlとjavaが入っていれば、それだけでなんとなく動くお手軽さが特徴です。

# つかいかた

```bash
perl bench.pl サーバーのIP
```

こんな感じの結果が得られます:

```
RESULT: success
SCORE: 268.9
```

# 依存

## Perl

Perl v5.13.9 以降ではコアモジュールのみで実行可能です。
Perl v5.13.9 未満では[JSON::PP](https://metacpan.org/pod/JSON::PP)が必要です。[cpanm](https://metacpan.org/pod/App::cpanminus)でインストールしてください。

```bash
cpanm JSON::PP
```

## Java

JDK8なら確実にうごくけどようわからんです。
