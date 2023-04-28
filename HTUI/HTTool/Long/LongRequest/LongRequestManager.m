//
//  LongRequestManager.m
//  Demo
//
//  Created by zilong.li on 2017/9/22.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import "LongRequestManager.h"

#import <pthread.h>

#import "LongRequest.h"

static const NSTimeInterval defaultTimeOut = 60.f;

static LongRequestManager *instance = nil;

@interface LongRequestManager() <NSURLSessionDelegate>
{
    NSURLSession *_session;
    NSMutableDictionary *_requestDic;
    
    pthread_mutex_t _mutex;
}
@end

@implementation LongRequestManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LongRequestManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        configuration.timeoutIntervalForRequest = 120;
        _session = [NSURLSession sessionWithConfiguration:configuration];
        _requestDic = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_mutex, NULL);
    }
    return self;
}

#pragma mark - public

- (void)downloadWithUrl:(NSString*)aUrl
               progress:(void (^)(int progress))aProgressBlock
             completion:(void (^)(NSData *aData, NSError *aError))aCompletionBlock
{
    [self downloadWithUrl:aUrl
                  headers:nil
                 progress:aProgressBlock
               completion:aCompletionBlock];
}

- (void)downloadWithUrl:(NSString *)aUrl
                headers:(NSDictionary *)aHeaders
               progress:(void (^)(int))aProgressBlock
             completion:(void (^)(NSData *, NSError *))aCompletionBlock
{
    [self downloadWithUrl:aUrl
                  headers:aHeaders
          timeoutInterval:defaultTimeOut
                 progress:aProgressBlock
               completion:aCompletionBlock];
}

- (void)downloadWithUrl:(NSString*)aUrl
                headers:(NSDictionary*)aHeaders
        timeoutInterval:(NSTimeInterval)aTimeoutInterval
               progress:(void (^)(int progress))aProgressBlock
             completion:(void (^)(NSData *aData, NSError *aError))aCompletionBlock
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    __block NSString *_blockUrl = aUrl;
    LongRequest *request = [self _httpDownloadRequestWithURL:aUrl
                                                     headers:aHeaders
                                             timeoutInterval:aTimeoutInterval
                                             progressHandler:^(int64_t total, int64_t now) {
        if (aProgressBlock) {
            if (total > 0) {
                aProgressBlock((int)(now*100/total));
            }
        }
    } andCompletionHandler:^(NSInteger statusCode, NSString *response, NSError *error) {
        NSData *data = nil;
        if (statusCode == 200) {
            data = [NSData dataWithContentsOfFile:response];
        }
        if (aCompletionBlock) {
            aCompletionBlock(data, error);
        }
        [weakSelf _removeRequestWithUrl:_blockUrl];
        dispatch_semaphore_signal(semaphore);
    }];
    [self _setRequest:request url:aUrl];
    if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, aTimeoutInterval * NSEC_PER_SEC))) {
        [request cancel];
        [request invalid];
    } else {
        [request invalid];
    }
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}


- (void)downloadWithUrl:(NSString*)aUrl
               progress:(void (^)(int progress))aProgressBlock
             completionResponse:(void (^)(NSString *response, NSError *aError))aCompletionResponseBlock
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __weak typeof(self) weakSelf = self;
    __block NSString *_blockUrl = aUrl;
    LongRequest *request = [self _httpDownloadRequestWithURL:aUrl
                                                     headers:nil
                                             timeoutInterval:defaultTimeOut
                                             progressHandler:^(int64_t total, int64_t now) {
        if (aProgressBlock) {
            if (total > 0) {
                aProgressBlock((int)(now*100/total));
            }
        }
    } andCompletionHandler:^(NSInteger statusCode, NSString *response, NSError *error) {
//        NSData *data = nil;
//        if (statusCode == 200) {
//            data = [NSData dataWithContentsOfFile:response];
//        }
        if (aCompletionResponseBlock) {
            aCompletionResponseBlock(response, error);
        }
        [weakSelf _removeRequestWithUrl:_blockUrl];
        dispatch_semaphore_signal(semaphore);
    }];
    [self _setRequest:request url:aUrl];
    if (dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, defaultTimeOut * NSEC_PER_SEC))) {
        [request cancel];
        [request invalid];
    } else {
        [request invalid];
    }
#if !OS_OBJECT_USE_OBJC
    dispatch_release(semaphore);
#endif
}

- (void)cancelRequestWithUrl:(NSString*)aUrl
{
    pthread_mutex_lock(&_mutex);
    if ([_requestDic objectForKey:aUrl]) {
        LongRequest *request = [_requestDic objectForKey:aUrl];
        [request cancel];
    }
    pthread_mutex_unlock(&_mutex);
}

#pragma mark - private

- (void)_setRequest:(LongRequest*)aRequest url:(NSString*)aUrl
{
    pthread_mutex_lock(&_mutex);
    [_requestDic setObject:aRequest forKey:aUrl];
    pthread_mutex_unlock(&_mutex);
}

- (void)_removeRequestWithUrl:(NSString*)aUrl
{
    pthread_mutex_lock(&_mutex);
    [_requestDic removeObjectForKey:aUrl];
    pthread_mutex_unlock(&_mutex);
}

- (LongRequest*)_httpDownloadRequestWithURL:(NSString*)url
                                    headers:(NSDictionary*)headers
                            timeoutInterval:(NSTimeInterval)interval
                            progressHandler:(LongHTTPRequestProgressHandler)progressHandler
                       andCompletionHandler:(LongHTTPRequestCompletionHandler)completionHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    if ([headers count]) {
        request.allHTTPHeaderFields = headers;
    }
    
    if (interval) {
        request.timeoutInterval = interval;
    }
    
    NSURLSessionDownloadTask *task = [_session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(((NSHTTPURLResponse*)response).statusCode, location ? location.path : nil, error);
    }];
    
    LongRequest *longRequest = [[LongRequest alloc] initWithTask:task
                                             progressHandler:progressHandler andKeyPath:@[NSStringFromSelector(@selector(countOfBytesReceived))]];
    [task resume];
    return longRequest;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

@end
