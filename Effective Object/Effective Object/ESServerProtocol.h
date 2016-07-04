//
//  ESServerProtocol.h
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ESServerProtocol <NSObject>
@optional
- (void) didDownload:(id)manager;
- (void) didUpload:(id)manager;
- (void) didDownFinished:(id)manager :(NSData *)data :(NSError *)error;
@end
