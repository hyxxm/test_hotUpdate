//
//  HJPageRouterAPI.h
//  thrallplus
//
//  Created by HeJia on 2016/11/15.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJPageRouterInterface.h"

/**
 *  注册创建方法
 *
 *  @param creator 创建工具
 */
extern void registCreateFunc(PageRouterCreateCommonViewContoller creator);

/**
 *  为指定的class提供创建方法
 *
 *  @param creator   创建方法
 *  @param className 类名
 */
extern void registCreateFuncForClassName(PageRouterCreateViewContoller creator ,NSString *className);

/**
 *  注销指定class的创建方法
 *
 *  @param className 类名
 */
extern void unregistCreateFunc(NSString *className);

/**
 *  为指定的class注册上下文处理函数
 *
 *  @param handler   上下文处理函数
 *  @param className 类名
 */
extern void registContextHandlerFunc(PageRouterContextHandler handler ,NSString *className);

/**
 *  注销指定class的上下文处理函数
 *
 *  @param className 类名
 */
extern void unregistContextHandlerFunc(NSString *className);

/**
 *  注册短名表
 *
 *  @param class 注册的类名
 */
extern void registClass(Class class);

/**
 *  注册自定义短名表
 *
 *  @param class 注册的类名
 *  @param name  注册的类短名
 */
extern void registClassWithName(Class class , NSString *name);




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
extern void jumpToPageCreateReturn(NSString *pageName ,
                                   NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,
                                   UIViewController *from,
                                   ReturnViewController createdVC,
                                   ReturnViewController retVC);

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
extern void jumpToPageIsAnimCreateReturn(NSString *pageName ,
                                         NSDictionary<NSString* , NSDictionary<NSString* , id> *> * context,
                                         UIViewController* from,
                                         bool isAnim,
                                         ReturnViewController createdVC,
                                         ReturnViewController retVC);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param from     跳转的起始位置
 */
extern void jumpToPage(NSString *pageName, UIViewController *from);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param from     跳转的起始位置
 *  @param isAnim   是否需要动画
 */
extern void jumpToPageIsAnim(NSString *pageName ,UIViewController *from ,bool isAnim);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转上下文
 *  @param from     跳转的起始位置
 */
extern void jumpToPageWithContext(NSString *pageName,NSDictionary<NSString* , NSDictionary<NSString* , id> *> * context,UIViewController *from);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转的上下文
 *  @param from     起始位置
 *  @param isAnim   是否需要动画
 */
extern void jumpToPageWithContextIsAnim(NSString *pageName ,NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,UIViewController *from,bool isAnim);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转的上下文
 *  @param from     起始位置
 *  @param retVC    跳转成功后的目标vc
 */
extern void jumpToPageWithContextReturnAfterShow(NSString *pageName,
                                                 NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,
                                                 UIViewController *from,
                                                 ReturnViewController retVC);

/**
 *  跳转任意页面的简化接口
 *
 *  @param pageName 跳转的完整路径
 *  @param context  跳转的上下文
 *  @param from     起始位置
 *  @param retVC    跳转成功后的目标vc
 */
extern void jumpToPageWithContextReturnAfterShowIsAnim(NSString *pageName,
                                                       NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,
                                                       UIViewController *from,
                                                       ReturnViewController retVC,
                                                       bool isAnim);

/**
 *  是否可以回退至某个页面
 *  @param pageName 回退的页面名
 *  @return bool 是否可以回跳
 */
extern bool canBackTo(NSString *pageName,UIViewController *from);


/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 */
extern void jumpBack(UIViewController * from);

/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 *  @param isAnim 是否有动画
 */
extern void jumpBackWithAnim(UIViewController * from ,bool isAnim);

/**
 *  回退一个页面，从a->b 时，a调用
 *
 *  @param from 起跳页面
 *  @param returnVC 跳转结束后的回调
 */
extern void jumpBackWithCompletion(UIViewController * from ,ReturnViewController returnVC);

/**
 *  回退一个页面 从a->b 时，a调用
 *
 *  @param from     起跳页面
 *  @param isAnim   是否显示动画
 *  @param returnVC 动画结束
 */
extern void jumpBackWithAnimCompletion(UIViewController *from, bool isAnim ,ReturnViewController returnVC);

/**
 *  回退到指定短名的页面
 *
 *  @param shortName 页面短名
 *  @param from      起跳页面
 *  @param isAnim    是否有动画效果
 *  @param returnVC  完成之后的回调
 */
extern void backToWithAnimCompletion(NSString *shortName ,UIViewController *from ,bool isAnim ,ReturnViewController returnVC);

/**
 *  回退到指定短名的页面
 *
 *  @param shortName 页面短名
 *  @param from      起跳页面
 *  @param returnVC  跳转结束后的回调
 *
 */
extern void backToWithCompletion(NSString *shortName ,UIViewController *from ,ReturnViewController returnVC);


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
extern UIViewController* jumpToNextWithContextCreatedReturnAfterShow(NSString *pageName ,
                                                                     NSDictionary<NSString *,id> *context,
                                                                     UIViewController *from,
                                                                     ReturnViewController createdVC ,
                                                                     ReturnViewController retVC);


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 跳转页面的简称
 *  @param context  跳转上下文
 *  @param from     跳转的起始位置
 */
extern UIViewController* jumpToNextWithContext(NSString *pageName ,
                                               NSDictionary<NSString *,id> *context,
                                               UIViewController *from);


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 跳转的下个页面的简称
 *  @param from     跳转的起始页面
 */
extern UIViewController* jumpToNext(NSString *pageName ,
                                    UIViewController *from);


/**
 *  跳转下个页面的简化接口
 *
 *  @param pageName 页面简称
 *  @param context  上下文
 *  @param from     跳转起始页面
 *  @param retVC    返回接口
 */
extern UIViewController * jumpToNextWithContextReturnAfterShow(NSString *pageName,
                                                               NSDictionary<NSString *,id> *context,
                                                               UIViewController *from,
                                                               ReturnViewController retVC);




