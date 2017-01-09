//
//  HJPageRouteJPExtension.m
//  thrallplus
//
//  Created by HeJia on 2016/11/15.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJPageRouteJPExtension.h"

@implementation HJPageRouteJPExtension

+ (void)main:(JSContext *)context{
    context[@"registCreateFunc"] = ^(JSValue *param){
        registCreateFunc([JPExtension formatJSToOC:param]);
    };
    
    context[@"registCreateFuncForClassName"] = ^(JSValue *creator , JSValue *className){
        registCreateFuncForClassName([JPExtension formatJSToOC:creator] , [JPExtension formatJSToOC:className]);
    };
    
    context[@"unregistCreateFunc"] = ^(JSValue *className){
        unregistCreateFunc([JPExtension formatJSToOC:className]);
    };
    
    context[@"registContextHandlerFunc"] = ^(JSValue *handler,JSValue *className){
        registContextHandlerFunc([JPExtension formatJSToOC:handler], [JPExtension formatJSToOC:className]);
    };
    
    context[@"unregistContextHandlerFunc"] = ^(JSValue *className){
        unregistContextHandlerFunc([JPExtension formatJSToOC:className]);
    };
    
    context[@"registClass"] = ^(JSValue *class){
        registClass([JPExtension formatJSToOC:class]);
    };
    
    context[@"registClassWithName"] = ^(JSValue *class,JSValue *name){
        registClassWithName([JPExtension formatJSToOC:class],[JPExtension formatJSToOC:name]);
    };
    
    context[@"jumpToPageCreateReturn"] = ^(JSValue *pageName,JSValue *context, JSValue *from,JSValue *createdVC,JSValue *retVC){
        jumpToPageCreateReturn([JPExtension formatJSToOC:pageName],
                               [JPExtension formatJSToOC:context],
                               [JPExtension formatJSToOC:from],
                               [JPExtension formatJSToOC:createdVC],
                               [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"jumpToPageIsAnimCreateReturn"] = ^(JSValue *pageName,JSValue *context, JSValue *from,JSValue *isAnim ,JSValue *createdVC,JSValue *retVC){
        jumpToPageIsAnimCreateReturn([JPExtension formatJSToOC:pageName],
                                     [JPExtension formatJSToOC:context],
                                     [JPExtension formatJSToOC:from],
                                     [isAnim toBool],
                                     [JPExtension formatJSToOC:createdVC],
                                     [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"jumpToPage"] = ^(JSValue *pageName, JSValue *from){
        jumpToPage([JPExtension formatJSToOC:pageName], [JPExtension formatJSToOC:from]);
    };
    
    context[@"jumpToPageIsAnim"] = ^(JSValue *pageName,JSValue *from,JSValue *isAnim){
        jumpToPageIsAnim([JPExtension formatJSToOC:pageName], [JPExtension formatJSToOC:from], [isAnim toBool]);
    };
    
    context[@"jumpToPageWithContext"] = ^(JSValue *pageName,JSValue *context,JSValue *from){
        jumpToPageWithContext([JPExtension formatJSToOC:pageName],
                              [JPExtension formatJSToOC:context],
                              [JPExtension formatJSToOC:from]);
    };
    
    context[@"jumpToPageWithContextIsAnim"] = ^(JSValue *pageName,JSValue *context,JSValue *from,JSValue *isAnim){
        jumpToPageWithContextIsAnim([JPExtension formatJSToOC:pageName],
                                    [JPExtension formatJSToOC:context],
                                    [JPExtension formatJSToOC:from],
                                    [isAnim toBool]);
    };
    
    context[@"jumpToPageWithContextReturnAfterShow"] = ^(JSValue *pageName,JSValue *context,JSValue *from,JSValue *retVC){
        jumpToPageWithContextReturnAfterShow([JPExtension formatJSToOC:pageName],
                                             [JPExtension formatJSToOC:context],
                                             [JPExtension formatJSToOC:from],
                                             [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"jumpToPageWithContextReturnAfterShowIsAnim"] = ^(JSValue *pageName,
                                                               JSValue *context,
                                                               JSValue *from,
                                                               JSValue *retVC,
                                                               JSValue *isAnim){
        jumpToPageWithContextReturnAfterShowIsAnim([JPExtension formatJSToOC:pageName],
                                                   [JPExtension formatJSToOC:context],
                                                   [JPExtension formatJSToOC:from],
                                                   [JPExtension formatJSToOC:retVC],
                                                   [isAnim toBool]);
    };
    
    context[@"canBackTo"] = ^bool(JSValue *pageName,JSValue *from){
        return canBackTo([JPExtension formatJSToOC:pageName], [JPExtension formatJSToOC:from]);
    };
    
    context[@"jumpBack"] = ^(JSValue *from){
        jumpBack([JPExtension formatJSToOC:from]);
    };
    
    context[@"jumpBackWithAnim"] = ^(JSValue *from,JSValue *isAnim){
        jumpBackWithAnim([JPExtension formatJSToOC:from], [isAnim toBool]);
    };
    
    context[@"jumpBackWithCompletion"] = ^(JSValue *from,JSValue *retVC){
        jumpBackWithCompletion([JPExtension formatJSToOC:from], [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"jumpBackWithAnimCompletion"] = ^(JSValue *from,JSValue *isAnim,JSValue *retVC){
        jumpBackWithAnimCompletion([JPExtension formatJSToOC:from], [isAnim toBool], [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"backToWithAnimCompletion"] = ^(JSValue *shortName,JSValue *from,JSValue *isAnim,JSValue* retValue){
        backToWithAnimCompletion([JPExtension formatJSToOC:shortName],
                                 [JPExtension formatJSToOC:from],
                                 [isAnim toBool],
                                 [JPExtension formatJSToOC:retValue]);
    };
    
    context[@"backToWithCompletion"] = ^(JSValue *shortName,JSValue *from,JSValue *retVC){
        backToWithCompletion([JPExtension formatJSToOC:shortName], [JPExtension formatJSToOC:from], [JPExtension formatJSToOC:retVC]);
    };
    
    context[@"jumpToNextWithContextCreatedReturnAfterShow"] = ^id(JSValue *pageName,
                                                                  JSValue *context,
                                                                  JSValue *from,
                                                                  JSValue *createdVC,
                                                                  JSValue *retVC){
        UIViewController *vc =
        jumpToNextWithContextCreatedReturnAfterShow([JPExtension formatJSToOC:pageName],
                                                    [JPExtension formatJSToOC:context],
                                                    [JPExtension formatJSToOC:from],
                                                    [JPExtension formatJSToOC:createdVC],
                                                    [JPExtension formatJSToOC:retVC]);
        return [JPExtension formatOCToJS:vc];
    };
    
    context[@"jumpToNextWithContext"] = ^id(JSValue *pageName,JSValue *context,JSValue *from){
        UIViewController *vc =
        jumpToNextWithContext([JPExtension formatJSToOC:pageName],
                              [JPExtension formatJSToOC:context],
                              [JPExtension formatJSToOC:from]);
        return [JPExtension formatOCToJS:vc];
    };
    
    context[@"jumpToNext"] = ^id(JSValue *pageName,JSValue *from){
        UIViewController *vc =
        jumpToNext([JPExtension formatJSToOC:pageName], [JPExtension formatJSToOC:from]);
        return [JPExtension formatOCToJS:vc];
    };
    
    context[@"jumpToNextWithContextReturnAfterShow"] = ^id(JSValue *pageName,JSValue* context,JSValue *from,JSValue *retVC){
        UIViewController *vc =
        jumpToNextWithContextReturnAfterShow([JPExtension formatJSToOC:pageName],
                                             [JPExtension formatJSToOC:context],
                                             [JPExtension formatJSToOC:from],
                                             [JPExtension formatJSToOC:retVC]);
        return [JPExtension formatOCToJS:vc];
    };
}

@end
