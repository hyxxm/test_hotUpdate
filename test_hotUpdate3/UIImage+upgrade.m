//
//  UIImage+upgrade.m
//  thrallplus
//
//  Created by HeJia on 16/6/13.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "UIImage+upgrade.h"
#import <objc/runtime.h>
#import "HotUpdateInterface.h"

@implementation UIImage (upgrade)

+(void) load{
    Method imageNamedOriginal = class_getClassMethod(self, @selector(imageNamed:));
    Method imageNamedCustom = class_getClassMethod(self, @selector(imageNamedEx:));
    
    
    //Swizzle methods
    method_exchangeImplementations(imageNamedOriginal, imageNamedCustom);
}

+(UIImage *)imageNamedEx:(NSString *)name{
    NSBundle *upBundle = upgradeBundle();
    if(upBundle){
        NSString *path = [upBundle pathForResource:name ofType:@"png"];
        if(path){
            return [UIImage imageWithContentsOfFile:path];
        }else{
            return [self imageNamedEx:name];
        }
    }else{
        return [self imageNamedEx:name];
    }
}



@end
