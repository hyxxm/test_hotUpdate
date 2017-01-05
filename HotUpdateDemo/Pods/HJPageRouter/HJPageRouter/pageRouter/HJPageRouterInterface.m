//
//  HJPageRouterInterface.m
//  thrallplus
//
//  Created by HeJia on 16/6/23.
//  Copyright © 2016年 HeJia. All rights reserved.
//
#import "HJPageRouterInterface.h"
//#import "HJPageInterceptor.h"
#import "HJPageRouteProtocol.h"
#import "UIViewController+PageRouter.h"
//#import "AppDelegate.h"
#import <objc/runtime.h>
//#import "HJCommon.h"
#import "UINavigationController+CompletionHandler.h"


#ifdef MAC
NSObject<NSApplicationDelegate>* get_appDelegate(){
    return [NSApplication sharedApplication].delegate;
}

#else
NSObject<UIApplicationDelegate>* get_appDelegate(){
    
    return [UIApplication sharedApplication].delegate;
}
#endif
//! 输出，断言 仅在debug模式下有效
#ifdef DEBUG
#define HJLog(format,...) NSLog(format,##__VA_ARGS__)
#define HJAssert(condition, desc, ...) NSAssert(condition,desc,##__VA_ARGS__)
#else
#define HJLog(format,...)
#define HJAssert(condition, desc, ...)
#endif

static bool isKindOfTabBarController(UIViewController *vc){
    return [vc isKindOfClass:[UITabBarController class]];
}

static bool isKindOfNavgationController(UIViewController *vc){
    return [vc isKindOfClass:[UINavigationController class]];
}

static NSArray *separatedPath(NSString *path){
    return [path componentsSeparatedByString:@"."];
}

static NSString *shortNameFromPath(NSString *path){
    return separatedPath(path).firstObject;
}

@implementation HJPageRouterInterface

static NSMutableDictionary *shortNameMap = nil;
static PageRouterCreateCommonViewContoller _s_creator = nil;
static NSMutableDictionary<NSString *,PageRouterCreateViewContoller> *_s_class_creator = nil;
static NSMutableDictionary<NSString *,PageRouterContextHandler> *_s_class_context = nil;

+(void)registCreateFunc:(PageRouterCreateCommonViewContoller)creator{
    _s_creator = nil;
    _s_creator = creator;
}


+(void) registCreateFunc:(PageRouterCreateViewContoller)creator forClassName:(NSString *)className{
    if(_s_class_creator == nil){
        _s_class_creator = [NSMutableDictionary<NSString *,PageRouterCreateViewContoller> new];
    }
    _s_class_creator[className] = creator;
}


+(void) unregistCreateFunc:(NSString *)className{
    if(_s_class_creator) [_s_class_creator removeObjectForKey:className];
}


+(void) registContextHandlerFunc:(PageRouterContextHandler)handler forClassName:(NSString *)className{
    if(_s_class_context == nil){
        _s_class_context = [NSMutableDictionary<NSString *,PageRouterContextHandler> new];
    }
    _s_class_context[className] = handler;
}


+(void) unregistContextHandlerFunc:(NSString *)className{
    if(_s_class_context) [_s_class_context removeObjectForKey:className];
}


+(void) registClass:(Class)class{
    if(shortNameMap == nil){
        shortNameMap = [NSMutableDictionary new];
    }
    
    [shortNameMap setValue:[NSString stringWithUTF8String:class_getName(class)] forKey:[class shortName]];
}


+(void) registClass:(Class)class withName:(NSString *)name{
    if(shortNameMap == nil){
        shortNameMap = [NSMutableDictionary new];
    }
    
    [shortNameMap setValue:[NSString stringWithUTF8String:class_getName(class)] forKey:name];
}


#define _IS_SAVE(Params) ([Params indexOfObject:@"s"] != NSNotFound)
#define _IS_NAV(Params) ([Params indexOfObject:@"n"] != NSNotFound)
#define _IS_MODAL(Params) ([Params indexOfObject:@"m"] != NSNotFound)
#define _IS_ANIM(Params) ([Params indexOfObject:@"na"] == NSNotFound)

