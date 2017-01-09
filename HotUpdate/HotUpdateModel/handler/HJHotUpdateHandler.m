//
//  HJHJHotUpdateHandler.mModelView
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJHotUpdateHandler.h"
#import <NSObject+MJKeyValue.h>
#import "HJDataInterface.h"
#import "HJCommon.h"

@interface HJHotUpdateHandler ()

@end

@implementation HJHotUpdateHandler

-(instancetype)init {
    if(self = [super init]){
        
    }
    return self;
    // Do any additional setup after loading the view.
}

-(void)get:(dataResponse)dataRes error:(errorResponse)errRes{
    RequestParam *param = [RequestParam new];
    param.url = combineUrl(@"hotUpdate/hotUpdateVersion");
    param.type = CACHE_NONE;
    param.cmd = [NSString stringWithFormat:@"hotUpdateVersion"];
    [param.param setValue:@"ios" forKey:@"os"];
    [param.param setValue:appVersion() forKey:@"sys"];
    
    GetData(param, ^id(id jsonData){
        return [HJHotUpdateModel mj_objectWithKeyValues:jsonData[@"version"]];
    }, nil, ^(id jsonData, RequestResult *result){
        if (dataRes) {
            dataRes(jsonData, result);
        }
        
    }, ^(RequestResult *result){
        if (errRes) {
            errRes(result);
        }
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
