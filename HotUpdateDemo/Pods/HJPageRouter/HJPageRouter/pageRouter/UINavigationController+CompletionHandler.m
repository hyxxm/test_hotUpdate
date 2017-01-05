//
//  UINavigationController+CompletionHandler.m
//  TestPageRouter
//
//  Created by HeJia on 16/6/28.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "UINavigationController+CompletionHandler.h"

@implementation UINavigationController (CompletionHandler)

- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self pushViewController:viewController animated:animated];
    [CATransaction commit];
}


- (void)completionhandler_popToViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion
{
    [CATransaction begin];
    [CATransaction setCompletionBlock:completion];
    [self popToViewController:viewController animated:animated];
    [CATransaction commit];
}

@end
