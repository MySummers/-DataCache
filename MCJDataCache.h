//
//  YSDataCache.m
//  LoveApp
//
//  Created by YS on 15/10/21.
//  Copyright (c) 2015年 锐进. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDataCache : NSObject
/**
 *  刷新时间间隔
 */
@property (nonatomic, assign)NSTimeInterval myTime;

// 缓存单例
+ (YSDataCache *)shareYSDataCache;

// 存储数据
- (void)saveWithData:(NSData *)data path:(NSString *)path;

// 取出数据
- (NSData *)getDataWithPath:(NSString *)path;
@end
