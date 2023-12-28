//
//  HTModel.h
//  HTEffectDemo
//
//  Created by Texeljoy Tech on 2022/7/18.
//

#import <Foundation/Foundation.h>

@interface HTModel : NSObject

@property (nonatomic, assign) int idCard;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *title_en;
@property (nonatomic, assign) NSInteger sliderType;// 滑动条类型
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL subType;// false表示正常cell,true表示cell展开后的子cell
@property (nonatomic, assign) BOOL opened;// true表示此cell可以展开
@property (nonatomic, strong) NSString *icon;// 默认未选中图片
@property (nonatomic, strong) NSString *selectedIcon;// 默认选中图片
@property (nonatomic, assign) NSInteger defaultValue;// 默认参数
@property (nonatomic, strong) NSString *name;// 对应的效果名称
@property (nonatomic, strong) NSString *key;// 用于缓存的key
@property (nonatomic, strong) NSString *fillColor;// 用于不同风格中的填充颜色
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger download;// 0:未下载 1:下载中 2:已下载/本地加载

- (instancetype)initWithDic:(NSDictionary *)dic;

@end
