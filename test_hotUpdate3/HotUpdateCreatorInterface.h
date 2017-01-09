//
//  HotUpdateCreatorInterface.h
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotUpdateCreatorInterface <NSObject>

/**
 *  装载脚本
 *
 *  @param fileArray 文件路径列表
 */
-(void) load:(NSArray *)fileArray;

/**
 *  卸载脚本
 */
-(void) uninstall;

/**
 *  支持处理的前缀
 *
 *  @return 前缀名
 */
-(NSString *) suffixes;

@end
