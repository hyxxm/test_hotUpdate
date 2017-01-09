//
//  HotUpdateJSCreator.m
//  thrallplus
//
//  Created by HeJia on 16/6/7.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdateJSCreator.h"
#import "JSPatch/JPEngine.h"
#import "JPCleaner.h"


@implementation HotUpdateJSCreator

-(instancetype)init{
    if(self = [super init]){
        [JPEngine startEngine];
    }
    return self;
}

-(void)load:(NSArray *)fileArray{
    for(NSString *filePath in fileArray){
        [JPEngine evaluateScriptWithPath:filePath];
    }
}

-(NSString *)suffixes{
    return @"js";
}

-(void)uninstall{
    //! do nothing
    [JPCleaner cleanAll];
}

@end
