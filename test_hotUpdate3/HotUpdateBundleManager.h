//
//  HotUpdateBundleManager.h
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotUpdateDefine.h"
@class RNDecryptor;
@class RNEncryptor;
@interface HotUpdateBundleManager : NSObject

/**
 *  初始化
 *
 *  @return id
 */
-(instancetype)init;

/**
 *  根据文件后缀，返回对应的文件列表
 *
 *  @param suffixes 要搜索的文件后缀
 *
 *  @return 返回满足后缀的文件列表
 */
-(NSArray<NSString *> *) filePathsWithSuffixes:(NSString *) suffixes;

/**
 *  检测更新情况
 *
 *  @param toUpdate     是否开始更新，返回no表示不更新，yes表示开始下载和更新
 *  @param updateInfo 更新进度
 *  @param updated    更新完成
 *  @param error      更新错误
 */
-(void) update:(HotUpdateNeedUpdate)toUpdate progress:(HotUpdateUpdating) updateInfo updated:(HotUpdateUpdated) updated error:(HotUpdateError) error;

/**
 *  结束更新
 */
-(void) end;

/**
 *  从upgrade.plist的aliasmap中通过别名获取xib的名称
 *
 *  @param aliasName 别名
 *
 *  @return 通过别名获取class名
 */
-(NSString *)classNameByAlias:(NSString *)aliasName;

/**
 *  从upgrade.plist的upgrademap中通过类名获取nib文件名
 *
 *  @param className 类名
 *
 *  @return 通过类名获取对应xib文件名
 */
-(NSString *)nibNameByClassName:(NSString *)className;


-(bool) hasUpgradeFile;

@end

/**
 *  热更新的bundle的存储位置
 *
 *  @return bundle存储位置
 */
extern NSString * bundlePath();

/**
 *  热更新的bundle
 *
 *  @return 热更新的bundle
 */
extern NSBundle *hotupdateBundle();
