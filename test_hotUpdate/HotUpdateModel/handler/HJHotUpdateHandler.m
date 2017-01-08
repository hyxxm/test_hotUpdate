//
//  HJHJHotUpdateHandler.mModelView
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJHotUpdateHandler.h"
#import "NSObject+MJKeyValue.h"
#import "HJDataInterface.h"
//#import "HJCommon.h"
#define HotUpdate_HTTPURL @"http://192.168.31.5:8080/v3/"//公司测试环境
@interface HJHotUpdateHandler ()

@end

@implementation HJHotUpdateHandler

-(instancetype)init {
    if(self = [super init]){
        
    }
    return self;
    // Do any additional setup after loading the view.
}
-(NSString *)appversion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
-(NSString *)combineUrl:(NSString *)cmd{
    return [NSString stringWithFormat:@"%@%@",HotUpdate_HTTPURL,cmd];
}
-(void)get:(hotUpdate_dataResponse)dataRes error:(hotUpdate_errorResponse)errRes{
    RequestParam *param = [RequestParam new];
//    param.url = hotUpdate_combineUrl(@"hotUpdate/hotUpdateVersion");
    param.url = [self combineUrl:@"hotUpdate/hotUpdateVersion"];
    param.type = CACHE_NONE;
    param.cmd = [NSString stringWithFormat:@"hotUpdateVersion"];
    [param.param setValue:@"ios" forKey:@"os"];
    [param.param setValue:[self appversion] forKey:@"sys"];
    
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
