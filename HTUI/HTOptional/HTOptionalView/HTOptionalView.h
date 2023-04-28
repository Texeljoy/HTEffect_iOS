//
//  HTOptionalView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTOptionalView : UIView

@property (nonatomic, copy) void (^onClickOptionalBlock)(NSInteger tag);

@property (nonatomic, assign) BOOL isThemeWhite;

@end

NS_ASSUME_NONNULL_END
