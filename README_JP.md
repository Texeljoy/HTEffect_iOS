[简体中文](README.md) | [English](README_EN.md) | 日本語

# **HTEffect SDK**

<br/>

## **概要**
- 洗練された美顔美形メイクと髪色変換効果を提供
- 60種類以上のスタイルフィルター、画面を鮮やかに変幻させる効果を提供する特殊効果フィルター、人の顔を変形させる趣味のハハミラー
- 精緻な2 D動的シール、3 D道具、マスク、豊富なフルスクリーン3 Dプレゼント特効機能
- 透かしシールのドラッグ可能：ユーザーのアップロード、ドラッグ、ズーム、回転などをサポート
- 複数のジェスチャーを識別し、効果をトリガ
- AIバックグラウンド分割と複数の幕色をサポートする緑幕キー機能

<br/>

### **特色**
- [ 特殊効果がより豊富に ] 多種のAR特殊効果がすべてカバーされ、特殊効果の種類が豊富で多様で、ユーザーの多様な需要を満たす
- [ ドッキングがより便利 ] 開梱即使用型UIはCエンドに直接使用でき、ドッキングが速く、体験が良く、3行コードは迅速にドッキングを実現する
- [ リソースサポート自己設計 ] すべての素材はプラットフォームの自己設計とカスタマイズをサポートし、プラットフォームの位置付けと一致するAR素材の効果を構築する
- [ パフォーマンスの更なる極致 ] 業界をリードするAIアルゴリズム能力、946人の顔のキーポイントは五感の位置付けをより正確にし、人の顔の表情の感情捕捉をより効率的、より安定的、より正確にする
- [ プラットフォーム化サービスをより自主的に ] ユーザー自ら登録し、虹図AIオープンプラットフォームに登録すれば人間像のSDK能力を獲得でき、リアルタイムで応用状態と情報に対してより自由で正確な把握制御を備える

<br/>

### **効果の表示**
- 人の顔の美顔美形、シール道具、ジェスチャー特効から人の像の背景分割などのAR特効を通じて、ユーザーに人の像をめぐる人体の豊富で多様なAI+AR技術を提供する

