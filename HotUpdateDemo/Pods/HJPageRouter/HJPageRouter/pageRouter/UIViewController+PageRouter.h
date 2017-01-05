//
//  UIViewController+PageRouter.h
//  thrallplus
//
//  Created by HeJia on 16/6/24.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PageRouter)

/**
 *  viewcontroll的简短名称，
 *  此函数会自动去掉类名的前缀(HJ)和后缀(ViewController)，比如HJLaunchViewController－－》Launch
 *  @return 简称
 */
+(NSString *) shortName;

-(NSString *) shortName;

-(void) setPageRouteViewController:(UIViewController *) child;

-(UIViewController *) pageRouteViewController:(NSString *) shortName;

@end
