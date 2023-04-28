//
//  LongDispatch.h
//  LongDispatch
//
//  Created by zilong.li on 2017/9/1.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LongDispatch : NSObject

/*!
 *  初始化LongDispatch实例
 *
 *  @param  aMaxCount   最大并发数
 *
 *  @result LongDispatch实例
 */
+ (instancetype)initWithMaxCount:(NSInteger)aMaxCount;

/*!
 *  向LongDispatch实例添加任务
 *
 *  @param  aBlock      执行任务
 */
- (void)addTask:(dispatch_block_t)aBlock;

/*!
 *  取消LongDispatch实例当前所有任务，正在执行的任务无法取消
 */
- (void)cancelAllTask;

@end
