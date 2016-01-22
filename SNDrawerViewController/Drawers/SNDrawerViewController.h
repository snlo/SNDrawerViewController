//
//  SNDrawerViewController.h
//  DrawerTest
//
//  Created by snloveydus on 16/1/4.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNDrawerViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *mainViewController;
@property (nonatomic, strong, readonly) UIViewController *leftViewController;
@property (nonatomic, strong, readonly) UIViewController *rightViewController;

@property (nonatomic) CGFloat drawerWidth; //抽屉的宽，默认是self.view的宽的0.8倍
@property (nonatomic) CGFloat mainYOfOpeningDrawer; //抽屉打开状态下，主页的起始坐标的高度
@property (nonatomic) CGFloat maskAlpha; //主页蒙版，默认值为0.1f
@property (nonatomic) CGFloat mainShadowOpacity; //主页阴影，默认值为1.0f，当maskAlpha被修改后默认值为0.0f

@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureOfOpeningLeftDrawer;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureOfOpeningRightDrawer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureOfOpeningLeftDrawer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureOfOpeningRightDrawer;

//designate
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController rightViewController:(UIViewController *)rightViewController;
//secondary 
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController leftViewController:(UIViewController *)leftViewController;
//thrice
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController rightViewController:(UIViewController *)rightViewController;
//抽屉的打开和关闭
- (void)openLeftDrawer;
- (void)closeLeftDrawer;
- (void)openRightDrawer;
- (void)closeRightDrawer;

@end
