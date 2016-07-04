//
//  ViewController.m
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import "ViewController.h"
#import "ESServerManager.h"
@interface ViewController ()<ESServerProtocol>
@property (strong ,nonatomic) ESServerManager * serverManager;
@end

@implementation ViewController

- (ESServerManager *)serverManager{
    if (!_serverManager) {
        _serverManager = [ESServerManager sharedManager];
        [_serverManager setDelegate:self];
    }
    return _serverManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   //1、如果使用懒加载就要用访问属性的方式访问 否则直接用访问实例变量的方式就可以了_
    [self.serverManager upload];
//    self.serverManager.state = ESServerManagerStateOpen;
    [self.serverManager exec];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         [[ESServerManager sharedManager] down];
//    });
    
    [self.serverManager startWithCompletionHandle:^(NSData *data, NSError *error) {
        
    }];
}


- (void)didUpload:(id)manager{
    NSLog(@"%s==%@",__func__,manager);
}

- (void)didDownload:(id)manager{
    NSLog(@"%s==%@",__func__,manager);
}

-(void)didDownFinished:(id)manager :(NSData *)data :(NSError *)error{
    NSLog(@"%s==%@",__func__,manager);
}

- (void)GCD{
    /**
     *  并发优先级 完成之后 通知主线程
     */
    dispatch_queue_t lowPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t highPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    NSArray * lowPriorityObjects;
    NSArray * highPriorityObjects;
    for (id object  in lowPriorityObjects) {
        dispatch_group_async(dispatchGroup, lowPriorityQueue, ^{
            NSLog(@"%@",object);
        });
    }
    
    for (id object  in highPriorityObjects) {
        dispatch_group_async(dispatchGroup, highPriorityQueue, ^{
            NSLog(@"%@",object);
        });
    }
    
    dispatch_queue_t notifyQueue = dispatch_get_main_queue();
    dispatch_group_notify(dispatchGroup, notifyQueue, ^{
        NSLog(@"Finished");
    });
    
    
    dispatch_queue_t queue = dispatch_queue_create("串行", NULL);
    NSArray * collection ;
    for (id object  in collection) {
        dispatch_async(queue, ^{
            // do something
        });
    }
    
    dispatch_async(queue, ^{
        NSLog(@"Finished");
    });
    
    // 反复执行 串行队列
    dispatch_apply(10, queue, ^(size_t i) {
        
    });
    
    //等价于
    for (int i = 0 ; i < 10; i ++) {
        
    }
    
    //并发 这种用法会阻塞主线程
    dispatch_queue_t normalPriorityQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(collection.count, normalPriorityQueue, ^(size_t i) {
        id object = collection[i];
    });
//    dispatch_get_current_queue()
    
}


- (void)nextObject{
    NSArray * anArray ;
    NSEnumerator * enumerator = [anArray objectEnumerator];
//    [anArray reverseObjectEnumerator]; //反向遍历数组
    id object ;
    while ((object = [enumerator nextObject])!= nil) {
        
    }
    
    [anArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
        
        if (1) {
            * stop = YES; //停止
        }
    }];
    
    
    NSDictionary * aDictionary ;
    enumerator = [aDictionary keyEnumerator];
    id key ;
    while ((key = [enumerator nextObject])!=nil) {
        id value = [aDictionary objectForKey:key];
    }
    
}


















@end