#define _SAVE_CALL(func,param) if(func) func(param);
#define _SAVE_CALL_CREATED(vc) _SAVE_CALL(funcCreatedVC,vc)
#define _SAVE_CALL_RETURN(vc) _SAVE_CALL(funcRetVC,vc)



+ (UIViewController *) jumpToNext:(NSString *)pageName
        withContext:(NSDictionary<NSString* , id> *)context
               from:(UIViewController *)from
            created:(ReturnViewController)funcCreatedVC
    returnAfterShow:(ReturnViewController)funcRetVC
{
    NSArray *params = separatedPath(pageName);
    PageRouterContextHandler ctxHandler = nil;
    NSString *className = [NSString stringWithUTF8String:class_getName([from class])];
    if(_s_class_context && (ctxHandler = _s_class_context[className]) != nil){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:context];
        [dic addEntriesFromDictionary:ctxHandler(from,pageName)];
        context = dic;
    }
    
    //! 前置判断，默认tab格式不会自动创建子页面
    if(isKindOfTabBarController(from)){
        //! 如果跳转的页面在tabbarviewcontroller 的儿子中，则跳转到对应的页面
        UITabBarController *tabVC = (UITabBarController*)from;
        int nIndex = 0;
        for(UIViewController *vc in tabVC.childViewControllers){
            UIViewController* tmpVC = vc;
            if(isKindOfNavgationController(vc)){
                tmpVC = [(UINavigationController *)vc childViewControllers].firstObject;
            }
            
            if([[tmpVC shortName] isEqualToString:params.firstObject]){
                [self setContext:context in:tmpVC];
                [tabVC setSelectedIndex:nIndex];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _SAVE_CALL_RETURN([[tabVC childViewControllers] objectAtIndex:nIndex]);
                });
                return tmpVC;
            }
            nIndex += 1;
        }
        
        HJAssert(_IS_MODAL(params), @"Tab框架 只能跳转到以存在的页面或者以Modal跳出");
    }
    
    
    UIViewController *next = nil;
    
    //! 获取或创建跳转的下个页面
    if(_IS_SAVE(params)){
        //! 是保存状态，先从内存中读取
        next = [from pageRouteViewController:params.firstObject];
        if(!next){
            next = [self createViewController:params.firstObject from:from];
            if(!next) {
                _SAVE_CALL_CREATED(next);
                return nil;
            }
            
            [self setContext:context in:next];
            //! 判断是否需要生成nav
            if(_IS_NAV(params)){
                next = [[UINavigationController alloc] initWithRootViewController:next];
                [(UINavigationController*)next navigationBar].translucent = NO;
                next.edgesForExtendedLayout = UIRectEdgeNone;
            }
            [from setPageRouteViewController:next];
        }else{
            [self setContext:context in:next];
        }
        _SAVE_CALL_CREATED(next);
        
    }else{
        //! 不用缓存，则直接创建
        next = [self createViewController:params.firstObject from:from];
        if(!next){
            _SAVE_CALL_CREATED(next);
            return nil;
        }
        
        [self setContext:context in:next];
        
        //! 判断是否要生成nav
        if(_IS_NAV(params) && (from.navigationController == nil || _IS_MODAL(params))){
            next = [[UINavigationController alloc] initWithRootViewController:next];
            [(UINavigationController*)next navigationBar].translucent = NO;
            next.edgesForExtendedLayout = UIRectEdgeNone;
        }
        _SAVE_CALL_CREATED(next);
    }
    
    //! 页面跳转到下一级
    bool needAnim = _IS_ANIM(params);
    if(_IS_MODAL(params)){
        [from presentViewController:next animated:needAnim completion:^{
            _SAVE_CALL_RETURN(next);
        }];
    }else{
        if(from.navigationController != nil){
            //! from是nav型
            [from.navigationController completionhandler_pushViewController:next animated:needAnim completion:^{
                _SAVE_CALL_RETURN(next);
            }];
        }else{
            [from presentViewController:next animated:needAnim completion:^{
                _SAVE_CALL_RETURN(next);
            }];
        }
    }
    return next;
}



