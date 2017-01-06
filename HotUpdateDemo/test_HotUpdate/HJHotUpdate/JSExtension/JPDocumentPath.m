//
//  JPDocumentPath.m
//  thrallplus
//
//  Created by HeJia on 16/6/14.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "JPDocumentPath.h"

@implementation JPDocumentPath

+(void)main:(JSContext *)context{
    context[@"NSTemporaryDirectory"] = ^NSString*(){
        return NSTemporaryDirectory();
    };
    
    context[@"NSHomeDirectory"] = ^NSString*(){
        return NSHomeDirectory();
    };
    
}

@end
