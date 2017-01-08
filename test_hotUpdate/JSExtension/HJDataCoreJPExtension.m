//
//  HJDataCoreJPExtension.m
//  thrallplus
//
//  Created by HeJia on 16/6/14.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HJDataCoreJPExtension.h"
#import "HJDataInterface.h"

@implementation HJDataCoreJPExtension

+ (void)main:(JSContext *)context{
    context[@"GetData"] = ^(JSValue *param, JSValue *parse,JSValue *local, JSValue *net, JSValue *error){
        GetData([JPExtension formatJSToOC:param],
                [JPExtension formatJSToOC:parse],
                [JPExtension formatJSToOC:local],
                [JPExtension formatJSToOC:net],
                [JPExtension formatJSToOC:error]);
    };

    
    context[@"DownloadFile"] = ^(JSValue *param, JSValue *savePath,JSValue *progress,JSValue *finished,JSValue *error){
        DownloadFile([JPExtension formatJSToOC:param],
                     [JPExtension formatJSToOC:savePath],
                     [JPExtension formatJSToOC:progress],
                     [JPExtension formatJSToOC:finished],
                     [JPExtension formatJSToOC:error]);
    };
    
    context[@"UploadImage"] = ^(JSValue *param , JSValue *img,JSValue *progress, JSValue *finished,JSValue *error){
        UploadImage([JPExtension formatJSToOC:param],
                    [JPExtension formatJSToOC:img],
                    [JPExtension formatJSToOC:progress],
                    [JPExtension formatJSToOC:finished],
                    [JPExtension formatJSToOC:error]);
    };
}

@end