+(void) jumpBack:(UIViewController *)from completion:(ReturnViewController)returnVC{
    [self jumpBack:from isAnim:YES completion:returnVC];
}


+(void) jumpBack:(UIViewController *)from isAnim:(bool)isAnim completion:(ReturnViewController)returnVC{
    if(from.navigationController != nil){
        NSInteger index = [from.navigationController.childViewControllers indexOfObject:from];
        if( index != 0){
            UIViewController *tmpVC = from.navigationController.childViewControllers[index - 1];
            [from.navigationController completionhandler_popToViewController:tmpVC animated:isAnim completion:^{
                if(returnVC) returnVC(tmpVC);
            }];
            
        }else{
            UIViewController *tmpVC = from.navigationController.presentingViewController;
            if(tmpVC != nil){
                [from.navigationController dismissViewControllerAnimated:isAnim completion:^{
                    if(returnVC) returnVC(tmpVC);
                }];
            }
        }
    }else{
        if(from.presentingViewController != nil){
            UIViewController *tmpVC = from.presentingViewController;
            [from dismissViewControllerAnimated:isAnim completion:^{
                if(returnVC) returnVC(tmpVC);
            }];
        }else{
            //! do nothing
            
        }
    }

}

+(void) jumpBack:(UIViewController *) from{
    [self jumpBack:from isAnim:YES];
}

+(void) jumpBack:(UIViewController *)from isAnim:(bool)isAnim{
    [self jumpBack:from isAnim:isAnim completion:nil];
}


+(void) setContext:(NSDictionary *)ctx in:(UIViewController *) vc{
    Protocol *protocol = objc_getProtocol("HJPageRouteProtocol");
    if([[vc class] conformsToProtocol:protocol]){
        [(UIViewController<HJPageRouteProtocol> *)vc setContext:ctx];
    }
}

+(UIViewController *) createViewController:(NSString *) shortName from:(UIViewController *)from{
    NSString *className = shortNameMap[shortName];
    if(className == nil) return nil;
    
    PageRouterCreateViewContoller router = _s_class_creator[className];
    if(router){
        return router(className,from,shortName);
    }else if(_s_creator){
        return _s_creator(className);
    }else{
        Class class = objc_getClass(className.UTF8String);
        return [class new];
    }
}


+(void) jumpToPage:(NSString *)pageName
       withContext:(NSDictionary *)context
              from:(UIViewController *)from
            isAnim:(bool) isAnim
           created:(ReturnViewController)funcCreatedVC
   returnAfterShow:(ReturnViewController)funcRetVC
{
    NSArray *aryPathTo = [pageName componentsSeparatedByString:@"/"];
    NSArray *aryPathFrom = [self pathFrom:from];
    
    NSLog(@"Path To:%@",aryPathTo);
    NSLog(@"Path From:%@",aryPathFrom);
    
    __block NSInteger nIndex = [self findDifferentNode:aryPathTo pathB:aryPathFrom];
    
    if(nIndex == 0){
        //! 第一个页面不同
        UIViewController<HJPageRouteProtocol> *frame = (UIViewController<HJPageRouteProtocol> *)(get_appDelegate().window.rootViewController);
        if(frame == nil) {
            NSLog(@"主框架还没建立");
            assert(0);
            return;
        }
        //! dismiss所有modal型的页面
        [self dismissAllViewController:from isAnim:isAnim completion:^(UIViewController *retVC){
            [self backTo:[aryPathFrom firstObject] from:retVC completion:^(UIViewController *vc) {
                __block UIViewController *next = nil;
                if(aryPathTo.count == 1){
                    [self jumpToNext:aryPathTo[0] withContext:context[aryPathTo[0]] from:frame created:funcCreatedVC returnAfterShow:funcRetVC];
                    return;
                }
                else{
                    [self jumpToNext:aryPathTo[0] withContext:context[aryPathTo[0]] from:frame returnAfterShow:^(UIViewController *retVC) {
                        next = retVC;
                        [self jumpTo:aryPathTo from:next context:context created:funcCreatedVC returnAfterShow:funcRetVC];
                    }];
                }
            }];
        }];
        
    }else if(nIndex < aryPathTo.count){
        if(nIndex < aryPathFrom.count){
            nIndex -= 1;
            //! 回退到某个目录再跳转到其他分支型
            [self backTo:aryPathFrom[nIndex] from:from isAnim:isAnim completion:^(UIViewController *vc) {
                nIndex++;
                [self jumpTo:nIndex path:aryPathTo context:context startViewController:vc created:funcCreatedVC returnAfterShow:funcRetVC];
            }];
        }else{
            [self jumpTo:nIndex path:aryPathTo context:context startViewController:from created:funcCreatedVC returnAfterShow:funcRetVC];
        }
    }else{
        //! 回退型
        [self backTo:shortNameFromPath(aryPathTo.lastObject) from:from isAnim:isAnim completion:^(UIViewController *vc) {
            _SAVE_CALL_RETURN(vc);
        }];
    }

}


