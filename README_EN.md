[简体中文](README.md) | English | [日本語](README_JP.md)


# **HTEffect SDK**

<br/>

## **Instruction**

- Exquisite facial beauty AR, makeup AR and hair color transformation effects
- More than 60 types of beauty filters, wonderful effect filters, and interesting distorting mirror effects
- Exquisite 2D dynamic face AR stickers, 3D props, masks, and rich full screen 3D gift effects
- Draggable watermarks: supports users to upload, drag, zoom, rotate, etc
- Interactive AR filters that users can launch with multiple gestures and triggers.
- Background segmentation supports AI background segmentation and chroma key segmentation with multiple colors.

<br/>

### **Feature**

- [Richer special effects] Multiple AR special effects are fully covered, with a variety of special effects types to meet the diverse needs of users
- [More convenient integration] Perfect UI can be directly used on the C end, with fast integration and a good experience. Three lines of code can quickly finish integration
- [Resource support self design] All materials support self-design and customization, creating AR material special effects that align with your own platform style
- [Ultimate performance] Industry leading AI algorithm capability, 106 - 946 facial key points make facial features more precise, and capture of facial expression and emotion is more efficient, stable, and accurate
- [Platform-based services are more autonomous] Users can register and log in to Hongtu AI open platform to obtain beauty AR SDK, and have more accurate control over SDK using status and information in any time

<br/>

### **Results**

- By utilizing AR effects such as facial beauty AR, face AR stickers, props, gesture effects, and background segmentation, we provide users with rich and diverse AI + AR technologies that related to the human face and body

