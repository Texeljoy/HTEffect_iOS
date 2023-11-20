//
//  HTAdapter.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import "HTAdapter.h"

@implementation HTAdapter

static HTAdapter *shareInstance = NULL;

+ (HTAdapter *)shareInstance {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareInstance = [[HTAdapter alloc] init];
    });
    return shareInstance;
}

- (CGFloat)getAfterAdaptionLeft:(CGFloat)left{
    return HTScreenWidth * (left / 375);
}

- (CGFloat)getAfterAdaptionTop:(CGFloat)top{
    return HTScreenHeight * (top / 812);
}

- (CGFloat)getAfterAdaptionWidth:(CGFloat)width{
    return HTScreenWidth * (width / 375);
}

- (CGFloat)getAfterAdaptionHeight:(CGFloat)height{
    return HTScreenWidth * (height / 375);
}

- (CGFloat)getStatusBarHeight{
    if (HTScreenHeight == 568 || HTScreenHeight == 667 || HTScreenHeight == 736) {
        return 20;
    } else {
        return 44;
    }
}

- (CGFloat)getSaftAreaHeight{
    if (HTScreenHeight >= 812) {
        return 34.0;
    }
    return 0;
}

@end
