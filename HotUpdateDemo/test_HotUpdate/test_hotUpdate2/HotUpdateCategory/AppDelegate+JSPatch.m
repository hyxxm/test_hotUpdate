//
//  AppDelegate+JSPatch.m
//  thrallplus
//
//  Created by HeJia on 16/6/13.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "AppDelegate+JSPatch.h"
#import "JPEngine.h"
@implementation AppDelegateJSPatch

- (void)JPEngineStart{
    [JPEngine startEngine];
}

-(void) JPEngineEvaluateScriptWithPath:(NSString *)scriptPath{
    [JPEngine evaluateScriptWithPath:scriptPath];
}

@end
