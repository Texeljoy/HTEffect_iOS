# **虹图人像人体 SDK**

<br/>

## **简介**
- 提供面部精致的美颜美型美妆和发色变换效果
- 提供不少于60款风格滤镜、画面炫彩变幻效果的特效滤镜、人脸变形的趣味哈哈镜
- 精致的2D动态贴纸、3D道具、面具、及丰富的全屏3D礼物特效功能
- 可拖拽水印贴纸：支持用户上传，拖拽、缩放、旋转等
- 多种手势识别，并触发特效
- 支持AI背景分割和多种幕布颜色的绿幕抠图功能

<br/>

### **特色**
- 【特效更丰富】：多种AR特效全覆盖，特效类型丰富多样，满足用户多样需求
- 【对接更便捷】：开箱即用型UI可直接对C端使用，对接快且体验好，三行代码快速实现对接
- 【资源支持自设计】：所有素材都支持平台自设计和自定义，打造和平台定位一致的AR素材特效
- 【性能更极致】：行业领先的 AI 算法能力，946人脸关键点让五官定位更精准，人脸表情情绪捕捉更高效、更稳定、更准确
- 【平台化服务更自主】：用户自行注册、登录虹图AI开放平台即可获得人像人体SDK能力，实时对应用状态和信息具备更自由、精准的把控

<br/>

### **效果展示**
- 通过人脸美颜美型、贴纸道具、手势特效到人像背景分割等AR特效，为用户提供围绕人像人体丰富多样的AI+AR技术
<center>
	<img src="./documents/imgs/sticker.png" width="20%" />
    <img src="./documents/imgs/matting.png" width="20%" />
    <img src="./documents/imgs/filter.png" width="20%" />
    <img src="./documents/imgs/beauty.png" width="20%" />
</center>
<br/>

----

## **快速集成**
### **1. 前提条件**
- Xcode 13.0+
- iOS 11.0 以上的 iPhone 真机
- APP ID，由[虹图AI开放平台](https://console.texeljoy.com/login)控制台获取

<br/>

### **2. 安装**
您可以选择使用 CocoaPods 自动加载的方式，或者先下载 SDK，再将其导入到您当前的工程项目中
#### CocoaPods
- 编辑Podfile文件：
```objective-c
pod 'HTEffect'
```

- 安装
```objective-c
pod install
```

<br/>

#### 手动集成
- 将下载好的 HTEffect.framework 库文件和 HTEffect.bundle 资源包放到您的项目文件夹下
- 在 Xcode > General 中添加动态库，确保 Embed 属性设置为 Embed & Sign
- 在 Xcode > Build Settings 中搜索 bitcode ，将 Enable Bitcode 设置为 No
- 在 Xcode > Info 中添加 App Transport Security Settings > Allow Arbitrary Loads 并设置为 YES

<br/>

### **3. 引用**
- 在项目需要使用 SDK API 的文件里，添加模块引用
```objective-c
#import <HTEffect/HTEffectInterface.h>
```

- (可选) HTUI 可根据项目需求选用，将 HTUI 文件夹添加到您的项目文件夹中，在项目需要使用的文件里，添加引用
```objective-c
#import "HTUIManager.h"
```

<br/>

### **4. 使用**
#### 初始化
- 在您的 App 调用 HTEffect 的相关功能之前（建议在 [AppDelegate application:didFinishLaunchingWithOptions:] 中）进行如下设置
```objective-c
/**
* 在线鉴权初始化方法
*/
[[HTEffect shareInstance] initHTEffect:@"YOUR_APP_ID" withDelegate:self];

/**
* 离线鉴权初始化方法
*/
// [[HTEffect shareInstance] initHTEffect:@"YOUR_APP_ID"];
```

- (可选) 如果需要使用 HTUI，您可以在 viewDidLoad 中添加以下方法
```objective-c
[[HTUIManager shareManager] loadToWindowDelegate:self];
[self.view addSubview:[HTUIManager shareManager].defaultButton];
 ```
 
<br/>

#### 渲染
- 定义一个 BOOL 变量 isRenderInit ，用来标志渲染器的初始化状态，根据获取到的视频格式，采用对应的方法进行渲染
```objective-c
/**
* 视频帧
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
* 纹理
*/
// if (!_isRenderInit) {
//     [[HTEffect shareInstance] releaseTextureRenderer];
//     _isRenderInit = [[HTEffect shareInstance] initTextureRenderer:width height:height rotation:rotation isMirror:isMirror maxFaces:maxFaces];
// }
// [[HTEffect shareInstance] processTexture:textureId];
```

<br/>

#### 销毁
- 结束渲染时，需根据视频格式，调用对应的释放方法，通常写在 dealloc 方法里
```objective-c
/**
* 销毁纹理渲染资源
*/
[[HTEffect shareInstance] releaseTextureRenderer];

/**
* 销毁buffer渲染资源
*/
// [[HTEffect shareInstance] releaseBufferRenderer];
```

<br/>

----

## **示例代码**
> [Demo下载](https://doc.texeljoy.com/hummanBody/beauty/SDK/sdkDownload.html)

<br/>

----

## **最近更新**
- **2023.04.27:** 全新2.0版本
    - 新增30多种风格滤镜、特效滤镜、哈哈镜
    - 新增美发、面具、礼物及自定义可拖拽水印
    - 绿幕抠图新增蓝、白两种幕布颜色和参数调节
    - 优化了手势特效和人像分割特效效果
- [More](https://doc.texeljoy.com/hummanBody/beauty/API/api.html)

<br/>

----

## **联系与反馈**
### 1. 官网地址: [www.texeljoy.com](https://www.texeljoy.com)
### 2. 商务合作: 400-178-9918
### 3. 邮箱地址: business@texeljoy.com
### 4. 公众号:
<div align="left">
<img src="./documents/imgs/public.png"  width = "200" height = "200" />
</div>
