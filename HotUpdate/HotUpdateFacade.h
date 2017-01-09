//
//  HotUpdateFacade.h
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARCSingletonTemplate.h"
#import "HotUpdateDefine.h"

@interface HotUpdateFacade : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(HotUpdateFacade);

/**
 *  根据 className 创建View
 *
 *  @param className 类名
 *
 *  @return View
 */
-(UIView *)createView:(NSString *)className parent:(id) parent;

/**
 *  根据className 创建UIViewController
 *
 *  @param className ViewController名称
 *
 *  @return ViewController
 */
-(UIViewController *) createViewController:(NSString *) className;

/**
 *  根据别名创建UIViewController,当别名不存在时返回WebViewController并装载defaultUrl。用于活动类
 *
 *  @param alias  别名
 *  @param strUrl 如别名不存在时，加载的h5地址
 *
 *  @return ViewController
 */
-(UIViewController *) createViewControllerByAlias:(NSString *) alias defaultUrl:(NSString *)strUrl;

/**
 *  检查更新
 *
 *  @param updateInfo 下载更新的进度
 *  @param updated    更新完成
 *  @param error      更新错误
 */
-(void) checkUpdate:(HotUpdateUpdating) updateInfo updated:(HotUpdateUpdated) updated error:(HotUpdateError) error;

/**
 *  结束更新
 */
-(void) end;

/**
 *  加载本地更新文件
 *
 */
//-(void) load;

/**
 *  获取更新包
 *
 *  @return 更新的bundle包
 */
-(NSBundle *)upgradeBundle;

/**
 *  获取文件路径，优先读取更新包文件路径。如果获取不到，则在mainbundle中寻找
 *
 *  @param fileName 文件名
 *  @param ex       扩展名
 *
 *  @return 文件路径
 */
-(NSString *)filePath:(NSString *)fileName Extension:(NSString *)ex;


@end
