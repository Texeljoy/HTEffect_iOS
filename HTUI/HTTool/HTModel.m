//
//  HTModel.m
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
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