+(void)jumpToPage:(NSString *)pageName
                    withContext:(NSDictionary *)context
                           from:(UIViewController *)from
                        created:(ReturnViewController)funcCreatedVC
                returnAfterShow:(ReturnViewController)funcRetVC
{
    [self jumpToPage:pageName withContext:context from:from isAnim:YES created:funcCreatedVC returnAfterShow:funcRetVC];
}

+(void) dismissAllViewController:(UIViewController *)pVC isAnim:(bool) isAnim completion:(ReturnViewController) block{
    __block UIViewController* vc = pVC;
    __block dispatch_block_t dismissBlock = ^{
        UIViewController* presentingVC = nil;
        if(vc.presentingViewController != nil){
            presentingVC = vc.presentingViewController;
        }else if(vc.navigationController != nil && vc.navigationController.presentingViewController != nil){
            presentingVC = vc.navigationController.presentingViewController;
        }else{
            block(vc);
            dismissBlock = nil;
        }
        
        [vc dismissViewControllerAnimated:isAnim completion:^{
            vc = presentingVC;
            dismissBlock();
        }];
    };
    
    dismissBlock();

}

+(NSInteger) findDifferentNode:(NSArray *)pathA pathB:(NSArray *) pathB{
    NSUInteger nCompareCout = MIN(pathA.count, pathB.count);
    int nIndex = 0;
    for(;nIndex < nCompareCout;nIndex++){
        if(![shortNameFromPath(pathA[nIndex]) isEqualToString:shortNameFromPath(pathB[nIndex])]){
            break;
        }
    }
    return nIndex;
}

