//
//  UINavigationController+CompletionHandler.h
//  TestPageRouter
//
//  Created by HeJia on 16/6/28.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CompletionHandler)

- (void)completionhandler_pushViewController:(UIViewController *)viewController
                                    animated:(BOOL)animated
                                  completion:(void (^)(void))completion;

- (void)completionhandler_popToViewController:(UIViewController *)viewController
                                     animated:(BOOL)animated
                                   completion:(void (^)(void))completion;

@end
