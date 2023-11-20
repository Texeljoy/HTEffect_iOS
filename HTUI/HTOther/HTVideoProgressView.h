//
//  HTVideoProgressView.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2023/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTVideoProgressView : UIView

@property (assign, nonatomic) NSInteger timeMax;

@property (copy, nonatomic) void(^videoProgressEndBlock)(void);

/**
 *  清除进度条
 */
- (void)clearProgress;

@end

NS_ASSUME_NONNULL_END