+(bool) canBackTo:(NSString *)pageName
             from:(UIViewController *)from{
    NSArray *aryPathFrom = [self pathFrom:from];
    if([aryPathFrom containsObject:pageName]){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  针对根节点变更的跳转
 *
 *  @param paths         跳转的完整路径
 *  @param from          起跳位置
 *  @param ctx           上下文
 *  @param funcCreatedVC 创建完成通知
 *  @param funcRetVC     展示完成通知
 */
+(void) jumpTo:(NSArray *) paths
          from:(UIViewController *)from
       context:(NSDictionary *)ctx
       created:(ReturnViewController)funcCreatedVC
returnAfterShow:(ReturnViewController)funcRetVC

{
    if(from.navigationController == nil && !isKindOfNavgationController(from)) return;
    NSArray *aryVC = nil;
    UINavigationController *nav = nil;
    if(from.navigationController != nil){
        aryVC = from.navigationController.childViewControllers;
        nav = from.navigationController;
    }else{
        aryVC = from.childViewControllers;
        nav = (UINavigationController *)from;
    }
    
    NSMutableArray *aryPaths = [NSMutableArray new];
    for(UIViewController *vc in aryVC){
        [aryPaths addObject:[[vc class] shortName]];
    }
    
    NSInteger nIndex = [self findDifferentNode:paths pathB:aryPaths];
    UIViewController *vc = nil;
    if(nIndex < aryPaths.count){
        //! 分歧点在当前navgation堆栈的中间
        nIndex -= 1;
        vc = aryVC[nIndex];
        [nav popToViewController:vc animated:NO];
        nIndex += 1;
    }else{
        //! 分歧点在最后，直接往后跳跃，省去回退的过程
        vc = aryVC[nIndex - 1];
    }
    
    if(nIndex < paths.count){
        [self jumpTo:nIndex path:paths context:ctx startViewController:vc created:funcCreatedVC returnAfterShow:funcRetVC];
    }
}

/**
 *  从当前节点依次跳转到目标位置
 *
 *  @param startIndex    起点位置 在paths中的起点位置
 *  @param paths         要跳转的整条目录
 *  @param ctx           上下文
 *  @param pVC           起跳的viewcontroller
 *  @param funcCreatedVC 创建完成的回调
 *  @param funcRetVC     显示完成的回调
 */
+(void) jumpTo:(NSInteger) startIndex
          path: (NSArray *) paths
       context:(NSDictionary *)ctx
startViewController:(UIViewController *)pVC
       created:(ReturnViewController)funcCreatedVC
returnAfterShow:(ReturnViewController)funcRetVC
{
    __block NSInteger nIndex = startIndex;
    __block UIViewController *vc = pVC;
    __block dispatch_block_t jumpBlock = ^{
        if(nIndex < paths.count - 1){
            [self jumpToNext:paths[nIndex]
                 withContext:ctx[shortNameFromPath(paths[nIndex])]
                        from:vc
             returnAfterShow:^(UIViewController *retVC) {
                 vc = retVC;
                 nIndex++;
                 jumpBlock();
             }];
        }else{
            [self jumpToNext:paths.lastObject
                 withContext:ctx[shortNameFromPath(paths.lastObject)]
                        from:vc
                     created:funcCreatedVC
             returnAfterShow:funcRetVC];
            jumpBlock = nil;
        }
    };
    
    jumpBlock();

}


+(void) backTo:(NSString *)shortName from:(UIViewController *)from completion:(ReturnViewController)returnVC{
    [self backTo:shortName from:from isAnim:NO completion:returnVC];
}

+(void) backTo:(NSString *) name from:(UIViewController *)from isAnim:(bool)isAnim completion:(ReturnViewController)funcRetVC{
    __block UIViewController *tmpVC = from;
    __block NSString *tmpName = name;
    
    if([name isEqualToString:[tmpVC shortName]]){
        funcRetVC(tmpVC);
        return;
    }
    
    __block dispatch_block_t backBlock = ^{
        if(isKindOfTabBarController(tmpVC)){
            UIViewController* vc = [(UITabBarController *)tmpVC selectedViewController];
            if(isKindOfNavgationController(vc)){
                tmpVC = vc;
                backBlock();
                return;
            }else{
                if([[tmpVC shortName] isEqualToString:tmpName]){
                    if(funcRetVC) funcRetVC(tmpVC);
                    backBlock = nil;
                    return;
                }else{
                    assert(0);
                }
            }
        }
        
        //! 导航类型
        if(isKindOfNavgationController(tmpVC) || tmpVC.navigationController != nil){
            UINavigationController *nav = nil;
            if(isKindOfNavgationController(tmpVC)){
                nav = (UINavigationController*)tmpVC;
            }else{
                nav = tmpVC.navigationController;
            }
            
            NSArray *children = nav.childViewControllers;
            //! 如果回退到的页面就在navgation堆栈中
            for(UIViewController * vc in children){
                if([[vc shortName] isEqualToString:tmpName]){
                    [nav completionhandler_popToViewController:vc animated:isAnim completion:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(funcRetVC)
                                funcRetVC(vc);
                            backBlock = nil;
                        });
                    }];
                    return;
                }
            }
            
            if(nav.presentingViewController != nil){
                [nav popToRootViewControllerAnimated:isAnim];
                UIViewController *pVC = nav.presentingViewController;
                [nav dismissViewControllerAnimated:isAnim completion:^{
                    tmpVC = pVC;
                    if([[tmpVC shortName] isEqualToString:tmpName]){
                        funcRetVC(tmpVC);
                        backBlock = nil;
                        return;
                    }else{
                        backBlock();
                    }
                }];
                
                return;
            }
            else{
                assert(0);
            }
        }

        if(tmpVC.presentingViewController != nil){
            UIViewController *pVC = tmpVC.presentingViewController;
            [tmpVC dismissViewControllerAnimated:isAnim completion:^{
                tmpVC = pVC;
                backBlock();
            }];
        }
    };
    
    backBlock();
    
}


