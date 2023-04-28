//
//  LongRequestManager.h
//  Demo
//
//  Created by zilong.li on 2017/9/22.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LongHTTPRequestCompletionHandler)(NSInteger statusCode, NSString *response, NSError *error);
typedef void (^LongHTTPRequestProgressHandler)(int64_t total, int64_t now);

@class LongRequest;
@interface LongRequestManager : NSObject

+ (instancetype)sharedInstance;

- (void)downloadWithUrl:(NSString*)aUrl
               progress:(void (^)(int progress))aProgressBlock
             completion:(void (^)(NSData *aData, NSError *aError))aCompletionBlock;

- (void)downloadWithUrl:(NSString*)aUrl
                headers:(NSDictionary*)aHeaders
               progress:(void (^)(int progress))aProgressBlock
             completion:(void (^)(NSData *aData, NSError *aError))aCompletionBlock;

- (void)downloadWithUrl:(NSString*)aUrl
                headers:(NSDictionary*)aHeaders
        timeoutInterval:(NSTimeInterval)aTimeoutInterval
               progress:(void (^)(int progress))aProgressBlock
             completion:(void (^)(NSData *aData, NSError *aError))aCompletionBlock;

- (void)downloadWithUrl:(NSString*)aUrl
               progress:(void (^)(int progress))aProgressBlock
     completionResponse:(void (^)(NSString *response, NSError *aError))aCompletionResponseBlock;

- (void)cancelRequestWithUrl:(NSString*)aUrl;

@end
