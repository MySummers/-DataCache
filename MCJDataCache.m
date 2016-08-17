//
//  YSDataCache.m
//  LoveApp
//
//  Created by YS on 15/10/21.
//  Copyright (c) 2015年 锐进. All rights reserved.
//

#import "YSDataCache.h"
#import "NSString+Hashing.h"

static YSDataCache *_dataCache;

@implementation YSDataCache
+(YSDataCache *)shareMCJDataCache
{
    if (_dataCache == nil) {
        _dataCache = [[YSDataCache alloc] init];
    }
    return _dataCache;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    // 线程安全
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _dataCache = [super allocWithZone:zone];
    });
    return _dataCache;
}

- (instancetype)init
{
    if (self = [super init]) {
        // 秒为单位
        _myTime = 30;
    }
    return self;
}

- (void)saveWithData:(NSData *)data path:(NSString *)path
{
    // 获取缓存路径
    NSString *cachePath = [NSString stringWithFormat:@"%@/Documents/Cache/",NSHomeDirectory()];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    if (!isSuccess) {
        NSLog(@"创建文件失败");
        return;
    }
    
    // 存储数据
    path = [path MD5Hash];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",cachePath,path];
    BOOL isWrite = [data writeToFile:filePath atomically:YES];
    if (isWrite) {
        NSLog(@"存储数据成功");
    }else{
        NSLog(@"存储数据失败");
    }
}

#pragma mark - 获取数据
- (NSData *)getDataWithPath:(NSString *)path
{
    // 1.获取缓存数据路径
    path = [path MD5Hash];
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/Cache/%@",NSHomeDirectory(),path];
    
    // 2.判断路径是否存在
    NSFileManager *fileManeger = [NSFileManager defaultManager];
    if (![fileManeger fileExistsAtPath:filePath]) {
        NSLog(@"文件路径不存在");
        return nil;
    }
    
    // 3.检验时间
    // 3.1 获取文件最后更改的时间
    NSDictionary *dict = [fileManeger attributesOfItemAtPath:filePath error:nil];
    NSDate *lastDate = dict[NSFileModificationDate];
    // 3.2 获取时间间隔
    NSTimeInterval difTime = [[NSDate date] timeIntervalSinceDate:lastDate];
    // 3.3 校验
    if (_myTime < difTime) {// 时间间隔已经大与我们规定的时间
        return nil;
    }
    
    // 4. 返回数据
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}
@end