+(NSArray *) pathFrom:(UIViewController *) vc{
    NSMutableArray *ary = [NSMutableArray new];
//    if(isKindOfTabBarController(vc)){
//        vc = [(UITabBarController *)vc selectedViewController];
//        if(isKindOfNavgationController(vc)){
//            vc = [(UINavigationController *)vc childViewControllers].lastObject;
//        }
//        [ary addObject:[[vc class] shortName]];
//    }else{
        [ary addObject:[[vc class] shortName]];
//    }
    
    while (YES) {
        //! 判断是否有navgationViewControl
        if(vc.navigationController != nil){
            [self addNavgationBrother:ary navigation:vc.navigationController self:vc];
            //! 判断navgationViewController是否是modal弹出型的
            if(vc.navigationController.presentingViewController != nil){
                vc = vc.navigationController.presentingViewController;
                if(isKindOfTabBarController(vc)){
                    vc = [(UITabBarController *)vc selectedViewController];
                    if(isKindOfNavgationController(vc)){
                        vc = [(UINavigationController *)vc childViewControllers].lastObject;
                        [ary insertObject:[[vc class] shortName] atIndex:0];
                    }
                    continue;
                }else if(isKindOfNavgationController(vc)){
                    vc = [(UINavigationController *)vc childViewControllers].lastObject;
                    [ary insertObject:[[vc class] shortName] atIndex:0];
                    continue;
                }else{
                    [ary insertObject:[[vc class] shortName] atIndex:0];
                    continue;
                }
            }else{
                break;
            }
        }
        //! 判断是不是modal型viewcontrol
        if(vc.presentingViewController != nil){
            vc = vc.presentingViewController;
            if(isKindOfTabBarController(vc)){
                //! 如果父亲是TabbarController类型，就添加其子类的视图
                UITabBarController *tab = (UITabBarController*)vc;
                vc = tab.selectedViewController;
                if(isKindOfNavgationController(vc)){
                    //! 如果选中的视图是navgation，则添加下面所有的子类
                    vc = (UINavigationController *)vc.childViewControllers.lastObject;
                    [ary insertObject:[[vc class] shortName] atIndex:0];
                }else{
                    //! 否则添加当前选中的
                    [ary insertObject:[[vc class] shortName] atIndex:0];
                }
            }else if(isKindOfNavgationController(vc)){
                vc = (UINavigationController *)vc.childViewControllers.lastObject;
                [ary insertObject:[[vc class] shortName] atIndex:0];
            }else{
                [ary insertObject:[[vc class] shortName] atIndex:0];
            }
        }else{
            break;
        }
    }
    
    return ary;
}

+(void) addNavgationChildren:(NSMutableArray *)ary navigation:(UINavigationController *)nav{
    NSArray *children = nav.childViewControllers;
    //!上面已经添加过自己这个节点
    
    for(NSInteger nIndex = children.count - 1;nIndex>=0;nIndex --){
        [ary insertObject:[[children[nIndex] class] shortName] atIndex:0];
    }
}

