//
//  SNDrawer.m
//  SNDrawerViewController
//
//  Created by sunDong on 16/5/20.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import "SNDrawer.h"

#import "SNDrawerViewController.h"

static id _drawer = nil;

@implementation SNDrawer

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _drawer = [[self alloc] init];
    });
    return _drawer;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _drawer = [super allocWithZone:zone];
    });
    return _drawer;
}

+ (SNDrawerViewController *)sharedDrawer {
    return [SNDrawer sharedManager].drawerViewController;
}

@end
