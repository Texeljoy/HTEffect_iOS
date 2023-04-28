//
//  QZImagePickerController.h
//  Toivan_Education
//
//  Created by MBP DA1003 on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QZImagePickerControllerDelegate <NSObject>
@optional
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image;

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithOriginImage:(UIImage *)originImage;

@end

@interface QZImagePickerController : UIImagePickerController


@property (nonatomic, weak) id<QZImagePickerControllerDelegate> qzDelegate;

@property (nonatomic, copy) void (^viewWillDisappearBlock)(void);

@property(nonatomic,assign) CGFloat toMaxKBytes;
@property(nonatomic,assign) CGSize  scaleToSize;

+(UIImage *_Nullable)image:(UIImage *)originImage ToMaxDataSizeKBytes:(CGFloat)KB scaleToSize:(CGSize)size;
+ (UIImage *)image:(UIImage *)originImage scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
