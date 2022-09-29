//
//  HTModel.m
//  HTEffectDemo
//
//  Created by 杭子 on 2022/7/18.
//

#import "HTModel.h"
#import "HTTool.h"

@implementation HTModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        // KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}

@end
