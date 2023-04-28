//
//  LongRequest.h
//  Demo
//
//  Created by zilong.li on 2017/9/22.
//  Copyright © 2017年 zilong.li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LongRequestManager.h"

@interface LongRequest : NSObject

- (instancetype)initWithTask:(NSURLSessionTask*)task
             progressHandler:(LongHTTPRequestProgressHandler)handler
                  andKeyPath:(NSArray*)keyPaths;

- (void)cancel;

- (void)invalid;

@end
