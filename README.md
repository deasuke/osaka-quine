# osaka-quine
山手quineと同様なものを大阪環状線で作ってみました。
[あなたの知らない超絶技巧プログラミングの世界](https://www.amazon.co.jp/あなたの知らない超絶技巧プログラミングの世界-遠藤侑介-ebook/dp/B015R0GNXK/ref=cm_rdp_product)を読んだ成果の公開です。

## 使い方
山手と同じ、引数なしで内回り、引数ありで外回り。
```bash
% ruby osaka.rb | ruby | ruby ...
```
とすると順に内回り
```bash
% ruby osaka.rb x | ruby - x | ruby - x ...
```
とすると順に外回り


## 仕組

４章を理解した上で、単に大阪環状線の駅を表示するだけのプログラム(osaka-s.rb)を見てみましょう。

```ruby
t="aSf<ckVws=r8bo7mQxmQs^Ru_=zAh7]BYiQrgqnMl7XjQs9rD"
eval$s=%q(
f="のノ九京今公原園城大天宮寺島弁新条桃桜森橋正満玉王田町福芦西谷造野阪鶴"
s=t;($*[0]?18:1).times{s=t[/.+?[0-W]/];t=$'+s};
$e=s.scan(/./).map{|i|f[i.ord%35]}*'';
puts(%{t="#{t}"\neval$s=%q(#{$s})\n# #$e}))
# 大阪
```

まずは、駅名に出てくる文字をソートしたもの。

```ruby
f="のノ九京今公原園城大天宮寺島弁新条桃桜森橋正満玉王田町福芦西谷造野阪鶴"
```

各駅名は文字列`f`中のインデックスで表します。大阪なら`[9,33]`です。35文字あるので、あとで`%35`するとして文字コード表の35連続している場所を２組使います。駅名の最後の文字になるものと、ならないものです。

```ruby
t="aSf<ckVws=r8bo7mQxmQs^Ru_=zAh7]BYiQrgqnMl7XjQs9rD"
```

で`aS`は福島、`rD`は大阪を表します。文字コードが`W`またはそれ以下は駅名の最後の文字で、文字コードが`X`またはそれ以上は駅名の最後以外の文字です。

```ruby
s=t;($*[0]?18:1).times{s=t[/.+?[0-W]/];t=$'+s};
```

が駅名の回転部分。`s=t`は`s`に予め何らかの値が入っていないとrubyがエラーを吐くのを避けているだけであまり重要でありません。rubyの正規表現には一致する**最短**の文字列を返す、という便利なものがあり、`/.+?[0-W]/`で文字列`t`中の最初の駅名を取ることが出来ます。`$'`は残りの文字列を指すのでこの後にマッチした文字列を追加すれば、駅名リストを回転させることが出来ます。オリジナルの山手rubyでは逆向きに回転させる正規表現も使っていましたが、大阪環状線の駅は19個あるので18回繰替えせば逆向きの回転になります。`$*[0]`は引数の有無をチェックで、引数の有無で1回か18回かを決定します。

あとは、文字をそのまま表示するのではなく圧縮されたフォントデータを展開しつつ整形していけば、完成します。山手では圧縮にzlibを使っていますが本プログラムでは独自の圧縮をすることで100バイト以上小さくなっています。`q=%w~<文字列>~*''`で`<文字列>`中の空白改行がなくなったものがqに代入されますから、この<文字列>には自由に空白を含めることが出来るので自由に文字の形に整形できます。

下記にプログラムの構造を書いておきます。

```ruby
t="<駅名の文字列>";
eval(q=%w~
F=%q!<圧縮されたフォントデータ>!;
<フォント展開>;
<tの回転>;
b=<新しいプログラム文字列生成>;
<文字列bをフォントを利用して整形しながら出力>;
<最後の2行を出力>~*'');
%|<埋め草>| # コメント
```

この最後の埋め草の部分が、鶴橋(くり抜きが大きいので埋め草が最も短い)と大阪城公園(唯一の５文字駅なので埋め草が最も長い)で同じ構造のプログラムとなるための調整に役立っています。

## 作ってみた感想、反省点

1. 鶴橋のフォントのくり抜きが存外大きくて、横幅を何度も大きくする羽目になった。最初から鶴橋でサイズを設計しておけば良かった。
2. フォントデータは横１文字縦35文字にしたが、縦横逆の方がおそらく圧縮率が高い。
3. フォントデータの圧縮率を重視して強引に91進数にしたが、埋め草ために`|`を消去するコードを追加する羽目になり結局プログラムのサイズは大きくなった。
4. 周囲に大阪環状線を知っている人が少なくて受けなかった。
5. 元の山手では横は２ドット単位のフォントになっていたのを字形を重視して１ドット単位にしたところ、最後の長さ調整で`""`の間で改行されてエラーになり、調整に苦労した。
