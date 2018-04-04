//
//  MyCenterModel.h
//  RedPacketApp
//
//  Created by 刘园 on 2018/4/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCenterModel : NSObject
//标题
@property(nonatomic, strong) NSString *title;
//图片
@property(nonatomic, strong) NSString *imageName;
//详情
@property(nonatomic, strong) NSString *info;

@end
