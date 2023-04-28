//
//  LongRequest.m
//  Demo
//
//  Created by zilong.li on 2017/9/22.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import "LongRequest.h"

@interface LongRequest ()

@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, copy) LongHTTPRequestProgressHandler handler;
@property (nonatomic, copy) NSArray *keyPaths;

@end

@implementation LongRequest

- (instancetype)initWithTask:(NSURLSessionTask*)task
             progressHandler:(LongHTTPRequestProgressHandler)handler
                  andKeyPath:(NSArray*)keyPaths
{
    if (self = [super init]) {
        _task = task;
        _handler = handler;
        _keyPaths = [keyPaths copy];
        
        if (_task && _handler && [_keyPaths count]) {
            [_keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
                [_task addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
            }];
        }
    }
    return self;
}

- (void)invalid
{
    if (_task && _handler && [_keyPaths count]) {
        [_keyPaths enumerateObjectsUsingBlock:^(NSString *keyPath, NSUInteger idx, BOOL *stop) {
            [_task removeObserver:self forKeyPath:keyPath];
        }];
    }
}

- (void)cancel
{
    if (_task) {
        [_task cancel];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesSent))] && _handler) {
        NSURLSessionUploadTask *task = (NSURLSessionUploadTask*)object;
        _handler(task.countOfBytesExpectedToSend >= task.countOfBytesSent ? task.countOfBytesExpectedToSend : task.countOfBytesSent, task.countOfBytesSent);
    }
    else if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))] && _handler) {
        NSURLSessionDownloadTask *task = (NSURLSessionDownloadTask*)object;
        _handler(task.countOfBytesExpectedToReceive >= task.countOfBytesReceived ? task.countOfBytesExpectedToReceive : task.countOfBytesReceived, task.countOfBytesReceived);
    }
}

@end
