//
//  LongDispatch.m
//  LongDispatch
//
//  Created by zilong.li on 2017/9/1.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import "LongDispatch.h"

#define kDefaultMaxConcurrentCount 5

@interface LongQueue : NSObject
{
    NSMutableArray *_queue;
    dispatch_queue_t _serialQueue;
}

- (void)push:(id)aObj;

- (id)top;

- (void)clear;

@end

@implementation LongQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [NSMutableArray array];
        NSString *serialName = [NSString stringWithFormat:@"com.zilong.serial.LongQueue.%@",@([[NSDate date] timeIntervalSince1970])];
        _serialQueue = dispatch_queue_create([serialName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)push:(id)aObj
{
    dispatch_async(_serialQueue, ^{
        [_queue addObject:aObj];
    });
}

- (id)top
{
    __block id obj = nil;
    dispatch_sync(_serialQueue, ^{
        if ([_queue count] > 0) {
            obj = [_queue objectAtIndex:0];
            [_queue removeObjectAtIndex:0];
        }
    });
    return obj;
}

- (void)clear
{
    dispatch_sync(_serialQueue, ^{
        if ([_queue count] > 0) {
            [_queue removeAllObjects];
        }
    });
}

@end

@interface LongBlock : NSObject

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, copy, readonly) NSString *taskId;
@property (nonatomic, assign, getter=isCancel) BOOL cancel;

@end

@implementation LongBlock

@synthesize taskId = _taskId;
@synthesize cancel = _cancel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskId = [NSString stringWithFormat:@"block-%@",@((long)([[NSDate date] timeIntervalSince1970] * 1000))];
    }
    return self;
}

- (BOOL)isCancel
{
    BOOL isCancel = NO;
    @synchronized (self) {
        isCancel = _cancel;
    }
    return isCancel;
}

- (void)setCancel:(BOOL)cancel
{
    @synchronized (self) {
        _cancel = cancel;
    }
}

@end

@interface LongDispatch ()
{
    dispatch_queue_t _serialQueue;
    dispatch_queue_t _concurrentQueue;
    dispatch_queue_t _innerQueue;
    dispatch_semaphore_t _semaphore;
    dispatch_source_t _pollingTimer;
    
    long _maxConcurrentCount;
    BOOL _isCancel;
    NSTimeInterval _cancelTime;
    
    NSMutableDictionary *_blockDic;
    LongQueue *_taskQueue;
    BOOL _stopLoop;
}

@end

@implementation LongDispatch

+ (instancetype)initWithMaxCount:(NSInteger)aMaxCount
{
    LongDispatch *dispatch = [[LongDispatch alloc] initWithMaxCount:aMaxCount];
    return dispatch;
}

- (instancetype)initWithMaxCount:(NSInteger)aMaxCount
{
    self = [super init];
    if (self) {
        [self _createQueue:aMaxCount];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _createQueue:kDefaultMaxConcurrentCount];
    }
    return self;
}

#pragma mark - private

- (void)_createQueue:(NSInteger)aMaxCount
{
    NSString *serialName = [NSString stringWithFormat:@"com.zilong.serial.queue.%@",@([[NSDate date] timeIntervalSince1970])];
    _serialQueue = dispatch_queue_create([serialName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    
    NSString *concurrentName = [NSString stringWithFormat:@"com.zilong.concurrent.queue.%@",@([[NSDate date] timeIntervalSince1970])];
    _concurrentQueue = dispatch_queue_create([concurrentName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
    
    NSString *innerName = [NSString stringWithFormat:@"com.zilong.inner.queue.%@",@([[NSDate date] timeIntervalSince1970])];
    _innerQueue = dispatch_queue_create([innerName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    
    _maxConcurrentCount = aMaxCount;
    _semaphore = dispatch_semaphore_create(_maxConcurrentCount);
    
    _blockDic = [NSMutableDictionary dictionary];
    _taskQueue = [LongQueue new];
    
    _stopLoop = YES;
}

- (void)_resetCancel
{
    if (_cancelTime != 0) {
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now > _cancelTime) {
            _cancelTime = 0;
        }
        _isCancel = NO;
    }
}

- (void)_dealLoop
{
    if (!_stopLoop) {
        return;
    }
    _stopLoop = NO;
    __weak typeof(self) weakSelf = self;
    dispatch_block_t block = ^{
        __strong LongDispatch *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_pollingTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, strongSelf->_innerQueue);
            dispatch_source_set_event_handler(strongSelf->_pollingTimer, ^{
                if (!strongSelf->_stopLoop) {
                    long ret = dispatch_semaphore_wait(strongSelf->_semaphore, DISPATCH_TIME_FOREVER);
                    if (!ret) {
                        LongBlock *block = (LongBlock*)[strongSelf->_taskQueue top];
                        if (block) {
                            dispatch_async(strongSelf->_serialQueue, block.block);
                        } else {
                            dispatch_semaphore_signal(strongSelf->_semaphore);
                            [strongSelf _cancelLoop];
                        }
                    } else {
                        dispatch_semaphore_signal(strongSelf->_semaphore);
                        [strongSelf _cancelLoop];
                    }
                }
            });
            
            dispatch_source_set_timer(strongSelf->_pollingTimer,dispatch_time(DISPATCH_TIME_NOW, 0),
                                      0.05 * NSEC_PER_SEC, 0);
            dispatch_resume(strongSelf->_pollingTimer);
        }
    };
    dispatch_async(_innerQueue, block);
}

- (void)_cancelLoop
{
    __weak typeof(self) weakSelf = self;
    dispatch_block_t block = ^{
        __strong LongDispatch *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_stopLoop = YES;
            if (strongSelf->_pollingTimer) {
                dispatch_source_cancel(strongSelf->_pollingTimer);
                strongSelf->_pollingTimer = nil;
            }
        }
    };
    
    dispatch_async(_innerQueue, block);
}

#pragma mark - public

- (void)addTask:(dispatch_block_t)aBlock
{
    [self _resetCancel];
    
    LongBlock *block = [[LongBlock alloc] init];
    __weak typeof(self) weakSelf = self;
    __block LongBlock *_block = block;
    dispatch_block_t task = dispatch_block_create(0, ^{
        __strong LongDispatch *strongSelf = weakSelf;
        if (strongSelf) {
            if (!strongSelf->_isCancel) {
                if (_block.cancel || strongSelf->_isCancel) {
                    dispatch_semaphore_signal(strongSelf->_semaphore);
                } else {
                    dispatch_async(strongSelf->_concurrentQueue,^{
                        aBlock();
                        dispatch_semaphore_signal(strongSelf->_semaphore);
                    });
                }
            } else {
                dispatch_semaphore_signal(strongSelf->_semaphore);
            }
            [strongSelf->_blockDic removeObjectForKey:_block.taskId];
        } else {
            dispatch_semaphore_signal(strongSelf->_semaphore);
        }
    });
    block.block = task;
    [_blockDic setObject:block forKey:block.taskId];
    [_taskQueue push:block];
    dispatch_async(_innerQueue, ^{
        __strong LongDispatch *strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf->_stopLoop) {
                [strongSelf _dealLoop];
            }
        }
    });
}

- (void)cancelAllTask
{
   _cancelTime = [[NSDate date] timeIntervalSince1970];
    __weak typeof(self) weakSelf = self;
    dispatch_sync(_innerQueue, ^{
        __strong LongDispatch *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf->_isCancel = YES;
            [strongSelf->_blockDic removeAllObjects];
            [strongSelf->_taskQueue clear];
        }
    });
}

@end
