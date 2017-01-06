//
//  HJHotUpdateHandler.h
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJHotUpdateModel.h"
//#import "HJHandlerBase.h"
#import "HJDataInterface.h"
typedef void(^hotUpdate_dataResponse)(id data,RequestResult *result);
typedef void(^hotUpdate_localResponse)(id data);
typedef void(^hotUpdate_errorResponse)(RequestResult *result);
@interface HJHotUpdateHandler : NSObject

-(void) get:(hotUpdate_dataResponse)dataRes error:(hotUpdate_errorResponse)errRes;

@end