+(void) addNavgationBrother:(NSMutableArray *)ary navigation:(UINavigationController *) nav self:(UIViewController *)vc{
    NSArray *brothes = nav.childViewControllers;
    NSInteger nIndex = [brothes indexOfObject:vc];
    //!不添加自己
    nIndex-=1;
    for(;nIndex>=0;nIndex --){
        [ary insertObject:[[brothes[nIndex] class] shortName] atIndex:0];
    }
}


+(bool) jumpToFrame:(UIViewController *)from{
//    AppDelegate* mainDelegate = (AppDelegate *)appDelegate();
//    if(mainDelegate.window.rootViewController != mainDelegate.frameVC){
//        mainDelegate.window.rootViewController = mainDelegate.frameVC;
//        return YES;
//    }else{
//        NSArray<UIViewController *> *controllers = mainDelegate.frameVC.childViewControllers;
//        if(from.navigationController != nil && ([controllers indexOfObject:from.navigationController] != NSNotFound)){
//            //! 如果当前页面的导航在标签页面中
//            [from.navigationController popToRootViewControllerAnimated:NO];
//            return YES;
//        }else if( from.isBeingPresented || from.navigationController.isBeingPresented){
//            //! 如果当前的vc是model的显示方式
//#warning 这里的处理有问题
//            [from dismissViewControllerAnimated:YES completion:nil];
//            return YES;
//        }else{
//            return NO;
//        }
//    }
    return NO;
}


//! 简化接口
+(UIViewController *) jumpToNext:(NSString *)pageName from:(UIViewController *)from{
    return [self jumpToNext:pageName withContext:nil from:from created:nil returnAfterShow:nil];
}

+(UIViewController *)jumpToNext:(NSString *)pageName withContext:(NSDictionary<NSString *,id> *)context from:(UIViewController *)from{
    return [self jumpToNext:pageName withContext:context from:from created:nil returnAfterShow:nil];
}

+(UIViewController *) jumpToNext:(NSString *)pageName
       withContext:(NSDictionary<NSString *,id> *)context
              from:(UIViewController *)from
   returnAfterShow:(ReturnViewController)retVC
{
    return [self jumpToNext:pageName withContext:context from:from created:nil returnAfterShow:retVC];
}

+(void)jumpToPage:(NSString *)pageName from:(UIViewController *)from{
    return [self jumpToPage:pageName withContext:nil from:from created:nil returnAfterShow:nil];
}

+(void) jumpToPage:(NSString *)pageName from:(UIViewController *)from isAnim:(bool)isAnim{
    return [self jumpToPage:pageName withContext:nil from:from isAnim:isAnim];
}


+(void)jumpToPage:(NSString *)pageName
      withContext:(NSDictionary<NSString *,NSDictionary<NSString *,id> *> *)context
             from:(UIViewController *)from
{
    return [self jumpToPage:pageName withContext:context from:from created:nil returnAfterShow:nil];
}

+(void)jumpToPage:(NSString *)pageName
      withContext:(NSDictionary<NSString *,NSDictionary<NSString *,id> *> *)context
             from:(UIViewController *)from
           isAnim:(bool)isAnim
{
    return [self jumpToPage:pageName withContext:context from:from returnAfterShow:nil isAnim:isAnim];
}



+(void)jumpToPage:(NSString *)pageName
      withContext:(NSDictionary<NSString *,NSDictionary<NSString *,id> *> *)context
             from:(UIViewController *)from
  returnAfterShow:(ReturnViewController)retVC
{
    return [self jumpToPage:pageName withContext:context from:from created:nil returnAfterShow:retVC];
}

+(void)jumpToPage:(NSString *)pageName
      withContext:(NSDictionary<NSString *,NSDictionary<NSString *,id> *> *)context
             from:(UIViewController *)from
  returnAfterShow:(ReturnViewController)retVC
           isAnim:(bool)isAnim
{
    return [self jumpToPage:pageName withContext:context from:from isAnim:isAnim created:nil returnAfterShow:retVC];
}


@end