![](https://hteffect-resource.oss-cn-shanghai.aliyuncs.com/gitee_resource/hteffect_en.png)
<br/>
<br/>

---

## **Quick start**

### **iOS**

#### **1. Prerequisites**

- Xcode version 13.0 or later
- iOS version 11.0 or later
- APP ID, acquired from [HONGTU AI open platform](https://console.texeljoy.com/login) console

#### **2. Installation**

You can use CocoaPods to automatically load, or download the SDK and then import it into your project

**CocoaPods**

- Open **Podfile**, and add the **HTEffect** pod

```shell
pod 'HTEffect'
```

- Install

```shell
pod install
```

**Manual**

- Place the downloaded **HTEffect.framework** library file and **HTEffect.bundle** resource package in your project folder
- Add a dynamic library in Xcode > General, ensuring that the **Embed** property is set to **Embed&Sign**
- Search for bitcode in Xcode > Build Settings and set **Enable Bitcode** to **NO**
- Add **App Transport Security Settings** > **Allow Arbitrary Loads** in Xcode>Info and set it to **YES**

#### **3. Reference**

- Add module references to the files that require the use of SDK APIs in the project

```objective-c
#import <HTEffect/HTEffectInterface.h>
```

- (Optional) HTUI can be selected according to project requirements. Add the HTUI folder to your project folder and add references to the files that need to be used in the project

```objective-c
#import "HTUIManager.h"
```

#### **4. Usage**

**Initialization**

- Before calling the relevant functions of HTEffect on your app (it is recommended to set the following settings in [AppDelegate application: didFinishLaunchingWithOptions:])

```objective-c
/**
 * Online authentication method
 */
[[HTEffect shareInstance] initHTEffect:@"YOUR_APPID" withDelegate:self];

/**
 * Offline authentication method
 */
// [[HTEffect shareInstance] initHTEffect:@"YOUR_LICENSE"];
```

- (Optional) If you need to use HTUI, you can add the following method in viewDidLoad

```objective-c
[[HTUIManager shareManager] loadToWindowDelegate:self];
[self.view addSubview:[HTUIManager shareManager].defaultButton];
```

**Rendering**

- Video frames: define a BOOL variable **isRenderInit** to indicate the initialization status of the renderer, and use the corresponding method to render based on the obtained video format

```objective-c
/**
 * Video frames
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
 * Texture
 */
// if (!_isRenderInit) {
//     [[HTEffect shareInstance] releaseTextureRenderer];
//     _isRenderInit = [[HTEffect shareInstance] initTextureRenderer:width height:height rotation:rotation isMirror:isMirror maxFaces:maxFaces];
// }
// [[HTEffect shareInstance] processTexture:textureId];
```

- Image
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

**Destruction**

- At the end of rendering, the corresponding release method needs to be called based on current format, usually written in the dealloc method

```objective-c
// Destroy video frame rendering resources
/**
 * texture
 */
[[HTEffect shareInstance] releaseTextureRenderer];

/**
 * buffer
 */
// [[HTEffect shareInstance] releaseBufferRenderer];


// Destroy image rendering resources
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

#### **1. Import project**

- Copy the **HTEffect.aar** file to the libs folder in the app module, and add the following dependencies in the dependencies of the build.gradle file in the app module

```shell
dependencies {
 implementation files('libs/HTEffect.aar')
}
```

- Copy the **libHTEffect.so** files corresponding to each ABI in the jniLibs folder to the corresponding directory
- Copy the assets resource file to the corresponding directory of the project

#### **2. Use HTUI (optional)**

- Relying on our HTUI project and using the open-source UI library we provide, copy the HTUI folder to the root directory of the project. In the settings.gradle file of the project root directory, add the following code

```java
include(":htui")
```

- In the dependencies section of the build.gradle file in the app module, add the following code

```shell
implementation project(':htui')
```

#### **3. Integration**

**Initialization**

- The HTEffect initialization function takes effect after being called once in the program. It is recommended that you call it when the Application is created; If the rendering function is not frequently used, it can also be called during use, with the following interfaces

```java
// Online authentication method
HTEffect.shareInstance().initHTEffect(context, "YOUR_APPID", new InitCallback() {
        @Override public void onInitSuccess() {}
        @Override public void onInitFailure() {}
});
// Offline authentication method
//HTEffect.shareInstance().initHTEffect(context,"YOUR_LICENSE");
```

**Add HTUI (optional)**

- Set whether to inherit or indirectly inherit FragmentActivity using htui's activity, such as

```java
public class CameraActivity extends FragmentActivity {
    //...
}
```

- If you need to use htui, please call addcontentView to add the UI. The code is as follows

```java
addContentView(
    new HTPanelLayout(this).init(getSupportFragmentManager()),
    new FrameLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,
        ViewGroup.LayoutParams.MATCH_PARENT)
);
```

**Rendering**

- Video frames: define the Boolean variable **isRenderInit** to indicate whether the rendering method has been initialized, and then use the corresponding method for rendering based on the different video frame formats obtained

```java
/**
 * texture format GL_TEXTURE_EXTERNAL_OES
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initTextureOESRenderer(width, height, rotation, isMirror, maxFaces);
}
int textureId = HTEffect.shareInstance().processTextureOES(textureOES);

/**
 * texture format GL_TEXTURE_2D
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initTextureRenderer(width, height, rotation, isMirror, maxFaces);
}
int textureId = HTEffect.shareInstance().processTexture(texture2D);

/**
 * Video frames
 */
if (!isRenderInit) {
    isRenderInit = HTEffect.shareInstance().initBufferRenderer(format,width, height, rotation, isMirror, maxFaces);
}
HTEffect.shareInstance().processBuffer(buffer);
```

- Image
```java
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

**Destruction**

- At the end of rendering, in order to prevent memory leak, it is necessary to call the corresponding destroy method to release resources according to the different video frame formats. The call location is usually at the destruction of the video frame callback interface, or at the end of the life cycle of Activity and Fragment. At the same time, set the defined boolean variable **isRenderInit** to false

```java
/**
 * Use one of them
 */
HTEffect.shareInstance().releaseTextureOESRenderer();
HTEffect.shareInstance().releaseTextureRenderer();
HTEffect.shareInstance().releaseBufferRenderer();

/*
 * Set isRenderInit to false
 */
isRenderInit = false;

/**
 * Destroy image rendering resources, byte[]
 */
HTEffect.shareInstance().releaseImageRenderer();

/**
 * Destroy image rendering resources, Bitmap
 */
HTEffect.shareInstance().releaseBitmapRenderer();
```

<br/>

---

## **Demo**

> [Link](https://doc.texeljoy.com/document/hummanBody/beauty/quickStart/demo.html)

<br/>

---

## **Recent updates**
- **2024.02.06:** v3.2.1
    - Add interface for setting performance priority mode
    - Improve internal rendering and algorithm performance

- **2024.01.29:** v3.2.0
    - Add a single image rendering processing interface
    - Improvement of facial detection, landmark and tracking performance
    - Simplify algorithm model file structure
    - Implement RGB and BGR format support
    - Complete implementation of transparent background image rendering switch interface
    - Improve the algorithm model file related log system, fault tolerance mechanism, and backward compatibility logic

- **2023.12.28:** v3.1.0
    - Optimized the algorithm of gesture recognition effects
    - Added rendering support for some transparent images
    - Improved the output of the log system
    - Solved some known issues

- **2023.11.30:** v3.0.2
    - Optimized grinding and clear algorithm
    - Solved some known issues

- **2023.11.23:** v3.0.1
    - Improved the beauty fit
    - Optimized the stretching of beauty eyeliner

- **2023.11.20:** v3.0.0
    - Green screen cutout with added background image local upload function
    - Improved the effectiveness of beauty and makeup recommendations
    - Optimization of underlying algorithms such as hairdressing, portrait cutout, gesture recognition, and green screen background seg.
    - Solved some known issues

- **2023.09.27:** v3.0.0-beta
    - Added makeup effects, including eyebrows, powder blusher, eye shadow, eyeliner, eyelashes, lipstick, pupil and other effects
    - Added makeup recommendation effects, including various popular makeup effects such as fox beauty, pure desire, girl group, etc
    - Added body shape effects, including long legs and slimming
    - Optimized hairdressing algorithm for more stable support for CPU/GPU
    - Optimized portrait segmentation algorithm for more natural and stable edges
    - Optimized gesture recognition algorithm to support hand following movement

- **2023.07.18:** v2.2.0
    - Added 4 new mask materials
    - Solved some known issues

- **2023.06.09:** v2.1.0
    - Added 16 senior filters
    
- **2023.06.07:** v2.0.2
    - Fixed the issue
    - Optimized resource memory space processing

- **2023.06.01:** v2.0.1
    - Fixed the issue with default values for green screens

- **2023.05.17:** new v2.0
  - More than 30 new styles of filters, special effect filters, and distorting mirror
  - Added hairdressing, masks, gifts, and custom drag and drop watermarks
  - Green screen background seg. added blue and white screen colors and parameter adjustments
  - Optimized gesture effects and portrait segmentation effects
- [More](https://doc.texeljoy.com/document/hummanBody/beauty/Introduce/function.html)

<br/>

---

## **Communication & Feedback**

HONGTU AI Open Platform is an AI technology open platform,which is designed to build application scenarios around audio and video,providing visual AI technologies such as portrait human body special effects, human behavior analysis,content auditing, face real-name authentication, image special effects, etc.,to accelerate AI's business empowerment for small and medium-sized enterprises.From its establishment to the end of 2022, HONGTU has provided products and services to 10+ industries, including live broadcasting, social networking, education, game competition, IoT, XR and meta-universe, with nearly 1500 service platforms and more than 120 million terminals.

HONGTU explores the method of AI combining scenario and ecology, centers on the scheme mode of "AI product + scenario + ecological cooperation", takes audio and video application as the entry scenario, creates AI product matrix serving the whole life cycle of audio and video application, combines eco -partner products, realizes the "open" significance of the platform, and provides users with business needs. Achieve value symbiosis with users.


### 1. Official website: [www.texeljoy.com](https://www.texeljoy.com)

### 2. Cooperation number: 400-178-9918

### 3. E-mail address: business@texeljoy.com

### 4. Official account:

<div align="left">
<img src="https://hteffect-resource.oss-cn-shanghai.aliyuncs.com/gitee_resource/public.png"  width = "200" height = "200" />
</div>
