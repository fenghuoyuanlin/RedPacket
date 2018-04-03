//
//  NSMutableArray+ErrorHandle.h
//  RedPacketApp
//
//  Created by apple on 2018/3/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ErrorHandle)

/**
 数组中插入数据
 
 @param object 数据
 @param index 下标
 */
- (void)insertObjectVerify:(id)object atIndex:(NSInteger)index;
/**
 数组中添加数据
 
 @param object 数据
 */
- (void)addObjectVerify:(id)object;

@end