//
//  HJPageRouteProtocol.h
//  thrallplus
//
//  Created by HeJia on 16/6/24.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJPageRouterInterface.h"

@protocol HJPageRouteProtocol <NSObject>


/**
 *  设置上下文
 *
 *  @param ctx 上下文
 */
-(void) setContext:(NSDictionary *)ctx;

@end
