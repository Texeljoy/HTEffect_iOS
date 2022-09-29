//
//  HTDefaultButton.h
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import <UIKit/UIKit.h>

@interface HTDefaultButton : UIView

@property (nonatomic, strong) UIButton *enterBeautyBtn;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *demoShowBtn;// demo演示入口
@property (nonatomic, copy) void(^onClickBlock)(NSInteger tag);

@end
