//
//  QZImagePickerController.m
//  HTEffectDemo
//
//  Created by MBP DA1003 on 2022/7/15.
//

#import "QZImagePickerController.h"
#import "MJHUD.h"
#import "HTUIConfig.h"

@interface QZImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation QZImagePickerController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.navigationBar.barTintColor = MAIN_COLOR;
        self.allowsEditing = YES;
        self.delegate = self;
        self.toMaxKBytes = MAXFLOAT;
        self.scaleToSize = CGSizeZero;
        
    }
    return self;
}

-(void)setSourceType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [super setSourceType:sourceType];
    }else{
        NSLog(@"input error");
    }
}



-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]){
        //切忌不可直接使用originImage

        NSString *imageKey;
        if(self.allowsEditing){
            imageKey = UIImagePickerControllerEditedImage;
        }else{
            imageKey = UIImagePickerControllerOriginalImage;
        }
        UIImage *originImage = [info objectForKey:imageKey];
        
        if (self.qzDelegate && [self.qzDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithOriginImage:)]) {
            [self.qzDelegate imagePickerController:picker didFinishPickingMediaWithOriginImage:originImage];
        }
        
        UIImage *image = [QZImagePickerController image:originImage ToMaxDataSizeKBytes:self.toMaxKBytes scaleToSize:CGSizeMake(originImage.size.width, originImage.size.height)];
        if (self.qzDelegate && [self.qzDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
            [self.qzDelegate imagePickerController:picker didFinishPickingMediaWithImage:image];
        }
        
    }else{
        [MJHUD showMessage:@"errer"];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


+(UIImage *_Nullable)image:(UIImage *)originImage ToMaxDataSizeKBytes:(CGFloat)KB scaleToSize:(CGSize)size{
    
    // 执行这句代码之后会有一个范围 例如500m 会是 100m～500k
    NSData * data = UIImageJPEGRepresentation(originImage, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    
    // 执行while循环 如果第一次压缩不会小与KB 那么减小尺寸在重新开始压缩
        while (dataKBytes > KB && maxQuality > 0.1f)
        {
            maxQuality = maxQuality - 0.1f;
            data = UIImageJPEGRepresentation(originImage, maxQuality);
            dataKBytes = data.length / 1000.0;
            if(dataKBytes <= KB||maxQuality <= 0.1f )
            {
                break;
            }
        }
    UIImage *image = [UIImage imageWithData:data];
    if (size.width+size.height) {//CGSizeZero
        image = [QZImagePickerController image:image scaleToSize:size];
    }
    return image;
    
}



+ (UIImage *)image:(UIImage *)originImage scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    //    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    if([[UIScreen mainScreen] scale] == 2.0) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    // 绘制改变大小的图片
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.viewWillDisappearBlock)self.viewWillDisappearBlock();
}


-(void)dealloc{
    NSLog(@"QZImagePickerController - dealloc");
}

@end
