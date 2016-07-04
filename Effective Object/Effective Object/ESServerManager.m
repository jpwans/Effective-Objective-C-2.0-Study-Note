//
//  ESServerManager.m
//  Effective Object
//
//  Created by jiangqin on 16/7/4.
//  Copyright © 2016年 mopellet. All rights reserved.
//

#import "ESServerManager.h"
#import "NSTimer+ESBlocksSupport.h"
const NSTimeInterval kAnimationDuration = 0.3 ;
NSString * const ESConnectionString  = @"connection";

@interface ESServerManager(){
    struct {
        unsigned int didDownload : 1;
        unsigned int didUpload   : 1;
        unsigned int didDownFinished : 1;
    } _delegateFlags;
}
@end

@implementation ESServerManager{
    NSCache * _cache;
}
+ (instancetype)sharedManager {
    static ESServerManager * shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[[self class] alloc]init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSCache new];
        _cache.countLimit = 100;
        _cache .totalCostLimit = 5 * 1024 * 1024 ; //5MB
    }
    return self;
}

-(void)setDelegate:(id<ESServerProtocol>)delegate{
    _delegate = delegate;
    _delegateFlags.didDownload = [delegate respondsToSelector:@selector(didDownload:)];
    _delegateFlags.didUpload = [delegate respondsToSelector:@selector(didUpload:)];
    _delegateFlags.didDownFinished = [delegate respondsToSelector:@selector(didDownFinished:::)];
}

- (void)down{
    if (_delegateFlags.didDownload) {
        [_delegate didDownload:self];
    }
}

- (void)downFinished{
    if (_delegateFlags.didDownFinished) {
        NSError * error = [NSError errorWithDomain:@"测试错误" code:404 userInfo:nil];
        [ _delegate didDownFinished:self :[NSData new] :error ];
    }
}

- (void)upload{
    if (_delegateFlags.didDownload) {
        [_delegate didUpload:self];
    }
}


/**
 *  动态执行某个选择器的方法
 */
- (void)exec{
    SEL selector = @selector(noneAction);
    switch (_state) {
        case ESServerManagerStateNone:
            selector = @selector(noneAction);
            break;
        case ESServerManagerStateOpen:
             selector = @selector(openAction);
            break;
        case ESServerManagerStateClose:
            selector = @selector(closeAction);
            break;
    }
    if ([self respondsToSelector:selector]) {
        // 这种方式不完美容易造成内存泄露 不到万不得已不要使用这种方式
        id  ret =  [self performSelector:selector];
    }
}


- (void)noneAction{
    NSLog(@"%s",__func__);
}

- (void)openAction{
    NSLog(@"%s",__func__);
}

- (void) closeAction{
    NSLog(@"%s",__func__);
}

- (void) startWithCompletionHandle:(ESCompletionHandler)completion{
    if (completion) {
            completion([NSData new],nil);
    }
    
    [self p_requestCompleted];
}


- (void)downloadDataForUrl:(NSURL *)url{
    //1.
    NSData * cachedData = [_cache objectForKey:url];
    if (cachedData) {
        //使用缓存
        [self useData:cachedData];
    }
    else {
        [[ESServerManager sharedManager ] startWithCompletionHandle:^(NSData *data, NSError *error) {
            [_cache setObject:data forKey:url cost:data.length];
            [self useData:data];
        }];
    }
    
    // 2. 告诉它不应该丢弃内存 使用完成之后可以在需要的地方丢弃
    // NSPurgeableData 对象所占内存为系统所丢弃时，该对象的自身也会从缓存中移除
    //网络请求或者从磁盘读取的数据就用这个固定不变的那种
    NSPurgeableData * purgeableData = [_cache objectForKey:url];
    if (purgeableData) {
        [purgeableData beginContentAccess]; //+1
        [self useData:purgeableData];
        [purgeableData endContentAccess];//-1
    }else{
        [[ESServerManager sharedManager] startWithCompletionHandle:^(NSData *data, NSError *error) {
            NSPurgeableData * purData = [NSPurgeableData dataWithData:data];//+1
            [_cache setObject:purData forKey:url cost:purData.length];
            // 这里不需要 beginContentAccess 因为已经marked;
            [self useData:data];
            [purData endContentAccess]; //-1
        }];
    }
    
}

- (void) useData:(NSData *)data{


}

- (void) p_requestCompleted{
    if(_completionHandler){
        _completionHandler([NSData new],nil);
    }
    self.completionHandler = nil;
}
- (void)block{
    void (^someBlock)() = ^{
        //do sometiing
    };
    //return_type (^blockname) (parameters)
    int (^addBlock)(int a,int b) = ^(int a, int b){
        return  a + b;
    };
    
   int c =  addBlock(1,2);
}

//+ (void)load{
//
//}
static NSMutableArray * kSomeObjects ;
+ (void)initialize{
    //无法在编译期设定全局常量可以在这里初始化
    //在load 和 initialize 方法应该尽量精简一点 这有助于保持应用程序的响应能力 也能减少依赖环的几率
    kSomeObjects = [NSMutableArray new];
}

- (void)startPolling{
     __weak __typeof(self)weakSelf = self;
    [NSTimer es_scheduledTimerWithTimeInterval:5 block:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf p_doPoll];
    } repeats:YES];
}

- (void)p_doPoll{

}
@end
