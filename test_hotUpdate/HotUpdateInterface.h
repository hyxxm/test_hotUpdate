//
//  HotUpdateInterface.h
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#ifndef HotUpdateInterface_h
#define HotUpdateInterface_h

#import <UIKit/UIKit.h>
#import "HotUpdateDefine.h"

/** 热更新包中的upgrade.plist说明
 *  1.aliasmap 别名表，别名（键值）－类名   
 *  主要针对活动类，别名针对活动页面的对外名称，类名代表对应的视图名称，如果包含xib，xib文件名必须与className保持一致
 *  2.upgrademap 热修复表，类名－ xib名  
 *  主要针对包涵xib的类需要热更新xib上的内容。当现有页面的xib更新后，必须写在该表中。如果现有的页面仅仅更新逻辑，并未更新xib，此处可以不写
 */

/**
 *  根据 className 创建View，主要应对cell及headerview 的nib热更新
 *  1.首先查找热更新bundler中是否有对应的nib文件。有，则加载返回，替代mainbundle中的nib
 *  2.查找mainbundle中是否有对应的nib文件。有，则从mainbundle中的nib加载返回
 *  3.通过类名加载返回
 *
 *  @param className 类名
 *
 *  @return View
 */
extern UIView *createView(NSString *className , id parent);

/**
 *  根据className 创建UIViewController。主要目的是应对现有viewcontroller的nib更新。
 *  1.首先查找热更新的bundle中是否有对应的nib文件。有，则加载返回，替代mainbundle中的nib
 *  2.查找mainbundle中是否有对应的nib文件，有，则从mainbundle中的nib加载
 *  3.直接通过类名 new一个uiviewcontroller，应对uiviewcontroll没有nib的情况
 *
 *  @param className ViewController名称
 *
 *  @return ViewController
 */
extern UIViewController *createViewController(NSString *className);

/**
 *  根据别名创建UIViewController,当别名不存在时返回WebViewController并装载defaultUrl。用于活动类
 *  1.查找别名，如果存在更新的viewcontroller，则先看是否在热更新的bundle中是否有对应的xib，有则加载返回
 *  2.说明viewcontroller没有对应的nib,直接根据类名new返回
 *  3.说明本地更新包中没有对应的viewcontroller，返回一个webviewcontroller，并加载默认的h5地址
 *
 *  @param classAlias  别名
 *  @param strUrl 如别名不存在时，加载的h5地址
 *
 *  @return ViewController
 */
extern UIViewController *createViewControllerByAlias(NSString *classAlias, NSString *strUrl);

/**
 *  检查热更新
 *
 *  @param updateInfo 更新进度信息
 *  @param updated    更新完成通知
 *  @param error      更新出错信息
 */
extern void checkUpdate(HotUpdateUpdating updateInfo , HotUpdateUpdated updated , HotUpdateError error);

/**
 *  结束更新
 */
extern void end();

/**
 *  初始化
 *
 *  @return 返回自己
 */
extern id hu_init();

/**
 *  获取更新bundle
 *
 *  @return 更新包bundle
 */
extern NSBundle* upgradeBundle();

/**
 *  获取文件路径，优先读取更新包文件路径。如果获取不到，则在mainbundle中寻找
 *
 *  @param fileName 文件名
 *  @param Extension       扩展名
 *
 *  @return 文件路径
 */
extern NSString* hu_filePath(NSString *fileName , NSString *Extension);


#endif /* HotUpdateInterface_h */
