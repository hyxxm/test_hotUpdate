//
//  HJPageRouterAPI.m
//  thrallplus
//
//  Created by HeJia on 2016/11/15.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJPageRouterAPI.h"

void registCreateFunc(PageRouterCreateCommonViewContoller creator){
    [HJPageRouterInterface registCreateFunc:creator];
}

void registCreateFuncForClassName(PageRouterCreateViewContoller creator ,NSString *className){
    [HJPageRouterInterface registCreateFunc:creator forClassName:className];
}

void unregistCreateFunc(NSString *className){
    [HJPageRouterInterface unregistCreateFunc:className];
}

void registContextHandlerFunc(PageRouterContextHandler handler ,NSString *className){
    [HJPageRouterInterface registContextHandlerFunc:handler forClassName:className];
}

void unregistContextHandlerFunc(NSString *className){
    [HJPageRouterInterface unregistContextHandlerFunc:className];
}

void registClass(Class class){
    [HJPageRouterInterface registClass:class];
}

void registClassWithName(Class class , NSString *name){
    [HJPageRouterInterface registClass:class withName:name];
}

void jumpToPageCreateReturn(NSString *pageName , NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,UIViewController *from,ReturnViewController createdVC,ReturnViewController retVC){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from created:createdVC returnAfterShow:retVC];
}

void jumpToPageIsAnimCreateReturn(NSString *pageName ,NSDictionary<NSString* , NSDictionary<NSString* , id> *> * context, UIViewController* from, bool isAnim,ReturnViewController createdVC,ReturnViewController retVC){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from isAnim:isAnim created:createdVC returnAfterShow:retVC];
}

void jumpToPage(NSString *pageName, UIViewController *from){
    [HJPageRouterInterface jumpToPage:pageName from:from];
}

void jumpToPageIsAnim(NSString *pageName ,UIViewController *from ,bool isAnim){
    [HJPageRouterInterface jumpToPage:pageName from:from isAnim:isAnim];
}

void jumpToPageWithContext(NSString *pageName,NSDictionary<NSString* , NSDictionary<NSString* , id> *> * context,UIViewController *from){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from];
}

void jumpToPageWithContextIsAnim(NSString *pageName ,NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,UIViewController *from,bool isAnim){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from isAnim:isAnim];
}

void jumpToPageWithContextReturnAfterShow(NSString *pageName,
                                          NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,
                                          UIViewController *from,
                                          ReturnViewController retVC){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from returnAfterShow:retVC];
}

void jumpToPageWithContextReturnAfterShowIsAnim(NSString *pageName,
                                                NSDictionary<NSString* , NSDictionary<NSString* , id> *> *context,
                                                UIViewController *from,
                                                ReturnViewController retVC,
                                                bool isAnim){
    [HJPageRouterInterface jumpToPage:pageName withContext:context from:from returnAfterShow:retVC isAnim:isAnim];
}

bool canBackTo(NSString *pageName,UIViewController *from){
    return [HJPageRouterInterface canBackTo:pageName from:from];
}

void jumpBack(UIViewController * from){
    [HJPageRouterInterface jumpBack:from];
}

void jumpBackWithAnim(UIViewController * from ,bool isAnim){
    [HJPageRouterInterface jumpBack:from isAnim:isAnim];
}

void jumpBackWithCompletion(UIViewController * from ,ReturnViewController returnVC){
    [HJPageRouterInterface jumpBack:from completion:returnVC];
}

void jumpBackWithAnimCompletion(UIViewController *from, bool isAnim ,ReturnViewController returnVC){
    [HJPageRouterInterface jumpBack:from isAnim:isAnim completion:returnVC];
}

void backToWithAnimCompletion(NSString *shortName ,UIViewController *from ,bool isAnim ,ReturnViewController returnVC){
    [HJPageRouterInterface backTo:shortName from:from isAnim:isAnim completion:returnVC];
}

void backToWithCompletion(NSString *shortName ,UIViewController *from ,ReturnViewController returnVC){
    [HJPageRouterInterface backTo:shortName from:from completion:returnVC];
}

UIViewController* jumpToNextWithContextCreatedReturnAfterShow(NSString *pageName ,
                                                              NSDictionary<NSString *,id> *context,
                                                              UIViewController *from,
                                                              ReturnViewController createdVC ,
                                                              ReturnViewController retVC){
    return [HJPageRouterInterface jumpToNext:pageName withContext:context from:from created:createdVC returnAfterShow:retVC];
}

UIViewController* jumpToNextWithContext(NSString *pageName ,
                                        NSDictionary<NSString *,id> *context,
                                        UIViewController *from){
    return [HJPageRouterInterface jumpToNext:pageName withContext:context from:from];
}

UIViewController* jumpToNext(NSString *pageName ,
                             UIViewController *from){
    return [HJPageRouterInterface jumpToNext:pageName from:from];
}

UIViewController * jumpToNextWithContextReturnAfterShow(NSString *pageName,
                                                        NSDictionary<NSString *,id> *context,
                                                        UIViewController *from,
                                                        ReturnViewController retVC){
    return [HJPageRouterInterface jumpToNext:pageName
                                 withContext:context
                                        from:from
                             returnAfterShow:retVC];
}

