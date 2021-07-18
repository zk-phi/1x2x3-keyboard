# Hifumi Keyboard

初心者向け自作キーボードキットです。

A tiny DIY keyboard for newbs.

実際にキーボードの組み立てを体験しながら自作キーボードに入門してもらえるよう、 [同人誌](https://riconken.bitbucket.io/hifumi/) の内容に合わせて設計しました。

## ファームウェア

ビルド済みのファームウェアのダウンロード：

- [test キーマップ](./firmware/hifumi_test.hex)
  - 動作確認のためのキーマップです

- [default キーマップ](./firmware/hifumi_default.hex)
  - スクリーンショット (PrScr) など実用的なキーが配置されたキーマップです

ソースコードからビルドしたい場合は [QMK Firmware の公式リポジトリ](https://github.com/qmk/qmk_firmware) を参照してください。

## 組み立て

わかる人向けの近道ガイド。丁寧な解説は同人誌の方をどうぞ。

1. コンスルー (H=2.5mm) を ProMicro に実装

   https://github.com/zk-phi/keyboard-buildguide-common/blob/master/conthrough.markdown

2. SK6812mini Neopixel LED を実装 (optional)

   https://github.com/zk-phi/keyboard-buildguide-common/blob/master/neopixel.markdown

3. 1N4818 (または 1N4148w) ダイオードを実装

   https://github.com/zk-phi/keyboard-buildguide-common/blob/master/diode.markdown

4. MX 互換スイッチをトッププレートにはめ、基板と合体して半田付け

   https://github.com/zk-phi/keyboard-buildguide-common/blob/master/switch.markdown

5. M2 ネジ・高ナットでボトムプレートを連結

## 基板の発注

自分で基板を発注してみたい人向け。

1. [KiCAD](https://kicad.org/) をインストールして、プロジェクト `pcb/surfboard.pro` を開く

2. 基板データ `surfboard.kicad_pcb` をダブルクリックして基板エディタ (Pcbnew) を立ち上げる

3. `ファイル (F) > プロット (l)` で製造ファイルの出力画面を開き、設定する

   必要なレイヤーにチェックを入れる他は、基本的にデフォルトのままで問題ないと思います

   - 出力フォーマット：ガーバー

   - 含まれるレイヤー：
     - F.Cu (配線 - 表)
     - B.Cu (配線 - 裏)
     - F.SilkS (シルク印刷 - 表)
     - B.SilkS (シルク印刷 - 裏)
     - F.Mask (レジスト塗装 - 表)
     - B.Mask (レジスト塗装 - 裏)
     - Edge.Cuts (基板外形)

   - 一般オプション：
     - フットプリントの定数をプロット
     - フットプリントのリファレンスをプロット
     - 基板外形レイヤーのデータを他のレイヤーから除外 (外形専用のレイヤーに出力するので不要)
     - シルクからパッドを除外 (シルク印刷がパッドに被っているところをいい感じにしてくれる)
     - プロット前にゾーンの塗り潰しをチェック (データが変になってると警告してくれる)

   `フットプリントの xx をプロット` 系のオプションは hifumi の場合どっちでもいいです (使っていないので)。

4. `製造ファイルを出力` でガーバーデータを生成

5. `ドリルファイルを生成` でドリルファイルの出力画面を開き、設定する

   以下のデフォルト設定で特に困ったことがないです

   - ファイル形式: Excellon
   - 単位:  mm
   - ゼロのフォーマット: 小数点フォーマット
   - マップファイルフォーマット: (マップファイルは使用しません)
   - ドリルファイルオプション: 特になし
   - ドリル原点: 絶対位置

6. `ドリルファイルを生成` でドリルファイルを生成

7. 各製造業者の指定するファイル名に直す

   便利スクリプトあります: `pcb/rename-elecrow.sh`

   elecrow の場合、

   - ガーバー
     - `<プロジェクト名>-F.Cu.gbr` => `<プロジェクト名>.GTL`
     - `<プロジェクト名>-B.Cu.gbr` => `<プロジェクト名>.GBL`
     - `<プロジェクト名>-F.Mask.gbr` => `<プロジェクト名>.GTS`
     - `<プロジェクト名>-B.Mask.gbr` => `<プロジェクト名>.GBS`
     - `<プロジェクト名>-F.SilkS.gbr` => `<プロジェクト名>.GTO`
     - `<プロジェクト名>-B.SilkS.gbr` => `<プロジェクト名>.GBO`
     - `<プロジェクト名>-Edge.Cuts.gbr` => `<プロジェクト名>.GML`

   - ドリル
     - `<プロジェクト名>-PTH.drl` => `<プロジェクト名>.TXT`
     - `<プロジェクト名>-NPTH.drl` => `<プロジェクト名>-NPTH.TXT`

   と改名して、 zip に固めれば ok

   ファイルが足りない場合は手順を確認してやり直してください

8. 基板製造業者のオーダーページを開いて、ガーバーをアップロード

   サイトによっては基板サイズなどをこの時点で自動計算してくれる場合があります

9. フォームを埋めてオーダーする

   どのサイトでも確認した方がいいのは主に以下：

   - レイヤー数 layers: 2 (表と裏)
   - サイズ dimensions: 65 x 46 mm (小数点以下は切り上げで ok)
   - 作る枚数 qty
   - デザイン数 different design: 1
   - 厚み thickness: 1.6 mm
   - レジストの色 PCB (mask) color: お好みで
   - シルク印刷の色 silkscreen color: お好みで
   - パッドの表面仕上げ surface finish: HASL (Lead-free にすると鉛フリー, Gold にすると金ピカ)

   JLCPCB などの場合、追加料金を払わないと管理番号を印刷されてしまう場合があります:

   - 製造番号を消す remove order no: お好みで

   その他、サイトによって細かい技術仕様を申告する欄がありますが (すごい小さい穴を開けたい場合追加料金とか)、 hifumi の場合はそのままで大丈夫だと思います。

## プレートのレーザーカット

自分でプレートを切ってみたい人向け。

1. [OpenSCAD](https://www.openscad.org/) をインストールして、 `case/surfbord.scad` を開く

2. プログラム末尾の以下の行を書き換えて、必要な大きさのモデルを表示

   ```scad
   //cut_model_100x100();
   //cut_model_150x100();
   //cut_model_300x300();
   preview();
   ```

   デフォルトではキーボード全体のプレビューが表示されています。

   `prevew()` の行をコメントアウトして、たとえば `cut_model_100x100()` の行のコメントアウトを解除すると、 100mm x 100mm の板から切り出すためのモデルが表示されます。

   ```diff
   -//cut_model_100x100();
   +cut_model_100x100();
    //cut_model_150x100();
    //cut_model_300x300();
   -preview();
   +//preview();
   ```

   発注先のサイトや、レンタルするマシンの仕様に応じて適切なものを選んでください

   100x100 １枚からは１台分、 150x100 １枚からは２台分、 300x300 １枚からは１２台分が取れます。

3. `Design > Render (F6)` でレンダリングを実行

   一瞬で終わります

4. `File > Export > Export as DXF` で DXF ファイルを作成

   レーザーカッターでよく使われるファイル形式です

5. レーザーカットサービスに依頼したり、工房でレーザーカッターをレンタルして切る

   板は 3mm 厚のものを選んでください

   elecrow で `cut_model_100x100()` を切ってもらう場合の例:

   - Size: `10cm x 10cm Max (Thickness 3.0mm)`
   - Color: お好みで
   - Lead Time: 3-5 日固定 (執筆時点)
   - File: (`.dxf` を `.zip` に圧縮してアップロード)

   まれに変な寸法で作られてしまうことがあるので、もし連絡欄などがあれば

   - FYI: 四角い穴は 14mm x 14mm が正しいです

   などと補足をいれておいてもいいかもしれないです
