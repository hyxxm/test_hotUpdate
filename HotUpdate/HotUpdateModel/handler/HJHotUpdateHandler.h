//
//  HJHotUpdateHandler.h
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJHotUpdateModel.h"
#import "HJHandlerBase.h"
#import "HJDataInterface.h"

@interface HJHotUpdateHandler : HJHandlerBase

-(void) get:(dataResponse)dataRes error:(errorResponse)errRes;

@end
