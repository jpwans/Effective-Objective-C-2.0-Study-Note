//
//  ESServerManager.h
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESServerProtocol.h"

typedef NS_ENUM(NSInteger, ESServerManagerState) {
    ESServerManagerStateNone, //默认从0开始
    ESServerManagerStateOpen,
    ESServerManagerStateClose
};

extern NSString * const ESConnectionString;
extern const NSTimeInterval kAnimationDuration;

typedef void (^ESCompletionHandler)(NSData * data , NSError * error);

@interface ESServerManager : NSObject

+ (instancetype)sharedManager;

@property (assign ,nonatomic) ESServerManagerState state;
@property (weak ,nonatomic) id <ESServerProtocol> delegate;
@property (copy ,nonatomic) ESCompletionHandler completionHandler;

- (void)down;

- (void)downFinished;

- (void)upload;

- (void)exec;

- (void) startWithCompletionHandle:(ESCompletionHandler )completion;


@end