![](https://hteffect-resource.oss-cn-shanghai.aliyuncs.com/gitee_resource/hteffect_en.png)
<br/>
<br/>

----

## **迅速な統合**
### **iOS**
#### **1. 前提条件**
- Xcode 13.0+
- iOS 11.0以上のiPhoneの真機
- APP IDは、[虹図AIオープンプラットフォーム](https://console.texeljoy.com/login)コンソール取得

#### **2. インストール**
CocoaPodsを使用して自動的にロードする方法を選択するか、現在のプロジェクトにインポートする前にSDKをダウンロードすることができます

**CocoaPods**
- Podfileファイルの編集
```shell
pod 'HTEffect'
```

- インストール
```shell
pod install
```

**手動統合**
- ダウンロードした**HTEffect.framework**ライブラリファイルと**HTEffect.bundle**リソースパッケージをプロジェクトフォルダの下に配置します
- Xcode>Generalにダイナミックライブラリを追加し、**Embed**属性が**Embed&Sign**に設定されていることを確認します
- Xcode>Build Settingsでbitcodeを検索し、**Enable Bitcode**を**No**に設定します
- Xcode>Infoに**App Transport Security Settings**>**Allow Arbitrary Loads**を追加し、**YES**に設定

#### **3. 参照**
- プロジェクトでSDK APIを使用する必要があるファイルに、モジュール参照を追加する
```objective-c
#import <HTEffect/HTEffectInterface.h>
```

- (オプション) HTUIはプロジェクトのニーズに合わせて選択し、HTUIフォルダをプロジェクトフォルダに追加し、プロジェクトが使用するファイルにリファレンスを追加することができます
```objective-c
#import "HTUIManager.h"
```

#### **4. 使用**
**初期化**
- アプリケーションがHTEffectの関連機能を呼び出す前に([AppDelegate application:didFinishLaunchingWithOptions:]で)次の設定を行うことをお勧めします
```objective-c
/**
 * オンライン認証初期化方法
 */
[[HTEffect shareInstance] initHTEffect:@"YOUR_APPID" withDelegate:self];

/**
 * オフライン認証初期化方法
 */
// [[HTEffect shareInstance] initHTEffect:@"YOUR_LICENSE"];
```

- (オプション) HTUIを使用する必要がある場合は、viewDidLoadに次の方法を追加できます
```objective-c
[[HTUIManager shareManager] loadToWindowDelegate:self];
[self.view addSubview:[HTUIManager shareManager].defaultButton];
 ```

**レンダリング**
- ビデオフレーム: レンダラーの初期化状態を示すBOOL変数**isRenderInit**を定義し、取得したビデオフォーマットに基づいて対応する方法でレンダーする
```objective-c
/**
 * ビデオフレーム
 */
CVPixelBufferLockBaseAddress(pixelBuffer, 0);
unsigned char *buffer = (unsigned char *) CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);

if (!_isRenderInit) {
    [[HTEffect shareInstance] releaseBufferRenderer];
    _isRenderInit = [[HTEffect shareInstance] initBufferRenderer:format width:width height:height rotation:rotation isMirror:isMirror maxFaces:maxFaces];
}
[[HTEffect shareInstance] processBuffer:buffer];

CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

/**
 * テクスチャ
 */
// if (!_isRenderInit) {
//     [[HTEffect shareInstance] releaseTextureRenderer];
//     _isRenderInit = [[HTEffect shareInstance] initTextureRenderer:width height:height rotation:rotation isMirror:isMirror maxFaces:maxFaces];
// }
// [[HTEffect shareInstance] processTexture:textureId];
```

- 画像
```objective-c
/**
 * byte[]
 */
if (!_isRenderInit) {
    [[HTEffect shareInstance] releaseImageRenderer];
    _isRenderInit = [[HTEffect shareInstance] initImageRenderer:format width:width height:height rotation:rotation isMirror:isMirror maxFaces:maxFaces];
}
[[HTEffect shareInstance] processImage:pixels];

/**
 * UIImage
 */
// UIImage *resultImage = [[HTEffect shareInstance] processUIImage:image];
```

**破棄**
- レンダリングを終了するには、対応するフォーマットに基づいて、対応するリリース方法を呼び出す必要があります。通常、dealloc方法に書かれています
```objective-c
// ビデオフレームレンダリングアセットを破棄する
/**
 * texture
 */
[[HTEffect shareInstance] releaseTextureRenderer];

/**
 * buffer
 */
// [[HTEffect shareInstance] releaseBufferRenderer];

// 画像レンダリングリソースを破棄する
/**
 * byte[]
 */
// [[HTEffect shareInstance] releaseImageRenderer];

/**
 * UIImage
 */
// [[HTEffect shareInstance] releaseUIImageRenderer];
```
<br/>

### **Android**
#### **1. 導入工事**
- **HTEffect.aar**ファイルをappモジュール内のlibsフォルダにコピーし、appモジュールのbuild.gradleファイルのdependenciesで、次のような依存関係を追加します
```shell
dependencies {
 implementation files('libs/HTEffect.aar')
}
```
- jniLibsフォルダ内の各ABIに対応する**libHTEffect.so**ファイルを対応するディレクトリにコピーします
- assetsリソースファイルをプロジェクトの対応するディレクトリにコピーします

#### **2. HTUIの使用 (オプション)**
- 私たちのhtuiプロジェクトに依存して、私たちが提供するオープンソースUIライブラリを使用して、htuiフォルダをプロジェクトルートディレクトリの下にコピーして、プロジェクトルートディレクトリのsettings.gradleファイルに、次のコードを追加します
```java
include(":htui")
```
- appモジュール内のbuild.gradleファイルのdependenciesに、次のコードを追加します
```shell
implementation project(':htui')
```

#### **3. 統合開発**
**初期化**
- HTEffect初期化関数プログラムで1回呼び出すと有効になります。Applicationの作成時に呼び出すことをお勧めします。レンダリング機能が頻繁に使用されていない場合は、次のインタフェースで使用時に呼び出すこともできます
```java
// オンライン認証初期化方法
HTEffect.shareInstance().initHTEffect(context, "YOUR_APPID", new InitCallback() {
        @Override public void onInitSuccess() {}
        @Override public void onInitFailure() {}
});
// オフライン認証初期化方法
//HTEffect.shareInstance().initHTEffect(context,"YOUR_LICENSE");
```

**HTUIの追加 (オプション)**
- htuiを使用したActivity継承または間接継承FragmentActivityの設定、例
```java
public class CameraActivity extends FragmentActivity {
    //...
}
```

- htuiを使用する必要がある場合は、次のコードでaddcontentViewを呼び出してUIを追加します
```java
addContentView(
    new HTPanelLayout(this).init(getSupportFragmentManager()),
    new FrameLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT)
);
```

**レンダリング**
- ビデオフレーム: ブール変数**isRenderInit**を定義して、レンダリング方法の初期化が完了したかどうかを示し、得られたビデオフレームフォーマットに応じて対応する方法でレンダリングする

```java
/**
 * GL_TEXTURE_EXTERNAL_OES テクスチャフォーマット
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initTextureOESRenderer(width, height, rotation, isMirror, maxFaces);
}
int textureId = HTEffect.shareInstance().processTextureOES(textureOES);

/**
 * GL_TEXTURE_2D テクスチャフォーマット
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initTextureRenderer(width, height, rotation, isMirror, maxFaces);
}
int textureId = HTEffect.shareInstance().processTexture(texture2D);

/**
 * byte[] ビデオフレーム
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initBufferRenderer(format,width, height, rotation, isMirror, maxFaces);
}
HTEffect.shareInstance().processBuffer(buffer);
```

- 画像
```java
/**
 * 画像のレンダリング
 */

/**
 * byte[] 
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initImageRenderer(format,width, height,rotation,isMirror,maxFaces);
}
    HTEffect.shareInstance().processImage(buffer);

/**
 * Bitmap 
 */
Bitmap newBitmap = HTEffect.shareInstance().processBitmap(bitmap);
```

**破棄**
- レンダリングを終了する際には、メモリ漏洩の発生を防ぐために、ビデオフレームのフォーマットに応じて、対応するdestroyメソッドを呼び出してリソースを解放する必要があります。呼び出し位置は通常、ビデオフレームコールバックインタフェースの破棄箇所、またはActivity、Fragmentのライフサイクルの終了箇所にあり、同時に定義されたブール変数**isRenderInit**をfalseに設定します
```java
/**
 * どちらかを使用
 */
HTEffect.shareInstance().releaseTextureOESRenderer();
HTEffect.shareInstance().releaseTextureRenderer();
HTEffect.shareInstance().releaseBufferRenderer();

/*
 * boolをfalseにする
 */
isRenderInit = false;

/**
 * 画像レンダリングリソースを破棄する,byte[]
 */
HTEffect.shareInstance().releaseImageRenderer();

/**
 * 画像レンダリングリソースを破棄する,Bitmap
 */
HTEffect.shareInstance().releaseBitmapRenderer();
```

<br/>

----

## **サンプルコード**
> [Demoダウンロード](https://doc.texeljoy.com/document/hummanBody/beauty/quickStart/demo.html)

<br/>

----

## **最近の更新**
- **2024.11.19:** v3.5.2
    - 皮膚検査の問題を修復する
    - 内部構造を最適化し、メモリ使用率を削減

- **2024.10.30:** v3.5.1
    - Android端子Texture変換ByteBufferインタフェースを完全なものにする
    - Windows側ネットワーク認証インタフェースの追加
    - Windowsエンドのローカル認証インタフェース名を変更
    - Windows側のAIケチアルゴリズムのパフォーマンスを向上させる

- **2024.10.22:** v3.5.0
    - コスメの効果とインタフェースを更新
    - パラメータ付きフィルタインタフェースを追加
    - メイク推奨の効果とインタフェースを変更
    - スプリット3 Dエフェクト
    - ネットワーク認証ノードインタフェースの新規交換
    - 顔検出アルゴリズムを切り替えるインタフェースを追加
    - 完全なログシステム
    - フィギュア・キーイング・アルゴリズムの最適化
    - 美髪効果の最適化
    - Bugの一部を修正
    
- **2024.06.26:** v3.4.0
    - 新たに1組の初期化インタフェースを追加し、AI駆動ロード方法を切り離す
    - AIドライバのロード/アンロード方法の追加
    - クマ除去素材の更新
    - 新規顔検出とパラメータに関する開閉ロジック
    - 顔検出モデルのバージョンを変更
    - エンベロープを縮小
    - Bugの一部を修正

- **2024.06.06:** v3.3.2
    - 画像分割効果を最適化し、多層レンダリングを実現

- **2024.05.30:** v3.3.2-beta
    - 修復顔検出マルチフェイスサポート関連Bug
    - 美顔フィルターの強度調整を追加するためのインタフェース

- **2024.05.24:** v3.3.1
    - ログ情報を英語に変換（初期化情報を除く）
    - Windows側人物像分割交換推論フレームワーク、性能向上

- **2024.04.23:** v3.3.0
    - 顔検出モデルを切り替えるインタフェースを追加
    - CPU処理コア数を増やすことでパフォーマンスが向上するインタフェースの追加
    - 顔検出距離レベルを設定するインタフェースを追加
    - Android側プレビュークラスのカスタム画面方向インタフェースを追加
    - いくつかの既知の問題を解決しました

- **2024.03.28:** v3.3.0-beta
    - 腰の細さ、肩の美しさ、太ももの細さ、股間の修理、白鳥の首、豊胸などの美ボディ効果を追加
    - 3分割スクリーン、割れたガラス、ワンクリックレゴなどの特殊効果フィルタの追加
    - SDKをAvatarエフェクトに組み込む
    - 顔キー追跡アルゴリズムの最適化
    - 人体検出モデルの最適化
    - 完全なログシステム
    - いくつかの既知の問題を解決しました

- **2024.02.06:** v3.2.1
    - パフォーマンス優先モード設定インタフェースの追加
    - 内部レンダリングとアルゴリズムのパフォーマンスの向上

- **2024.01.29:** v3.2.0
    - 1枚の画像レンダリング処理インタフェースを追加
    - 顔の検出、キー、追跡パフォーマンスの向上
    - アルゴリズムモデルファイル構造の簡略化
    - RGB、BGRのフォーマットサポートを実現
    - 透明バックグラウンドマップレンダリングスイッチインタフェースの完全な実装
    - アルゴリズムモデルファイル関連ログシステム、フォールトトレランス機構、下位互換ロジックの整備

- **2023.12.28:** v3.1.0
    - ジェスチャーエフェクトの最適化のための最下位アルゴリズム
    - 部分的に透明な画像のレンダリングサポートを追加する
    - 完全なログシステムの出力印刷
    - いくつかの既知の問題が解決されました

- **2023.11.30:** v3.0.2
    - 最適化された研削皮、明確なアルゴリズム
    - いくつかの既知の問題が解決されました

- **2023.11.23:** v3.0.1
    - メイクの密着度を高める
    - 化粧品のアイラインのストレッチを最適化する問題

- **2023.11.20:** v3.0.0
    - 緑のカーテン・キーによる背景画像のローカルアップロード機能の追加
    - メイク、メイクのおすすめなど効果アップ
    - 美髪、人間像のほり絵、ジェスチャー識別、緑幕のほり絵などの基礎アルゴリズムの最適化
    - いくつかの既知の問題が解決されました

- **2023.09.27:** v3.0.0-beta
    - 眉毛、チーク、アイシャドウ、アイライン、まつ毛、口紅、瞳などのメイクアップ効果を含むメイクアップ機能を追加
    - 狐系美人、純欲メイク、女団メイクなど多くの人気メイク効果を含むメイクのおすすめ機能を追加
    - 脚長、痩身の2つの効果を含む新ボディ機能
    - 美髪アルゴリズムを最適化し、CPU/GPUをより安定的にサポート
    - 人間像分割アルゴリズムを最適化し、エッジをより自然に安定させる
    - ジェスチャー認識アルゴリズムを最適化し、追手移動効果をサポート

- **2023.07.18:** v2.2.0
    - 新たに4つのマスク素材を追加
    - 解いくつかの既知の問題が解決されました决了一些已知问题

- **2023.06.09:** v2.1.0
    - 16種類の高級フィルターを追加
    
- **2023.06.07:** v2.0.2
    - 一部機種で点滅していた問題を修正
    - リソースメモリ空間処理の最適化

- **2023.06.01:** v2.0.1
    - 緑のカーテンの既定の問題を修正する

- **2023.05.17:** 新しいバージョン2.0
    - 30種類以上のスタイルフィルタ、特殊効果フィルタ、ハハミラーを追加
    - ヘアー、マスク、プレゼント、カスタムドラッグ可能ウォーターマークを追加
    - 緑のカーテンキー青、白の2種類のカーテンカラーとパラメータ調整を追加
    - ジェスチャー効果と画像分割効果を最適化

- [詳細](https://doc.texeljoy.com/document/hummanBody/beauty/Introduce/function.html)

<br/>

----

## **連絡とフィードバック**

HONGTU AIオープンプラットフォームは、HONGTUが自己研究したAI能力に基づいて、音声ビデオなどの応用シーンを取り巻くAI技術オープンプラットフォームである。人像人体特効、人体行動分析、内容審査、人顔実名認証、画像特効などの視覚AI技術を提供し、AIが中小企業の業務にエネルギーを与えることを加速させる。設立から2022年末までに、HONGTUはすでに累計で生中継、社交、教育、ゲームeスポーツ、IoT、XR、元宇宙など10以上の業界コースを賦与し、サービスプラットフォームは1500社近く、端末使用数は1億2000万台を超えた。

HONGTUはAIがシーンと生態を結合する方法を模索し、「AI製品+シーン+生態協力」の方案モデルをめぐって、音声ビデオ応用を切り口として、サービス音声ビデオ応用の全ライフサイクルのAI製品マトリックスを構築し、生態パートナー製品を組み合わせ、プラットフォームの「開放」意義を実現し、ユーザーの業務ニーズに全体的なソリューションを提供し、ユーザーと価値共生を実現する。


### 1. 公式サイト: [www.texeljoy.com](https://www.texeljoy.com)
### 2. ビジネス提携: 400-178-9918
### 3. メールアドレス: business@texeljoy.com
### 4. 公衆番号:
<div align="left">
<img src="https://hteffect-resource.oss-cn-shanghai.aliyuncs.com/gitee_resource/public.png"  width = "200" height = "200" />
</div>
