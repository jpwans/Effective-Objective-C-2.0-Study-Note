//
//  NSTimer+ESBlocksSupport.h
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ESBlocksSupport)
+ (NSTimer *) es_scheduledTimerWithTimeInterval:(NSTimeInterval )interval block:(void(^)())block repeats:(BOOL)repeats;
@end
