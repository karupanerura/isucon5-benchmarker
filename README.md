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
Perl v5.13.9 未満では[JSON::PP](https://metacpan.org/pod/JSON::PP)が必要です。  
[cpanm](https://metacpan.org/pod/App::cpanminus)でインストールしてください。

```bash
cpanm JSON::PP
```

## Java

JDK8なら確実にうごくけどようわからんです。

# 注意

`bench.jar` は僕の手元でビルドした、[fatjarしたオリジナルのベンチマーカー](https://github.com/karupanerura/isucon5-qualify/tree/fatjar)です。  
攻撃コードなどは混入させていませんが、心配な方は元のソースコードを読んだ上で自前でビルドしたfatjarを使うことをおすすめします。

# Licence / Copyright

## bench.jar, testsets.json

[公式のリポジトリ](https://github.com/isucon/isucon5-qualify)から独自にビルドあるいはコピーし、MITライセンスに則り再配布しています。  
https://github.com/isucon/isucon5-qualify#license

## bench.pl

http://karupanerura.mit-license.org/
