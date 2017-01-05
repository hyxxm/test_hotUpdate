//
//  UIViewController+PageRouter.m
//  thrallplus
//
//  Created by HeJia on 16/6/24.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "UIViewController+PageRouter.h"
#import "HJPageRouteProtocol.h"
#import "HJPageRouterInterface.h"
#import <objc/runtime.h>

#define _PAGE_ROUTE_VIEWCONTROLLER_KEY_ "_pageroutemap_"

@implementation UIViewController (PageRouter)


+(NSString *) shortName{
    NSString *prefix = @"HJ";
    NSString *suffix = @"ViewController";
    
    NSString *className = [NSString stringWithUTF8String:class_getName([self class])];
    if([className hasPrefix:prefix]){
        className = [className substringFromIndex:prefix.length];
    }
    
    if([className hasSuffix:suffix]){
        className = [className substringToIndex:(className.length - suffix.length)];
    }
    
    return className;
}

-(NSString *) shortName{
    return [[self class] shortName];
}

-(void) setPageRouteViewController:(UIViewController *)child{
    NSMutableDictionary *map = objc_getAssociatedObject(self, _PAGE_ROUTE_VIEWCONTROLLER_KEY_);
    if(map == nil){
        map = [NSMutableDictionary new];
        objc_setAssociatedObject(self, _PAGE_ROUTE_VIEWCONTROLLER_KEY_, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [map setValue:child forKey:[[child class] shortName]];
}

-(UIViewController *) pageRouteViewController:(NSString *)shortName{
    NSMutableDictionary *map = objc_getAssociatedObject(self, _PAGE_ROUTE_VIEWCONTROLLER_KEY_);
    if(!map) return nil;
    return [map valueForKey:shortName];
}

@end
