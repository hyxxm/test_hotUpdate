//
//  HJPageRouterInterface.h
//  thrallplus
//
//  Created by HeJia on 16/6/23.
//  Copyright © 2016年 HeJia. All rights reserved.
//
//  任我行
//  实现页面跳转，创建的自动化过程。强解藕页面之间的依赖关系。能够被跳转的链路页面必须实现 HJPageRouteProtocol
//  路径名采用类名的短名，比如HJFrameViewController 短名为Frame。从当前页面跳转至任意页面的路径格式为  短名1/短名2/短名3/../短名n，此时页面会自动跳转至指定页面，如果链路中某些页面没有创建，则会自动创建
//  路径有一些固定参数 。跳转参数用'.'间隔 ，顺序无关。如 shortname.s.m.n
//  1. s 保存实例，默认不保存，如果短名后有此参数，就会保存到对应的父亲页面。比如 短名1/短名2.s ,则页面1会保存页面2的实例，如果下次再跳转不会执行创建过程
//  2. m = doModal型跳转，如果不填，会根据自身页面的特性进行跳转。如当前页面是在nav容器中，默认采用nav的方式跳转，否则采用modal形态跳转。
//  3. n = navgation， 如果填写，则会给下个视图增加navgation后跳转，返回的是navgation实例。
//  4. na = no animation , 如果填写，则表示不需要动画效果。默认采用动画效果

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HJPageRouteProtocol.h"

typedef void(^ReturnViewController)(UIViewController *vc);

@interface HJPageRouterInterface : NSObject

typedef UIViewController *(^PageRouterCreateCommonViewContoller)(NSString *className);

typedef UIViewController *(^PageRouterCreateViewContoller)(NSString *className, UIViewController *parent, NSString *shortName);

typedef NSDictionary<NSString *,id> *(^PageRouterContextHandler)(UIViewController *vc, NSString *nextShortName);

/**
 *  注册创建方法
 *
 *  @param creator 创建工具
 */
+(void) registCreateFunc:(PageRouterCreateCommonViewContoller) creator;



/**
 *  为指定的class提供创建方法
 *
 *  @param creator   创建方法
 *  @param className 类名
 */
+(void) registCreateFunc:(PageRouterCreateViewContoller)creator forClassName:(NSString *)className;



/**
 *  注销指定class的创建方法
 *
 *  @param className 类名
 */
+(void) unregistCreateFunc:(NSString *)className;



/**
 *  为指定的class注册上下文处理函数
 *
 *  @param handler   上下文处理函数
 *  @param className 类名
 */
+(void) registContextHandlerFunc:(PageRouterContextHandler)handler forClassName:(NSString *)className;



/**
 *  注销指定class的上下文处理函数
 *
 *  @param className 类名
 */
+(void) unregistContextHandlerFunc:(NSString *)className;



/**
 *  注册短名表
 *
 *  @param class 注册的类名
 */
+(void) registClass:(Class)class;


/**
 *  注册自定义短名表
 *
 *  @param class 注册的类名
 *  @param name  注册的类短名
 */
+(void) registClass:(Class) class withName:(NSString *) name;


/**
 *  跳转到任意页面
 *
 *  @param pageName 页面链路名
 *  @param context  上下文 上下文是一张二维表，二维表的内容map<shortname,context_dictinary<key,value>>
 *  @param from     当前页面
 *  @param createdVC 创建完的vc，未展示，已经初始化
 *  @param retVC     已经显示在界面的vc
 *
 */
+(void) jumpToPage:(NSString *)pageName
                     withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
                            from:(UIViewController *)from
                         created:(ReturnViewController)createdVC
                 returnAfterShow:(ReturnViewController)retVC;

/**
 *  跳转到任意页面
 *
 *  @param pageName 页面链路名
 *  @param context  上下文 上下文是一张二维表，二维表的内容map<shortname,context_dictinary<key,value>>
 *  @param from     当前页面
 *  @param createdVC 创建完的vc，未展示，已经初始化
 *  @param retVC     已经显示在界面的vc
 *
 */
+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
              from:(UIViewController *)from
            isAnim:(bool) isAnim
           created:(ReturnViewController)createdVC
   returnAfterShow:(ReturnViewController)retVC;


