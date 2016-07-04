//
//  NSTimer+ESBlocksSupport.m
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import "NSTimer+ESBlocksSupport.h"

@implementation NSTimer (ESBlocksSupport)

+ (NSTimer *) es_scheduledTimerWithTimeInterval:(NSTimeInterval )interval block:(void(^)())block repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ec_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)ec_blockInvoke:(NSTimer*)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