/**
 *  跳转到下个页面，pagename只支持一级，不能填写多个
 *
 *  @param pageName  下个页面的名字
 *  @param context   单个页面的上下文
 *  @param from      当前页面的实例
 *  @param createdVC 创建完的vc，未展示，已经初始化
 *  @param retVC     已经显示在界面的vc
 *
 */
+(UIViewController *) jumpToNext:(NSString *)pageName
       withContext:(NSDictionary<NSString *,id> *)context
              from:(UIViewController *)from
           created:(ReturnViewController)createdVC
   returnAfterShow:(ReturnViewController)retVC;


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 跳转页面的简称
 *  @param context  跳转上下文
 *  @param from     跳转的起始位置
 */
+(UIViewController *) jumpToNext:(NSString *)pageName
       withContext:(NSDictionary<NSString *,id> *)context
              from:(UIViewController *)from;


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 跳转的下个页面的简称
 *  @param from     跳转的起始页面
 */
+(UIViewController *) jumpToNext:(NSString *)pageName
              from:(UIViewController *)from;


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 页面简称
 *  @param context  上下文
 *  @param from     跳转起始页面
 *  @param retVC    返回接口
 */
+(UIViewController *) jumpToNext:(NSString *)pageName
       withContext:(NSDictionary<NSString *,id> *)context
              from:(UIViewController *)from
   returnAfterShow:(ReturnViewController)retVC;


/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param from     跳转的起始位置
 */
+(void) jumpToPage:(NSString *)pageName from:(UIViewController *)from;

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param from     跳转的起始位置
 */
+(void) jumpToPage:(NSString *)pageName from:(UIViewController *)from isAnim:(bool) isAnim;



/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转上下文
 *  @param from     跳转的起始位置
 */
+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
              from:(UIViewController *)from;

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转上下文
 *  @param from     跳转的起始位置
 */
+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
              from:(UIViewController *)from
            isAnim:(bool) isAnim;

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转的上下文
 *  @param from     起始位置
 *  @param retVC    跳转成功后的目标vc
 */
+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
              from:(UIViewController *)from
   returnAfterShow:(ReturnViewController)retVC;

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转的上下文
 *  @param from     起始位置
 *  @param retVC    跳转成功后的目标vc
 */
+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary<NSString* , NSDictionary<NSString* , id> *> *)context
              from:(UIViewController *)from
   returnAfterShow:(ReturnViewController)retVC
            isAnim:(bool) isAnim;


/**
 *  是否可以回退至某个页面
 *  @param pageName 回退的页面名
 *  @return bool 是否可以回跳
 */
+(bool) canBackTo:(NSString *) pageName
             from:(UIViewController *)from;

/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 */
+(void) jumpBack:(UIViewController *) from;

/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 *  @param isAnim 是否有动画
 */
+(void) jumpBack:(UIViewController *) from isAnim:(bool) isAnim;

/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 *  @param returnVC 跳转结束后的回调
 */
+(void) jumpBack:(UIViewController *) from completion:(ReturnViewController) returnVC;


/**
 *  回退一个页面 从a->b 时，a调用
 *
 *  @param from     起跳页面
 *  @param isAnim   是否显示动画
 *  @param returnVC 动画结束
 */
+(void) jumpBack:(UIViewController *) from isAnim:(bool) isAnim completion:(ReturnViewController) returnVC;


/**
 *  回退到指定短名的页面
 *
 *  @param shortName 页面短名
 *  @param from      起跳页面
 *  @param isAnim    是否有动画效果
 *  @param returnVC  完成之后的回调
 */
+(void) backTo:(NSString *)shortName from:(UIViewController *)from isAnim:(bool) isAnim completion:(ReturnViewController) returnVC;

/**
 *  回退到指定短名的页面
 *
 *  @param shortName 页面短名
 *  @param from      起跳页面
 *
 */
+(void) backTo:(NSString *)shortName from:(UIViewController *)from completion:(ReturnViewController)returnVC;

/**
 *  废弃接口 跳转到首页
 *
 *  @param from 跳转的起始位置
 *
 *  @return 跳转是否成功
 */
+(bool) jumpToFrame:(UIViewController *)from;









@end
